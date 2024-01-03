/*
	Licensed to the Apache Software Foundation (ASF) under one or more
	contributor license agreements.  See the NOTICE file distributed with
	this work for additional information regarding copyright ownership.
	The ASF licenses this file to You under the Apache License, Version 2.0
	(the "License"); you may not use this file except in compliance with
	the License.  You may obtain a copy of the License at

	http://www.apache.org/licenses/LICENSE-2.0

	Unless required by applicable law or agreed to in writing, software
	distributed under the License is distributed on an "AS IS" BASIS,
	WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
	See the License for the specific language governing permissions and
	limitations under the License.
 */

package mxhx.parser;

import haxe.CallStack;
import hxparse.Lexer;
import hxparse.LexerTokenSource;
import mxhx.internal.MXHXData;
import mxhx.internal.MXHXInstructionData;
import mxhx.internal.MXHXTagAttributeData;
import mxhx.internal.MXHXTagData;
import mxhx.internal.MXHXTagWhitespaceData;
import mxhx.internal.MXHXTextData;
import mxhx.internal.MXHXUnitData;
import mxhx.internal.parser.BalancingMXHXProcessor;
import mxhx.internal.parser.hxparse.Parser;
import mxhx.parser.MXHXToken;

class MXHXParser extends Parser<LexerTokenSource<MXHXToken>, MXHXToken> {
	private var byteData:byte.ByteData;
	private var lexer:MXHXLexer;
	private var index:Int = -1;
	private var balancingIndex:Int = 0;
	private var result:MXHXData;
	private var depthStack:Array<Int>;
	private var balancingProcessor:BalancingMXHXProcessor;
	private var hasRootTag = false;

	/**
		Creates a new `MXHXParser` object with the given arguments.
	**/
	public function new(input:String, sourcePath:String) {
		byteData = byte.ByteData.ofString(input);
		lexer = new MXHXLexer(byteData, sourcePath);
		var ts = new hxparse.LexerTokenSource(lexer, MXHXLexer.topLevel);
		super(ts);
	}

	/**
		By default, non-signifigant content, including DTD tokens and whitespace
		tokens between tag attributes, is ignored. However, if
		`includeNonSignificantContent` is set to `true`, they will be included.

		This property is meant for editors and other environments that need to
		preserve the document's original text.
	**/
	public var includeNonSignificantContent:Bool = false;

	/**
		Parses the MXHX string as `IMXHXData`.
	**/
	public function parse():IMXHXData {
		index = -1;
		balancingIndex = 0;
		depthStack = [-1];
		result = new MXHXData(lexer.curPos().psource);
		balancingProcessor = new BalancingMXHXProcessor(lexer.curPos().psource, result.problems);
		try {
			while (parseUnitData()) {}
			result.units = balancingProcessor.balance(result.units, result, @:privateAccess result.prefixMapMap);
			// repaired, so let's rebuild our prefix maps and tag depths
			if (balancingProcessor.wasRepaired) {
				refreshPositionData(result.units);
			}
		} catch (e:Dynamic) {
			var curPos = curPos();
			var linePos = curPos.getLinePosition(byteData);
			result.problems.push(new MXHXParserProblem('Unexpected exception: $e\n${CallStack.toString(CallStack.exceptionStack())}', 1530, Error,
				curPos.psource, curPos.pmin, curPos.pmax, linePos.lineMin - 1, linePos.posMin, linePos.lineMax - 1, linePos.posMax));
		}
		for (problem in lexer.problems) {
			result.problems.push(problem);
		}
		return result;
	}

