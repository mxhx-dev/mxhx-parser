package mxhx.macros;

import utest.Assert;
import utest.Test;
import fixtures.TestBuildMacro;
import fixtures.TestBuildMacroNested;

class MXHXComponentBuildMacroTest extends Test {
	public function testBuildMacro():Void {
		var result = new TestBuildMacro();
		Assert.equals(123.4, result.float);
	}

	public function testBuildMacroNested():Void {
		var result = new TestBuildMacroNested();
		Assert.notNull(result.nested);
		Assert.isOfType(result.nested, TestBuildMacro);
	}
}
