package mxhx.parser;

import utest.Assert;
import utest.Test;

class MXHXParserTagTest extends Test {
	private static final SOURCE = "source.mxhx";

	public function testParserWithSelfClosingTag():Void {
		var parser = new MXHXParser("<p:Tag/>", SOURCE);
		var mxhxData = parser.parse();

		Assert.notNull(mxhxData);
		Assert.notNull(mxhxData.problems);
		Assert.equals(0, mxhxData.problems.length);

		Assert.notNull(mxhxData.rootTag);
		Assert.equals(SOURCE, mxhxData.source);
		Assert.equals(1, mxhxData.numUnits);

		var unit = mxhxData.unitAt(0);
		Assert.notNull(unit);
		Assert.equals(SOURCE, unit.source);
		Assert.equals(0, unit.start);
		Assert.equals(8, unit.end);
		Assert.isOfType(unit, IMXHXTagData);
		var tagData = cast(unit, IMXHXTagData);
		Assert.equals(mxhxData.rootTag, tagData);
		Assert.equals("p:Tag", tagData.name);
		Assert.equals("Tag", tagData.shortName);
		Assert.equals("p", tagData.prefix);
		Assert.isNull(tagData.uri);
		Assert.isTrue(tagData.isOpenTag());
		Assert.isFalse(tagData.isCloseTag());
		Assert.isTrue(tagData.isEmptyTag());
		Assert.isFalse(tagData.isImplicit());
		var prefixMap = tagData.prefixMap;
		Assert.notNull(prefixMap);
		Assert.isFalse(prefixMap.containsPrefix("p"));
	}

	public function testParserWithOpenAndCloseTag():Void {
		var parser = new MXHXParser("<p:Tag></p:Tag>", SOURCE);
		var mxhxData = parser.parse();

		Assert.notNull(mxhxData);
		Assert.notNull(mxhxData.problems);
		Assert.equals(0, mxhxData.problems.length);

		Assert.notNull(mxhxData.rootTag);
		Assert.equals(SOURCE, mxhxData.source);
		Assert.equals(2, mxhxData.numUnits);

		var unit0 = mxhxData.unitAt(0);
		Assert.notNull(unit0);
		Assert.equals(SOURCE, unit0.source);
		Assert.equals(0, unit0.start);
		Assert.equals(7, unit0.end);
		Assert.isOfType(unit0, IMXHXTagData);
		var tagData0 = cast(unit0, IMXHXTagData);
		Assert.equals(mxhxData.rootTag, tagData0);
		Assert.equals("p:Tag", tagData0.name);
		Assert.equals("Tag", tagData0.shortName);
		Assert.equals("p", tagData0.prefix);
		Assert.isNull(tagData0.uri);
		Assert.isTrue(tagData0.isOpenTag());
		Assert.isFalse(tagData0.isCloseTag());
		Assert.isFalse(tagData0.isEmptyTag());
		Assert.isFalse(tagData0.isImplicit());
		var prefixMap0 = tagData0.prefixMap;
		Assert.notNull(prefixMap0);
		Assert.isFalse(prefixMap0.containsPrefix("p"));

		var unit1 = mxhxData.unitAt(1);
		Assert.notNull(unit1);
		Assert.equals(SOURCE, unit1.source);
		Assert.equals(7, unit1.start);
		Assert.equals(15, unit1.end);
		Assert.isOfType(unit1, IMXHXTagData);
		var tagData1 = cast(unit1, IMXHXTagData);
		Assert.equals("p:Tag", tagData1.name);
		Assert.equals("Tag", tagData1.shortName);
		Assert.equals("p", tagData1.prefix);
		Assert.isNull(tagData1.uri);
		Assert.isFalse(tagData1.isOpenTag());
		Assert.isTrue(tagData1.isCloseTag());
		Assert.isFalse(tagData1.isEmptyTag());
		Assert.isFalse(tagData1.isImplicit());
		var prefixMap1 = tagData1.prefixMap;
		Assert.notNull(prefixMap1);
		Assert.isFalse(prefixMap1.containsPrefix("p"));
	}