	private function parseUnitData():Bool {
		if (peek(0) == null) {
			var curPos = lexer.curPos();
			var linePos = curPos.getLinePosition(byteData);
			result.problems.push(new MXHXParserProblem('Unexpected character. \'${lexer.current}\' is not allowed here', 1310, Error, curPos.psource,
				curPos.pmin, curPos.pmax, linePos.lineMin - 1, linePos.posMin, linePos.lineMax - 1, linePos.posMax));
			junk();
			return true;
		}
		switch (peek(0)) {
			case TProcessingInstruction(value):
				junk();
				var instructionData = new MXHXInstructionData(value);
				instructionData.setLocation(result, ++index);
				instructionData.parentUnitIndex = depthStack[depthStack.length - 1];
				var curPos = curPos();
				instructionData.start = curPos.pmax - value.length;
				instructionData.end = curPos.pmax;
				var linePos = curPos.getLinePosition(byteData);
				if (result.numUnits == 0) {
					instructionData.line = 0;
					instructionData.column = 0;
				} else {
					var prevUnit = result.units[result.numUnits - 1];
					instructionData.line = prevUnit.endLine;
					instructionData.column = prevUnit.endColumn;
				}
				instructionData.endLine = linePos.lineMax - 1;
				instructionData.endColumn = linePos.posMax;
				result.units.push(instructionData);
			case TDtd(value):
				junk();
				// simply ignore the dtd token, unless specified
				if (includeNonSignificantContent) {
					var dtdData = new MXHXTextData(value, Dtd);
					dtdData.setLocation(result, ++index);
					dtdData.parentUnitIndex = depthStack[depthStack.length - 1];
					var curPos = curPos();
					dtdData.start = curPos.pmax - value.length;
					dtdData.end = curPos.pmax;
					var linePos = curPos.getLinePosition(byteData);
					if (result.numUnits == 0) {
						dtdData.line = 0;
						dtdData.column = 0;
					} else {
						var prevUnit = result.units[result.numUnits - 1];
						dtdData.line = prevUnit.endLine;
						dtdData.column = prevUnit.endColumn;
					}
					dtdData.endLine = linePos.lineMax - 1;
					dtdData.endColumn = linePos.posMax;
					result.units.push(dtdData);
				}
			case TOpenTagStart(value):
				junk();
				if (depthStack.length == 1) {
					if (hasRootTag) {
						var curPos = lexer.curPos();
						var linePos = curPos.getLinePosition(byteData);
						result.problems.push(new MXHXParserProblem('Only one root tag allowed. \'${lexer.current}\' tag will be ignored', 1431, Error,
							curPos.psource, curPos.pmin, curPos.pmax, linePos.lineMin - 1, linePos.posMin, linePos.lineMax - 1, linePos.posMax));
					}
					hasRootTag = true;
				}
				var tagData = new MXHXTagData();
				tagData.init(value);
				tagData.setLocation(result, ++index);
				tagData.parentUnitIndex = depthStack[depthStack.length - 1];
				var curPos = curPos();
				tagData.start = curPos.pmin;
				tagData.end = curPos.pmax;
				var linePos = curPos.getLinePosition(byteData);
				tagData.line = linePos.lineMin - 1;
				tagData.endLine = linePos.lineMax - 1;
				tagData.column = linePos.posMin;
				tagData.endColumn = linePos.posMax;
				result.units.push(tagData);
				stream.ruleset = MXHXLexer.tag;
				var tagContentItems:Array<IMXHXTagContentData> = [];
				var prefixMap = new MutablePrefixMap();
				tag(tagData, tagContentItems, prefixMap);
				tagData.contentData = tagContentItems;
				@:privateAccess result.prefixMapMap.set(tagData, prefixMap.toImmutable());
				stream.ruleset = MXHXLexer.topLevel;
				if (!tagData.isEmptyTag()) {
					depthStack.push(tagData.index);
					balancingProcessor.addOpenTag(tagData, balancingIndex);
					balancingIndex++;
				}
			case TCloseTagStart(value):
				junk();
				if (depthStack.length == 1) {
					var curPos = lexer.curPos();
					var linePos = curPos.getLinePosition(byteData);
					result.problems.push(new MXHXParserProblem('Only one root tag allowed. \'${lexer.current}\' tag will be ignored', 1431, Error,
						curPos.psource, curPos.pmin, curPos.pmax, linePos.lineMin - 1, linePos.posMin, linePos.lineMax - 1, linePos.posMax));
				} else {
					depthStack.pop();
					balancingIndex--;
				}
				var tagData = new MXHXTagData();
				tagData.init(value);
				tagData.setLocation(result, ++index);
				tagData.parentUnitIndex = depthStack[depthStack.length - 1];
				balancingProcessor.addCloseTag(tagData, balancingIndex);
				var curPos = curPos();
				tagData.start = curPos.pmin;
				tagData.end = curPos.pmax;
				var linePos = curPos.getLinePosition(byteData);
				tagData.line = linePos.lineMin - 1;
				tagData.endLine = linePos.lineMax - 1;
				tagData.column = linePos.posMin;
				tagData.endColumn = linePos.posMax;
				result.units.push(tagData);
				stream.ruleset = MXHXLexer.tag;
				tag(tagData);
				stream.ruleset = MXHXLexer.topLevel;
			case TCData(value):
				junk();
				var cdata = new MXHXTextData(value, CData);
				cdata.setLocation(result, ++index);
				cdata.parentUnitIndex = depthStack[depthStack.length - 1];
				var isEnd = StringTools.endsWith(lexer.current, "]]>");
				var curPos = curPos();
				cdata.start = curPos.pmax - value.length - 9 - (isEnd ? 3 : 0);
				cdata.end = curPos.pmax;
				var linePos = curPos.getLinePosition(byteData);
				if (result.numUnits == 0) {
					cdata.line = 0;
					cdata.column = 0;
				} else {
					var prevUnit = result.units[result.numUnits - 1];
					cdata.line = prevUnit.endLine;
					cdata.column = prevUnit.endColumn;
				}
				cdata.endLine = linePos.lineMax - 1;
				cdata.endColumn = linePos.posMax;
				result.units.push(cdata);
			case TComment(value):
				junk();
				var comment = new MXHXTextData(value, Comment);
				comment.setLocation(result, ++index);
				comment.parentUnitIndex = depthStack[depthStack.length - 1];
				var isEnd = StringTools.endsWith(lexer.current, "-->");
				var curPos = curPos();
				comment.start = curPos.pmax - value.length - 4 - (isEnd ? 3 : 0);
				comment.end = curPos.pmax;
				var linePos = curPos.getLinePosition(byteData);
				if (result.numUnits == 0) {
					comment.line = 0;
					comment.column = 0;
				} else {
					var prevUnit = result.units[result.numUnits - 1];
					comment.line = prevUnit.endLine;
					comment.column = prevUnit.endColumn;
				}
				comment.endLine = linePos.lineMax - 1;
				comment.endColumn = linePos.posMax;
				result.units.push(comment);
			case TDocComment(value):
				junk();
				var docComment = new MXHXTextData(value, DocComment);
				docComment.setLocation(result, ++index);
				docComment.parentUnitIndex = depthStack[depthStack.length - 1];
				var isEnd = StringTools.endsWith(lexer.current, "-->");
				var curPos = curPos();
				docComment.start = curPos.pmax - value.length - 5 - (isEnd ? 3 : 0);
				docComment.end = curPos.pmax;
				var linePos = curPos.getLinePosition(byteData);
				if (result.numUnits == 0) {
					docComment.line = 0;
					docComment.column = 0;
				} else {
					var prevUnit = result.units[result.numUnits - 1];
					docComment.line = prevUnit.endLine;
					docComment.column = prevUnit.endColumn;
				}
				docComment.endLine = linePos.lineMax - 1;
				docComment.endColumn = linePos.posMax;
				result.units.push(docComment);
			case TWhitespace(value):
				junk();
				var whitespace = new MXHXTextData(value, Whitespace);
				whitespace.setLocation(result, ++index);
				whitespace.parentUnitIndex = depthStack[depthStack.length - 1];
				var curPos = curPos();
				whitespace.start = curPos.pmax - value.length;
				whitespace.end = curPos.pmax;
				var linePos = curPos.getLinePosition(byteData);
				whitespace.line = linePos.lineMin - 1;
				whitespace.endLine = linePos.lineMax - 1;
				whitespace.column = linePos.posMin;
				whitespace.endColumn = linePos.posMax;
				result.units.push(whitespace);
			case TText(value):
				junk();
				var text = new MXHXTextData(value, Text);
				text.setLocation(result, ++index);
				text.parentUnitIndex = depthStack[depthStack.length - 1];
				var curPos = curPos();
				text.start = curPos.pmax - value.length;
				text.end = curPos.pmax;
				var linePos = curPos.getLinePosition(byteData);
				text.line = linePos.lineMin - 1;
				text.endLine = linePos.lineMax - 1;
				text.column = linePos.posMin;
				text.endColumn = linePos.posMax;
				result.units.push(text);
			case TEof:
				junk();
				return false;
			default:
				junk();
				var curPos = curPos();
				var linePos = curPos.getLinePosition(byteData);
				result.problems.push(new MXHXParserProblem('Unexpected \'${peek(0)}\'', null, Error, curPos.psource, curPos.pmin, curPos.pmax,
					linePos.lineMin - 1, linePos.posMin, linePos.lineMax - 1, linePos.posMax));
		};
		return true;
	}

