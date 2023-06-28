package mxhx.internal;

import utest.Assert;
import utest.Test;

class MXHXTagAttributeDataTest extends Test {
	private static final SOURCE = "source.mxhx";

	public function testName():Void {
		var attr = new MXHXTagAttributeData();
		attr.name = "attr";
		Assert.equals("attr", attr.name);
		Assert.equals("attr", attr.shortName);
		Assert.equals("", attr.prefix);
		Assert.isNull(attr.stateName);
		Assert.isNull(attr.uri);
	}

	public function testNameWithPrefix():Void {
		var attr = new MXHXTagAttributeData();
		attr.name = "p:attr";
		Assert.equals("p:attr", attr.name);
		Assert.equals("attr", attr.shortName);
		Assert.equals("p", attr.prefix);
		Assert.isNull(attr.stateName);
		Assert.isNull(attr.uri);
	}

	public function testNameWithState():Void {
		var attr = new MXHXTagAttributeData();
		attr.name = "attr.state";
		Assert.equals("attr.state", attr.name);
		Assert.equals("attr", attr.shortName);
		Assert.equals("", attr.prefix);
		Assert.equals("state", attr.stateName);
		Assert.isNull(attr.uri);
	}

	public function testNameWithPrefixAndState():Void {
		var attr = new MXHXTagAttributeData();
		attr.name = "p:attr.state";
		Assert.equals("p:attr.state", attr.name);
		Assert.equals("attr", attr.shortName);
		Assert.equals("p", attr.prefix);
		Assert.equals("state", attr.stateName);
		Assert.isNull(attr.uri);
	}

	public function testHasValue():Void {
		var attr = new MXHXTagAttributeData("attr");
		Assert.isFalse(attr.hasValue);
		Assert.isNull(attr.rawValue);
		attr.setValueIncludingDelimeters("\"123.4\"");
		Assert.isTrue(attr.hasValue);
		Assert.equals("123.4", attr.rawValue);
	}

	public function testValueStartAndValueEnd():Void {
		var attr = new MXHXTagAttributeData("attr");
		Assert.equals(-1, attr.valueStart);
		Assert.equals(-1, attr.valueEnd);
		attr.setValueIncludingDelimeters("\"123.4\"");
		attr.setValueStartIncludingDelimiters(5);
		Assert.equals(6, attr.valueStart);
		Assert.equals(11, attr.valueEnd);
	}
}