	public function testParserWithOpenAndCloseTagUnclosedOpenTag():Void {
		var parser = new MXHXParser("<p:Tag</p:Tag>", SOURCE);
		var mxhxData = parser.parse();

		Assert.notNull(mxhxData);
		Assert.notNull(mxhxData.problems);
		Assert.equals(1, mxhxData.problems.length);
		var problem = mxhxData.problems[0];
		Assert.notNull(problem);
		Assert.equals(1552, problem.code);
		Assert.equals(SOURCE, problem.source);
		Assert.equals(6, problem.start);
		Assert.equals(13, problem.end);

		Assert.notNull(mxhxData.rootTag);
		Assert.equals(SOURCE, mxhxData.source);
		Assert.equals(2, mxhxData.numUnits);

		var unit0 = mxhxData.unitAt(0);
		Assert.notNull(unit0);
		Assert.equals(SOURCE, unit0.source);
		Assert.equals(0, unit0.start);
		Assert.equals(6, unit0.end);
		Assert.isOfType(unit0, IMXHXTagData);
		var tagData0 = cast(unit0, IMXHXTagData);
		Assert.equals(mxhxData.rootTag, tagData0);
		Assert.equals("p:Tag", tagData0.name);
		Assert.equals("Tag", tagData0.shortName);
		Assert.equals("p", tagData0.prefix);
		Assert.isNull(tagData0.uri);
		Assert.isTrue(tagData0.isOpenTag());
		Assert.isFalse(tagData0.isCloseTag());
		Assert.isFalse(tagData0.isEmptyTag());
		Assert.isFalse(tagData0.isImplicit());
		var prefixMap0 = tagData0.prefixMap;
		Assert.notNull(prefixMap0);
		Assert.isFalse(prefixMap0.containsPrefix("p"));

		var unit1 = mxhxData.unitAt(1);
		Assert.notNull(unit1);
		Assert.equals(SOURCE, unit1.source);
		Assert.equals(6, unit1.start);
		Assert.equals(14, unit1.end);
		Assert.isOfType(unit1, IMXHXTagData);
		var tagData1 = cast(unit1, IMXHXTagData);
		Assert.equals("p:Tag", tagData1.name);
		Assert.equals("Tag", tagData1.shortName);
		Assert.equals("p", tagData1.prefix);
		Assert.isNull(tagData1.uri);
		Assert.isFalse(tagData1.isOpenTag());
		Assert.isTrue(tagData1.isCloseTag());
		Assert.isFalse(tagData1.isEmptyTag());
		Assert.isFalse(tagData1.isImplicit());
		var prefixMap1 = tagData1.prefixMap;
		Assert.notNull(prefixMap1);
		Assert.isFalse(prefixMap1.containsPrefix("p"));
	}