	private function tag(tagData:MXHXTagData, ?tagContentItems:Array<IMXHXTagContentData>, ?prefixMap:MutablePrefixMap):Void {
		var oldLexerPos = @:privateAccess lexer.pos;
		if (peek(0) == null) {
			// the tag is malformed, but we're going to keep going
			result.problems.push(new MXHXParserProblem('${tagData.name} tag (or non-tag inside this tag) is unclosed', 1552, Error, tagData.source,
				tagData.start, tagData.end, tagData.line, tagData.column, tagData.endLine, tagData.endColumn));
			tagData.end = curPos().pmax;
			var curPos = lexer.curPos();
			var linePos = curPos.getLinePosition(byteData);
			result.problems.push(new MXHXParserProblem('Unexpected character. \'${lexer.current}\' is not allowed here', 1310, Error, curPos.psource,
				curPos.pmin, curPos.pmax, linePos.lineMin - 1, linePos.posMin, linePos.lineMax - 1, linePos.posMax));
			junk();
			return;
		}
		switch (peek(0)) {
			case TWhitespace(value):
				junk();
				// whitespace isn't significant, so ignore it, unless specified
				if (includeNonSignificantContent) {
					var whitespace = new MXHXTagWhitespaceData(value);
					whitespace.parentTag = tagData;
					var curPos = curPos();
					whitespace.start = curPos.pmax - value.length;
					whitespace.end = curPos.pmax;
					var linePos = curPos.getLinePosition(byteData);
					whitespace.line = linePos.lineMin - 1;
					whitespace.endLine = linePos.lineMax - 1;
					whitespace.column = linePos.posMin;
					whitespace.endColumn = linePos.posMax;
					whitespace.source = result.source;
					tagContentItems.push(whitespace);
				}
				tag(tagData, tagContentItems, prefixMap);
			case TXmlns(value):
				junk();
				if (tagData.isCloseTag()) {
					// can't have attributes
					var curPos = curPos();
					var linePos = curPos.getLinePosition(byteData);
					result.problems.push(new MXHXParserProblem('${lexer.current} is not allowed here', 1510, Error, curPos.psource, curPos.pmin, curPos.pmax,
						linePos.lineMin - 1, linePos.posMin, linePos.lineMax - 1, linePos.posMax));
					tag(tagData, tagContentItems, prefixMap);
					return;
				}
				var attributeData = new MXHXTagAttributeData(value);
				tagData.parentUnitIndex = depthStack[depthStack.length - 1];
				attributeData.parentTag = tagData;
				var curPos = curPos();
				attributeData.start = curPos.pmin;
				attributeData.end = curPos.pmax;
				var linePos = curPos.getLinePosition(byteData);
				attributeData.line = linePos.lineMin - 1;
				attributeData.endLine = linePos.lineMax - 1;
				attributeData.column = linePos.posMin;
				attributeData.endColumn = linePos.posMax;
				attributeData.source = result.source;
				attribute(attributeData);
				tagContentItems.push(attributeData);

				if (prefixMap != null) {
					var prefix = "";
					if (value.length > 5) {
						prefix = value.substr(6);
					}
					var uri = attributeData.rawValue;
					prefixMap.add(uri, prefix);
				}

				tag(tagData, tagContentItems, prefixMap);
			case TName(value):
				junk();
				if (tagData.isCloseTag()) {
					// can't have attributes
					var curPos = curPos();
					var linePos = curPos.getLinePosition(byteData);
					result.problems.push(new MXHXParserProblem('${lexer.current} is not allowed here', 1510, Error, curPos.psource, curPos.pmin, curPos.pmax,
						linePos.lineMin - 1, linePos.posMin, linePos.lineMax - 1, linePos.posMax));
					tag(tagData, tagContentItems, prefixMap);
					return;
				}
				var attributeData = new MXHXTagAttributeData(value);
				tagData.parentUnitIndex = depthStack[depthStack.length - 1];
				attributeData.parentTag = tagData;
				var curPos = curPos();
				attributeData.start = curPos.pmin;
				attributeData.end = curPos.pmax;
				var linePos = curPos.getLinePosition(byteData);
				attributeData.line = linePos.lineMin - 1;
				attributeData.endLine = linePos.lineMax - 1;
				attributeData.column = linePos.posMin;
				attributeData.endColumn = linePos.posMax;
				attributeData.source = result.source;
				attribute(attributeData);
				if (Lambda.exists(tagContentItems, other -> {
					if ((other is IMXHXTagAttributeData)) {
						var otherAttrData:IMXHXTagAttributeData = cast other;
						return otherAttrData.name == attributeData.name;
					}
					return false;
				})) {
					result.problems.push(new MXHXParserProblem('Attribute \'${attributeData.shortName}\' bound to namespace \'${attributeData.uri}\' is already specified for element \'${tagData.name}\'. It will be ignored.',
						1408, Error, curPos.psource, curPos.pmin, curPos.pmax, linePos.lineMin
						- 1, linePos.posMin, linePos.lineMax
						- 1, linePos.posMax));
				}
				tagContentItems.push(attributeData);
				tag(tagData, tagContentItems, prefixMap);
			case TTagEnd:
				junk();
				tagData.setExplicitCloseToken(true);
				var curPos = curPos();
				tagData.end = curPos.pmax;
				var linePos = curPos.getLinePosition(byteData);
				tagData.endLine = linePos.lineMax - 1;
				tagData.endColumn = linePos.posMax;
			case TEmptyTagEnd:
				junk();
				tagData.setExplicitCloseToken(true);
				tagData.setEmptyTag(true);
				var curPos = curPos();
				tagData.end = curPos.pmax;
				var linePos = curPos.getLinePosition(byteData);
				tagData.endLine = linePos.lineMax - 1;
				tagData.endColumn = linePos.posMax;
			case TOpenTagStart(_) | TCloseTagStart(_):
				junk();
				// the tag is malformed, but we're going to keep going
				var curPos = curPos();
				var linePos = curPos.getLinePosition(byteData);
				result.problems.push(new MXHXParserProblem('${tagData.name} tag (or non-tag inside this tag) is unclosed', 1552, Error, curPos.psource,
					curPos.pmin, curPos.pmax, linePos.lineMin - 1, linePos.posMin, linePos.lineMax - 1, linePos.posMax));
				// end at the start of the new tag
				tagData.end = curPos.pmin;
				tagData.endLine = linePos.lineMin - 1;
				tagData.endColumn = linePos.posMin;
				setLexerPos(oldLexerPos);
			case TEof:
				junk();
				var curPos = curPos();
				var linePos = curPos.getLinePosition(byteData);
				result.problems.push(new MXHXParserProblem('${tagData.name} tag (or non-tag inside this tag) is unclosed', 1552, Error, curPos.psource,
					curPos.pmax, curPos.pmax, linePos.lineMin - 1, linePos.posMin, linePos.lineMax - 1, linePos.posMax));
				tagData.end = curPos.pmax;
				tagData.endLine = linePos.lineMax - 1;
				tagData.endColumn = linePos.posMax;
				setLexerPos(oldLexerPos);
			default:
				var curPos = curPos();
				var linePos = curPos.getLinePosition(byteData);
				result.problems.push(new MXHXParserProblem('${lexer.current} is not allowed here', 1510, Error, curPos.psource, curPos.pmin, curPos.pmax,
					linePos.lineMin - 1, linePos.posMin, linePos.lineMax - 1, linePos.posMax));
		}
	}

