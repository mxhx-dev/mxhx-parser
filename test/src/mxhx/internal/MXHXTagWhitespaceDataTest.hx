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
		whitespace.start = 11;
		whitespace.end = 17;
		whitespace.line = 0;
		whitespace.column = 11;
		whitespace.endLine = 0;
		whitespace.endColumn = 17;
		parentTag.contentData = [whitespace];

		var clonedWhitespace = whitespace.clone();
		Assert.notNull(clonedWhitespace);
		Assert.notEquals(whitespace, clonedWhitespace);
		Assert.equals(" \t\t   ", clonedWhitespace.content);
		Assert.equals(parentTag, clonedWhitespace.parentTag);
		Assert.equals(11, clonedWhitespace.start);
		Assert.equals(17, clonedWhitespace.end);
		Assert.equals(0, clonedWhitespace.line);
		Assert.equals(11, clonedWhitespace.column);
		Assert.equals(0, clonedWhitespace.endLine);
		Assert.equals(17, clonedWhitespace.endColumn);
	}
}