	public function testParserWithOpenAndCloseTagUnclosedCloseTagEof():Void {
		var parser = new MXHXParser("<p:Tag></p:Tag", SOURCE);
		var mxhxData = parser.parse();

		Assert.notNull(mxhxData);
		Assert.notNull(mxhxData.problems);
		Assert.equals(1, mxhxData.problems.length);
		var problem = mxhxData.problems[0];
		Assert.notNull(problem);
		Assert.equals(1552, problem.code);
		Assert.equals(SOURCE, problem.source);
		Assert.equals(14, problem.start);
		Assert.equals(14, problem.end);

		Assert.notNull(mxhxData.rootTag);
		Assert.equals(SOURCE, mxhxData.source);
		Assert.equals(2, mxhxData.numUnits);

		var unit0 = mxhxData.unitAt(0);
		Assert.notNull(unit0);
		Assert.equals(SOURCE, unit0.source);
		Assert.equals(0, unit0.start);
		Assert.equals(7, unit0.end);
		Assert.isOfType(unit0, IMXHXTagData);
		var tagData0 = cast(unit0, IMXHXTagData);
		Assert.equals(mxhxData.rootTag, tagData0);
		Assert.equals("p:Tag", tagData0.name);
		Assert.equals("Tag", tagData0.shortName);
		Assert.equals("p", tagData0.prefix);
		Assert.isNull(tagData0.uri);
		Assert.isTrue(tagData0.isOpenTag());
		Assert.isFalse(tagData0.isCloseTag());
		Assert.isFalse(tagData0.isEmptyTag());
		Assert.isFalse(tagData0.isImplicit());
		var prefixMap0 = tagData0.prefixMap;
		Assert.notNull(prefixMap0);
		Assert.isFalse(prefixMap0.containsPrefix("p"));

		var unit1 = mxhxData.unitAt(1);
		Assert.notNull(unit1);
		Assert.equals(SOURCE, unit1.source);
		Assert.equals(7, unit1.start);
		Assert.equals(14, unit1.end);
		Assert.isOfType(unit1, IMXHXTagData);
		var tagData1 = cast(unit1, IMXHXTagData);
		Assert.equals("p:Tag", tagData1.name);
		Assert.equals("Tag", tagData1.shortName);
		Assert.equals("p", tagData1.prefix);
		Assert.isNull(tagData1.uri);
		Assert.isFalse(tagData1.isOpenTag());
		Assert.isTrue(tagData1.isCloseTag());
		Assert.isFalse(tagData1.isEmptyTag());
		Assert.isFalse(tagData1.isImplicit());
		var prefixMap1 = tagData1.prefixMap;
		Assert.notNull(prefixMap1);
		Assert.isFalse(prefixMap1.containsPrefix("p"));
	}

