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
		rootTag.line = 0;
		rootTag.column = 0;
		rootTag.endLine = 0;
		rootTag.endColumn = 26;
		mxhxData.units.push(rootTag);

		var tag = new MXHXTagData();
		tag.init("<p:tag.state");
		tag.setLocation(mxhxData, 1);
		tag.setOffsets(26, 61);
		tag.line = 0;
		tag.column = 26;
		tag.endLine = 0;
		tag.endColumn = 61;
		tag.parentUnitIndex = 0;
		mxhxData.units.push(tag);

		var attr = new MXHXTagAttributeData();
		attr.name = "p:attr.state";
		attr.setValueIncludingDelimeters("\"123.4\"");
		attr.parentTag = tag;
		attr.start = 39;
		attr.end = 59;
		attr.line = 0;
		attr.column = 39;
		attr.endLine = 0;
		attr.endColumn = 59;
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
		Assert.equals(0, clonedRootTag.line);
		Assert.equals(0, clonedRootTag.column);
		Assert.equals(0, clonedRootTag.endLine);
		Assert.equals(26, clonedRootTag.endColumn);
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
		Assert.equals(61, clonedTag.end);
		Assert.equals(0, clonedTag.line);
		Assert.equals(26, clonedTag.column);
		Assert.equals(0, clonedTag.endLine);
		Assert.equals(61, clonedTag.endColumn);
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
		Assert.equals(39, clonedAttr.start);
		Assert.equals(59, clonedAttr.end);
		Assert.equals(0, clonedAttr.line);
		Assert.equals(39, clonedAttr.column);
		Assert.equals(0, clonedAttr.endLine);
		Assert.equals(59, clonedAttr.endColumn);
	}
}