	private function attribute(attributeData:MXHXTagAttributeData):Void {
		var oldLexerPos = @:privateAccess lexer.pos;
		switch (peek(0)) {
			case TEquals:
				junk();
				var curPos = curPos();
				var linePos = curPos.getLinePosition(byteData);
				attributeData.end = curPos.pmax;
				attributeData.endLine = linePos.lineMax - 1;
				attributeData.endColumn = linePos.posMax;
				attributeData.setValueStartIncludingDelimiters(curPos.pmax);
			default:
				// the attribute is malformed, but we're going to keep going
				var curPos = curPos();
				var linePos = curPos.getLinePosition(byteData);
				result.problems.push(new MXHXParserProblem('${attributeData.name} attribute is missing a value', 1510, Error, attributeData.source,
					attributeData.start, curPos.pmin, linePos.lineMin - 1, linePos.posMin, linePos.lineMax - 1, linePos.posMax));
				attributeData.end = curPos.pmin;
				attributeData.endLine = linePos.lineMin - 1;
				attributeData.endColumn = linePos.posMin;
				setLexerPos(oldLexerPos);
				return;
		}
		oldLexerPos = @:privateAccess lexer.pos;
		switch (peek(0)) {
			case TString(_):
				junk();
				if (lexer.current == "\"") {
					stream.ruleset = MXHXLexer.string1;
					string(attributeData, lexer.current);
				} else {
					stream.ruleset = MXHXLexer.string2;
					string(attributeData, lexer.current);
				}
				stream.ruleset = MXHXLexer.tag;
			default:
				// the attribute value is malformed, so create an error, but
				// then we're going to continue parsing as if it were closed
				var curPos = curPos();
				var linePos = curPos.getLinePosition(byteData);
				result.problems.push(new MXHXParserProblem('${attributeData.name} attribute is missing a value', 1510, Error, attributeData.source,
					attributeData.start, curPos.pmin, linePos.lineMin - 1, linePos.posMin, linePos.lineMax - 1, linePos.posMax));
				attributeData.end = curPos.pmin;
				setLexerPos(oldLexerPos);
		}
	}

