package mxhx.parser;

import utest.Assert;
import utest.Test;

class MXHXParserTest extends Test {
	private static final SOURCE = "source.mxhx";

	public function testParserWithEmptyString():Void {
		var parser = new MXHXParser("", SOURCE);

		var mxhxData = parser.parse();

		Assert.notNull(mxhxData);
		Assert.notNull(mxhxData.problems);
		// the parser doesn't care if there's no root tag
		// that gets handled at a higher level
		Assert.equals(0, mxhxData.problems.length);

		Assert.isNull(mxhxData.rootTag);
		Assert.equals(SOURCE, mxhxData.source);
		Assert.equals(0, mxhxData.numUnits);
	}
}
