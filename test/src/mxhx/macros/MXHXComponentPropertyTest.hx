package mxhx.macros;

import fixtures.TestPropertiesClass;
import fixtures.TestPropertyEnum;
import fixtures.TestComplexEnum;
import utest.Assert;
import utest.Test;

class MXHXComponentPropertyTest extends Test {
	public function testAnyChildElement():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestPropertiesClass
				xmlns:mx="https://ns.mxhx.dev/2022/basic"
				xmlns:tests="https://ns.mxhx.dev/2022/tests">
				<tests:any>
					<mx:Any float="123.4" boolean="true" string="hello">
						<mx:object>
							<mx:Any integer="567"/>
						</mx:object>
					</mx:Any>
				</tests:any>
			</tests:TestPropertiesClass>
		');
		Assert.notNull(result);
		Assert.notNull(result.any);
		Assert.equals(4, Reflect.fields(result.any).length);
		Assert.isTrue(Reflect.hasField(result.any, "float"));
		Assert.isTrue(Reflect.hasField(result.any, "boolean"));
		Assert.isTrue(Reflect.hasField(result.any, "string"));
		Assert.isTrue(Reflect.hasField(result.any, "object"));
		Assert.equals(123.4, Reflect.field(result.any, "float"));
		Assert.isTrue(Reflect.field(result.any, "boolean"));
		Assert.equals("hello", Reflect.field(result.any, "string"));
		Assert.notNull(Reflect.field(result.any, "object"));
		Assert.equals(567, Reflect.field(Reflect.field(result.any, "object"), "integer"));
	}

	public function testStrictChildElement():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestPropertiesClass
				xmlns:mx="https://ns.mxhx.dev/2022/basic"
				xmlns:tests="https://ns.mxhx.dev/2022/tests">
				<tests:strict>
					<tests:TestPropertiesClass
						boolean="true"
						float="123.4"
						integer="567"
						string="hello">
						<tests:any>
							<mx:Any float="123.4" boolean="true" string="hello">
								<mx:float>123.4</mx:float>
								<mx:boolean>true</mx:boolean>
								<mx:string>hello</mx:string>
								<mx:object>
									<mx:Any>
										<mx:integer>567</mx:integer>
									</mx:Any>
								</mx:object>
							</mx:Any>
						</tests:any>
					</tests:TestPropertiesClass>
				</tests:strict>
			</tests:TestPropertiesClass>
		');
		Assert.notNull(result);
		Assert.notNull(result.strict);
		Assert.isTrue(result.strict.boolean);
		Assert.equals(123.4, result.strict.float);
		Assert.equals("hello", result.strict.string);
		Assert.equals(567, result.strict.integer);
		Assert.notNull(result.strict.any);
		Assert.equals(4, Reflect.fields(result.strict.any).length);
		Assert.isTrue(Reflect.hasField(result.strict.any, "float"));
		Assert.isTrue(Reflect.hasField(result.strict.any, "boolean"));
		Assert.isTrue(Reflect.hasField(result.strict.any, "string"));
		Assert.isTrue(Reflect.hasField(result.strict.any, "object"));
		Assert.equals(123.4, Reflect.field(result.strict.any, "float"));
		Assert.isTrue(Reflect.field(result.strict.any, "boolean"));
		Assert.equals("hello", Reflect.field(result.strict.any, "string"));
		Assert.notNull(Reflect.field(result.strict.any, "object"));
		Assert.equals(567, Reflect.field(Reflect.field(result.strict.any, "object"), "integer"));
	}

	public function testArrayChildElement():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestPropertiesClass
				xmlns:mx="https://ns.mxhx.dev/2022/basic"
				xmlns:tests="https://ns.mxhx.dev/2022/tests">
				<tests:array>
					<mx:String>one</mx:String>
					<mx:String>two</mx:String>
					<mx:String>three</mx:String>
				</tests:array>
			</tests:TestPropertiesClass>
		');
		Assert.notNull(result);
		Assert.notNull(result.array);
		Assert.isOfType(result.array, Array);
		Assert.equals(3, result.array.length);
		Assert.equals("one", result.array[0]);
		Assert.equals("two", result.array[1]);
		Assert.equals("three", result.array[2]);
	}

	public function testArrayChildElementRedundant():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestPropertiesClass
				xmlns:mx="https://ns.mxhx.dev/2022/basic"
				xmlns:tests="https://ns.mxhx.dev/2022/tests">
				<tests:array>
					<mx:Array>
						<mx:String>one</mx:String>
						<mx:String>two</mx:String>
						<mx:String>three</mx:String>
					</mx:Array>
				</tests:array>
			</tests:TestPropertiesClass>
		');
		Assert.notNull(result);
		Assert.notNull(result.array);
		Assert.isOfType(result.array, Array);
		Assert.equals(3, result.array.length);
		Assert.equals("one", result.array[0]);
		Assert.equals("two", result.array[1]);
		Assert.equals("three", result.array[2]);
	}

	public function testArrayChildElementRedundantEmpty():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestPropertiesClass
				xmlns:mx="https://ns.mxhx.dev/2022/basic"
				xmlns:tests="https://ns.mxhx.dev/2022/tests">
				<tests:array>
					<mx:Array></mx:Array>
				</tests:array>
			</tests:TestPropertiesClass>
		');
		Assert.notNull(result);
		Assert.notNull(result.array);
		Assert.isOfType(result.array, Array);
		Assert.equals(0, result.array.length);
	}

	public function testArrayChildElementRedundantEmptyExtraWhitespace():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestPropertiesClass
				xmlns:mx="https://ns.mxhx.dev/2022/basic"
				xmlns:tests="https://ns.mxhx.dev/2022/tests">
				<tests:array>
					<mx:Array>
					</mx:Array>
				</tests:array>
			</tests:TestPropertiesClass>
		');
		Assert.notNull(result);
		Assert.notNull(result.array);
		Assert.isOfType(result.array, Array);
		Assert.equals(0, result.array.length);
	}

	public function testBoolAttribute():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestPropertiesClass
				xmlns:mx="https://ns.mxhx.dev/2022/basic"
				xmlns:tests="https://ns.mxhx.dev/2022/tests"
				boolean="true"/>
		');
		Assert.notNull(result);
		Assert.isOfType(result.boolean, Bool);
		Assert.isTrue(result.boolean);
	}

	public function testBoolChildElement():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestPropertiesClass
				xmlns:mx="https://ns.mxhx.dev/2022/basic"
				xmlns:tests="https://ns.mxhx.dev/2022/tests">
				<tests:boolean>true</tests:boolean>
			</tests:TestPropertiesClass>
		');
		Assert.notNull(result);
		Assert.isOfType(result.boolean, Bool);
		Assert.isTrue(result.boolean);
	}

	public function testBoolChildElementCData():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestPropertiesClass
				xmlns:mx="https://ns.mxhx.dev/2022/basic"
				xmlns:tests="https://ns.mxhx.dev/2022/tests">
				<tests:boolean><![CDATA[true]]></tests:boolean>
			</tests:TestPropertiesClass>
		');
		Assert.notNull(result);
		Assert.isOfType(result.boolean, Bool);
		Assert.isTrue(result.boolean);
	}

	public function testBoolChildElementRedundant():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestPropertiesClass
				xmlns:mx="https://ns.mxhx.dev/2022/basic"
				xmlns:tests="https://ns.mxhx.dev/2022/tests">
				<tests:boolean><mx:Bool>true</mx:Bool></tests:boolean>
			</tests:TestPropertiesClass>
		');
		Assert.notNull(result);
		Assert.isOfType(result.boolean, Bool);
		Assert.isTrue(result.boolean);
	}

	public function testBoolChildElementRedundantEmpty():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestPropertiesClass
				xmlns:mx="https://ns.mxhx.dev/2022/basic"
				xmlns:tests="https://ns.mxhx.dev/2022/tests">
				<tests:boolean><mx:Bool></mx:Bool></tests:boolean>
			</tests:TestPropertiesClass>
		');
		Assert.notNull(result);
		Assert.isOfType(result.boolean, Bool);
		Assert.isFalse(result.boolean);
	}

	public function testBoolChildElementRedundantEmptyExtraWhitespace():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestPropertiesClass
				xmlns:mx="https://ns.mxhx.dev/2022/basic"
				xmlns:tests="https://ns.mxhx.dev/2022/tests">
				<tests:boolean>
					<mx:Bool>
					</mx:Bool>
				</tests:boolean>
			</tests:TestPropertiesClass>
		');
		Assert.notNull(result);
		Assert.isOfType(result.boolean, Bool);
		Assert.isFalse(result.boolean);
	}

	public function testClassAttribute():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestPropertiesClass
				xmlns:mx="https://ns.mxhx.dev/2022/basic"
				xmlns:tests="https://ns.mxhx.dev/2022/tests"
				type="fixtures.TestClass1"/>
		');
		Assert.notNull(result);
		Assert.isOfType(result.type, Class);
		Assert.equals(fixtures.TestClass1, result.type);
	}

	public function testClassChildElement():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestPropertiesClass
				xmlns:mx="https://ns.mxhx.dev/2022/basic"
				xmlns:tests="https://ns.mxhx.dev/2022/tests">
				<tests:type>fixtures.TestClass1</tests:type>
			</tests:TestPropertiesClass>
		');
		Assert.notNull(result);
		Assert.isOfType(result.type, Class);
		Assert.equals(fixtures.TestClass1, result.type);
	}

	public function testClassChildElementCData():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestPropertiesClass
				xmlns:mx="https://ns.mxhx.dev/2022/basic"
				xmlns:tests="https://ns.mxhx.dev/2022/tests">
				<tests:type><![CDATA[fixtures.TestClass1]]></tests:type>
			</tests:TestPropertiesClass>
		');
		Assert.notNull(result);
		Assert.isOfType(result.type, Class);
		Assert.equals(fixtures.TestClass1, result.type);
	}

	public function testClassChildElementRedundant():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestPropertiesClass
				xmlns:mx="https://ns.mxhx.dev/2022/basic"
				xmlns:tests="https://ns.mxhx.dev/2022/tests">
				<tests:type><mx:Class>fixtures.TestClass1</mx:Class></tests:type>
			</tests:TestPropertiesClass>
		');
		Assert.notNull(result);
		Assert.isOfType(result.type, Class);
		Assert.equals(fixtures.TestClass1, result.type);
	}

	public function testClassChildElementRedundantEmpty():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestPropertiesClass
				xmlns:mx="https://ns.mxhx.dev/2022/basic"
				xmlns:tests="https://ns.mxhx.dev/2022/tests">
				<tests:type><mx:Class></mx:Class></tests:type>
			</tests:TestPropertiesClass>
		');
		Assert.notNull(result);
		Assert.isNull(result.type);
	}

	public function testClassChildElementRedundantEmptyExtraWhitespace():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestPropertiesClass
				xmlns:mx="https://ns.mxhx.dev/2022/basic"
				xmlns:tests="https://ns.mxhx.dev/2022/tests">
				<tests:type>
					<mx:Class>
					</mx:Class>
				</tests:type>
			</tests:TestPropertiesClass>
		');
		Assert.notNull(result);
		Assert.isNull(result.type);
	}

	public function testEnumValueAttribute():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestPropertiesClass
				xmlns:mx="https://ns.mxhx.dev/2022/basic"
				xmlns:tests="https://ns.mxhx.dev/2022/tests"
				enumValue="Value2"/>
		');
		Assert.notNull(result);
		Assert.equals(TestPropertyEnum.Value2, result.enumValue);
	}

	public function testEnumValueChildElement():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestPropertiesClass
				xmlns:mx="https://ns.mxhx.dev/2022/basic"
				xmlns:tests="https://ns.mxhx.dev/2022/tests">
				<tests:enumValue>Value2</tests:enumValue>
			</tests:TestPropertiesClass>
		');
		Assert.notNull(result);
		Assert.equals(TestPropertyEnum.Value2, result.enumValue);
	}

	public function testEnumValueChildElementCData():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestPropertiesClass
				xmlns:mx="https://ns.mxhx.dev/2022/basic"
				xmlns:tests="https://ns.mxhx.dev/2022/tests">
				<tests:enumValue><![CDATA[Value2]]></tests:enumValue>
			</tests:TestPropertiesClass>
		');
		Assert.notNull(result);
		Assert.equals(TestPropertyEnum.Value2, result.enumValue);
	}

	public function testEnumValueChildElementRedundant():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestPropertiesClass
				xmlns:mx="https://ns.mxhx.dev/2022/basic"
				xmlns:tests="https://ns.mxhx.dev/2022/tests">
				<tests:enumValue><tests:TestPropertyEnum>Value2</tests:TestPropertyEnum></tests:enumValue>
			</tests:TestPropertiesClass>
		');
		Assert.notNull(result);
		Assert.equals(TestPropertyEnum.Value2, result.enumValue);
	}

	public function testComplexEnumValueChildElementWithoutParameters():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestPropertiesClass
				xmlns:mx="https://ns.mxhx.dev/2022/basic"
				xmlns:tests="https://ns.mxhx.dev/2022/tests">
				<tests:complexEnum>
					<tests:TestComplexEnum.One/>
				</tests:complexEnum>
			</tests:TestPropertiesClass>
		');
		Assert.notNull(result);
		Assert.equals(TestComplexEnum.One, result.complexEnum);
	}

	public function testComplexEnumValueChildElementWithParameters():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestPropertiesClass
				xmlns:mx="https://ns.mxhx.dev/2022/basic"
				xmlns:tests="https://ns.mxhx.dev/2022/tests">
				<tests:complexEnum>
					<tests:TestComplexEnum.Two a="hello" b="123.4"/>
				</tests:complexEnum>
			</tests:TestPropertiesClass>
		');
		Assert.notNull(result);
		switch (result.complexEnum) {
			case TestComplexEnum.Two("hello", 123.4):
				Assert.pass();
			default:
				Assert.fail("Wrong enum value: " + result.complexEnum);
		}
	}

	public function testComplexEnumValueChildElementWithoutParametersRedundant():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestPropertiesClass
				xmlns:mx="https://ns.mxhx.dev/2022/basic"
				xmlns:tests="https://ns.mxhx.dev/2022/tests">
				<tests:complexEnum>
					<tests:TestComplexEnum>
						<tests:TestComplexEnum.One/>
					</tests:TestComplexEnum>
				</tests:complexEnum>
			</tests:TestPropertiesClass>
		');
		Assert.notNull(result);
		Assert.equals(TestComplexEnum.One, result.complexEnum);
	}

	public function testComplexEnumValueChildElementWithParametersRedundant():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestPropertiesClass
				xmlns:mx="https://ns.mxhx.dev/2022/basic"
				xmlns:tests="https://ns.mxhx.dev/2022/tests">
				<tests:complexEnum>
					<tests:TestComplexEnum>
						<tests:TestComplexEnum.Two a="hello" b="123.4"/>
					</tests:TestComplexEnum>
				</tests:complexEnum>
			</tests:TestPropertiesClass>
		');
		Assert.notNull(result);
		switch (result.complexEnum) {
			case TestComplexEnum.Two("hello", 123.4):
				Assert.pass();
			default:
				Assert.fail("Wrong enum value: " + result.complexEnum);
		}
	}

	public function testERegChildElement():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestPropertiesClass
				xmlns:mx="https://ns.mxhx.dev/2022/basic"
				xmlns:tests="https://ns.mxhx.dev/2022/tests">
				<tests:ereg>~/[a-z]+/g</tests:ereg>
			</tests:TestPropertiesClass>
		');
		Assert.notNull(result);
		Assert.isOfType(result.ereg, EReg);
		Assert.equals("~/[a-z]+/g", Std.string(result.ereg));
	}

	public function testERegChildElementCData():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestPropertiesClass
				xmlns:mx="https://ns.mxhx.dev/2022/basic"
				xmlns:tests="https://ns.mxhx.dev/2022/tests">
				<tests:ereg><![CDATA[~/[a-z]+/g]]></tests:ereg>
			</tests:TestPropertiesClass>
		');
		Assert.notNull(result);
		Assert.isOfType(result.ereg, EReg);
		Assert.equals("~/[a-z]+/g", Std.string(result.ereg));
	}

	public function testERegChildElementRedundant():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestPropertiesClass
				xmlns:mx="https://ns.mxhx.dev/2022/basic"
				xmlns:tests="https://ns.mxhx.dev/2022/tests">
				<tests:ereg><mx:EReg>~/[a-z]+/g</mx:EReg></tests:ereg>
			</tests:TestPropertiesClass>
		');
		Assert.notNull(result);
		Assert.isOfType(result.ereg, EReg);
		Assert.equals("~/[a-z]+/g", Std.string(result.ereg));
	}

	public function testERegChildElementRedundantEmpty():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestPropertiesClass
				xmlns:mx="https://ns.mxhx.dev/2022/basic"
				xmlns:tests="https://ns.mxhx.dev/2022/tests">
				<tests:ereg><mx:EReg></mx:EReg></tests:ereg>
			</tests:TestPropertiesClass>
		');
		Assert.notNull(result);
		Assert.isOfType(result.ereg, EReg);
		Assert.equals("~//", Std.string(result.ereg));
	}

	public function testERegChildElementRedundantEmptyExtraWhitespace():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestPropertiesClass
				xmlns:mx="https://ns.mxhx.dev/2022/basic"
				xmlns:tests="https://ns.mxhx.dev/2022/tests">
				<tests:ereg>
					<mx:EReg>
					</mx:EReg>
				</tests:ereg>
			</tests:TestPropertiesClass>
		');
		Assert.notNull(result);
		Assert.isOfType(result.ereg, EReg);
		Assert.equals("~//", Std.string(result.ereg));
	}

	public function testFloatAttribute():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestPropertiesClass
				xmlns:mx="https://ns.mxhx.dev/2022/basic"
				xmlns:tests="https://ns.mxhx.dev/2022/tests"
				float="123.4"/>
		');
		Assert.notNull(result);
		Assert.isOfType(result.float, Float);
		Assert.equals(123.4, result.float);
	}

	public function testFloatChildElement():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestPropertiesClass
				xmlns:mx="https://ns.mxhx.dev/2022/basic"
				xmlns:tests="https://ns.mxhx.dev/2022/tests">
				<tests:float>123.4</tests:float>
			</tests:TestPropertiesClass>
		');
		Assert.notNull(result);
		Assert.isOfType(result.float, Float);
		Assert.equals(123.4, result.float);
	}

	public function testFloatChildElementCData():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestPropertiesClass
				xmlns:mx="https://ns.mxhx.dev/2022/basic"
				xmlns:tests="https://ns.mxhx.dev/2022/tests">
				<tests:float><![CDATA[123.4]]></tests:float>
			</tests:TestPropertiesClass>
		');
		Assert.notNull(result);
		Assert.isOfType(result.float, Float);
		Assert.equals(123.4, result.float);
	}

	public function testFloatChildElementRedundant():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestPropertiesClass
				xmlns:mx="https://ns.mxhx.dev/2022/basic"
				xmlns:tests="https://ns.mxhx.dev/2022/tests">
				<tests:float><mx:Float>123.4</mx:Float></tests:float>
			</tests:TestPropertiesClass>
		');
		Assert.notNull(result);
		Assert.isOfType(result.float, Float);
		Assert.equals(123.4, result.float);
	}

	public function testFloatChildElementRedundantEmpty():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestPropertiesClass
				xmlns:mx="https://ns.mxhx.dev/2022/basic"
				xmlns:tests="https://ns.mxhx.dev/2022/tests">
				<tests:float><mx:Float></mx:Float></tests:float>
			</tests:TestPropertiesClass>
		');
		Assert.notNull(result);
		Assert.isOfType(result.float, Float);
		Assert.isTrue(Math.isNaN(result.float));
	}

	public function testFloatChildElementRedundantEmptyExtraWhitespace():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestPropertiesClass
				xmlns:mx="https://ns.mxhx.dev/2022/basic"
				xmlns:tests="https://ns.mxhx.dev/2022/tests">
				<tests:float>
					<mx:Float>
					</mx:Float>
				</tests:float>
			</tests:TestPropertiesClass>
		');
		Assert.notNull(result);
		Assert.isOfType(result.float, Float);
		Assert.isTrue(Math.isNaN(result.float));
	}

	public function testIntAttribute():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestPropertiesClass
				xmlns:mx="https://ns.mxhx.dev/2022/basic"
				xmlns:tests="https://ns.mxhx.dev/2022/tests"
				integer="567"/>
		');
		Assert.notNull(result);
		Assert.isOfType(result.integer, Int);
		Assert.equals(567, result.integer);
	}

	public function testIntChildElement():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestPropertiesClass
				xmlns:mx="https://ns.mxhx.dev/2022/basic"
				xmlns:tests="https://ns.mxhx.dev/2022/tests">
				<tests:integer>567</tests:integer>
			</tests:TestPropertiesClass>
		');
		Assert.notNull(result);
		Assert.isOfType(result.integer, Int);
		Assert.equals(567, result.integer);
	}

	public function testIntChildElementCData():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestPropertiesClass
				xmlns:mx="https://ns.mxhx.dev/2022/basic"
				xmlns:tests="https://ns.mxhx.dev/2022/tests">
				<tests:integer><![CDATA[567]]></tests:integer>
			</tests:TestPropertiesClass>
		');
		Assert.notNull(result);
		Assert.isOfType(result.integer, Int);
		Assert.equals(567, result.integer);
	}

	public function testIntChildElementRedundant():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestPropertiesClass
				xmlns:mx="https://ns.mxhx.dev/2022/basic"
				xmlns:tests="https://ns.mxhx.dev/2022/tests">
				<tests:integer><mx:Int>567</mx:Int></tests:integer>
			</tests:TestPropertiesClass>
		');
		Assert.notNull(result);
		Assert.isOfType(result.integer, Int);
		Assert.equals(567, result.integer);
	}

	public function testIntChildElementRedundantEmpty():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestPropertiesClass
				xmlns:mx="https://ns.mxhx.dev/2022/basic"
				xmlns:tests="https://ns.mxhx.dev/2022/tests">
				<tests:integer><mx:Int></mx:Int></tests:integer>
			</tests:TestPropertiesClass>
		');
		Assert.notNull(result);
		Assert.isOfType(result.integer, Int);
		Assert.equals(0, result.integer);
	}

	public function testIntChildElementRedundantEmptyExtraWhitespace():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestPropertiesClass
				xmlns:mx="https://ns.mxhx.dev/2022/basic"
				xmlns:tests="https://ns.mxhx.dev/2022/tests">
				<tests:integer>
					<mx:Int>
					</mx:Int>
				</tests:integer>
			</tests:TestPropertiesClass>
		');
		Assert.notNull(result);
		Assert.isOfType(result.integer, Int);
		Assert.equals(0, result.integer);
	}

	public function testStringAttribute():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestPropertiesClass
				xmlns:mx="https://ns.mxhx.dev/2022/basic"
				xmlns:tests="https://ns.mxhx.dev/2022/tests"
				string="hello"/>
		');
		Assert.notNull(result);
		Assert.isOfType(result.string, String);
		Assert.equals("hello", result.string);
	}

	public function testStringAttributeEmpty():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestPropertiesClass
				xmlns:mx="https://ns.mxhx.dev/2022/basic"
				xmlns:tests="https://ns.mxhx.dev/2022/tests"
				string=""/>
		');
		Assert.notNull(result);
		Assert.isOfType(result.string, String);
		Assert.equals("", result.string);
	}

	public function testStringChildElement():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestPropertiesClass
				xmlns:mx="https://ns.mxhx.dev/2022/basic"
				xmlns:tests="https://ns.mxhx.dev/2022/tests">
				<tests:string>hello</tests:string>
			</tests:TestPropertiesClass>
		');
		Assert.notNull(result);
		Assert.isOfType(result.string, String);
		Assert.equals("hello", result.string);
	}

	public function testStringChildElementEmpty():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestPropertiesClass
				xmlns:mx="https://ns.mxhx.dev/2022/basic"
				xmlns:tests="https://ns.mxhx.dev/2022/tests">
				<tests:string></tests:string>
			</tests:TestPropertiesClass>
		');
		Assert.notNull(result);
		Assert.isOfType(result.string, String);
		Assert.equals("", result.string);
	}

	public function testStringChildElementCData():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestPropertiesClass
				xmlns:mx="https://ns.mxhx.dev/2022/basic"
				xmlns:tests="https://ns.mxhx.dev/2022/tests">
				<tests:string><![CDATA[MXHX & Haxe are <cool/>]]></tests:string>
			</tests:TestPropertiesClass>
		');
		Assert.notNull(result);
		Assert.isOfType(result.string, String);
		Assert.equals("MXHX & Haxe are <cool/>", result.string);
	}

	public function testStringChildElementCDataEmpty():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestPropertiesClass
				xmlns:mx="https://ns.mxhx.dev/2022/basic"
				xmlns:tests="https://ns.mxhx.dev/2022/tests">
				<tests:string><![CDATA[]]></tests:string>
			</tests:TestPropertiesClass>
		');
		Assert.notNull(result);
		Assert.isOfType(result.string, String);
		Assert.equals("", result.string);
	}

	public function testStringChildElementRedundant():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestPropertiesClass
				xmlns:mx="https://ns.mxhx.dev/2022/basic"
				xmlns:tests="https://ns.mxhx.dev/2022/tests">
				<tests:string><mx:String>hello</mx:String></tests:string>
			</tests:TestPropertiesClass>
		');
		Assert.notNull(result);
		Assert.isOfType(result.string, String);
		Assert.equals("hello", result.string);
	}

	public function testStringChildElementRedundantEmpty1():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestPropertiesClass
				xmlns:mx="https://ns.mxhx.dev/2022/basic"
				xmlns:tests="https://ns.mxhx.dev/2022/tests">
				<tests:string><mx:String></mx:String></tests:string>
			</tests:TestPropertiesClass>
		');
		Assert.notNull(result);
		Assert.isOfType(result.string, String);
		// child of field element: empty string, child of declarations: null
		Assert.equals("", result.string);
	}

	public function testStringChildElementRedundantEmpty2():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestPropertiesClass
				xmlns:mx="https://ns.mxhx.dev/2022/basic"
				xmlns:tests="https://ns.mxhx.dev/2022/tests">
				<tests:string><mx:String/></tests:string>
			</tests:TestPropertiesClass>
		');
		Assert.notNull(result);
		Assert.isOfType(result.string, String);
		// child of field element: empty string, child of declarations: null
		Assert.equals("", result.string);
	}

	public function testStringChildElementRedundantWhitespace():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestPropertiesClass
				xmlns:mx="https://ns.mxhx.dev/2022/basic"
				xmlns:tests="https://ns.mxhx.dev/2022/tests">
				<tests:string>
					<mx:String>
					</mx:String>
				</tests:string>
			</tests:TestPropertiesClass>
		');
		Assert.notNull(result);
		Assert.isOfType(result.string, String);
		// child of field element: empty string, child of declarations: null
		Assert.equals("", result.string);
	}

	public function testStringChildElementRedundantCDataEmpty():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestPropertiesClass
				xmlns:mx="https://ns.mxhx.dev/2022/basic"
				xmlns:tests="https://ns.mxhx.dev/2022/tests">
				<tests:string><mx:String><![CDATA[]]></mx:String></tests:string>
			</tests:TestPropertiesClass>
		');
		Assert.notNull(result);
		Assert.isOfType(result.string, String);
		// child of field element: empty string, child of declarations: null
		Assert.equals("", result.string);
	}

	public function testStringChildElementRedundantCDataWhitespace():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestPropertiesClass
				xmlns:mx="https://ns.mxhx.dev/2022/basic"
				xmlns:tests="https://ns.mxhx.dev/2022/tests">
				<tests:string><mx:String><![CDATA[ ]]></mx:String></tests:string>
			</tests:TestPropertiesClass>
		');
		Assert.notNull(result);
		Assert.isOfType(result.string, String);
		Assert.equals(" ", result.string);
	}

	public function testUIntAttribute():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestPropertiesClass
				xmlns:mx="https://ns.mxhx.dev/2022/basic"
				xmlns:tests="https://ns.mxhx.dev/2022/tests"
				unsignedInteger="4000000000"/>
		');
		Assert.notNull(result);
		Assert.isOfType(result.unsignedInteger, Int);
		var expected:UInt = Std.int(4000000000);
		Assert.equals(expected, result.unsignedInteger);
	}

	public function testUIntChildElement():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestPropertiesClass
				xmlns:mx="https://ns.mxhx.dev/2022/basic"
				xmlns:tests="https://ns.mxhx.dev/2022/tests">
				<tests:unsignedInteger>4000000000</tests:unsignedInteger>
			</tests:TestPropertiesClass>
		');
		Assert.notNull(result);
		Assert.isOfType(result.unsignedInteger, Int);
		var expected:UInt = Std.int(4000000000);
		Assert.equals(expected, result.unsignedInteger);
	}

	public function testUIntChildElementCData():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestPropertiesClass
				xmlns:mx="https://ns.mxhx.dev/2022/basic"
				xmlns:tests="https://ns.mxhx.dev/2022/tests">
				<tests:unsignedInteger><![CDATA[4000000000]]></tests:unsignedInteger>
			</tests:TestPropertiesClass>
		');
		Assert.notNull(result);
		Assert.isOfType(result.unsignedInteger, Int);
		var expected:UInt = Std.int(4000000000);
		Assert.equals(expected, result.unsignedInteger);
	}

	public function testUIntChildElementRedundant():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestPropertiesClass
				xmlns:mx="https://ns.mxhx.dev/2022/basic"
				xmlns:tests="https://ns.mxhx.dev/2022/tests">
				<tests:unsignedInteger><mx:UInt>4000000000</mx:UInt></tests:unsignedInteger>
			</tests:TestPropertiesClass>
		');
		Assert.notNull(result);
		Assert.isOfType(result.unsignedInteger, Int);
		var expected:UInt = Std.int(4000000000);
		Assert.equals(expected, result.unsignedInteger);
	}

	public function testUIntChildElementRedundantEmpty():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestPropertiesClass
				xmlns:mx="https://ns.mxhx.dev/2022/basic"
				xmlns:tests="https://ns.mxhx.dev/2022/tests">
				<tests:unsignedInteger><mx:UInt></mx:UInt></tests:unsignedInteger>
			</tests:TestPropertiesClass>
		');
		Assert.notNull(result);
		Assert.isOfType(result.unsignedInteger, Int);
		Assert.equals(0, result.unsignedInteger);
	}

	public function testUIntChildElementRedundantEmptyExtraWhitespace():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestPropertiesClass
				xmlns:mx="https://ns.mxhx.dev/2022/basic"
				xmlns:tests="https://ns.mxhx.dev/2022/tests">
				<tests:unsignedInteger>
					<mx:UInt>
					</mx:UInt>
				</tests:unsignedInteger>
			</tests:TestPropertiesClass>
		');
		Assert.notNull(result);
		Assert.isOfType(result.unsignedInteger, Int);
		Assert.equals(0, result.unsignedInteger);
	}

	public function testDefaultPropertyClassWithSimpleValue():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestDefaultPropertyClass2
				xmlns:mx="https://ns.mxhx.dev/2022/basic"
				xmlns:tests="https://ns.mxhx.dev/2022/tests">
				123.4
			</tests:TestDefaultPropertyClass2>
		');
		Assert.notNull(result);
		Assert.equals(123.4, result.float);
	}

	public function testDefaultPropertyClassWithSimpleValueRedundant():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestDefaultPropertyClass2
				xmlns:mx="https://ns.mxhx.dev/2022/basic"
				xmlns:tests="https://ns.mxhx.dev/2022/tests">
				<mx:Float>123.4</mx:Float>
			</tests:TestDefaultPropertyClass2>
		');
		Assert.notNull(result);
		Assert.equals(123.4, result.float);
	}

	public function testDefaultPropertyClassWithArrayValue():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestDefaultPropertyClass1
				xmlns:mx="https://ns.mxhx.dev/2022/basic"
				xmlns:tests="https://ns.mxhx.dev/2022/tests">
				<mx:String>one</mx:String>
				<mx:String>two</mx:String>
				<mx:String>three</mx:String>
			</tests:TestDefaultPropertyClass1>
		');
		Assert.notNull(result);
		Assert.notNull(result.mxhxContent);
		var array = result.mxhxContent;
		Assert.equals(3, array.length);
		Assert.equals("one", array[0]);
		Assert.equals("two", array[1]);
		Assert.equals("three", array[2]);
	}

	public function testDefaultPropertyClassWithArrayValueRedundant():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestDefaultPropertyClass1
				xmlns:mx="https://ns.mxhx.dev/2022/basic"
				xmlns:tests="https://ns.mxhx.dev/2022/tests">
				<mx:Array>
					<mx:String>one</mx:String>
					<mx:String>two</mx:String>
					<mx:String>three</mx:String>
				</mx:Array>
			</tests:TestDefaultPropertyClass1>
		');
		Assert.notNull(result);
		Assert.notNull(result.mxhxContent);
		var array = result.mxhxContent;
		Assert.equals(3, array.length);
		Assert.equals("one", array[0]);
		Assert.equals("two", array[1]);
		Assert.equals("three", array[2]);
	}

	public function testDefaultPropertyClassWithArrayValueAndOtherPropertyBefore():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestDefaultPropertyClass1
				xmlns:mx="https://ns.mxhx.dev/2022/basic"
				xmlns:tests="https://ns.mxhx.dev/2022/tests">
				<tests:other>four</tests:other>
				<mx:String>one</mx:String>
				<mx:String>two</mx:String>
				<mx:String>three</mx:String>
			</tests:TestDefaultPropertyClass1>
		');
		Assert.notNull(result);
		Assert.notNull(result.mxhxContent);
		var array = result.mxhxContent;
		Assert.equals(3, array.length);
		Assert.equals("one", array[0]);
		Assert.equals("two", array[1]);
		Assert.equals("three", array[2]);
		Assert.equals("four", result.other);
	}

	public function testDefaultPropertyClassWithArrayValueAndOtherPropertyAfter():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestDefaultPropertyClass1
				xmlns:mx="https://ns.mxhx.dev/2022/basic"
				xmlns:tests="https://ns.mxhx.dev/2022/tests">
				<mx:String>one</mx:String>
				<mx:String>two</mx:String>
				<mx:String>three</mx:String>
				<tests:other>four</tests:other>
			</tests:TestDefaultPropertyClass1>
		');
		Assert.notNull(result);
		Assert.notNull(result.mxhxContent);
		var array = result.mxhxContent;
		Assert.equals(3, array.length);
		Assert.equals("one", array[0]);
		Assert.equals("two", array[1]);
		Assert.equals("three", array[2]);
		Assert.equals("four", result.other);
	}

	public function testDefaultPropertyClassWithArrayValueAndOtherPropertyBetween():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestDefaultPropertyClass1
				xmlns:mx="https://ns.mxhx.dev/2022/basic"
				xmlns:tests="https://ns.mxhx.dev/2022/tests">
				<mx:String>one</mx:String>
				<tests:other>four</tests:other>
				<mx:String>two</mx:String>
				<mx:String>three</mx:String>
			</tests:TestDefaultPropertyClass1>
		');
		Assert.notNull(result);
		Assert.notNull(result.mxhxContent);
		var array = result.mxhxContent;
		Assert.equals(3, array.length);
		Assert.equals("one", array[0]);
		Assert.equals("two", array[1]);
		Assert.equals("three", array[2]);
		Assert.equals("four", result.other);
	}
}
