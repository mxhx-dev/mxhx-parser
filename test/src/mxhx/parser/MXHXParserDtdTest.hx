package mxhx.parser;

import utest.Assert;
import utest.Test;

class MXHXParserDtdTest extends Test {
	private static final SOURCE = "source.mxhx";

	public function testParserWithDtd():Void {
		var parser = new MXHXParser("<!DOCTYPE note SYSTEM \"Note.dtd\">", SOURCE);
		var mxhxData = parser.parse();

		Assert.notNull(mxhxData);
		Assert.notNull(mxhxData.problems);
		Assert.equals(0, mxhxData.problems.length);

		Assert.isNull(mxhxData.rootTag);
		Assert.equals(SOURCE, mxhxData.source);
		Assert.equals(0, mxhxData.numUnits);
	}

	public function testParserWithDtdUnclosed():Void {
		var parser = new MXHXParser("<!DOCTYPE unclosed", SOURCE);
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
		Assert.equals(0, mxhxData.numUnits);
	}
}
