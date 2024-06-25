package mxhx.internal;

import utest.Assert;
import utest.Test;

class MXHXTagDataTest extends Test {
	private static final SOURCE = "source.mxhx";

	public function testOpenTagName():Void {
		var tag = new MXHXTagData();
		tag.init("<Tag");
		Assert.equals("Tag", tag.name);
		Assert.equals("Tag", tag.shortName);
		Assert.equals("", tag.prefix);
		Assert.isNull(tag.stateName);
		Assert.isNull(tag.uri);
		Assert.isTrue(tag.isOpenTag());
		Assert.isFalse(tag.isCloseTag());
		Assert.isFalse(tag.isEmptyTag());
	}

	public function testOpenTagNameWithPrefix():Void {
		var tag = new MXHXTagData();
		tag.init("<p:Tag");
		Assert.equals("p:Tag", tag.name);
		Assert.equals("Tag", tag.shortName);
		Assert.equals("p", tag.prefix);
		Assert.isNull(tag.stateName);
		Assert.isNull(tag.uri);
		Assert.isTrue(tag.isOpenTag());
		Assert.isFalse(tag.isCloseTag());
		Assert.isFalse(tag.isEmptyTag());
	}

	public function testOpenTagNameWithState():Void {
		var tag = new MXHXTagData();
		tag.init("<Tag.state");
		Assert.equals("Tag.state", tag.name);
		Assert.equals("Tag", tag.shortName);
		Assert.equals("", tag.prefix);
		Assert.equals("state", tag.stateName);
		Assert.isNull(tag.uri);
		Assert.isTrue(tag.isOpenTag());
		Assert.isFalse(tag.isCloseTag());
		Assert.isFalse(tag.isEmptyTag());
	}

	public function testOpenTagNameWithPrefixAndState():Void {
		var tag = new MXHXTagData();
		tag.init("<p:tag.state");
		Assert.equals("p:tag.state", tag.name);
		Assert.equals("tag", tag.shortName);
		Assert.equals("p", tag.prefix);
		Assert.equals("state", tag.stateName);
		Assert.isNull(tag.uri);
		Assert.isTrue(tag.isOpenTag());
		Assert.isFalse(tag.isCloseTag());
		Assert.isFalse(tag.isEmptyTag());
	}

	public function testCloseTagName():Void {
		var tag = new MXHXTagData();
		tag.init("</p:Tag");
		Assert.equals("p:Tag", tag.name);
		Assert.equals("Tag", tag.shortName);
		Assert.equals("p", tag.prefix);
		Assert.isNull(tag.stateName);
		Assert.isNull(tag.uri);
		Assert.isFalse(tag.isOpenTag());
		Assert.isTrue(tag.isCloseTag());
		Assert.isFalse(tag.isEmptyTag());
	}

	public function testIsOpenTag():Void {
		var tag = new MXHXTagData();
		tag.init("<p:Tag");
		Assert.isTrue(tag.isOpenTag());
		Assert.isFalse(tag.isCloseTag());
		Assert.isFalse(tag.isEmptyTag());
	}

	public function testIsCloseTag():Void {
		var tag = new MXHXTagData();
		tag.init("</p:Tag");
		Assert.isFalse(tag.isOpenTag());
		Assert.isTrue(tag.isCloseTag());
		Assert.isFalse(tag.isEmptyTag());
	}

	public function testEmptyTag():Void {
		var tag = new MXHXTagData();
		tag.init("<p:Tag");
		Assert.isFalse(tag.isEmptyTag());
		Assert.isTrue(tag.isOpenTag());
		Assert.isFalse(tag.isCloseTag());
		tag.setEmptyTag(true);
		Assert.isTrue(tag.isEmptyTag());
		Assert.isTrue(tag.isOpenTag());
		Assert.isFalse(tag.isCloseTag());
	}