	public function testParserWithOpenAndCloseTagUnclosedCloseTagWithSelfClosingTagAfter():Void {
		var parser = new MXHXParser("<p:Outer><p:Tag></p:Tag<q:Other/></p:Outer>", SOURCE);
		var mxhxData = parser.parse();

		Assert.notNull(mxhxData);
		Assert.notNull(mxhxData.problems);
		Assert.equals(1, mxhxData.problems.length);
		var problem = mxhxData.problems[0];
		Assert.notNull(problem);
		Assert.equals(1552, problem.code);
		Assert.equals(SOURCE, problem.source);
		Assert.equals(23, problem.start);
		Assert.equals(31, problem.end);

		Assert.notNull(mxhxData.rootTag);
		Assert.equals(SOURCE, mxhxData.source);
		Assert.equals(5, mxhxData.numUnits);

		var unit0 = mxhxData.unitAt(0);
		Assert.notNull(unit0);
		Assert.equals(SOURCE, unit0.source);
		Assert.equals(0, unit0.start);
		Assert.equals(9, unit0.end);
		Assert.isOfType(unit0, IMXHXTagData);
		var tagData0 = cast(unit0, IMXHXTagData);
		Assert.equals("p:Outer", tagData0.name);
		Assert.equals("Outer", tagData0.shortName);
		Assert.equals("p", tagData0.prefix);
		Assert.isNull(tagData0.uri);
		Assert.isTrue(tagData0.isOpenTag());
		Assert.isFalse(tagData0.isCloseTag());
		Assert.isFalse(tagData0.isEmptyTag());
		Assert.isFalse(tagData0.isImplicit());
		var prefixMap0 = tagData0.prefixMap;
		Assert.notNull(prefixMap0);
		Assert.isFalse(prefixMap0.containsPrefix("p"));

		var unit1 = mxhxData.unitAt(1);
		Assert.notNull(unit1);
		Assert.equals(SOURCE, unit1.source);
		Assert.equals(9, unit1.start);
		Assert.equals(16, unit1.end);
		Assert.isOfType(unit1, IMXHXTagData);
		var tagData1 = cast(unit1, IMXHXTagData);
		Assert.equals("p:Tag", tagData1.name);
		Assert.equals("Tag", tagData1.shortName);
		Assert.equals("p", tagData1.prefix);
		Assert.isNull(tagData1.uri);
		Assert.isTrue(tagData1.isOpenTag());
		Assert.isFalse(tagData1.isCloseTag());
		Assert.isFalse(tagData1.isEmptyTag());
		Assert.isFalse(tagData1.isImplicit());
		var prefixMap1 = tagData1.prefixMap;
		Assert.notNull(prefixMap1);
		Assert.isFalse(prefixMap1.containsPrefix("p"));

		var unit2 = mxhxData.unitAt(2);
		Assert.notNull(unit2);
		Assert.equals(SOURCE, unit2.source);
		Assert.equals(16, unit2.start);
		Assert.equals(23, unit2.end);
		Assert.isOfType(unit2, IMXHXTagData);
		var tagData2 = cast(unit2, IMXHXTagData);
		Assert.equals("p:Tag", tagData2.name);
		Assert.equals("Tag", tagData2.shortName);
		Assert.equals("p", tagData2.prefix);
		Assert.isNull(tagData2.uri);
		Assert.isFalse(tagData2.isOpenTag());
		Assert.isTrue(tagData2.isCloseTag());
		Assert.isFalse(tagData2.isEmptyTag());
		Assert.isFalse(tagData2.isImplicit());
		var prefixMap2 = tagData2.prefixMap;
		Assert.notNull(prefixMap2);
		Assert.isFalse(prefixMap2.containsPrefix("p"));

		var unit3 = mxhxData.unitAt(3);
		Assert.notNull(unit3);
		Assert.equals(SOURCE, unit3.source);
		Assert.equals(23, unit3.start);
		Assert.equals(33, unit3.end);
		Assert.isOfType(unit3, IMXHXTagData);
		var tagData3 = cast(unit3, IMXHXTagData);
		Assert.equals("q:Other", tagData3.name);
		Assert.equals("Other", tagData3.shortName);
		Assert.equals("q", tagData3.prefix);
		Assert.isNull(tagData3.uri);
		Assert.isTrue(tagData3.isOpenTag());
		Assert.isFalse(tagData3.isCloseTag());
		Assert.isTrue(tagData3.isEmptyTag());
		Assert.isFalse(tagData3.isImplicit());
		var prefixMap3 = tagData3.prefixMap;
		Assert.notNull(prefixMap3);
		Assert.isFalse(prefixMap3.containsPrefix("q"));

		var unit4 = mxhxData.unitAt(4);
		Assert.notNull(unit4);
		Assert.equals(SOURCE, unit4.source);
		Assert.equals(33, unit4.start);
		Assert.equals(43, unit4.end);
		Assert.isOfType(unit4, IMXHXTagData);
		var tagData4 = cast(unit4, IMXHXTagData);
		Assert.equals("p:Outer", tagData4.name);
		Assert.equals("Outer", tagData4.shortName);
		Assert.equals("p", tagData4.prefix);
		Assert.isNull(tagData4.uri);
		Assert.isFalse(tagData4.isOpenTag());
		Assert.isTrue(tagData4.isCloseTag());
		Assert.isFalse(tagData4.isEmptyTag());
		Assert.isFalse(tagData4.isImplicit());
		var prefixMap4 = tagData4.prefixMap;
		Assert.notNull(prefixMap4);
		Assert.isFalse(prefixMap4.containsPrefix("p"));
	}

