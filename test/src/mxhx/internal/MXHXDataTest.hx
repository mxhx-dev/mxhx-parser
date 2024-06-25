package mxhx.internal;

import utest.Assert;
import utest.Test;

class MXHXDataTest extends Test {
	private static final SOURCE = "source.mxhx";

	public function testCloneMXHXData():Void {
		var mxhxData = new MXHXData(SOURCE);

		var rootTag = new MXHXTagData();
		rootTag.init("<RootTag");
		rootTag.setLocation(mxhxData, 0);
		rootTag.setOffsets(0, 26);
		mxhxData.units.push(rootTag);

		var tag = new MXHXTagData();
		tag.init("<p:tag.state");
		tag.setLocation(mxhxData, 1);
		tag.setOffsets(26, 36);
		tag.parentUnitIndex = 0;
		mxhxData.units.push(tag);

		var attr = new MXHXTagAttributeData();
		attr.name = "p:attr.state";
		attr.setValueIncludingDelimeters("\"123.4\"");
		attr.parentTag = tag;
		tag.attributeData = [attr];

		var clonedMxhxData = mxhxData.clone();

		var clonedRootTag = cast(clonedMxhxData.units[0], MXHXTagData);
		Assert.notNull(clonedRootTag);
		Assert.notEquals(rootTag, clonedRootTag);
		Assert.equals("RootTag", clonedRootTag.name);
		Assert.equals("RootTag", clonedRootTag.shortName);
		Assert.equals("", clonedRootTag.prefix);
		Assert.equals(SOURCE, clonedRootTag.source);
		Assert.isTrue(clonedRootTag.isOpenTag());
		Assert.isFalse(clonedRootTag.isCloseTag());
		Assert.isFalse(clonedRootTag.isEmptyTag());
		Assert.equals(0, clonedRootTag.index);
		Assert.equals(-1, clonedRootTag.parentUnitIndex);
		Assert.equals(0, clonedRootTag.start);
		Assert.equals(26, clonedRootTag.end);
		Assert.equals(clonedMxhxData, clonedRootTag.parent);
		Assert.isNull(clonedRootTag.parentTag);

		var clonedTag = cast(clonedRootTag.getNext(), MXHXTagData);
		Assert.notNull(clonedTag);
		Assert.notEquals(tag, clonedTag);
		Assert.equals("p:tag.state", clonedTag.name);
		Assert.equals("tag", clonedTag.shortName);
		Assert.equals("p", clonedTag.prefix);
		Assert.equals("state", clonedTag.stateName);
		Assert.isNull(clonedTag.uri);
		Assert.equals(SOURCE, clonedTag.source);
		Assert.isTrue(clonedTag.isOpenTag());
		Assert.isFalse(clonedTag.isCloseTag());
		Assert.isFalse(clonedTag.isEmptyTag());
		Assert.equals(1, clonedTag.index);
		Assert.equals(0, clonedTag.parentUnitIndex);
		Assert.equals(26, clonedTag.start);
		Assert.equals(36, clonedTag.end);
		Assert.equals(clonedMxhxData, clonedTag.parent);
		Assert.equals(clonedRootTag, clonedTag.parentTag);

		var clonedAttr = clonedTag.getAttributeData(attr.name);
		Assert.notNull(clonedAttr);
		Assert.notEquals(attr, clonedAttr);
		Assert.equals(clonedTag, clonedAttr.parentTag);
		Assert.equals("p:attr.state", clonedAttr.name);
		Assert.equals("attr", clonedAttr.shortName);
		Assert.equals("p", clonedAttr.prefix);
		Assert.equals("state", clonedAttr.stateName);
		Assert.isNull(clonedAttr.uri);
		Assert.isTrue(clonedAttr.hasValue);
		Assert.equals("123.4", clonedAttr.rawValue);
	}
}