	public function testExplicitCloseToken():Void {
		var tag = new MXHXTagData();
		tag.init("<p:Tag");
		Assert.isFalse(tag.hasExplicitCloseToken());
		tag.setExplicitCloseToken(true);
		Assert.isTrue(tag.hasExplicitCloseToken());
	}

	public function testGetNextSiblingTag():Void {
		var mxhxData = new MXHXData(SOURCE);

		var openTag0 = new MXHXTagData();
		openTag0.init("<p:Tag");
		openTag0.source = SOURCE;
		openTag0.index = 0;
		openTag0.start = 0;
		openTag0.end = 7;
		openTag0.parent = mxhxData;

		var closeTag0 = new MXHXTagData();
		closeTag0.init("</p:Tag");
		closeTag0.source = SOURCE;
		closeTag0.index = 1;
		closeTag0.start = 7;
		closeTag0.end = 15;
		closeTag0.parent = mxhxData;

		var openTag1 = new MXHXTagData();
		openTag1.init("<p:Other");
		openTag1.source = SOURCE;
		openTag1.index = 2;
		openTag1.start = 15;
		openTag1.end = 24;
		openTag1.parent = mxhxData;

		var closeTag1 = new MXHXTagData();
		closeTag1.init("</p:Other");
		closeTag1.source = SOURCE;
		closeTag1.index = 3;
		closeTag1.start = 24;
		closeTag1.end = 34;
		closeTag1.parent = mxhxData;

		mxhxData.units = [openTag0, closeTag0, openTag1, closeTag1];

		Assert.equals(openTag1, openTag0.getNextSiblingTag(true));
		Assert.equals(openTag1, closeTag0.getNextSiblingTag(true));
	}

	public function testGetNextSiblingTagWithEmptyTag():Void {
		var mxhxData = new MXHXData(SOURCE);

		var openTag0 = new MXHXTagData();
		openTag0.init("<p:Tag");
		openTag0.source = SOURCE;
		openTag0.index = 0;
		openTag0.start = 0;
		openTag0.end = 7;
		openTag0.parent = mxhxData;

		var closeTag0 = new MXHXTagData();
		closeTag0.init("</p:Tag");
		closeTag0.source = SOURCE;
		closeTag0.index = 1;
		closeTag0.start = 7;
		closeTag0.end = 15;
		closeTag0.parent = mxhxData;

		var emptyTag1 = new MXHXTagData();
		emptyTag1.init("<p:Other");
		emptyTag1.source = SOURCE;
		emptyTag1.index = 2;
		emptyTag1.start = 15;
		emptyTag1.end = 25;
		emptyTag1.setEmptyTag(true);
		emptyTag1.parent = mxhxData;

		mxhxData.units = [openTag0, closeTag0, emptyTag1];

		Assert.equals(emptyTag1, openTag0.getNextSiblingTag(true));
		Assert.equals(emptyTag1, closeTag0.getNextSiblingTag(true));
		Assert.isNull(openTag0.getNextSiblingTag(false));
		Assert.isNull(closeTag0.getNextSiblingTag(false));
	}

	public function testFindMatchingCloseTag():Void {
		var mxhxData = new MXHXData(SOURCE);

		var openTag = new MXHXTagData();
		openTag.init("<p:Tag");
		openTag.source = SOURCE;
		openTag.index = 0;
		openTag.start = 0;
		openTag.end = 7;
		openTag.parent = mxhxData;

		var closeTag = new MXHXTagData();
		closeTag.init("</p:Tag");
		closeTag.source = SOURCE;
		closeTag.index = 1;
		closeTag.start = 7;
		closeTag.end = 15;
		closeTag.parent = mxhxData;

		mxhxData.units = [openTag, closeTag];

		Assert.equals(closeTag, openTag.findMatchingCloseTag());
	}

