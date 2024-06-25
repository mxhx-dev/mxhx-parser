package mxhx.internal;

import utest.Assert;
import utest.Test;

class MXHXTextDataTest extends Test {
	private static final SOURCE = "source.mxhx";

	public function testCloneTextData():Void {
		var mxhxData = new MXHXData(SOURCE);

		var rootTag = new MXHXTagData();
		rootTag.init("<RootTag");
		rootTag.setLocation(mxhxData, 0);
		rootTag.setOffsets(0, 26);
		mxhxData.units.push(rootTag);

		var text = new MXHXTextData("hello world", CData);
		text.setLocation(mxhxData, 1);
		text.setOffsets(26, 37);
		text.parentUnitIndex = 0;
		mxhxData.units.push(text);

		var clonedText = text.clone();
		Assert.notNull(clonedText);
		Assert.notEquals(text, clonedText);
		Assert.equals("hello world", clonedText.content);
		Assert.equals(MXHXTextType.CData, clonedText.textType);
		Assert.equals(SOURCE, clonedText.source);
		Assert.equals(1, clonedText.index);
		Assert.equals(0, clonedText.parentUnitIndex);
		Assert.equals(26, clonedText.start);
		Assert.equals(37, clonedText.end);
		Assert.equals(mxhxData, clonedText.parent);
		Assert.equals(rootTag, clonedText.parentUnit);
	}
}