	public function testParserWithOpenTagOnly():Void {
		var parser = new MXHXParser("<p:Tag>", SOURCE);
		var mxhxData = parser.parse();

		Assert.notNull(mxhxData);
		Assert.notNull(mxhxData.problems);
		Assert.equals(1, mxhxData.problems.length);
		var problem = mxhxData.problems[0];
		Assert.notNull(problem);
		Assert.equals(1552, problem.code);
		Assert.equals(SOURCE, problem.source);
		Assert.equals(0, problem.start);
		Assert.equals(7, problem.end);

		Assert.notNull(mxhxData.rootTag);
		Assert.equals(SOURCE, mxhxData.source);
		Assert.equals(1, mxhxData.numUnits);

		var unit0 = mxhxData.unitAt(0);
		Assert.notNull(unit0);
		Assert.equals(SOURCE, unit0.source);
		Assert.equals(0, unit0.start);
		Assert.equals(7, unit0.end);
		Assert.isOfType(unit0, IMXHXTagData);
		var tagData0 = cast(unit0, IMXHXTagData);
		Assert.equals(mxhxData.rootTag, tagData0);
		Assert.equals("p:Tag", tagData0.name);
		Assert.equals("Tag", tagData0.shortName);
		Assert.equals("p", tagData0.prefix);
		Assert.isNull(tagData0.uri);
		Assert.isTrue(tagData0.isOpenTag());
		Assert.isFalse(tagData0.isCloseTag());
		Assert.isFalse(tagData0.isEmptyTag());
		Assert.isFalse(tagData0.isImplicit());
		var prefixMap0 = tagData0.prefixMap;
		Assert.notNull(prefixMap0);
		Assert.isFalse(prefixMap0.containsPrefix("p"));
	}

	public function testParserWithOuterOpenAndCloseTagAndInnerOpenTagOnly():Void {
		var parser = new MXHXParser("<p:Outer><p:Tag></p:Outer>", SOURCE);
		var mxhxData = parser.parse();

		Assert.notNull(mxhxData);
		Assert.notNull(mxhxData.problems);
		Assert.equals(1, mxhxData.problems.length);
		var problem = mxhxData.problems[0];
		Assert.notNull(problem);
		Assert.equals(1552, problem.code);
		Assert.equals(SOURCE, problem.source);
		Assert.equals(16, problem.start);
		Assert.equals(16, problem.end);

		Assert.notNull(mxhxData.rootTag);
		Assert.equals(SOURCE, mxhxData.source);
		Assert.equals(4, mxhxData.numUnits);

		var unit0 = mxhxData.unitAt(0);
		Assert.notNull(unit0);
		Assert.equals(SOURCE, unit0.source);
		Assert.equals(0, unit0.start);
		Assert.equals(9, unit0.end);
		Assert.isOfType(unit0, IMXHXTagData);
		var tagData0 = cast(unit0, IMXHXTagData);
		Assert.equals(mxhxData.rootTag, tagData0);
		Assert.equals("p:Outer", tagData0.name);
		Assert.equals("Outer", tagData0.shortName);
		Assert.equals("p", tagData0.prefix);
		Assert.isNull(tagData0.uri);
		Assert.isTrue(tagData0.isOpenTag());
		Assert.isFalse(tagData0.isCloseTag());
		Assert.isFalse(tagData0.isEmptyTag());
		Assert.isFalse(tagData0.isImplicit());
		var prefixMap0 = tagData0.prefixMap;
		Assert.notNull(prefixMap0);
		Assert.isFalse(prefixMap0.containsPrefix("p"));

		var unit1 = mxhxData.unitAt(1);
		Assert.notNull(unit1);
		Assert.equals(SOURCE, unit1.source);
		Assert.equals(9, unit1.start);
		Assert.equals(16, unit1.end);
		Assert.isOfType(unit1, IMXHXTagData);
		var tagData1 = cast(unit1, IMXHXTagData);
		Assert.equals("p:Tag", tagData1.name);
		Assert.equals("Tag", tagData1.shortName);
		Assert.equals("p", tagData1.prefix);
		Assert.isNull(tagData1.uri);
		Assert.isTrue(tagData1.isOpenTag());
		Assert.isFalse(tagData1.isCloseTag());
		Assert.isFalse(tagData1.isEmptyTag());
		Assert.isFalse(tagData1.isImplicit());
		var prefixMap1 = tagData1.prefixMap;
		Assert.notNull(prefixMap1);
		Assert.isFalse(prefixMap1.containsPrefix("p"));

		var unit2 = mxhxData.unitAt(2);
		Assert.notNull(unit2);
		Assert.equals(SOURCE, unit2.source);
		Assert.equals(16, unit2.start);
		Assert.equals(16, unit2.end);
		Assert.isOfType(unit2, IMXHXTagData);
		var tagData2 = cast(unit2, IMXHXTagData);
		Assert.equals("p:Tag", tagData2.name);
		Assert.equals("Tag", tagData2.shortName);
		Assert.equals("p", tagData2.prefix);
		Assert.isNull(tagData2.uri);
		Assert.isFalse(tagData2.isOpenTag());
		Assert.isTrue(tagData2.isCloseTag());
		Assert.isFalse(tagData2.isEmptyTag());
		Assert.isTrue(tagData2.isImplicit());
		var prefixMap2 = tagData2.prefixMap;
		Assert.notNull(prefixMap2);
		Assert.isFalse(prefixMap2.containsPrefix("p"));

		var unit3 = mxhxData.unitAt(3);
		Assert.notNull(unit3);
		Assert.equals(SOURCE, unit3.source);
		Assert.equals(16, unit3.start);
		Assert.equals(26, unit3.end);
		Assert.isOfType(unit3, IMXHXTagData);
		var tagData3 = cast(unit3, IMXHXTagData);
		Assert.equals("p:Outer", tagData3.name);
		Assert.equals("Outer", tagData3.shortName);
		Assert.equals("p", tagData3.prefix);
		Assert.isNull(tagData3.uri);
		Assert.isFalse(tagData3.isOpenTag());
		Assert.isTrue(tagData3.isCloseTag());
		Assert.isFalse(tagData3.isEmptyTag());
		Assert.isFalse(tagData3.isImplicit());
		var prefixMap3 = tagData3.prefixMap;
		Assert.notNull(prefixMap3);
		Assert.isFalse(prefixMap3.containsPrefix("p"));
	}

