package mxhx.internal;

import utest.Assert;
import utest.Test;

class MXHXTagWhitespaceDataTest extends Test {
	private static final SOURCE = "source.mxhx";

	public function testCloneTagWhitespaceData():Void {
		var parentTag = new MXHXTagData();
		parentTag.init("<ParentTag");

		var whitespace = new MXHXTagWhitespaceData(" \t\t   ");
		whitespace.parentTag = parentTag;
		parentTag.contentData = [whitespace];

		var clonedWhitespace = whitespace.clone();
		Assert.notNull(clonedWhitespace);
		Assert.notEquals(whitespace, clonedWhitespace);
		Assert.equals(" \t\t   ", clonedWhitespace.content);
		Assert.equals(parentTag, clonedWhitespace.parentTag);
	}
}
