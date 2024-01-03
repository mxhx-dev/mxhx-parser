package mxhx.parser;

import utest.Assert;
import utest.Test;

class MXHXParserCommentTest extends Test {
	private static final SOURCE = "source.mxhx";

	public function testParserWithComment():Void {
		var parser = new MXHXParser("<!-- comment -->", SOURCE);
		var mxhxData = parser.parse();

		Assert.notNull(mxhxData);
		Assert.notNull(mxhxData.problems);
		Assert.equals(0, mxhxData.problems.length);

		Assert.isNull(mxhxData.rootTag);
		Assert.equals(SOURCE, mxhxData.source);
		Assert.equals(1, mxhxData.numUnits);

		var unit = mxhxData.unitAt(0);
		Assert.notNull(unit);
		Assert.equals(SOURCE, unit.source);
		Assert.equals(0, unit.start);
		Assert.equals(16, unit.end);
		Assert.equals(0, unit.line);
		Assert.equals(0, unit.column);
		Assert.equals(0, unit.endLine);
		Assert.equals(16, unit.endColumn);
		Assert.isOfType(unit, IMXHXTextData);
		var textData = cast(unit, IMXHXTextData);
		Assert.equals(MXHXTextType.Comment, textData.textType);
		Assert.equals(" comment ", textData.content);
	}

	public function testParserWithMultilineComment():Void {
		var parser = new MXHXParser("<!-- multiline\ncomment -->", SOURCE);
		var mxhxData = parser.parse();

		Assert.notNull(mxhxData);
		Assert.notNull(mxhxData.problems);
		Assert.equals(0, mxhxData.problems.length);

		Assert.isNull(mxhxData.rootTag);
		Assert.equals(SOURCE, mxhxData.source);
		Assert.equals(1, mxhxData.numUnits);

		var unit = mxhxData.unitAt(0);
		Assert.notNull(unit);
		Assert.equals(SOURCE, unit.source);
		Assert.equals(0, unit.start);
		Assert.equals(26, unit.end);
		Assert.equals(0, unit.line);
		Assert.equals(0, unit.column);
		Assert.equals(1, unit.endLine);
		Assert.equals(11, unit.endColumn);
		Assert.isOfType(unit, IMXHXTextData);
		var textData = cast(unit, IMXHXTextData);
		Assert.equals(MXHXTextType.Comment, textData.textType);
		Assert.equals(" multiline\ncomment ", textData.content);
	}

	public function testParserWithEmptyComment():Void {
		var parser = new MXHXParser("<!---->", SOURCE);
		var mxhxData = parser.parse();

		Assert.notNull(mxhxData);
		Assert.notNull(mxhxData.problems);
		Assert.equals(0, mxhxData.problems.length);

		Assert.isNull(mxhxData.rootTag);
		Assert.equals(SOURCE, mxhxData.source);
		Assert.equals(1, mxhxData.numUnits);

		var unit = mxhxData.unitAt(0);
		Assert.notNull(unit);
		Assert.equals(SOURCE, unit.source);
		Assert.equals(0, unit.start);
		Assert.equals(7, unit.end);
		Assert.equals(0, unit.line);
		Assert.equals(0, unit.column);
		Assert.equals(0, unit.endLine);
		Assert.equals(7, unit.endColumn);
		Assert.isOfType(unit, IMXHXTextData);
		var textData = cast(unit, IMXHXTextData);
		Assert.equals(MXHXTextType.Comment, textData.textType);
		Assert.equals("", textData.content);
	}

	public function testParserWithCommentUnclosed():Void {
		var parser = new MXHXParser("<!-- comment ", SOURCE);
		var mxhxData = parser.parse();

		Assert.notNull(mxhxData);
		Assert.notNull(mxhxData.problems);
		Assert.equals(1, mxhxData.problems.length);
		var problem = mxhxData.problems[0];
		Assert.notNull(problem);
		Assert.equals(1549, problem.code);
		Assert.equals(SOURCE, problem.source);
		Assert.equals(12, problem.start);
		Assert.equals(13, problem.end);

		Assert.isNull(mxhxData.rootTag);
		Assert.equals(SOURCE, mxhxData.source);
		Assert.equals(1, mxhxData.numUnits);

		var unit = mxhxData.unitAt(0);
		Assert.notNull(unit);
		Assert.equals(SOURCE, unit.source);
		Assert.equals(0, unit.start);
		Assert.equals(13, unit.end);
		Assert.equals(0, unit.line);
		Assert.equals(0, unit.column);
		Assert.equals(0, unit.endLine);
		Assert.equals(13, unit.endColumn);
		Assert.isOfType(unit, IMXHXTextData);
		var textData = cast(unit, IMXHXTextData);
		Assert.equals(MXHXTextType.Comment, textData.textType);
		Assert.equals(" comment ", textData.content);
	}
}