	public function testParserWithOuterOpenTagOnlyAndInnerOpenTagOnly():Void {
		var parser = new MXHXParser("<p:Outer><p:Tag>", SOURCE);
		var mxhxData = parser.parse();

		Assert.notNull(mxhxData);
		Assert.notNull(mxhxData.problems);
		Assert.equals(2, mxhxData.problems.length);
		var problem0 = mxhxData.problems[0];
		Assert.notNull(problem0);
		Assert.equals(1552, problem0.code);
		Assert.equals(SOURCE, problem0.source);
		Assert.equals(0, problem0.start);
		Assert.equals(9, problem0.end);
		var problem1 = mxhxData.problems[1];
		Assert.notNull(problem1);
		Assert.equals(1552, problem1.code);
		Assert.equals(SOURCE, problem1.source);
		Assert.equals(9, problem1.start);
		Assert.equals(16, problem1.end);

		Assert.notNull(mxhxData.rootTag);
		Assert.equals(SOURCE, mxhxData.source);
		Assert.equals(2, mxhxData.numUnits);

		var unit0 = mxhxData.unitAt(0);
		Assert.notNull(unit0);
		Assert.equals(SOURCE, unit0.source);
		Assert.equals(0, unit0.start);
		Assert.equals(9, unit0.end);
		Assert.isOfType(unit0, IMXHXTagData);
		var tagData0 = cast(unit0, IMXHXTagData);
		Assert.equals(mxhxData.rootTag, tagData0);
		Assert.equals("p:Outer", tagData0.name);
		Assert.equals("Outer", tagData0.shortName);
		Assert.equals("p", tagData0.prefix);
		Assert.isNull(tagData0.uri);
		Assert.isTrue(tagData0.isOpenTag());
		Assert.isFalse(tagData0.isCloseTag());
		Assert.isFalse(tagData0.isEmptyTag());
		Assert.isFalse(tagData0.isImplicit());
		var prefixMap0 = tagData0.prefixMap;
		Assert.notNull(prefixMap0);
		Assert.isFalse(prefixMap0.containsPrefix("p"));

		var unit1 = mxhxData.unitAt(1);
		Assert.notNull(unit1);
		Assert.equals(SOURCE, unit1.source);
		Assert.equals(9, unit1.start);
		Assert.equals(16, unit1.end);
		Assert.isOfType(unit1, IMXHXTagData);
		var tagData1 = cast(unit1, IMXHXTagData);
		Assert.equals("p:Tag", tagData1.name);
		Assert.equals("Tag", tagData1.shortName);
		Assert.equals("p", tagData1.prefix);
		Assert.isNull(tagData1.uri);
		Assert.isTrue(tagData1.isOpenTag());
		Assert.isFalse(tagData1.isCloseTag());
		Assert.isFalse(tagData1.isEmptyTag());
		Assert.isFalse(tagData1.isImplicit());
		var prefixMap1 = tagData1.prefixMap;
		Assert.notNull(prefixMap1);
		Assert.isFalse(prefixMap1.containsPrefix("p"));
	}

