package mxhx.parser;

import utest.Assert;
import utest.Test;

class MXHXParserCDataTest extends Test {
	private static final SOURCE = "source.mxhx";

	public function testParserWithCData():Void {
		var parser = new MXHXParser("<![CDATA[ cdata ]]>", SOURCE);
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
		Assert.equals(19, unit.end);
		Assert.isOfType(unit, IMXHXTextData);
		var textData = cast(unit, IMXHXTextData);
		Assert.equals(MXHXTextType.CData, textData.textType);
		Assert.equals(" cdata ", textData.content);
	}

	public function testParserWithMultilineCData():Void {
		var parser = new MXHXParser("<![CDATA[ multiline\ncdata ]]>", SOURCE);
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
		Assert.equals(29, unit.end);
		Assert.isOfType(unit, IMXHXTextData);
		var textData = cast(unit, IMXHXTextData);
		Assert.equals(MXHXTextType.CData, textData.textType);
		Assert.equals(" multiline\ncdata ", textData.content);
	}

	public function testParserWithEmptyCData():Void {
		var parser = new MXHXParser("<![CDATA[]]>", SOURCE);
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
		Assert.equals(12, unit.end);
		Assert.isOfType(unit, IMXHXTextData);
		var textData = cast(unit, IMXHXTextData);
		Assert.equals(MXHXTextType.CData, textData.textType);
		Assert.equals("", textData.content);
	}

	public function testParserWithCDataUnclosed():Void {
		var parser = new MXHXParser("<![CDATA[ cdata ", SOURCE);
		var mxhxData = parser.parse();

		Assert.notNull(mxhxData);
		Assert.notNull(mxhxData.problems);
		Assert.equals(1, mxhxData.problems.length);
		var problem = mxhxData.problems[0];
		Assert.notNull(problem);
		Assert.equals(1549, problem.code);
		Assert.equals(SOURCE, problem.source);
		Assert.equals(15, problem.start);
		Assert.equals(16, problem.end);

		Assert.isNull(mxhxData.rootTag);
		Assert.equals(SOURCE, mxhxData.source);
		Assert.notNull(mxhxData.units);
		Assert.equals(1, mxhxData.units.length);

		var unit = mxhxData.units[0];
		Assert.notNull(unit);
		Assert.equals(SOURCE, unit.source);
		Assert.equals(0, unit.start);
		Assert.equals(16, unit.end);
		Assert.isOfType(unit, IMXHXTextData);
		var textData = cast(unit, IMXHXTextData);
		Assert.equals(MXHXTextType.CData, textData.textType);
		Assert.equals(" cdata ", textData.content);
	}
}
