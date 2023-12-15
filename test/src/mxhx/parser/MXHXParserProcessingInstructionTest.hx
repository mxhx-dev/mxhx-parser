package mxhx.parser;

import utest.Assert;
import utest.Test;

class MXHXParserProcessingInstructionTest extends Test {
	private static final SOURCE = "source.mxhx";

	public function testParserWithProcessingInstruction():Void {
		var instruction = "<?xml version=\"1.0\" encoding=\"utf-8\"?>";
		var parser = new MXHXParser(instruction, SOURCE);
		var mxhxData = parser.parse();

		Assert.notNull(mxhxData);
		Assert.notNull(mxhxData.problems);
		Assert.equals(0, mxhxData.problems.length);

		Assert.isNull(mxhxData.rootTag);
		Assert.equals(SOURCE, mxhxData.source);
		Assert.equals(1, mxhxData.numUnits);

		var unit = mxhxData.unitAt(0);
		Assert.notNull(unit);
		Assert.equals(SOURCE, unit.source);
		Assert.equals(0, unit.start);
		Assert.equals(38, unit.end);
		Assert.isOfType(unit, IMXHXInstructionData);
		var instructionData = cast(unit, IMXHXInstructionData);
		Assert.equals(instruction, instructionData.instructionText);
		Assert.equals("xml", instructionData.target);
		Assert.equals("version=\"1.0\" encoding=\"utf-8\"", instructionData.content);
	}

	public function testParserWithProcessingInstructionUnclosed():Void {
		var instruction = "<?xml unclosed";
		var parser = new MXHXParser(instruction, SOURCE);
		var mxhxData = parser.parse();

		Assert.notNull(mxhxData);
		Assert.notNull(mxhxData.problems);
		Assert.equals(1, mxhxData.problems.length);
		var problem = mxhxData.problems[0];
		Assert.notNull(problem);
		Assert.equals(1549, problem.code);
		Assert.equals(SOURCE, problem.source);
		Assert.equals(13, problem.start);
		Assert.equals(14, problem.end);

		Assert.isNull(mxhxData.rootTag);
		Assert.equals(SOURCE, mxhxData.source);
		Assert.equals(1, mxhxData.numUnits);

		var unit = mxhxData.unitAt(0);
		Assert.notNull(unit);
		Assert.equals(SOURCE, unit.source);
		Assert.equals(0, unit.start);
		Assert.equals(14, unit.end);
		Assert.isOfType(unit, IMXHXInstructionData);
		var instructionData = cast(unit, IMXHXInstructionData);
		Assert.equals(instruction, instructionData.instructionText);
		Assert.equals("xml", instructionData.target);
		Assert.equals("unclosed", instructionData.content);
	}
}