	public function testParserWithNestedOpenAndClosedTagButOuterOpenTagOnly():Void {
		var parser = new MXHXParser("<p:Outer><p:Tag></p:Tag>", SOURCE);
		var mxhxData = parser.parse();

		Assert.notNull(mxhxData);
		Assert.notNull(mxhxData.problems);
		Assert.equals(1, mxhxData.problems.length);
		var problem = mxhxData.problems[0];
		Assert.notNull(problem);
		Assert.equals(1552, problem.code);
		Assert.equals(SOURCE, problem.source);
		Assert.equals(0, problem.start);
		Assert.equals(9, problem.end);

		Assert.notNull(mxhxData.rootTag);
		Assert.equals(SOURCE, mxhxData.source);
		Assert.equals(3, mxhxData.numUnits);

		var unit0 = mxhxData.unitAt(0);
		Assert.notNull(unit0);
		Assert.equals(SOURCE, unit0.source);
		Assert.equals(0, unit0.start);
		Assert.equals(9, unit0.end);
		Assert.isOfType(unit0, IMXHXTagData);
		var tagData0 = cast(unit0, IMXHXTagData);
		Assert.equals(mxhxData.rootTag, tagData0);
		Assert.equals("p:Outer", tagData0.name);
		Assert.equals("Outer", tagData0.shortName);
		Assert.equals("p", tagData0.prefix);
		Assert.isNull(tagData0.uri);
		Assert.isTrue(tagData0.isOpenTag());
		Assert.isFalse(tagData0.isCloseTag());
		Assert.isFalse(tagData0.isEmptyTag());
		Assert.isFalse(tagData0.isImplicit());
		var prefixMap0 = tagData0.prefixMap;
		Assert.notNull(prefixMap0);
		Assert.isFalse(prefixMap0.containsPrefix("p"));

		var unit1 = mxhxData.unitAt(1);
		Assert.notNull(unit1);
		Assert.equals(SOURCE, unit1.source);
		Assert.equals(9, unit1.start);
		Assert.equals(16, unit1.end);
		Assert.isOfType(unit1, IMXHXTagData);
		var tagData1 = cast(unit1, IMXHXTagData);
		Assert.equals("p:Tag", tagData1.name);
		Assert.equals("Tag", tagData1.shortName);
		Assert.equals("p", tagData1.prefix);
		Assert.isNull(tagData1.uri);
		Assert.isTrue(tagData1.isOpenTag());
		Assert.isFalse(tagData1.isCloseTag());
		Assert.isFalse(tagData1.isEmptyTag());
		Assert.isFalse(tagData1.isImplicit());
		var prefixMap1 = tagData1.prefixMap;
		Assert.notNull(prefixMap1);
		Assert.isFalse(prefixMap1.containsPrefix("p"));

		var unit2 = mxhxData.unitAt(2);
		Assert.notNull(unit2);
		Assert.equals(SOURCE, unit2.source);
		Assert.equals(16, unit2.start);
		Assert.equals(24, unit2.end);
		Assert.isOfType(unit2, IMXHXTagData);
		var tagData2 = cast(unit2, IMXHXTagData);
		Assert.equals("p:Tag", tagData2.name);
		Assert.equals("Tag", tagData2.shortName);
		Assert.equals("p", tagData2.prefix);
		Assert.isNull(tagData2.uri);
		Assert.isFalse(tagData2.isOpenTag());
		Assert.isTrue(tagData2.isCloseTag());
		Assert.isFalse(tagData2.isEmptyTag());
		Assert.isFalse(tagData2.isImplicit());
		var prefixMap2 = tagData2.prefixMap;
		Assert.notNull(prefixMap2);
		Assert.isFalse(prefixMap2.containsPrefix("p"));
	}

