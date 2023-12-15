package mxhx.parser;

import utest.Assert;
import utest.Test;

class MXHXParserTagAttributeTest extends Test {
	private static final SOURCE = "source.mxhx";

	public function testParserWithAttribute():Void {
		var parser = new MXHXParser("<p:Tag attribute=\"value\"/>", SOURCE);
		var mxhxData = parser.parse();

		Assert.notNull(mxhxData);
		Assert.notNull(mxhxData.problems);
		Assert.equals(0, mxhxData.problems.length);

		Assert.notNull(mxhxData.rootTag);
		Assert.equals(SOURCE, mxhxData.source);
		Assert.equals(1, mxhxData.numUnits);

		var unit0 = mxhxData.unitAt(0);
		Assert.notNull(unit0);
		Assert.equals(SOURCE, unit0.source);
		Assert.equals(0, unit0.start);
		Assert.equals(26, unit0.end);
		Assert.isOfType(unit0, IMXHXTagData);
		var tagData0 = cast(unit0, IMXHXTagData);
		Assert.equals(mxhxData.rootTag, tagData0);
		Assert.equals("p:Tag", tagData0.name);
		Assert.equals("Tag", tagData0.shortName);
		Assert.equals("p", tagData0.prefix);

		Assert.equals(1, tagData0.attributeData.length);
		var attrData0 = tagData0.attributeData[0];
		Assert.notNull(attrData0);
		Assert.notNull(attrData0.parentTag);
		Assert.equals(tagData0, attrData0.parentTag);
		Assert.equals(attrData0, tagData0.getAttributeData("attribute"));
		Assert.equals(SOURCE, attrData0.source);
		Assert.equals(7, attrData0.start);
		Assert.equals(24, attrData0.end);
		Assert.equals("attribute", attrData0.name);
		Assert.equals("attribute", attrData0.shortName);
		Assert.equals("", attrData0.prefix);
		Assert.isNull(attrData0.stateName);
		Assert.isNull(attrData0.uri);
		Assert.isTrue(attrData0.hasValue);
		Assert.equals(18, attrData0.valueStart);
		Assert.equals(23, attrData0.valueEnd);
		Assert.equals("value", attrData0.rawValue);
		Assert.equals("value", tagData0.getRawAttributeValue("attribute"));
		Assert.equals(1, tagData0.contentStart);
		Assert.equals(24, tagData0.contentEnd);
	}

	public function testParserWithAttributeWithPrefix():Void {
		var parser = new MXHXParser("<p:Tag q:attribute=\"value\"/>", SOURCE);
		var mxhxData = parser.parse();

		Assert.notNull(mxhxData);
		Assert.notNull(mxhxData.problems);
		Assert.equals(0, mxhxData.problems.length);

		Assert.notNull(mxhxData.rootTag);
		Assert.equals(SOURCE, mxhxData.source);
		Assert.equals(1, mxhxData.numUnits);

		var unit0 = mxhxData.unitAt(0);
		Assert.notNull(unit0);
		Assert.equals(SOURCE, unit0.source);
		Assert.equals(0, unit0.start);
		Assert.equals(28, unit0.end);
		Assert.isOfType(unit0, IMXHXTagData);
		var tagData0 = cast(unit0, IMXHXTagData);
		Assert.equals(mxhxData.rootTag, tagData0);
		Assert.equals("p:Tag", tagData0.name);
		Assert.equals("Tag", tagData0.shortName);
		Assert.equals("p", tagData0.prefix);

		Assert.equals(1, tagData0.attributeData.length);
		var attrData0 = tagData0.attributeData[0];
		Assert.notNull(attrData0);
		Assert.notNull(attrData0.parentTag);
		Assert.equals(tagData0, attrData0.parentTag);
		Assert.equals(attrData0, tagData0.getAttributeData("q:attribute"));
		Assert.equals(SOURCE, attrData0.source);
		Assert.equals(7, attrData0.start);
		Assert.equals(26, attrData0.end);
		Assert.equals("q:attribute", attrData0.name);
		Assert.equals("attribute", attrData0.shortName);
		Assert.equals("q", attrData0.prefix);
		Assert.isNull(attrData0.stateName);
		Assert.isNull(attrData0.uri);
		Assert.isTrue(attrData0.hasValue);
		Assert.equals(20, attrData0.valueStart);
		Assert.equals(25, attrData0.valueEnd);
		Assert.equals("value", attrData0.rawValue);
		Assert.equals("value", tagData0.getRawAttributeValue("q:attribute"));
	}

	public function testParserWithAttributeWithState():Void {
		var parser = new MXHXParser("<p:Tag attribute.state=\"value\"/>", SOURCE);
		var mxhxData = parser.parse();

		Assert.notNull(mxhxData);
		Assert.notNull(mxhxData.problems);
		Assert.equals(0, mxhxData.problems.length);

		Assert.notNull(mxhxData.rootTag);
		Assert.equals(SOURCE, mxhxData.source);
		Assert.equals(1, mxhxData.numUnits);

		var unit0 = mxhxData.unitAt(0);
		Assert.notNull(unit0);
		Assert.equals(SOURCE, unit0.source);
		Assert.equals(0, unit0.start);
		Assert.equals(32, unit0.end);
		Assert.isOfType(unit0, IMXHXTagData);
		var tagData0 = cast(unit0, IMXHXTagData);
		Assert.equals(mxhxData.rootTag, tagData0);
		Assert.equals("p:Tag", tagData0.name);
		Assert.equals("Tag", tagData0.shortName);
		Assert.equals("p", tagData0.prefix);

		Assert.equals(1, tagData0.attributeData.length);
		var attrData0 = tagData0.attributeData[0];
		Assert.notNull(attrData0);
		Assert.notNull(attrData0.parentTag);
		Assert.equals(tagData0, attrData0.parentTag);
		Assert.equals(attrData0, tagData0.getAttributeData("attribute.state"));
		Assert.equals(SOURCE, attrData0.source);
		Assert.equals(7, attrData0.start);
		Assert.equals(30, attrData0.end);
		Assert.equals("attribute.state", attrData0.name);
		Assert.equals("attribute", attrData0.shortName);
		Assert.equals("", attrData0.prefix);
		Assert.equals("state", attrData0.stateName);
		Assert.isNull(attrData0.uri);
		Assert.isTrue(attrData0.hasValue);
		Assert.equals(24, attrData0.valueStart);
		Assert.equals(29, attrData0.valueEnd);
		Assert.equals("value", attrData0.rawValue);
		Assert.equals("value", tagData0.getRawAttributeValue("attribute.state"));
	}

