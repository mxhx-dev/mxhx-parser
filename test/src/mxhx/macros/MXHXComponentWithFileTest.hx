package mxhx.macros;

import fixtures.TestBuildMacro;
import utest.Assert;
import utest.Test;

class MXHXComponentWithFileTest extends Test {
	public function testBuildMacro():Void {
		var result = MXHXComponent.withFile("../../fixtures/TestBuildMacro.mxhx");
		Assert.equals(123.4, result.float);
	}

	public function testBuildMacroNested():Void {
		var result = MXHXComponent.withFile("../../fixtures/TestBuildMacroNested.mxhx");
		Assert.notNull(result.nested);
		Assert.isOfType(result.nested, TestBuildMacro);
	}
}