	private function string(attributeData:MXHXTagAttributeData, quote:String):Void {
		var oldLexerPos = @:privateAccess lexer.pos;
		switch (peek(0)) {
			case TString(value):
				junk();
				attributeData.setValueIncludingDelimeters(value);
				var curPos = curPos();
				var linePos = curPos.getLinePosition(byteData);
				attributeData.end = curPos.pmax;
				attributeData.endLine = linePos.lineMax - 1;
				attributeData.endColumn = linePos.posMax;
				// keep going until the closing quote is found
				if (lexer.current == quote) {
					return;
				}
				string(attributeData, quote);
			case TOpenTagStart(_) | TEof:
				junk();
				// this is an error, but it will be handled upstream
				var curPos = curPos();
				var linePos = curPos.getLinePosition(byteData);
				attributeData.end = curPos.pmax;
				attributeData.endLine = linePos.lineMax - 1;
				attributeData.endColumn = linePos.posMax;
				setLexerPos(oldLexerPos);
			default:
				junk();
				var curPos = curPos();
				var linePos = curPos.getLinePosition(byteData);
				result.problems.push(new MXHXParserProblem('Unexpected \'${peek(0)}\'', null, Error, curPos.psource, curPos.pmin, curPos.pmax,
					linePos.lineMin - 1, linePos.posMin, linePos.lineMax - 1, linePos.posMax));
		}
	}

