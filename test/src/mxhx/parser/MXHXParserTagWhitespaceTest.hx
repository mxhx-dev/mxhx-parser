package mxhx.parser;

import utest.Assert;
import utest.Test;

class MXHXParserTagWhitespaceTest extends Test {
	private static final SOURCE = "source.mxhx";

	public function testParserWithSpaceBeforeAttribute():Void {
		var parser = new MXHXParser("<p:Tag attribute=\"value\"/>", SOURCE);
		parser.includeNonSignificantContent = true;
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
		Assert.equals(0, unit0.line);
		Assert.equals(0, unit0.column);
		Assert.equals(0, unit0.endLine);
		Assert.equals(26, unit0.endColumn);
		Assert.isOfType(unit0, IMXHXTagData);
		var tagData0 = cast(unit0, IMXHXTagData);
		Assert.equals(mxhxData.rootTag, tagData0);
		Assert.equals("p:Tag", tagData0.name);
		Assert.equals("Tag", tagData0.shortName);
		Assert.equals("p", tagData0.prefix);

		Assert.equals(1, tagData0.attributeData.length);
		Assert.equals(2, tagData0.contentData.length);

		var contentData0 = cast(tagData0.contentData[0], IMXHXTagWhitespaceData);
		Assert.notNull(contentData0);
		Assert.notNull(contentData0.parentTag);
		Assert.equals(tagData0, contentData0.parentTag);
		Assert.equals(SOURCE, contentData0.source);
		Assert.equals(6, contentData0.start);
		Assert.equals(7, contentData0.end);
		Assert.equals(0, contentData0.line);
		Assert.equals(6, contentData0.column);
		Assert.equals(0, contentData0.endLine);
		Assert.equals(7, contentData0.endColumn);
		Assert.equals(" ", contentData0.content);

		var contentData1 = cast(tagData0.contentData[1], IMXHXTagAttributeData);
		Assert.notNull(contentData1);
		Assert.notNull(contentData1.parentTag);
		Assert.equals(tagData0, contentData1.parentTag);
		Assert.equals(contentData1, tagData0.getAttributeData("attribute"));
		Assert.equals(SOURCE, contentData1.source);
		Assert.equals(7, contentData1.start);
		Assert.equals(24, contentData1.end);
		Assert.equals(0, contentData1.line);
		Assert.equals(7, contentData1.column);
		Assert.equals(0, contentData1.endLine);
		Assert.equals(24, contentData1.endColumn);
		Assert.equals("attribute", contentData1.name);
		Assert.equals("attribute", contentData1.shortName);
		Assert.equals("", contentData1.prefix);
		Assert.isNull(contentData1.stateName);
		Assert.isNull(contentData1.uri);
		Assert.isTrue(contentData1.hasValue);
		Assert.equals(18, contentData1.valueStart);
		Assert.equals(23, contentData1.valueEnd);
		Assert.equals("value", contentData1.rawValue);
		Assert.equals("value", tagData0.getRawAttributeValue("attribute"));
	}

	public function testParserWithTabBeforeAttribute():Void {
		var parser = new MXHXParser("<p:Tag\tattribute=\"value\"/>", SOURCE);
		parser.includeNonSignificantContent = true;
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
		Assert.equals(0, unit0.line);
		Assert.equals(0, unit0.column);
		Assert.equals(0, unit0.endLine);
		Assert.equals(26, unit0.endColumn);
		Assert.isOfType(unit0, IMXHXTagData);
		var tagData0 = cast(unit0, IMXHXTagData);
		Assert.equals(mxhxData.rootTag, tagData0);
		Assert.equals("p:Tag", tagData0.name);
		Assert.equals("Tag", tagData0.shortName);
		Assert.equals("p", tagData0.prefix);

		Assert.equals(1, tagData0.attributeData.length);
		Assert.equals(2, tagData0.contentData.length);

		var contentData0 = cast(tagData0.contentData[0], IMXHXTagWhitespaceData);
		Assert.notNull(contentData0);
		Assert.notNull(contentData0.parentTag);
		Assert.equals(tagData0, contentData0.parentTag);
		Assert.equals(SOURCE, contentData0.source);
		Assert.equals(6, contentData0.start);
		Assert.equals(7, contentData0.end);
		Assert.equals(0, contentData0.line);
		Assert.equals(6, contentData0.column);
		Assert.equals(0, contentData0.endLine);
		Assert.equals(7, contentData0.endColumn);
		Assert.equals("\t", contentData0.content);

		var contentData1 = cast(tagData0.contentData[1], IMXHXTagAttributeData);
		Assert.notNull(contentData1);
		Assert.notNull(contentData1.parentTag);
		Assert.equals(tagData0, contentData1.parentTag);
		Assert.equals(contentData1, tagData0.getAttributeData("attribute"));
		Assert.equals(SOURCE, contentData1.source);
		Assert.equals(7, contentData1.start);
		Assert.equals(24, contentData1.end);
		Assert.equals(0, contentData1.line);
		Assert.equals(7, contentData1.column);
		Assert.equals(0, contentData1.endLine);
		Assert.equals(24, contentData1.endColumn);
		Assert.equals("attribute", contentData1.name);
		Assert.equals("attribute", contentData1.shortName);
		Assert.equals("", contentData1.prefix);
		Assert.isNull(contentData1.stateName);
		Assert.isNull(contentData1.uri);
		Assert.isTrue(contentData1.hasValue);
		Assert.equals(18, contentData1.valueStart);
		Assert.equals(23, contentData1.valueEnd);
		Assert.equals("value", contentData1.rawValue);
		Assert.equals("value", tagData0.getRawAttributeValue("attribute"));
	}