	public function testParserWithAttributeNoValue1():Void {
		var parser = new MXHXParser("<p:Tag attribute/>", SOURCE);
		var mxhxData = parser.parse();

		Assert.notNull(mxhxData);
		Assert.notNull(mxhxData.problems);
		Assert.equals(1, mxhxData.problems.length);
		var problem = mxhxData.problems[0];
		Assert.notNull(problem);
		Assert.equals(1510, problem.code);
		Assert.equals(SOURCE, problem.source);
		Assert.equals(7, problem.start);
		Assert.equals(16, problem.end);

		Assert.notNull(mxhxData.rootTag);
		Assert.equals(SOURCE, mxhxData.source);
		Assert.equals(1, mxhxData.numUnits);

		var unit0 = mxhxData.unitAt(0);
		Assert.notNull(unit0);
		Assert.equals(SOURCE, unit0.source);
		Assert.equals(0, unit0.start);
		Assert.equals(18, unit0.end);
		Assert.isOfType(unit0, IMXHXTagData);
		var tagData0 = cast(unit0, IMXHXTagData);
		Assert.equals(mxhxData.rootTag, tagData0);
		Assert.equals("p:Tag", tagData0.name);
		Assert.equals("Tag", tagData0.shortName);
		Assert.equals("p", tagData0.prefix);

		Assert.equals(1, tagData0.attributeData.length);
		var attrData0 = tagData0.attributeData[0];
		Assert.notNull(attrData0);
		Assert.notNull(attrData0.parentTag);
		Assert.equals(tagData0, attrData0.parentTag);
		Assert.equals(attrData0, tagData0.getAttributeData("attribute"));
		Assert.equals(SOURCE, attrData0.source);
		Assert.equals(7, attrData0.start);
		Assert.equals(16, attrData0.end);
		Assert.equals("attribute", attrData0.name);
		Assert.equals("attribute", attrData0.shortName);
		Assert.equals("", attrData0.prefix);
		Assert.isNull(attrData0.stateName);
		Assert.isNull(attrData0.uri);
		Assert.isFalse(attrData0.hasValue);
		Assert.equals(-1, attrData0.valueStart);
		Assert.equals(-1, attrData0.valueEnd);
		Assert.isNull(attrData0.rawValue);
		Assert.isNull(tagData0.getRawAttributeValue("attribute"));
	}

	public function testParserWithAttributeNoValue2():Void {
		var parser = new MXHXParser("<p:Tag attribute=/>", SOURCE);
		var mxhxData = parser.parse();

		Assert.notNull(mxhxData);
		Assert.notNull(mxhxData.problems);
		Assert.equals(1, mxhxData.problems.length);
		var problem = mxhxData.problems[0];
		Assert.notNull(problem);
		Assert.equals(1510, problem.code);
		Assert.equals(SOURCE, problem.source);
		Assert.equals(7, problem.start);
		Assert.equals(17, problem.end);

		Assert.notNull(mxhxData.rootTag);
		Assert.equals(SOURCE, mxhxData.source);
		Assert.equals(1, mxhxData.numUnits);

		var unit0 = mxhxData.unitAt(0);
		Assert.notNull(unit0);
		Assert.equals(SOURCE, unit0.source);
		Assert.equals(0, unit0.start);
		Assert.equals(19, unit0.end);
		Assert.isOfType(unit0, IMXHXTagData);
		var tagData0 = cast(unit0, IMXHXTagData);
		Assert.equals(mxhxData.rootTag, tagData0);
		Assert.equals("p:Tag", tagData0.name);
		Assert.equals("Tag", tagData0.shortName);
		Assert.equals("p", tagData0.prefix);

		Assert.equals(1, tagData0.attributeData.length);
		var attrData0 = tagData0.attributeData[0];
		Assert.notNull(attrData0);
		Assert.notNull(attrData0.parentTag);
		Assert.equals(tagData0, attrData0.parentTag);
		Assert.equals(attrData0, tagData0.getAttributeData("attribute"));
		Assert.equals(SOURCE, attrData0.source);
		Assert.equals(7, attrData0.start);
		Assert.equals(17, attrData0.end);
		Assert.equals("attribute", attrData0.name);
		Assert.equals("attribute", attrData0.shortName);
		Assert.equals("", attrData0.prefix);
		Assert.isNull(attrData0.stateName);
		Assert.isNull(attrData0.uri);
		Assert.isFalse(attrData0.hasValue);
		Assert.equals(-1, attrData0.valueStart);
		Assert.equals(-1, attrData0.valueEnd);
		Assert.isNull(attrData0.rawValue);
		Assert.isNull(tagData0.getRawAttributeValue("attribute"));
	}
}