	private function setLexerPos(pos:Int):Void {
		token = null;
		@:privateAccess lexer.pos = pos;
	}

	private function refreshPositionData(units:Array<IMXHXUnitData>):Void {
		var stackDepth:Array<Int> = [-1];
		for (i in 0...units.length) {
			if ((units[i] is IMXHXTagData)) {
				var currentTag:MXHXTagData = cast units[i];
				if (currentTag.isCloseTag()) {
					if (!currentTag.isEmptyTag()) {
						stackDepth.pop();
					}
				}
				currentTag.parentUnitIndex = stackDepth[stackDepth.length - 1];
				currentTag.setLocation(result, i);
				if (currentTag.isOpenTag()) {
					if (!currentTag.isEmptyTag()) {
						stackDepth.push(i);
					}
				}
			} else {
				var currentUnit:MXHXUnitData = cast units[i];
				currentUnit.parentUnitIndex = stackDepth[stackDepth.length - 1];
				currentUnit.setLocation(result, i);
			}
		}
	}
}

private class MXHXLexer extends Lexer {
	private var buf:StringBuf;
	private var bracketLevel:Int = 0;

	public var problems(default, never):Array<MXHXParserProblem> = [];

	public function new(input:byte.ByteData, sourceName:String = "<null>") {
		super(input, sourceName);
	}

	public static var topLevel = Lexer.buildRuleset([
		{
			rule: "<?",
			func: function(lexer:Lexer) {
				var mxhxLexer = cast(lexer, MXHXLexer);
				mxhxLexer.buf = new StringBuf();
				mxhxLexer.buf.add(lexer.current);
				lexer.token(processingInstruction);
				return TProcessingInstruction(mxhxLexer.buf.toString());
			}
		},
		{
			rule: "[ \t\r\n]+",
			func: function(lexer:Lexer) {
				return TWhitespace(lexer.current);
			}
		},
		{
			rule: "<!---->",
			func: function(lexer:Lexer) {
				return TComment("");
			}
		},
		{
			rule: "<!---",
			func: function(lexer:Lexer) {
				var mxhxLexer = cast(lexer, MXHXLexer);
				mxhxLexer.buf = new StringBuf();
				lexer.token(comment);
				return TDocComment(mxhxLexer.buf.toString());
			}
		},
		{
			rule: "<!--",
			func: function(lexer:Lexer) {
				var mxhxLexer = cast(lexer, MXHXLexer);
				mxhxLexer.buf = new StringBuf();
				lexer.token(comment);
				return TComment(mxhxLexer.buf.toString());
			}
		},
		{
			rule: "<!DOCTYPE|<!ENTITY|<!ELEMENT|<!ATTLIST|<!NOTATION",
			func: function(lexer:Lexer) {
				var mxhxLexer = cast(lexer, MXHXLexer);
				mxhxLexer.buf = new StringBuf();
				mxhxLexer.buf.add(lexer.current);
				mxhxLexer.bracketLevel = 1;
				lexer.token(dtd);
				return TDtd(mxhxLexer.buf.toString());
			}
		},
		{
			rule: "<([a-zA-Z]|:|_)([a-zA-Z]|[0-9]|:|_|\\.)*",
			func: function(lexer:Lexer) {
				return TOpenTagStart(lexer.current);
			}
		},
		{
			rule: "</([a-zA-Z]|:|_)([a-zA-Z]|[0-9]|:|_|\\.)*",
			func: function(lexer:Lexer) {
				return TCloseTagStart(lexer.current);
			}
		},
		{
			rule: "[^<]+",
			func: function(lexer:Lexer) {
				return TText(lexer.current);
			}
		},
		{
			rule: "<!\\[CDATA\\[",
			func: function(lexer:Lexer) {
				var mxhxLexer = cast(lexer, MXHXLexer);
				mxhxLexer.buf = new StringBuf();
				lexer.token(cdata);
				return TCData(mxhxLexer.buf.toString());
			}
		},
		{
			rule: "",
			func: function(lexer:Lexer) {
				return TEof;
			}
		},
		// null result needs to be detected with peek()
		{
			rule: ".",
			func: function(lexer:Lexer) {
				return null;
			}
		},
	]);