	public function testParserWithNewLineBeforeAttribute():Void {
		var parser = new MXHXParser("<p:Tag\nattribute=\"value\"/>", SOURCE);
		parser.includeNonSignificantContent = true;
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
		Assert.equals(0, unit0.line);
		Assert.equals(0, unit0.column);
		Assert.equals(1, unit0.endLine);
		Assert.equals(19, unit0.endColumn);
		Assert.isOfType(unit0, IMXHXTagData);
		var tagData0 = cast(unit0, IMXHXTagData);
		Assert.equals(mxhxData.rootTag, tagData0);
		Assert.equals("p:Tag", tagData0.name);
		Assert.equals("Tag", tagData0.shortName);
		Assert.equals("p", tagData0.prefix);

		Assert.equals(1, tagData0.attributeData.length);
		Assert.equals(2, tagData0.contentData.length);

		var contentData0 = cast(tagData0.contentData[0], IMXHXTagWhitespaceData);
		Assert.notNull(contentData0);
		Assert.notNull(contentData0.parentTag);
		Assert.equals(tagData0, contentData0.parentTag);
		Assert.equals(SOURCE, contentData0.source);
		Assert.equals(6, contentData0.start);
		Assert.equals(7, contentData0.end);
		Assert.equals(0, contentData0.line);
		Assert.equals(6, contentData0.column);
		Assert.equals(1, contentData0.endLine);
		Assert.equals(0, contentData0.endColumn);
		Assert.equals("\n", contentData0.content);

		var contentData1 = cast(tagData0.contentData[1], IMXHXTagAttributeData);
		Assert.notNull(contentData1);
		Assert.notNull(contentData1.parentTag);
		Assert.equals(tagData0, contentData1.parentTag);
		Assert.equals(contentData1, tagData0.getAttributeData("attribute"));
		Assert.equals(SOURCE, contentData1.source);
		Assert.equals(7, contentData1.start);
		Assert.equals(24, contentData1.end);
		Assert.equals(1, contentData1.line);
		Assert.equals(0, contentData1.column);
		Assert.equals(1, contentData1.endLine);
		Assert.equals(17, contentData1.endColumn);
		Assert.equals("attribute", contentData1.name);
		Assert.equals("attribute", contentData1.shortName);
		Assert.equals("", contentData1.prefix);
		Assert.isNull(contentData1.stateName);
		Assert.isNull(contentData1.uri);
		Assert.isTrue(contentData1.hasValue);
		Assert.equals(18, contentData1.valueStart);
		Assert.equals(23, contentData1.valueEnd);
		Assert.equals("value", contentData1.rawValue);
		Assert.equals("value", tagData0.getRawAttributeValue("attribute"));
	}

	public function testParserWithCrlfBeforeAttribute():Void {
		var parser = new MXHXParser("<p:Tag\r\nattribute=\"value\"/>", SOURCE);
		parser.includeNonSignificantContent = true;
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
		Assert.equals(27, unit0.end);
		Assert.equals(0, unit0.line);
		Assert.equals(0, unit0.column);
		Assert.equals(1, unit0.endLine);
		Assert.equals(19, unit0.endColumn);
		Assert.isOfType(unit0, IMXHXTagData);
		var tagData0 = cast(unit0, IMXHXTagData);
		Assert.equals(mxhxData.rootTag, tagData0);
		Assert.equals("p:Tag", tagData0.name);
		Assert.equals("Tag", tagData0.shortName);
		Assert.equals("p", tagData0.prefix);

		Assert.equals(1, tagData0.attributeData.length);
		Assert.equals(2, tagData0.contentData.length);

		var contentData0 = cast(tagData0.contentData[0], IMXHXTagWhitespaceData);
		Assert.notNull(contentData0);
		Assert.notNull(contentData0.parentTag);
		Assert.equals(tagData0, contentData0.parentTag);
		Assert.equals(SOURCE, contentData0.source);
		Assert.equals(6, contentData0.start);
		Assert.equals(8, contentData0.end);
		Assert.equals(0, contentData0.line);
		Assert.equals(6, contentData0.column);
		Assert.equals(1, contentData0.endLine);
		Assert.equals(0, contentData0.endColumn);
		Assert.equals("\r\n", contentData0.content);

		var contentData1 = cast(tagData0.contentData[1], IMXHXTagAttributeData);
		Assert.notNull(contentData1);
		Assert.notNull(contentData1.parentTag);
		Assert.equals(tagData0, contentData1.parentTag);
		Assert.equals(contentData1, tagData0.getAttributeData("attribute"));
		Assert.equals(SOURCE, contentData1.source);
		Assert.equals(8, contentData1.start);
		Assert.equals(25, contentData1.end);
		Assert.equals(1, contentData1.line);
		Assert.equals(0, contentData1.column);
		Assert.equals(1, contentData1.endLine);
		Assert.equals(17, contentData1.endColumn);
		Assert.equals("attribute", contentData1.name);
		Assert.equals("attribute", contentData1.shortName);
		Assert.equals("", contentData1.prefix);
		Assert.isNull(contentData1.stateName);
		Assert.isNull(contentData1.uri);
		Assert.isTrue(contentData1.hasValue);
		Assert.equals(19, contentData1.valueStart);
		Assert.equals(24, contentData1.valueEnd);
		Assert.equals("value", contentData1.rawValue);
		Assert.equals("value", tagData0.getRawAttributeValue("attribute"));
	}
}
