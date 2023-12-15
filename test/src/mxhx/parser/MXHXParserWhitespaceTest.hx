package mxhx.parser;

import utest.Assert;
import utest.Test;

class MXHXParserWhitespaceTest extends Test {
	private static final SOURCE = "source.mxhx";

	public function testParserWithWhitespace():Void {
		var text = " \t\n ";
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
		Assert.equals(4, unit.end);
		Assert.isOfType(unit, IMXHXTextData);
		var textData = cast(unit, IMXHXTextData);
		Assert.equals(MXHXTextType.Whitespace, textData.textType);
		Assert.equals(text, textData.content);
	}
}