	public static var tag = Lexer.buildRuleset([
		{
			rule: "<([a-zA-Z]|:|_)([a-zA-Z]|[0-9]|:|_|\\.)*",
			func: function(lexer:Lexer) {
				return TOpenTagStart(lexer.current);
			}
		},
		{
			rule: "</([a-zA-Z]|:|_)([a-zA-Z]|[0-9]|:|_|\\.)*",
			func: function(lexer:Lexer) {
				return TCloseTagStart(lexer.current);
			}
		},
		{
			rule: "[ \t\r\n]+",
			func: function(lexer:Lexer) {
				return TWhitespace(lexer.current);
			}
		},
		{
			rule: "xmlns(:([a-zA-Z]|[0-9]|:|_|\\.)*)?",
			func: function(lexer:Lexer) {
				return TXmlns(lexer.current);
			}
		},
		{
			rule: "([a-zA-Z]|:|_)([a-zA-Z]|[0-9]|:|_|\\.)*",
			func: function(lexer:Lexer) {
				return TName(lexer.current);
			}
		},
		{
			rule: "=",
			func: function(lexer:Lexer) {
				return TEquals;
			}
		},
		{
			rule: ">",
			func: function(lexer:Lexer) {
				return TTagEnd;
			}
		},
		{
			rule: "/>",
			func: function(lexer:Lexer) {
				return TEmptyTagEnd;
			}
		},
		{
			rule: "\"",
			func: function(lexer:Lexer) {
				var mxhxLexer = cast(lexer, MXHXLexer);
				mxhxLexer.buf = new StringBuf();
				mxhxLexer.buf.add(lexer.current);
				return TString(mxhxLexer.buf.toString());
			}
		},
		{
			rule: "'",
			func: function(lexer:Lexer) {
				var mxhxLexer = cast(lexer, MXHXLexer);
				mxhxLexer.buf = new StringBuf();
				lexer.token(string2);
				return TString(mxhxLexer.buf.toString());
			}
		},
		{
			rule: "",
			func: function(lexer:Lexer) {
				return TEof;
			}
		}, // null result needs to be detected with peek()
		{
			rule: ".",
			func: function(lexer:Lexer) {
				return null;
			}
		}
	]);

	public static var processingInstruction = Lexer.buildRuleset([
		{
			rule: "\\?>",
			func: function(lexer:Lexer) {
				var mxhxLexer = cast(lexer, MXHXLexer);
				mxhxLexer.buf.add(lexer.current);
				return lexer.curPos().pmax;
			}
		},
		{
			rule: ".",
			func: function(lexer:Lexer) {
				var mxhxLexer = cast(lexer, MXHXLexer);
				mxhxLexer.buf.add(lexer.current);
				return lexer.token(processingInstruction);
			}
		},
		{
			rule: "",
			func: function(lexer:Lexer) {
				var mxhxLexer = cast(lexer, MXHXLexer);
				var curPos = lexer.curPos();
				var linePos = curPos.getLinePosition(lexer.input);
				mxhxLexer.problems.push(new MXHXParserProblem("input ended before processing instruction is closed", 1549, Error, curPos.psource, curPos.pmin,
					curPos.pmax, linePos.lineMin - 1, linePos.posMin, linePos.lineMax - 1, linePos.posMax));
				return curPos.pmax;
			}
		}
	]);

