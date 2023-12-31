package mxhx.parser;

import utest.Assert;
import utest.Test;

class MXHXParserTextTest extends Test {
	private static final SOURCE = "source.mxhx";

	public function testParserWithText():Void {
		var text = "Just Some Text";
		var parser = new MXHXParser(text, SOURCE);
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
		Assert.equals(14, unit.end);
		Assert.equals(0, unit.line);
		Assert.equals(0, unit.column);
		Assert.equals(0, unit.endLine);
		Assert.equals(14, unit.endColumn);
		Assert.isOfType(unit, IMXHXTextData);
		var textData = cast(unit, IMXHXTextData);
		Assert.equals(MXHXTextType.Text, textData.textType);
		Assert.equals(text, textData.content);
	}

	public function testParserWithMultilineText():Void {
		var text = "Just Some\nMultiline Text";
		var parser = new MXHXParser(text, SOURCE);
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
		Assert.equals(24, unit.end);
		Assert.equals(0, unit.line);
		Assert.equals(0, unit.column);
		Assert.equals(1, unit.endLine);
		Assert.equals(14, unit.endColumn);
		Assert.isOfType(unit, IMXHXTextData);
		var textData = cast(unit, IMXHXTextData);
		Assert.equals(MXHXTextType.Text, textData.textType);
		Assert.equals(text, textData.content);
	}
}