	public function testParserWithNestedOpenAndClosedTagButOuterCloseTagOnly():Void {
		var parser = new MXHXParser("<p:Tag></p:Tag></p:Outer>", SOURCE);
		var mxhxData = parser.parse();

		Assert.notNull(mxhxData);
		Assert.notNull(mxhxData.problems);
		Assert.equals(1, mxhxData.problems.length);
		var problem = mxhxData.problems[0];
		Assert.notNull(problem);
		Assert.equals(1431, problem.code);
		Assert.equals(SOURCE, problem.source);
		Assert.equals(15, problem.start);
		Assert.equals(24, problem.end);

		Assert.notNull(mxhxData.rootTag);
		Assert.equals(SOURCE, mxhxData.source);
		Assert.equals(3, mxhxData.numUnits);

		var unit0 = mxhxData.unitAt(0);
		Assert.notNull(unit0);
		Assert.equals(SOURCE, unit0.source);
		Assert.equals(0, unit0.start);
		Assert.equals(7, unit0.end);
		Assert.isOfType(unit0, IMXHXTagData);
		var tagData0 = cast(unit0, IMXHXTagData);
		Assert.equals(mxhxData.rootTag, tagData0);
		Assert.equals("p:Tag", tagData0.name);
		Assert.equals("Tag", tagData0.shortName);
		Assert.equals("p", tagData0.prefix);
		Assert.isNull(tagData0.uri);
		Assert.isTrue(tagData0.isOpenTag());
		Assert.isFalse(tagData0.isCloseTag());
		Assert.isFalse(tagData0.isEmptyTag());
		Assert.isFalse(tagData0.isImplicit());
		var prefixMap0 = tagData0.prefixMap;
		Assert.notNull(prefixMap0);
		Assert.isFalse(prefixMap0.containsPrefix("p"));

		var unit1 = mxhxData.unitAt(1);
		Assert.notNull(unit1);
		Assert.equals(SOURCE, unit1.source);
		Assert.equals(7, unit1.start);
		Assert.equals(15, unit1.end);
		Assert.isOfType(unit1, IMXHXTagData);
		var tagData1 = cast(unit1, IMXHXTagData);
		Assert.equals("p:Tag", tagData1.name);
		Assert.equals("Tag", tagData1.shortName);
		Assert.equals("p", tagData1.prefix);
		Assert.isNull(tagData1.uri);
		Assert.isFalse(tagData1.isOpenTag());
		Assert.isTrue(tagData1.isCloseTag());
		Assert.isFalse(tagData1.isEmptyTag());
		Assert.isFalse(tagData1.isImplicit());
		var prefixMap1 = tagData1.prefixMap;
		Assert.notNull(prefixMap1);
		Assert.isFalse(prefixMap1.containsPrefix("p"));
	}
}
