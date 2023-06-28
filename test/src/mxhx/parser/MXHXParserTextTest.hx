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
		Assert.notNull(mxhxData.units);
		Assert.equals(1, mxhxData.units.length);

		var unit = mxhxData.units[0];
		Assert.notNull(unit);
		Assert.equals(SOURCE, unit.source);
		Assert.equals(0, unit.start);
		Assert.equals(14, unit.end);
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
		Assert.notNull(mxhxData.units);
		Assert.equals(1, mxhxData.units.length);

		var unit = mxhxData.units[0];
		Assert.notNull(unit);
		Assert.equals(SOURCE, unit.source);
		Assert.equals(0, unit.start);
		Assert.equals(24, unit.end);
		Assert.isOfType(unit, IMXHXTextData);
		var textData = cast(unit, IMXHXTextData);
		Assert.equals(MXHXTextType.Text, textData.textType);
		Assert.equals(text, textData.content);
	}
}
