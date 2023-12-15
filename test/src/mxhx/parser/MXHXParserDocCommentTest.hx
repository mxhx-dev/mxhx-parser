package mxhx.parser;

import utest.Assert;
import utest.Test;

class MXHXParserDocCommentTest extends Test {
	private static final SOURCE = "source.mxhx";

	public function testParserWithDocComment():Void {
		var parser = new MXHXParser("<!--- doc comment -->", SOURCE);
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
		Assert.equals(21, unit.end);
		Assert.isOfType(unit, IMXHXTextData);
		var textData = cast(unit, IMXHXTextData);
		Assert.equals(MXHXTextType.DocComment, textData.textType);
		Assert.equals(" doc comment ", textData.content);
	}

	public function testParserWithMultilineDocComment():Void {
		var parser = new MXHXParser("<!--- multiline\ndoc comment -->", SOURCE);
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
		Assert.equals(31, unit.end);
		Assert.isOfType(unit, IMXHXTextData);
		var textData = cast(unit, IMXHXTextData);
		Assert.equals(MXHXTextType.DocComment, textData.textType);
		Assert.equals(" multiline\ndoc comment ", textData.content);
	}

	public function testParserWithEmptyDocComment():Void {
		var parser = new MXHXParser("<!----->", SOURCE);
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
		Assert.equals(8, unit.end);
		Assert.isOfType(unit, IMXHXTextData);
		var textData = cast(unit, IMXHXTextData);
		Assert.equals(MXHXTextType.DocComment, textData.textType);
		Assert.equals("", textData.content);
	}

	public function testParserWithDocCommentUnclosed():Void {
		var parser = new MXHXParser("<!--- doc comment ", SOURCE);
		var mxhxData = parser.parse();

		Assert.notNull(mxhxData);
		Assert.notNull(mxhxData.problems);
		Assert.equals(1, mxhxData.problems.length);
		var problem = mxhxData.problems[0];
		Assert.notNull(problem);
		Assert.equals(1549, problem.code);
		Assert.equals(SOURCE, problem.source);
		Assert.equals(17, problem.start);
		Assert.equals(18, problem.end);

		Assert.isNull(mxhxData.rootTag);
		Assert.equals(SOURCE, mxhxData.source);
		Assert.equals(1, mxhxData.numUnits);

		var unit = mxhxData.unitAt(0);
		Assert.notNull(unit);
		Assert.equals(SOURCE, unit.source);
		Assert.equals(0, unit.start);
		Assert.equals(18, unit.end);
		Assert.isOfType(unit, IMXHXTextData);
		var textData = cast(unit, IMXHXTextData);
		Assert.equals(MXHXTextType.DocComment, textData.textType);
		Assert.equals(" doc comment ", textData.content);
	}
}
