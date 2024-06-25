package mxhx.internal;

import utest.Assert;
import utest.Test;

class MXHXInstructionDataTest extends Test {
	private static final SOURCE = "source.mxhx";

	public function testCloneInstructionData():Void {
		var mxhxData = new MXHXData(SOURCE);

		var rootTag = new MXHXTagData();
		rootTag.init("<RootTag");
		rootTag.setLocation(mxhxData, 0);
		rootTag.setOffsets(0, 26);
		mxhxData.units.push(rootTag);

		var instruction = new MXHXInstructionData("<?target content?>");
		instruction.setLocation(mxhxData, 1);
		instruction.setOffsets(26, 36);
		instruction.parentUnitIndex = 0;
		mxhxData.units.push(instruction);

		var clonedInstruction = instruction.clone();
		Assert.notNull(clonedInstruction);
		Assert.notEquals(instruction, clonedInstruction);
		Assert.equals("content", clonedInstruction.content);
		Assert.equals("target", clonedInstruction.target);
		Assert.equals(SOURCE, clonedInstruction.source);
		Assert.equals(1, clonedInstruction.index);
		Assert.equals(0, clonedInstruction.parentUnitIndex);
		Assert.equals(26, clonedInstruction.start);
		Assert.equals(36, clonedInstruction.end);
		Assert.equals(mxhxData, clonedInstruction.parent);
		Assert.equals(rootTag, clonedInstruction.parentUnit);
	}
}