	public function testFindMatchingCloseTagNested():Void {
		var mxhxData = new MXHXData(SOURCE);

		var outerOpenTag = new MXHXTagData();
		outerOpenTag.init("<p:Outer");
		outerOpenTag.source = SOURCE;
		outerOpenTag.index = 0;
		outerOpenTag.start = 0;
		outerOpenTag.end = 7;
		outerOpenTag.parent = mxhxData;

		var innerOpenTag = new MXHXTagData();
		innerOpenTag.init("<p:Inner");
		innerOpenTag.source = SOURCE;
		innerOpenTag.index = 1;
		innerOpenTag.start = 7;
		innerOpenTag.end = 16;
		innerOpenTag.parent = mxhxData;

		var innerCloseTag = new MXHXTagData();
		innerCloseTag.init("</p:Inner");
		innerCloseTag.source = SOURCE;
		innerCloseTag.index = 2;
		innerCloseTag.start = 16;
		innerCloseTag.end = 26;
		innerCloseTag.parent = mxhxData;

		var outerCloseTag = new MXHXTagData();
		outerCloseTag.init("</p:Outer");
		outerCloseTag.source = SOURCE;
		outerCloseTag.index = 3;
		outerCloseTag.start = 26;
		outerCloseTag.end = 36;
		outerCloseTag.parent = mxhxData;

		mxhxData.units = [outerOpenTag, innerOpenTag, innerCloseTag, outerCloseTag];

		Assert.equals(outerCloseTag, outerOpenTag.findMatchingCloseTag());
		Assert.equals(innerCloseTag, innerOpenTag.findMatchingCloseTag());
	}

	public function testFindMatchingOpenTag():Void {
		var mxhxData = new MXHXData(SOURCE);

		var openTag = new MXHXTagData();
		openTag.init("<p:Tag");
		openTag.source = SOURCE;
		openTag.index = 0;
		openTag.start = 0;
		openTag.end = 7;
		openTag.parent = mxhxData;

		var closeTag = new MXHXTagData();
		closeTag.init("</p:Tag");
		closeTag.source = SOURCE;
		closeTag.index = 1;
		closeTag.start = 7;
		closeTag.end = 15;
		closeTag.parent = mxhxData;

		mxhxData.units = [openTag, closeTag];

		Assert.equals(openTag, closeTag.findMatchingOpenTag());
	}

	public function testFindMatchingOpenTagNested():Void {
		var mxhxData = new MXHXData(SOURCE);

		var outerOpenTag = new MXHXTagData();
		outerOpenTag.init("<p:Outer");
		outerOpenTag.source = SOURCE;
		outerOpenTag.index = 0;
		outerOpenTag.start = 0;
		outerOpenTag.end = 7;
		outerOpenTag.parent = mxhxData;

		var innerOpenTag = new MXHXTagData();
		innerOpenTag.init("<p:Inner");
		innerOpenTag.source = SOURCE;
		innerOpenTag.index = 1;
		innerOpenTag.start = 7;
		innerOpenTag.end = 16;
		innerOpenTag.parent = mxhxData;

		var innerCloseTag = new MXHXTagData();
		innerCloseTag.init("</p:Inner");
		innerCloseTag.source = SOURCE;
		innerCloseTag.index = 2;
		innerCloseTag.start = 16;
		innerCloseTag.end = 26;
		innerCloseTag.parent = mxhxData;

		var outerCloseTag = new MXHXTagData();
		outerCloseTag.init("</p:Outer");
		outerCloseTag.source = SOURCE;
		outerCloseTag.index = 3;
		outerCloseTag.start = 26;
		outerCloseTag.end = 36;
		outerCloseTag.parent = mxhxData;

		mxhxData.units = [outerOpenTag, innerOpenTag, innerCloseTag, outerCloseTag];

		Assert.equals(outerOpenTag, outerCloseTag.findMatchingOpenTag());
		Assert.equals(innerOpenTag, innerCloseTag.findMatchingOpenTag());
	}

	public function testCloneTagData():Void {
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

		var clonedTag = tag.clone();
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
		Assert.equals(mxhxData, clonedTag.parent);
		Assert.equals(rootTag, clonedTag.parentTag);

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