	public static var dtd = Lexer.buildRuleset([
		{
			rule: ">",
			func: function(lexer:Lexer) {
				var mxhxLexer = cast(lexer, MXHXLexer);
				mxhxLexer.buf.add(lexer.current);
				mxhxLexer.bracketLevel--;
				if (mxhxLexer.bracketLevel == 0) {
					return lexer.curPos().pmax;
				} else {
					return lexer.token(dtd);
				}
			}
		},
		{
			rule: "<",
			func: function(lexer:Lexer) {
				var mxhxLexer = cast(lexer, MXHXLexer);
				mxhxLexer.buf.add(lexer.current);
				mxhxLexer.bracketLevel++;
				return lexer.token(dtd);
			}
		},
		{
			rule: ".",
			func: function(lexer:Lexer) {
				var mxhxLexer = cast(lexer, MXHXLexer);
				mxhxLexer.buf.add(lexer.current);
				return lexer.token(dtd);
			}
		},
		{
			rule: "",
			func: function(lexer:Lexer) {
				var mxhxLexer = cast(lexer, MXHXLexer);
				var curPos = lexer.curPos();
				var linePos = curPos.getLinePosition(lexer.input);
				mxhxLexer.problems.push(new MXHXParserProblem("input ended before document type definition is closed", 1549, Error, curPos.psource,
					curPos.pmin, curPos.pmax, linePos.lineMin - 1, linePos.posMin, linePos.lineMax - 1, linePos.posMax));
				return curPos.pmax;
			}
		}
	]);

	public static var comment = Lexer.buildRuleset([
		{
			rule: "-->",
			func: function(lexer:Lexer) {
				return lexer.curPos().pmax;
			}
		},
		{
			rule: ".",
			func: function(lexer:Lexer) {
				var mxhxLexer = cast(lexer, MXHXLexer);
				mxhxLexer.buf.add(lexer.current);
				return lexer.token(comment);
			}
		},
		{
			rule: "",
			func: function(lexer:Lexer) {
				var mxhxLexer = cast(lexer, MXHXLexer);
				var curPos = lexer.curPos();
				var linePos = curPos.getLinePosition(lexer.input);
				mxhxLexer.problems.push(new MXHXParserProblem("input ended before comment is closed", 1549, Error, curPos.psource, curPos.pmin, curPos.pmax,
					linePos.lineMin - 1, linePos.posMin, linePos.lineMax - 1, linePos.posMax));
				return curPos.pmax;
			}
		}
	]);

	public static var cdata = Lexer.buildRuleset([
		{
			rule: "\\]\\]>",
			func: function(lexer:Lexer) {
				return lexer.curPos().pmax;
			}
		},
		{
			rule: ".",
			func: function(lexer:Lexer) {
				var mxhxLexer = cast(lexer, MXHXLexer);
				mxhxLexer.buf.add(lexer.current);
				return lexer.token(cdata);
			}
		},
		{
			rule: "",
			func: function(lexer:Lexer) {
				var mxhxLexer = cast(lexer, MXHXLexer);
				var curPos = lexer.curPos();
				var linePos = curPos.getLinePosition(lexer.input);
				mxhxLexer.problems.push(new MXHXParserProblem("input ended before CDATA is closed", 1549, Error, curPos.psource, curPos.pmin, curPos.pmax,
					linePos.lineMin - 1, linePos.posMin, linePos.lineMax - 1, linePos.posMax));
				return curPos.pmax;
			}
		}
	]);

	public static var string1 = Lexer.buildRuleset([
		{
			rule: "\"",
			func: function(lexer:Lexer) {
				var mxhxLexer = cast(lexer, MXHXLexer);
				mxhxLexer.buf.add(lexer.current);
				return TString(mxhxLexer.buf.toString());
			}
		},
		{
			rule: "[^\"<]+",
			func: function(lexer:Lexer) {
				var mxhxLexer = cast(lexer, MXHXLexer);
				mxhxLexer.buf.add(lexer.current);
				return TString(mxhxLexer.buf.toString());
			}
		},
		// it might not actually be an open tag,  but that's okay because the
		// string parser will rewind and pass it upstream
		{
			rule: "<",
			func: function(lexer:Lexer) {
				return TOpenTagStart(lexer.current);
			}
		},
		{
			rule: "",
			func: function(lexer:Lexer) {
				return TEof;
			}
		},
	]);

	public static var string2 = Lexer.buildRuleset([
		{
			rule: "'",
			func: function(lexer:Lexer) {
				var mxhxLexer = cast(lexer, MXHXLexer);
				mxhxLexer.buf.add(lexer.current);
				return TString(mxhxLexer.buf.toString());
			}
		},
		{
			rule: "[^'<]+",
			func: function(lexer:Lexer) {
				var mxhxLexer = cast(lexer, MXHXLexer);
				mxhxLexer.buf.add(lexer.current);
				return TString(mxhxLexer.buf.toString());
			}
		},
		// it might not actually be an open tag,  but that's okay because the
		// string parser will rewind and pass it upstream
		{
			rule: "<",
			func: function(lexer:Lexer) {
				return TOpenTagStart(lexer.current);
			}
		},
		{
			rule: "",
			func: function(lexer:Lexer) {
				return TEof;
			}
		},
	]);
}
