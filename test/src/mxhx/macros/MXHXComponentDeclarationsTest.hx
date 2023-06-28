package mxhx.macros;

import Xml.XmlType;
import fixtures.TestComplexEnum;
import fixtures.TestPropertyEnum;
import utest.Assert;
import utest.Test;

class MXHXComponentDeclarationsTest extends Test {
	public function testDeclarationsEmpty():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2022/basic" xmlns:tests="https://ns.mxhx.dev/2022/tests">
				<mx:Declarations></mx:Declarations>
			</tests:TestClass1>
		');
		Assert.notNull(result);
	}

	public function testDeclarationsEmptyExtraWhitespace():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2022/basic" xmlns:tests="https://ns.mxhx.dev/2022/tests">
				<mx:Declarations>
				</mx:Declarations>
			</tests:TestClass1>
		');
		Assert.notNull(result);
	}

	public function testDeclarationsComment1():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2022/basic" xmlns:tests="https://ns.mxhx.dev/2022/tests">
				<mx:Declarations><!-- comment --></mx:Declarations>
			</tests:TestClass1>
		');
		Assert.notNull(result);
	}

	public function testDeclarationsComment2():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2022/basic" xmlns:tests="https://ns.mxhx.dev/2022/tests">
				<mx:Declarations>
					<!-- comment -->
				</mx:Declarations>
			</tests:TestClass1>
		');
		Assert.notNull(result);
	}

	public function testDeclarationsDocComment1():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2022/basic" xmlns:tests="https://ns.mxhx.dev/2022/tests">
				<mx:Declarations><!--- doc comment --></mx:Declarations>
			</tests:TestClass1>
		');
		Assert.notNull(result);
	}

	public function testDeclarationsDocComment2():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2022/basic" xmlns:tests="https://ns.mxhx.dev/2022/tests">
				<mx:Declarations>
					<!--- doc comment -->
				</mx:Declarations>
			</tests:TestClass1>
		');
		Assert.notNull(result);
	}

	public function testAny():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2022/basic" xmlns:tests="https://ns.mxhx.dev/2022/tests">
				<mx:Declarations>
					<mx:Any id="any" float="123.4" floatHex="0xbeef" nan="NaN" boolean_true="true" boolean_false="false" string="hello">
						<mx:object>
							<mx:Any integer="567"/>
						</mx:object>
					</mx:Any>
				</mx:Declarations>
			</tests:TestClass1>
		');
		Assert.notNull(result);
		Assert.notNull(result.any);
		Assert.equals(7, Reflect.fields(result.any).length);
		Assert.isTrue(Reflect.hasField(result.any, "float"));
		Assert.isTrue(Reflect.hasField(result.any, "floatHex"));
		Assert.isTrue(Reflect.hasField(result.any, "nan"));
		Assert.isTrue(Reflect.hasField(result.any, "boolean_true"));
		Assert.isTrue(Reflect.hasField(result.any, "boolean_false"));
		Assert.isTrue(Reflect.hasField(result.any, "string"));
		Assert.isTrue(Reflect.hasField(result.any, "object"));
		Assert.equals(123.4, Reflect.field(result.any, "float"));
		Assert.equals(0xbeef, Reflect.field(result.any, "floatHex"));
		Assert.isTrue(Math.isNaN(Reflect.field(result.any, "nan")));
		Assert.isTrue(Reflect.field(result.any, "boolean_true"));
		Assert.isFalse(Reflect.field(result.any, "boolean_false"));
		Assert.equals("hello", Reflect.field(result.any, "string"));
		Assert.notNull(Reflect.field(result.any, "object"));
		Assert.equals(567, Reflect.field(Reflect.field(result.any, "object"), "integer"));
	}

	public function testAnyEmpty():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2022/basic" xmlns:tests="https://ns.mxhx.dev/2022/tests">
				<mx:Declarations>
					<mx:Any id="any"></mx:Any>
				</mx:Declarations>
			</tests:TestClass1>
		');
		Assert.notNull(result);
		Assert.notNull(result.any);
		Assert.equals(0, Reflect.fields(result.any).length);
	}

	public function testAnyEmptyExtraWhitespace():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2022/basic" xmlns:tests="https://ns.mxhx.dev/2022/tests">
				<mx:Declarations>
					<mx:Any id="any">
					</mx:Any>
				</mx:Declarations>
			</tests:TestClass1>
		');
		Assert.notNull(result);
		Assert.notNull(result.any);
		Assert.equals(0, Reflect.fields(result.any).length);
	}

	public function testAnyOnlyComment1():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2022/basic" xmlns:tests="https://ns.mxhx.dev/2022/tests">
				<mx:Declarations>
					<mx:Any id="any"><!-- comment --></mx:Any>
				</mx:Declarations>
			</tests:TestClass1>
		');
		Assert.notNull(result);
		Assert.notNull(result.any);
		Assert.equals(0, Reflect.fields(result.any).length);
	}

	public function testAnyOnlyComment2():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2022/basic" xmlns:tests="https://ns.mxhx.dev/2022/tests">
				<mx:Declarations>
					<mx:Any id="any">
						<!-- comment -->
					</mx:Any>
				</mx:Declarations>
			</tests:TestClass1>
		');
		Assert.notNull(result);
		Assert.notNull(result.any);
		Assert.equals(0, Reflect.fields(result.any).length);
	}

	public function testAnyOnlyDocComment():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2022/basic" xmlns:tests="https://ns.mxhx.dev/2022/tests">
				<mx:Declarations>
					<mx:Any id="any">
						<!--- comment -->
					</mx:Any>
				</mx:Declarations>
			</tests:TestClass1>
		');
		Assert.notNull(result);
		Assert.notNull(result.any);
		Assert.equals(0, Reflect.fields(result.any).length);
	}

	public function testStrict():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2022/basic" xmlns:tests="https://ns.mxhx.dev/2022/tests">
				<mx:Declarations>
					<tests:TestPropertiesClass
						id="strict"
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
				</mx:Declarations>
			</tests:TestClass1>
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

	public function testEnumValue():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2022/basic" xmlns:tests="https://ns.mxhx.dev/2022/tests">
				<mx:Declarations>
					<tests:TestPropertyEnum id="enumValue">Value2</tests:TestPropertyEnum>
				</mx:Declarations>
			</tests:TestClass1>
		');
		Assert.notNull(result);
		Assert.equals(TestPropertyEnum.Value2, result.enumValue);
	}

	public function testEnumValueExtraWhitespace():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2022/basic" xmlns:tests="https://ns.mxhx.dev/2022/tests">
				<mx:Declarations>
					<tests:TestPropertyEnum id="enumValue">
						Value2
					</tests:TestPropertyEnum>
				</mx:Declarations>
			</tests:TestClass1>
		');
		Assert.notNull(result);
		Assert.equals(TestPropertyEnum.Value2, result.enumValue);
	}

	public function testEnumValueComment1():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2022/basic" xmlns:tests="https://ns.mxhx.dev/2022/tests">
				<mx:Declarations>
					<tests:TestPropertyEnum id="enumValue">Value2<!-- comment --></tests:TestPropertyEnum>
				</mx:Declarations>
			</tests:TestClass1>
		');
		Assert.notNull(result);
		Assert.equals(TestPropertyEnum.Value2, result.enumValue);
	}

	public function testEnumValueComment2():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2022/basic" xmlns:tests="https://ns.mxhx.dev/2022/tests">
				<mx:Declarations>
					<tests:TestPropertyEnum id="enumValue"><!-- comment -->Value2</tests:TestPropertyEnum>
				</mx:Declarations>
			</tests:TestClass1>
		');
		Assert.notNull(result);
		Assert.equals(TestPropertyEnum.Value2, result.enumValue);
	}

	public function testEnumValueComment3():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2022/basic" xmlns:tests="https://ns.mxhx.dev/2022/tests">
				<mx:Declarations>
					<tests:TestPropertyEnum id="enumValue">Val<!-- comment -->ue2</tests:TestPropertyEnum>
				</mx:Declarations>
			</tests:TestClass1>
		');
		Assert.notNull(result);
		Assert.equals(TestPropertyEnum.Value2, result.enumValue);
	}

	public function testEnumValueCData():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2022/basic" xmlns:tests="https://ns.mxhx.dev/2022/tests">
				<mx:Declarations>
					<tests:TestPropertyEnum id="enumValue"><![CDATA[Value2]]></tests:TestPropertyEnum>
				</mx:Declarations>
			</tests:TestClass1>
		');
		Assert.notNull(result);
		Assert.equals(TestPropertyEnum.Value2, result.enumValue);
	}

	public function testEReg():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2022/basic" xmlns:tests="https://ns.mxhx.dev/2022/tests">
				<mx:Declarations>
					<mx:EReg id="ereg">~/[a-z]+/g</mx:EReg>
				</mx:Declarations>
			</tests:TestClass1>
		');
		Assert.notNull(result);
		Assert.isOfType(result.ereg, EReg);
		Assert.equals("~/[a-z]+/g", Std.string(result.ereg));
	}

	public function testERegExtraWhitespace():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2022/basic" xmlns:tests="https://ns.mxhx.dev/2022/tests">
				<mx:Declarations>
					<mx:EReg id="ereg">
						~/[a-z]+/g
					</mx:EReg>
				</mx:Declarations>
			</tests:TestClass1>
		');
		Assert.notNull(result);
		Assert.isOfType(result.ereg, EReg);
		Assert.equals("~/[a-z]+/g", Std.string(result.ereg));
	}

	public function testERegComment1():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2022/basic" xmlns:tests="https://ns.mxhx.dev/2022/tests">
				<mx:Declarations>
					<mx:EReg id="ereg">~/[a-z]+/g<!-- comment --></mx:EReg>
				</mx:Declarations>
			</tests:TestClass1>
		');
		Assert.notNull(result);
		Assert.isOfType(result.ereg, EReg);
		Assert.equals("~/[a-z]+/g", Std.string(result.ereg));
	}

	public function testERegComment2():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2022/basic" xmlns:tests="https://ns.mxhx.dev/2022/tests">
				<mx:Declarations>
					<mx:EReg id="ereg"><!-- comment -->~/[a-z]+/g</mx:EReg>
				</mx:Declarations>
			</tests:TestClass1>
		');
		Assert.notNull(result);
		Assert.isOfType(result.ereg, EReg);
		Assert.equals("~/[a-z]+/g", Std.string(result.ereg));
	}

	public function testERegEmpty():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2022/basic" xmlns:tests="https://ns.mxhx.dev/2022/tests">
				<mx:Declarations>
					<mx:EReg id="ereg"></mx:EReg>
				</mx:Declarations>
			</tests:TestClass1>
		');
		Assert.notNull(result);
		Assert.isOfType(result.ereg, EReg);
		Assert.equals("~//", Std.string(result.ereg));
	}

	public function testERegEmptyExtraWhitespace():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2022/basic" xmlns:tests="https://ns.mxhx.dev/2022/tests">
				<mx:Declarations>
					<mx:EReg id="ereg">
					</mx:EReg>
				</mx:Declarations>
			</tests:TestClass1>
		');
		Assert.notNull(result);
		Assert.isOfType(result.ereg, EReg);
		Assert.equals("~//", Std.string(result.ereg));
	}

	public function testERegOnlyComment1():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2022/basic" xmlns:tests="https://ns.mxhx.dev/2022/tests">
				<mx:Declarations>
					<mx:EReg id="ereg"><!-- comment --></mx:EReg>
				</mx:Declarations>
			</tests:TestClass1>
		');
		Assert.notNull(result);
		Assert.isOfType(result.ereg, EReg);
		Assert.equals("~//", Std.string(result.ereg));
	}

	public function testERegOnlyComment2():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2022/basic" xmlns:tests="https://ns.mxhx.dev/2022/tests">
				<mx:Declarations>
					<mx:EReg id="ereg">
						<!-- comment -->
					</mx:EReg>
				</mx:Declarations>
			</tests:TestClass1>
		');
		Assert.notNull(result);
		Assert.isOfType(result.ereg, EReg);
		Assert.equals("~//", Std.string(result.ereg));
	}

	public function testERegOnlyDocComment1():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2022/basic" xmlns:tests="https://ns.mxhx.dev/2022/tests">
				<mx:Declarations>
					<mx:EReg id="ereg"><!--- doc comment --></mx:EReg>
				</mx:Declarations>
			</tests:TestClass1>
		');
		Assert.notNull(result);
		Assert.isOfType(result.ereg, EReg);
		Assert.equals("~//", Std.string(result.ereg));
	}

	public function testERegOnlyDocComment2():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2022/basic" xmlns:tests="https://ns.mxhx.dev/2022/tests">
				<mx:Declarations>
					<mx:EReg id="ereg">
						<!--- doc comment -->
					</mx:EReg>
				</mx:Declarations>
			</tests:TestClass1>
		');
		Assert.notNull(result);
		Assert.isOfType(result.ereg, EReg);
		Assert.equals("~//", Std.string(result.ereg));
	}

	public function testERegNoExpression():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2022/basic" xmlns:tests="https://ns.mxhx.dev/2022/tests">
				<mx:Declarations>
					<mx:EReg id="ereg">~//</mx:EReg>
				</mx:Declarations>
			</tests:TestClass1>
		');
		Assert.notNull(result);
		Assert.isOfType(result.ereg, EReg);
		Assert.equals("~//", Std.string(result.ereg));
	}

	public function testERegCData():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2022/basic" xmlns:tests="https://ns.mxhx.dev/2022/tests">
				<mx:Declarations>
					<mx:EReg id="ereg"><![CDATA[~/[a-z]+/g]]></mx:EReg>
				</mx:Declarations>
			</tests:TestClass1>
		');
		Assert.notNull(result);
		Assert.isOfType(result.ereg, EReg);
		Assert.equals("~/[a-z]+/g", Std.string(result.ereg));
	}

	public function testFloat():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2022/basic" xmlns:tests="https://ns.mxhx.dev/2022/tests">
				<mx:Declarations>
					<mx:Float id="float">123.4</mx:Float>
				</mx:Declarations>
			</tests:TestClass1>
		');
		Assert.notNull(result);
		Assert.isOfType(result.float, Float);
		Assert.equals(123.4, result.float);
	}

	public function testFloatExtraWhitespace():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2022/basic" xmlns:tests="https://ns.mxhx.dev/2022/tests">
				<mx:Declarations>
					<mx:Float id="float">
						123.4
					</mx:Float>
				</mx:Declarations>
			</tests:TestClass1>
		');
		Assert.notNull(result);
		Assert.isOfType(result.float, Float);
		Assert.equals(123.4, result.float);
	}

	public function testFloatComment1():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2022/basic" xmlns:tests="https://ns.mxhx.dev/2022/tests">
				<mx:Declarations>
					<mx:Float id="float">123.4<!-- comment --></mx:Float>
				</mx:Declarations>
			</tests:TestClass1>
		');
		Assert.notNull(result);
		Assert.isOfType(result.float, Float);
		Assert.equals(123.4, result.float);
	}

	public function testFloatComment2():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2022/basic" xmlns:tests="https://ns.mxhx.dev/2022/tests">
				<mx:Declarations>
					<mx:Float id="float"><!-- comment -->123.4</mx:Float>
				</mx:Declarations>
			</tests:TestClass1>
		');
		Assert.notNull(result);
		Assert.isOfType(result.float, Float);
		Assert.equals(123.4, result.float);
	}

	public function testFloatComment3():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2022/basic" xmlns:tests="https://ns.mxhx.dev/2022/tests">
				<mx:Declarations>
					<mx:Float id="float">12<!-- comment -->3.4</mx:Float>
				</mx:Declarations>
			</tests:TestClass1>
		');
		Assert.notNull(result);
		Assert.isOfType(result.float, Float);
		Assert.equals(123.4, result.float);
	}

	public function testFloatEmpty():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2022/basic" xmlns:tests="https://ns.mxhx.dev/2022/tests">
				<mx:Declarations>
					<mx:Float id="float"></mx:Float>
				</mx:Declarations>
			</tests:TestClass1>
		');
		Assert.notNull(result);
		Assert.isOfType(result.float, Float);
		Assert.isTrue(Math.isNaN(result.float));
	}

	public function testFloatEmptyExtraWhitespace():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2022/basic" xmlns:tests="https://ns.mxhx.dev/2022/tests">
				<mx:Declarations>
					<mx:Float id="float">
					</mx:Float>
				</mx:Declarations>
			</tests:TestClass1>
		');
		Assert.notNull(result);
		Assert.isOfType(result.float, Float);
		Assert.isTrue(Math.isNaN(result.float));
	}

	public function testFloatOnlyComment1():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2022/basic" xmlns:tests="https://ns.mxhx.dev/2022/tests">
				<mx:Declarations>
					<mx:Float id="float"><!-- comment --></mx:Float>
				</mx:Declarations>
			</tests:TestClass1>
		');
		Assert.notNull(result);
		Assert.isOfType(result.float, Float);
		Assert.isTrue(Math.isNaN(result.float));
	}

	public function testFloatOnlyComment2():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2022/basic" xmlns:tests="https://ns.mxhx.dev/2022/tests">
				<mx:Declarations>
					<mx:Float id="float">
						<!-- comment -->
					</mx:Float>
				</mx:Declarations>
			</tests:TestClass1>
		');
		Assert.notNull(result);
		Assert.isOfType(result.float, Float);
		Assert.isTrue(Math.isNaN(result.float));
	}

	public function testFloatOnlyDocComment1():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2022/basic" xmlns:tests="https://ns.mxhx.dev/2022/tests">
				<mx:Declarations>
					<mx:Float id="float"><!--- comment --></mx:Float>
				</mx:Declarations>
			</tests:TestClass1>
		');
		Assert.notNull(result);
		Assert.isOfType(result.float, Float);
		Assert.isTrue(Math.isNaN(result.float));
	}

	public function testFloatOnlyDocComment2():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2022/basic" xmlns:tests="https://ns.mxhx.dev/2022/tests">
				<mx:Declarations>
					<mx:Float id="float">
						<!--- doc comment -->
					</mx:Float>
				</mx:Declarations>
			</tests:TestClass1>
		');
		Assert.notNull(result);
		Assert.isOfType(result.float, Float);
		Assert.isTrue(Math.isNaN(result.float));
	}

	public function testFloatNegative():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2022/basic" xmlns:tests="https://ns.mxhx.dev/2022/tests">
				<mx:Declarations>
					<mx:Float id="float">-123.4</mx:Float>
				</mx:Declarations>
			</tests:TestClass1>
		');
		Assert.notNull(result);
		Assert.isOfType(result.float, Float);
		Assert.equals(-123.4, result.float);
	}

	public function testFloatInt():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2022/basic" xmlns:tests="https://ns.mxhx.dev/2022/tests">
				<mx:Declarations>
					<mx:Float id="float">456</mx:Float>
				</mx:Declarations>
			</tests:TestClass1>
		');
		Assert.notNull(result);
		Assert.isOfType(result.float, Float);
		Assert.equals(456, result.float);
	}

	public function testFloatIntNegative():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2022/basic" xmlns:tests="https://ns.mxhx.dev/2022/tests">
				<mx:Declarations>
					<mx:Float id="float">-456</mx:Float>
				</mx:Declarations>
			</tests:TestClass1>
		');
		Assert.notNull(result);
		Assert.isOfType(result.float, Float);
		Assert.equals(-456, result.float);
	}

	public function testFloatHexLowerCase():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2022/basic" xmlns:tests="https://ns.mxhx.dev/2022/tests">
				<mx:Declarations>
					<mx:Float id="float">0xbeef</mx:Float>
				</mx:Declarations>
			</tests:TestClass1>
		');
		Assert.notNull(result);
		Assert.isOfType(result.float, Float);
		Assert.equals(0xbeef, result.float);
	}

	public function testFloatHexUpperCase():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2022/basic" xmlns:tests="https://ns.mxhx.dev/2022/tests">
				<mx:Declarations>
					<mx:Float id="float">0xBEEF</mx:Float>
				</mx:Declarations>
			</tests:TestClass1>
		');
		Assert.notNull(result);
		Assert.isOfType(result.float, Float);
		Assert.equals(0xbeef, result.float);
	}

	public function testFloatHexNegative():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2022/basic" xmlns:tests="https://ns.mxhx.dev/2022/tests">
				<mx:Declarations>
					<mx:Float id="float">-0xbeef</mx:Float>
				</mx:Declarations>
			</tests:TestClass1>
		');
		Assert.notNull(result);
		Assert.isOfType(result.float, Float);
		Assert.equals(-0xbeef, result.float);
	}

	public function testFloatExponent():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2022/basic" xmlns:tests="https://ns.mxhx.dev/2022/tests">
				<mx:Declarations>
					<mx:Float id="float">123.4e5</mx:Float>
				</mx:Declarations>
			</tests:TestClass1>
		');
		Assert.notNull(result);
		Assert.isOfType(result.float, Float);
		Assert.equals(123.4e5, result.float);
	}

	public function testFloatNegativeExponent():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2022/basic" xmlns:tests="https://ns.mxhx.dev/2022/tests">
				<mx:Declarations>
					<mx:Float id="float">123.4e-5</mx:Float>
				</mx:Declarations>
			</tests:TestClass1>
		');
		Assert.notNull(result);
		Assert.isOfType(result.float, Float);
		Assert.equals(123.4e-5, result.float);
	}

	public function testFloatNaN():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2022/basic" xmlns:tests="https://ns.mxhx.dev/2022/tests">
				<mx:Declarations>
					<mx:Float id="float">NaN</mx:Float>
				</mx:Declarations>
			</tests:TestClass1>
		');
		Assert.notNull(result);
		Assert.isOfType(result.float, Float);
		Assert.isTrue(Math.isNaN(result.float));
	}

	public function testFloatInfinity():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2022/basic" xmlns:tests="https://ns.mxhx.dev/2022/tests">
				<mx:Declarations>
					<mx:Float id="float">Infinity</mx:Float>
				</mx:Declarations>
			</tests:TestClass1>
		');
		Assert.notNull(result);
		Assert.isOfType(result.float, Float);
		Assert.equals(Math.POSITIVE_INFINITY, result.float);
	}

	public function testFloatNegativeInfinity():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2022/basic" xmlns:tests="https://ns.mxhx.dev/2022/tests">
				<mx:Declarations>
					<mx:Float id="float">-Infinity</mx:Float>
				</mx:Declarations>
			</tests:TestClass1>
		');
		Assert.notNull(result);
		Assert.isOfType(result.float, Float);
		Assert.equals(Math.NEGATIVE_INFINITY, result.float);
	}

	public function testFloatCData():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2022/basic" xmlns:tests="https://ns.mxhx.dev/2022/tests">
				<mx:Declarations>
					<mx:Float id="float"><![CDATA[123.4]]></mx:Float>
				</mx:Declarations>
			</tests:TestClass1>
		');
		Assert.notNull(result);
		Assert.isOfType(result.float, Float);
		Assert.equals(123.4, result.float);
	}

	public function testBool():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2022/basic" xmlns:tests="https://ns.mxhx.dev/2022/tests">
				<mx:Declarations>
					<mx:Bool id="boolean">true</mx:Bool>
				</mx:Declarations>
			</tests:TestClass1>
		');
		Assert.notNull(result);
		Assert.isOfType(result.boolean, Bool);
		Assert.isTrue(result.boolean);
	}

	public function testBoolExtraWhitespace():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2022/basic" xmlns:tests="https://ns.mxhx.dev/2022/tests">
				<mx:Declarations>
					<mx:Bool id="boolean">
						true
					</mx:Bool>
				</mx:Declarations>
			</tests:TestClass1>
		');
		Assert.notNull(result);
		Assert.isOfType(result.boolean, Bool);
		Assert.isTrue(result.boolean);
	}

	public function testBoolComment1():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2022/basic" xmlns:tests="https://ns.mxhx.dev/2022/tests">
				<mx:Declarations>
					<mx:Bool id="boolean">true<!-- comment --></mx:Bool>
				</mx:Declarations>
			</tests:TestClass1>
		');
		Assert.notNull(result);
		Assert.isOfType(result.boolean, Bool);
		Assert.isTrue(result.boolean);
	}

	public function testBoolComment2():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2022/basic" xmlns:tests="https://ns.mxhx.dev/2022/tests">
				<mx:Declarations>
					<mx:Bool id="boolean"><!-- comment -->true</mx:Bool>
				</mx:Declarations>
			</tests:TestClass1>
		');
		Assert.notNull(result);
		Assert.isTrue(result.boolean);
	}

	public function testBoolComment3():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2022/basic" xmlns:tests="https://ns.mxhx.dev/2022/tests">
				<mx:Declarations>
					<mx:Bool id="boolean">tr<!-- comment -->ue</mx:Bool>
				</mx:Declarations>
			</tests:TestClass1>
		');
		Assert.notNull(result);
		Assert.isOfType(result.boolean, Bool);
		Assert.isTrue(result.boolean);
	}

	public function testBoolEmpty():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2022/basic" xmlns:tests="https://ns.mxhx.dev/2022/tests">
				<mx:Declarations>
					<mx:Bool id="boolean"></mx:Bool>
				</mx:Declarations>
			</tests:TestClass1>
		');
		Assert.notNull(result);
		Assert.isOfType(result.boolean, Bool);
		Assert.isFalse(result.boolean);
	}

	public function testBoolEmptyExtraWhitespace():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2022/basic" xmlns:tests="https://ns.mxhx.dev/2022/tests">
				<mx:Declarations>
					<mx:Bool id="boolean">
					</mx:Bool>
				</mx:Declarations>
			</tests:TestClass1>
		');
		Assert.notNull(result);
		Assert.isFalse(result.boolean);
	}

	public function testBoolOnlyComment1():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2022/basic" xmlns:tests="https://ns.mxhx.dev/2022/tests">
				<mx:Declarations>
					<mx:Bool id="boolean"><!-- comment --></mx:Bool>
				</mx:Declarations>
			</tests:TestClass1>
		');
		Assert.notNull(result);
		Assert.isOfType(result.boolean, Bool);
		Assert.isFalse(result.boolean);
	}

	public function testBoolOnlyComment2():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2022/basic" xmlns:tests="https://ns.mxhx.dev/2022/tests">
				<mx:Declarations>
					<mx:Bool id="boolean">
						<!-- comment -->
					</mx:Bool>
				</mx:Declarations>
			</tests:TestClass1>
		');
		Assert.notNull(result);
		Assert.isOfType(result.boolean, Bool);
		Assert.isFalse(result.boolean);
	}

	public function testBoolCData():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2022/basic" xmlns:tests="https://ns.mxhx.dev/2022/tests">
				<mx:Declarations>
					<mx:Bool id="boolean"><![CDATA[true]]></mx:Bool>
				</mx:Declarations>
			</tests:TestClass1>
		');
		Assert.notNull(result);
		Assert.isOfType(result.boolean, Bool);
		Assert.isTrue(result.boolean);
	}

	public function testClass():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2022/basic" xmlns:tests="https://ns.mxhx.dev/2022/tests">
				<mx:Declarations>
					<mx:Class id="type">fixtures.TestClass1</mx:Class>
				</mx:Declarations>
			</tests:TestClass1>
		');
		Assert.notNull(result);
		Assert.isOfType(result.type, Class);
		Assert.equals(fixtures.TestClass1, result.type);
	}

	public function testClassExtraWhitespace():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2022/basic" xmlns:tests="https://ns.mxhx.dev/2022/tests">
				<mx:Declarations>
					<mx:Class id="type">
						fixtures.TestClass1
					</mx:Class>
				</mx:Declarations>
			</tests:TestClass1>
		');
		Assert.notNull(result);
		Assert.isOfType(result.type, Class);
		Assert.equals(fixtures.TestClass1, result.type);
	}

	public function testClassComment1():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2022/basic" xmlns:tests="https://ns.mxhx.dev/2022/tests">
				<mx:Declarations>
					<mx:Class id="type">fixtures.TestClass1<!-- comment --></mx:Class>
				</mx:Declarations>
			</tests:TestClass1>
		');
		Assert.notNull(result);
		Assert.isOfType(result.type, Class);
		Assert.equals(fixtures.TestClass1, result.type);
	}

	public function testClassComment2():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2022/basic" xmlns:tests="https://ns.mxhx.dev/2022/tests">
				<mx:Declarations>
					<mx:Class id="type"><!-- comment -->fixtures.TestClass1</mx:Class>
				</mx:Declarations>
			</tests:TestClass1>
		');
		Assert.notNull(result);
		Assert.isOfType(result.type, Class);
		Assert.equals(fixtures.TestClass1, result.type);
	}

	public function testClassComment3():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2022/basic" xmlns:tests="https://ns.mxhx.dev/2022/tests">
				<mx:Declarations>
					<mx:Class id="type">fixtures.<!-- comment -->TestClass1</mx:Class>
				</mx:Declarations>
			</tests:TestClass1>
		');
		Assert.notNull(result);
		Assert.isOfType(result.type, Class);
		Assert.equals(fixtures.TestClass1, result.type);
	}

	public function testClassEmpty():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2022/basic" xmlns:tests="https://ns.mxhx.dev/2022/tests">
				<mx:Declarations>
					<mx:Class id="type"></mx:Class>
				</mx:Declarations>
			</tests:TestClass1>
		');
		Assert.notNull(result);
		Assert.isNull(result.type);
	}

	public function testClassEmptyExtraWhitespace():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2022/basic" xmlns:tests="https://ns.mxhx.dev/2022/tests">
				<mx:Declarations>
					<mx:Class id="type">
					</mx:Class>
				</mx:Declarations>
			</tests:TestClass1>
		');
		Assert.notNull(result);
		Assert.isNull(result.type);
	}

	public function testClassOnlyComment1():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2022/basic" xmlns:tests="https://ns.mxhx.dev/2022/tests">
				<mx:Declarations>
					<mx:Class id="type"><!-- comment --></mx:Class>
				</mx:Declarations>
			</tests:TestClass1>
		');
		Assert.notNull(result);
		Assert.isNull(result.type);
	}

	public function testClassOnlyComment2():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2022/basic" xmlns:tests="https://ns.mxhx.dev/2022/tests">
				<mx:Declarations>
					<mx:Class id="type">
						<!-- comment -->
					</mx:Class>
				</mx:Declarations>
			</tests:TestClass1>
		');
		Assert.notNull(result);
		Assert.isNull(result.type);
	}

	public function testClassCData():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2022/basic" xmlns:tests="https://ns.mxhx.dev/2022/tests">
				<mx:Declarations>
					<mx:Class id="type"><![CDATA[fixtures.TestClass1]]></mx:Class>
				</mx:Declarations>
			</tests:TestClass1>
		');
		Assert.notNull(result);
		Assert.isOfType(result.type, Class);
		Assert.equals(fixtures.TestClass1, result.type);
	}

	public function testInt():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2022/basic" xmlns:tests="https://ns.mxhx.dev/2022/tests">
				<mx:Declarations>
					<mx:Int id="integer">123</mx:Int>
				</mx:Declarations>
			</tests:TestClass1>
		');
		Assert.notNull(result);
		Assert.isOfType(result.integer, Int);
		Assert.equals(123, result.integer);
	}

	public function testIntExtraWhitespace():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2022/basic" xmlns:tests="https://ns.mxhx.dev/2022/tests">
				<mx:Declarations>
					<mx:Int id="integer">
						123
					</mx:Int>
				</mx:Declarations>
			</tests:TestClass1>
		');
		Assert.notNull(result);
		Assert.isOfType(result.integer, Int);
		Assert.equals(123, result.integer);
	}

	public function testIntComment1():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2022/basic" xmlns:tests="https://ns.mxhx.dev/2022/tests">
				<mx:Declarations>
					<mx:Int id="integer">123<!-- comment --></mx:Int>
				</mx:Declarations>
			</tests:TestClass1>
		');
		Assert.notNull(result);
		Assert.isOfType(result.integer, Int);
		Assert.equals(123, result.integer);
	}

	public function testIntComment2():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2022/basic" xmlns:tests="https://ns.mxhx.dev/2022/tests">
				<mx:Declarations>
					<mx:Int id="integer"><!-- comment -->123</mx:Int>
				</mx:Declarations>
			</tests:TestClass1>
		');
		Assert.notNull(result);
		Assert.isOfType(result.integer, Int);
		Assert.equals(123, result.integer);
	}

	public function testIntComment3():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2022/basic" xmlns:tests="https://ns.mxhx.dev/2022/tests">
				<mx:Declarations>
					<mx:Int id="integer">12<!-- comment -->3</mx:Int>
				</mx:Declarations>
			</tests:TestClass1>
		');
		Assert.notNull(result);
		Assert.isOfType(result.integer, Int);
		Assert.equals(123, result.integer);
	}

	public function testIntEmpty():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2022/basic" xmlns:tests="https://ns.mxhx.dev/2022/tests">
				<mx:Declarations>
					<mx:Int id="integer"></mx:Int>
				</mx:Declarations>
			</tests:TestClass1>
		');
		Assert.notNull(result);
		Assert.isOfType(result.integer, Int);
		Assert.equals(0, result.integer);
	}

	public function testIntEmptyExtraWhitespace():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2022/basic" xmlns:tests="https://ns.mxhx.dev/2022/tests">
				<mx:Declarations>
					<mx:Int id="integer">
					</mx:Int>
				</mx:Declarations>
			</tests:TestClass1>
		');
		Assert.notNull(result);
		Assert.isOfType(result.integer, Int);
		Assert.equals(0, result.integer);
	}

	public function testIntOnlyComment1():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2022/basic" xmlns:tests="https://ns.mxhx.dev/2022/tests">
				<mx:Declarations>
					<mx:Int id="integer"><!-- comment --></mx:Int>
				</mx:Declarations>
			</tests:TestClass1>
		');
		Assert.notNull(result);
		Assert.isOfType(result.integer, Int);
		Assert.equals(0, result.integer);
	}

	public function testIntOnlyComment2():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2022/basic" xmlns:tests="https://ns.mxhx.dev/2022/tests">
				<mx:Declarations>
					<mx:Int id="integer">
						<!-- comment -->
					</mx:Int>
				</mx:Declarations>
			</tests:TestClass1>
		');
		Assert.notNull(result);
		Assert.isOfType(result.integer, Int);
		Assert.equals(0, result.integer);
	}

	public function testIntNegative():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2022/basic" xmlns:tests="https://ns.mxhx.dev/2022/tests">
				<mx:Declarations>
					<mx:Int id="integer">-123</mx:Int>
				</mx:Declarations>
			</tests:TestClass1>
		');
		Assert.notNull(result);
		Assert.isOfType(result.integer, Int);
		Assert.equals(-123, result.integer);
	}

	public function testIntHexLowerCase():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2022/basic" xmlns:tests="https://ns.mxhx.dev/2022/tests">
				<mx:Declarations>
					<mx:Int id="integer">0xbeef</mx:Int>
				</mx:Declarations>
			</tests:TestClass1>
		');
		Assert.notNull(result);
		Assert.isOfType(result.integer, Int);
		Assert.equals(0xbeef, result.integer);
	}

	public function testIntHexUpperCase():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2022/basic" xmlns:tests="https://ns.mxhx.dev/2022/tests">
				<mx:Declarations>
					<mx:Int id="integer">0xBEEF</mx:Int>
				</mx:Declarations>
			</tests:TestClass1>
		');
		Assert.notNull(result);
		Assert.isOfType(result.integer, Int);
		Assert.equals(0xbeef, result.integer);
	}

	public function testIntHexNegative():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2022/basic" xmlns:tests="https://ns.mxhx.dev/2022/tests">
				<mx:Declarations>
					<mx:Int id="integer">-0xbeef</mx:Int>
				</mx:Declarations>
			</tests:TestClass1>
		');
		Assert.notNull(result);
		Assert.isOfType(result.integer, Int);
		Assert.equals(-0xbeef, result.integer);
	}

	public function testIntCData():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2022/basic" xmlns:tests="https://ns.mxhx.dev/2022/tests">
				<mx:Declarations>
					<mx:Int id="integer"><![CDATA[123]]></mx:Int>
				</mx:Declarations>
			</tests:TestClass1>
		');
		Assert.notNull(result);
		Assert.isOfType(result.integer, Int);
		Assert.equals(123, result.integer);
	}

	public function testString():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2022/basic" xmlns:tests="https://ns.mxhx.dev/2022/tests">
				<mx:Declarations>
					<mx:String id="string">hello</mx:String>
				</mx:Declarations>
			</tests:TestClass1>
		');
		Assert.notNull(result);
		Assert.isOfType(result.string, String);
		Assert.equals("hello", result.string);
	}

	public function testStringComment1():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2022/basic" xmlns:tests="https://ns.mxhx.dev/2022/tests">
				<mx:Declarations>
					<mx:String id="string">hello<!-- comment --></mx:String>
				</mx:Declarations>
			</tests:TestClass1>
		');
		Assert.notNull(result);
		Assert.isOfType(result.string, String);
		Assert.equals("hello", result.string);
	}

	public function testStringComment2():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2022/basic" xmlns:tests="https://ns.mxhx.dev/2022/tests">
				<mx:Declarations>
					<mx:String id="string"><!-- comment -->hello</mx:String>
				</mx:Declarations>
			</tests:TestClass1>
		');
		Assert.notNull(result);
		Assert.isOfType(result.string, String);
		Assert.equals("hello", result.string);
	}

	public function testStringComment3():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2022/basic" xmlns:tests="https://ns.mxhx.dev/2022/tests">
				<mx:Declarations>
					<mx:String id="string">hello<!-- comment -->world</mx:String>
				</mx:Declarations>
			</tests:TestClass1>
		');
		Assert.notNull(result);
		Assert.isOfType(result.string, String);
		Assert.equals("helloworld", result.string);
	}

	public function testStringEmpty1():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2022/basic" xmlns:tests="https://ns.mxhx.dev/2022/tests">
				<mx:Declarations>
					<mx:String id="string"></mx:String>
				</mx:Declarations>
			</tests:TestClass1>
		');
		Assert.notNull(result);
		// child of field element: empty string, child of declarations: null
		Assert.isNull(result.string);
	}

	public function testStringEmpty2():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2022/basic" xmlns:tests="https://ns.mxhx.dev/2022/tests">
				<mx:Declarations>
					<mx:String id="string"/>
				</mx:Declarations>
			</tests:TestClass1>
		');
		Assert.notNull(result);
		// child of field element: empty string, child of declarations: null
		Assert.isNull(result.string);
	}

	public function testStringEmptyExtraWhitespace():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2022/basic" xmlns:tests="https://ns.mxhx.dev/2022/tests">
				<mx:Declarations>
					<mx:String id="string">
					</mx:String>
				</mx:Declarations>
			</tests:TestClass1>
		');
		Assert.notNull(result);
		// child of field element: empty string, child of declarations: null
		Assert.isNull(result.string);
	}

	public function testStringCData():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2022/basic" xmlns:tests="https://ns.mxhx.dev/2022/tests">
				<mx:Declarations>
					<mx:String id="string"><![CDATA[MXHX & Haxe are <cool/>]]></mx:String>
				</mx:Declarations>
			</tests:TestClass1>
		');
		Assert.notNull(result);
		Assert.isOfType(result.string, String);
		Assert.equals("MXHX & Haxe are <cool/>", result.string);
	}

	public function testStringCDataEmpty():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2022/basic" xmlns:tests="https://ns.mxhx.dev/2022/tests">
				<mx:Declarations>
					<mx:String id="string"><![CDATA[]]></mx:String>
				</mx:Declarations>
			</tests:TestClass1>
		');
		Assert.notNull(result);
		// child of field element: empty string, child of declarations: null
		Assert.isNull(result.string);
	}

	public function testStringCDataEmptyExtraWhitespace():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2022/basic" xmlns:tests="https://ns.mxhx.dev/2022/tests">
				<mx:Declarations>
					<mx:String id="string"><![CDATA[ ]]></mx:String>
				</mx:Declarations>
			</tests:TestClass1>
		');
		Assert.notNull(result);
		Assert.isOfType(result.string, String);
		Assert.equals(" ", result.string);
	}

	public function testUInt():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2022/basic" xmlns:tests="https://ns.mxhx.dev/2022/tests">
				<mx:Declarations>
					<mx:UInt id="uint">4000000000</mx:UInt>
				</mx:Declarations>
			</tests:TestClass1>
		');
		Assert.notNull(result);
		Assert.isOfType(result.uint, Int);
		var expected:UInt = Std.int(4000000000);
		Assert.equals(expected, result.uint);
	}

	public function testUIntExtraWhitespace():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2022/basic" xmlns:tests="https://ns.mxhx.dev/2022/tests">
				<mx:Declarations>
					<mx:UInt id="uint">
						4000000000
					</mx:UInt>
				</mx:Declarations>
			</tests:TestClass1>
		');
		Assert.notNull(result);
		Assert.isOfType(result.uint, Int);
		var expected:UInt = Std.int(4000000000);
		Assert.equals(expected, result.uint);
	}

	public function testUIntComment1():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2022/basic" xmlns:tests="https://ns.mxhx.dev/2022/tests">
				<mx:Declarations>
					<mx:UInt id="uint">4000000000<!-- comment --></mx:UInt>
				</mx:Declarations>
			</tests:TestClass1>
		');
		Assert.notNull(result);
		Assert.isOfType(result.uint, Int);
		var expected:UInt = Std.int(4000000000);
		Assert.equals(expected, result.uint);
	}

	public function testUIntComment2():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2022/basic" xmlns:tests="https://ns.mxhx.dev/2022/tests">
				<mx:Declarations>
					<mx:UInt id="uint"><!-- comment -->4000000000</mx:UInt>
				</mx:Declarations>
			</tests:TestClass1>
		');
		Assert.notNull(result);
		Assert.isOfType(result.uint, Int);
		var expected:UInt = Std.int(4000000000);
		Assert.equals(expected, result.uint);
	}

	public function testUIntComment3():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2022/basic" xmlns:tests="https://ns.mxhx.dev/2022/tests">
				<mx:Declarations>
					<mx:UInt id="uint">4000000<!-- comment -->000</mx:UInt>
				</mx:Declarations>
			</tests:TestClass1>
		');
		Assert.notNull(result);
		Assert.isOfType(result.uint, Int);
		var expected:UInt = Std.int(4000000000);
		Assert.equals(expected, result.uint);
	}

	public function testUIntEmpty():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2022/basic" xmlns:tests="https://ns.mxhx.dev/2022/tests">
				<mx:Declarations>
					<mx:UInt id="uint"></mx:UInt>
				</mx:Declarations>
			</tests:TestClass1>
		');
		Assert.notNull(result);
		Assert.isOfType(result.uint, Int);
		Assert.equals(0, result.uint);
	}

	public function testUIntEmptyExtraWhitespace():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2022/basic" xmlns:tests="https://ns.mxhx.dev/2022/tests">
				<mx:Declarations>
					<mx:UInt id="uint">
					</mx:UInt>
				</mx:Declarations>
			</tests:TestClass1>
		');
		Assert.notNull(result);
		Assert.isOfType(result.uint, Int);
		Assert.equals(0, result.uint);
	}

	public function testUIntEmptyOnlyComment1():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2022/basic" xmlns:tests="https://ns.mxhx.dev/2022/tests">
				<mx:Declarations>
					<mx:UInt id="uint"><!-- comment --></mx:UInt>
				</mx:Declarations>
			</tests:TestClass1>
		');
		Assert.notNull(result);
		Assert.isOfType(result.uint, Int);
		Assert.equals(0, result.uint);
	}

	public function testUIntEmptyOnlyComment2():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2022/basic" xmlns:tests="https://ns.mxhx.dev/2022/tests">
				<mx:Declarations>
					<mx:UInt id="uint">
						<!-- comment -->
					</mx:UInt>
				</mx:Declarations>
			</tests:TestClass1>
		');
		Assert.notNull(result);
		Assert.isOfType(result.uint, Int);
		Assert.equals(0, result.uint);
	}

	public function testUIntHexLowerCase():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2022/basic" xmlns:tests="https://ns.mxhx.dev/2022/tests">
				<mx:Declarations>
					<mx:UInt id="uint">0xee6b2800</mx:UInt>
				</mx:Declarations>
			</tests:TestClass1>
		');
		Assert.notNull(result);
		Assert.isOfType(result.uint, Int);
		var expected:UInt = Std.int(4000000000);
		Assert.equals(expected, result.uint);
	}

	public function testUIntHexUpperCase():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2022/basic" xmlns:tests="https://ns.mxhx.dev/2022/tests">
				<mx:Declarations>
					<mx:UInt id="uint">0xEE6B2800</mx:UInt>
				</mx:Declarations>
			</tests:TestClass1>
		');
		Assert.notNull(result);
		Assert.isOfType(result.uint, Int);
		var expected:UInt = Std.int(4000000000);
		Assert.equals(expected, result.uint);
	}

	public function testUIntCData():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2022/basic" xmlns:tests="https://ns.mxhx.dev/2022/tests">
				<mx:Declarations>
					<mx:UInt id="uint"><![CDATA[4000000000]]></mx:UInt>
				</mx:Declarations>
			</tests:TestClass1>
		');
		Assert.notNull(result);
		Assert.isOfType(result.uint, Int);
		var expected:UInt = Std.int(4000000000);
		Assert.equals(expected, result.uint);
	}

	public function testArray():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2022/basic" xmlns:tests="https://ns.mxhx.dev/2022/tests">
				<mx:Declarations>
					<mx:Array id="array">
						<mx:String>one</mx:String>
						<mx:String>two</mx:String>
						<mx:String>three</mx:String>
					</mx:Array>
				</mx:Declarations>
			</tests:TestClass1>
		');
		Assert.notNull(result);
		Assert.notNull(result.array);
		Assert.isOfType(result.array, Array);
		Assert.equals(3, result.array.length);
		Assert.equals("one", result.array[0]);
		Assert.equals("two", result.array[1]);
		Assert.equals("three", result.array[2]);
	}

	public function testArrayType():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2022/basic" xmlns:tests="https://ns.mxhx.dev/2022/tests">
				<mx:Declarations>
					<mx:Array id="array" type="String">
						<mx:String>one</mx:String>
						<mx:String>two</mx:String>
						<mx:String>three</mx:String>
					</mx:Array>
				</mx:Declarations>
			</tests:TestClass1>
		');
		Assert.notNull(result);
		Assert.notNull(result.array);
		Assert.isOfType(result.array, Array);
		Assert.equals(3, result.array.length);
		Assert.equals("one", result.array[0]);
		Assert.equals("two", result.array[1]);
		Assert.equals("three", result.array[2]);
	}

	public function testArrayComment1():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2022/basic" xmlns:tests="https://ns.mxhx.dev/2022/tests">
				<mx:Declarations>
					<mx:Array id="array">
						<mx:String>one</mx:String>
						<mx:String>two</mx:String>
						<mx:String>three</mx:String>
						<!-- comment -->
					</mx:Array>
				</mx:Declarations>
			</tests:TestClass1>
		');
		Assert.notNull(result);
		Assert.notNull(result.array);
		Assert.isOfType(result.array, Array);
		Assert.equals(3, result.array.length);
		Assert.equals("one", result.array[0]);
		Assert.equals("two", result.array[1]);
		Assert.equals("three", result.array[2]);
	}

	public function testArrayComment2():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2022/basic" xmlns:tests="https://ns.mxhx.dev/2022/tests">
				<mx:Declarations>
					<mx:Array id="array">
						<!-- comment -->
						<mx:String>one</mx:String>
						<mx:String>two</mx:String>
						<mx:String>three</mx:String>
					</mx:Array>
				</mx:Declarations>
			</tests:TestClass1>
		');
		Assert.notNull(result);
		Assert.notNull(result.array);
		Assert.isOfType(result.array, Array);
		Assert.equals(3, result.array.length);
		Assert.equals("one", result.array[0]);
		Assert.equals("two", result.array[1]);
		Assert.equals("three", result.array[2]);
	}

	public function testArrayComment3():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2022/basic" xmlns:tests="https://ns.mxhx.dev/2022/tests">
				<mx:Declarations>
					<mx:Array id="array">
						<mx:String>one</mx:String>
						<mx:String>two</mx:String>
						<!-- comment -->
						<mx:String>three</mx:String>
					</mx:Array>
				</mx:Declarations>
			</tests:TestClass1>
		');
		Assert.notNull(result);
		Assert.notNull(result.array);
		Assert.isOfType(result.array, Array);
		Assert.equals(3, result.array.length);
		Assert.equals("one", result.array[0]);
		Assert.equals("two", result.array[1]);
		Assert.equals("three", result.array[2]);
	}

	public function testArrayEmpty():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2022/basic" xmlns:tests="https://ns.mxhx.dev/2022/tests">
				<mx:Declarations>
					<mx:Array id="array"></mx:Array>
				</mx:Declarations>
			</tests:TestClass1>
		');
		Assert.notNull(result);
		Assert.notNull(result.array);
		Assert.isOfType(result.array, Array);
		Assert.equals(0, result.array.length);
	}

	public function testArrayEmptyExtraWhitespace():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2022/basic" xmlns:tests="https://ns.mxhx.dev/2022/tests">
				<mx:Declarations>
					<mx:Array id="array">
					</mx:Array>
				</mx:Declarations>
			</tests:TestClass1>
		');
		Assert.notNull(result);
		Assert.notNull(result.array);
		Assert.isOfType(result.array, Array);
		Assert.equals(0, result.array.length);
	}

	public function testArrayOnlyComment1():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2022/basic" xmlns:tests="https://ns.mxhx.dev/2022/tests">
				<mx:Declarations>
					<mx:Array id="array"><!-- comment --></mx:Array>
				</mx:Declarations>
			</tests:TestClass1>
		');
		Assert.notNull(result);
		Assert.notNull(result.array);
		Assert.isOfType(result.array, Array);
		Assert.equals(0, result.array.length);
	}

	public function testArrayOnlyComment2():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2022/basic" xmlns:tests="https://ns.mxhx.dev/2022/tests">
				<mx:Declarations>
					<mx:Array id="array">
						<!-- comment -->
					</mx:Array>
				</mx:Declarations>
			</tests:TestClass1>
		');
		Assert.notNull(result);
		Assert.notNull(result.array);
		Assert.isOfType(result.array, Array);
		Assert.equals(0, result.array.length);
	}

	public function testArrayStrictUnify():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2022/basic" xmlns:tests="https://ns.mxhx.dev/2022/tests">
				<mx:Declarations>
					<mx:Array id="array">
						<tests:TestPropertiesSubclass1/>
						<tests:TestPropertiesSubclass2/>
					</mx:Array>
				</mx:Declarations>
			</tests:TestClass1>
		');
		Assert.notNull(result);
		Assert.notNull(result.array);
		Assert.isOfType(result.array, Array);
		Assert.equals(2, result.array.length);
	}

	public function testArrayEmptyStrings():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2022/basic" xmlns:tests="https://ns.mxhx.dev/2022/tests">
				<mx:Declarations>
					<mx:Array id="array">
						<mx:String></mx:String>
						<mx:String/>
						<mx:String>
						</mx:String>
						<mx:String><![CDATA[]]></mx:String>
						<mx:String><![CDATA[ ]]></mx:String>
					</mx:Array>
				</mx:Declarations>
			</tests:TestClass1>
		');
		Assert.notNull(result);
		Assert.notNull(result.array);
		Assert.isOfType(result.array, Array);
		Assert.equals(5, result.array.length);
		// child of most elements: empty string, child of declarations: null
		Assert.equals("", result.array[0]);
		Assert.equals("", result.array[1]);
		Assert.equals("", result.array[2]);
		Assert.equals("", result.array[3]);
		Assert.equals(" ", result.array[4]);
	}

	public function testXmlEmpty():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2022/basic" xmlns:tests="https://ns.mxhx.dev/2022/tests">
				<mx:Declarations>
					<mx:Xml id="xml"></mx:Xml>
				</mx:Declarations>
			</tests:TestClass1>
		');
		Assert.notNull(result);
		Assert.isOfType(result.xml, Xml);
		var xml:Xml = result.xml;
		Assert.equals(XmlType.Document, xml.nodeType);
		var firstChild:Xml = xml.firstChild();
		Assert.notNull(firstChild);
		Assert.equals(XmlType.PCData, firstChild.nodeType);
		Assert.equals("", firstChild.nodeValue);
		Assert.isNull(xml.firstElement());
	}

	public function testXmlElement():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2022/basic" xmlns:tests="https://ns.mxhx.dev/2022/tests">
				<mx:Declarations>
					<mx:Xml id="xml"><element/></mx:Xml>
				</mx:Declarations>
			</tests:TestClass1>
		');
		Assert.notNull(result);
		Assert.isOfType(result.xml, Xml);
		var xml:Xml = result.xml;
		Assert.equals(XmlType.Document, xml.nodeType);
		var firstElement:Xml = xml.firstChild();
		Assert.notNull(firstElement);
		Assert.equals(XmlType.Element, firstElement.nodeType);
		Assert.equals("element", firstElement.nodeName);
		Assert.isFalse(firstElement.attributes().hasNext());
		Assert.isFalse(firstElement.elements().hasNext());
		Assert.isNull(firstElement.firstChild());
		Assert.isNull(firstElement.firstElement());
	}

	public function testXmlElementWithAttribute():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2022/basic" xmlns:tests="https://ns.mxhx.dev/2022/tests">
				<mx:Declarations>
					<mx:Xml id="xml"><element attr="value"/></mx:Xml>
				</mx:Declarations>
			</tests:TestClass1>
		');
		Assert.notNull(result);
		Assert.isOfType(result.xml, Xml);
		var xml:Xml = result.xml;
		Assert.equals(XmlType.Document, xml.nodeType);
		var firstElement:Xml = xml.firstChild();
		Assert.notNull(firstElement);
		Assert.equals(XmlType.Element, firstElement.nodeType);
		Assert.equals("element", firstElement.nodeName);
		var attributes = firstElement.attributes();
		Assert.isTrue(attributes.hasNext());
		attributes.next();
		Assert.isFalse(attributes.hasNext());
		Assert.isTrue(firstElement.exists("attr"));
		Assert.equals("value", firstElement.get("attr"));
		Assert.isFalse(firstElement.elements().hasNext());
		Assert.isNull(firstElement.firstChild());
		Assert.isNull(firstElement.firstElement());
	}

	public function testXmlElementWithMultipleAttributes():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2022/basic" xmlns:tests="https://ns.mxhx.dev/2022/tests">
				<mx:Declarations>
					<mx:Xml id="xml"><element attr1="value1" attr2="value2"/></mx:Xml>
				</mx:Declarations>
			</tests:TestClass1>
		');
		Assert.notNull(result);
		Assert.isOfType(result.xml, Xml);
		var xml:Xml = result.xml;
		Assert.equals(XmlType.Document, xml.nodeType);
		var firstElement:Xml = xml.firstChild();
		Assert.notNull(firstElement);
		Assert.equals(XmlType.Element, firstElement.nodeType);
		Assert.equals("element", firstElement.nodeName);
		var attributes = firstElement.attributes();
		Assert.isTrue(attributes.hasNext());
		attributes.next();
		Assert.isTrue(attributes.hasNext());
		attributes.next();
		Assert.isFalse(attributes.hasNext());
		Assert.isTrue(firstElement.exists("attr1"));
		Assert.equals("value1", firstElement.get("attr1"));
		Assert.isTrue(firstElement.exists("attr2"));
		Assert.equals("value2", firstElement.get("attr2"));
		Assert.isFalse(firstElement.elements().hasNext());
		Assert.isNull(firstElement.firstChild());
		Assert.isNull(firstElement.firstElement());
	}

	public function testXmlOpenCloseElement():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2022/basic" xmlns:tests="https://ns.mxhx.dev/2022/tests">
				<mx:Declarations>
					<mx:Xml id="xml"><element></element></mx:Xml>
				</mx:Declarations>
			</tests:TestClass1>
		');
		Assert.notNull(result);
		Assert.isOfType(result.xml, Xml);
		var xml:Xml = result.xml;
		Assert.equals(XmlType.Document, xml.nodeType);
		var firstElement:Xml = xml.firstChild();
		Assert.notNull(firstElement);
		Assert.equals(XmlType.Element, firstElement.nodeType);
		Assert.equals("element", firstElement.nodeName);
		Assert.isFalse(firstElement.attributes().hasNext());
		Assert.isFalse(firstElement.elements().hasNext());
		Assert.isNull(firstElement.firstChild());
		Assert.isNull(firstElement.firstElement());
	}

	public function testXmlElementChild():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2022/basic" xmlns:tests="https://ns.mxhx.dev/2022/tests">
				<mx:Declarations>
					<mx:Xml id="xml"><element><child/></element></mx:Xml>
				</mx:Declarations>
			</tests:TestClass1>
		');
		Assert.notNull(result);
		Assert.isOfType(result.xml, Xml);
		var xml:Xml = result.xml;
		Assert.equals(XmlType.Document, xml.nodeType);
		var firstElement:Xml = xml.firstChild();
		Assert.notNull(firstElement);
		Assert.equals(XmlType.Element, firstElement.nodeType);
		Assert.equals("element", firstElement.nodeName);
		Assert.isFalse(firstElement.attributes().hasNext());
		var elements = firstElement.elements();
		Assert.isTrue(elements.hasNext());
		elements.next();
		Assert.isFalse(elements.hasNext());
		var firstChild = firstElement.firstChild();
		Assert.notNull(firstChild);
		var firstChildElement = firstElement.firstElement();
		Assert.notNull(firstChildElement);
		Assert.equals(XmlType.Element, firstChildElement.nodeType);
		Assert.equals("child", firstChildElement.nodeName);
	}

	public function testXmlElementMultipleChildren():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2022/basic" xmlns:tests="https://ns.mxhx.dev/2022/tests">
				<mx:Declarations>
					<mx:Xml id="xml"><element><child1/><child2></child2></element></mx:Xml>
				</mx:Declarations>
			</tests:TestClass1>
		');
		Assert.notNull(result);
		Assert.isOfType(result.xml, Xml);
		var xml:Xml = result.xml;
		Assert.equals(XmlType.Document, xml.nodeType);
		var firstElement:Xml = xml.firstChild();
		Assert.notNull(firstElement);
		Assert.equals(XmlType.Element, firstElement.nodeType);
		Assert.equals("element", firstElement.nodeName);
		Assert.isFalse(firstElement.attributes().hasNext());
		var elements = firstElement.elements();
		Assert.isTrue(elements.hasNext());
		var firstChildElement = elements.next();
		Assert.isTrue(elements.hasNext());
		var secondChildElement = elements.next();
		Assert.isFalse(elements.hasNext());
		Assert.notNull(firstElement.firstChild());
		Assert.notNull(firstElement.firstElement());

		Assert.notNull(firstChildElement);
		Assert.equals(XmlType.Element, firstChildElement.nodeType);
		Assert.equals("child1", firstChildElement.nodeName);

		Assert.notNull(secondChildElement);
		Assert.equals(XmlType.Element, secondChildElement.nodeType);
		Assert.equals("child2", secondChildElement.nodeName);
	}

	public function testXmlChildElementComplex():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2022/basic" xmlns:tests="https://ns.mxhx.dev/2022/tests">
				<mx:Declarations>
					<mx:Xml id="xml"><element><child1><gchild/></child1><child2/></element></mx:Xml>
				</mx:Declarations>
			</tests:TestClass1>
		');
		Assert.notNull(result);
		Assert.isOfType(result.xml, Xml);
		var xml:Xml = result.xml;
		Assert.equals(XmlType.Document, xml.nodeType);
		var firstElement:Xml = xml.firstChild();
		Assert.notNull(firstElement);
		Assert.equals(XmlType.Element, firstElement.nodeType);
		Assert.equals("element", firstElement.nodeName);
		Assert.isFalse(firstElement.attributes().hasNext());

		var elements = firstElement.elements();
		Assert.isTrue(elements.hasNext());
		var firstChildElement = elements.next();
		Assert.isTrue(elements.hasNext());
		var secondChildElement = elements.next();
		Assert.isFalse(elements.hasNext());
		Assert.notNull(firstElement.firstChild());
		Assert.notNull(firstElement.firstElement());

		Assert.notNull(firstChildElement);
		Assert.equals(XmlType.Element, firstChildElement.nodeType);
		Assert.equals("child1", firstChildElement.nodeName);

		Assert.notNull(secondChildElement);
		Assert.equals(XmlType.Element, secondChildElement.nodeType);
		Assert.equals("child2", secondChildElement.nodeName);

		var gchild = firstChildElement.firstElement();
		Assert.notNull(gchild);
		Assert.equals(XmlType.Element, gchild.nodeType);
		Assert.equals("gchild", gchild.nodeName);
	}

	public function testXmlText():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2022/basic" xmlns:tests="https://ns.mxhx.dev/2022/tests">
				<mx:Declarations>
					<mx:Xml id="xml">this is text</mx:Xml>
				</mx:Declarations>
			</tests:TestClass1>
		');
		Assert.notNull(result);
		Assert.isOfType(result.xml, Xml);
		var xml:Xml = result.xml;
		Assert.equals(XmlType.Document, xml.nodeType);
		var firstChild:Xml = xml.firstChild();
		Assert.notNull(firstChild);
		Assert.equals(XmlType.PCData, firstChild.nodeType);
		Assert.equals("this is text", firstChild.nodeValue);
		Assert.isNull(xml.firstElement());
	}

	public function testXmlTextChild():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2022/basic" xmlns:tests="https://ns.mxhx.dev/2022/tests">
				<mx:Declarations>
					<mx:Xml id="xml"><element>this is text</element></mx:Xml>
				</mx:Declarations>
			</tests:TestClass1>
		');
		Assert.notNull(result);
		Assert.isOfType(result.xml, Xml);
		var xml:Xml = result.xml;
		Assert.equals(XmlType.Document, xml.nodeType);
		var firstElement:Xml = xml.firstChild();
		Assert.notNull(firstElement);
		Assert.equals(XmlType.Element, firstElement.nodeType);
		Assert.equals("element", firstElement.nodeName);
		Assert.isFalse(firstElement.attributes().hasNext());
		Assert.isFalse(firstElement.elements().hasNext());
		var children = firstElement.iterator();
		Assert.isTrue(children.hasNext());
		var firstChild = children.next();
		Assert.isFalse(children.hasNext());
		Assert.notNull(firstChild);
		Assert.equals(XmlType.PCData, firstChild.nodeType);
		Assert.equals("this is text", firstChild.nodeValue);
	}

	public function testXmlCData():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2022/basic" xmlns:tests="https://ns.mxhx.dev/2022/tests">
				<mx:Declarations>
					<mx:Xml id="xml"><![CDATA[this is cdata]]></mx:Xml>
				</mx:Declarations>
			</tests:TestClass1>
		');
		Assert.notNull(result);
		Assert.isOfType(result.xml, Xml);
		var xml:Xml = result.xml;
		Assert.equals(XmlType.Document, xml.nodeType);
		var firstChild:Xml = xml.firstChild();
		Assert.notNull(firstChild);
		Assert.equals(XmlType.CData, firstChild.nodeType);
		Assert.equals("this is cdata", firstChild.nodeValue);
		Assert.isNull(xml.firstElement());
	}

	public function testXmlCDataChild():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2022/basic" xmlns:tests="https://ns.mxhx.dev/2022/tests">
				<mx:Declarations>
					<mx:Xml id="xml"><element><![CDATA[this is cdata]]></element></mx:Xml>
				</mx:Declarations>
			</tests:TestClass1>
		');
		Assert.notNull(result);
		Assert.isOfType(result.xml, Xml);
		var xml:Xml = result.xml;
		Assert.equals(XmlType.Document, xml.nodeType);
		var firstElement:Xml = xml.firstChild();
		Assert.notNull(firstElement);
		Assert.equals(XmlType.Element, firstElement.nodeType);
		Assert.equals("element", firstElement.nodeName);
		Assert.isFalse(firstElement.attributes().hasNext());
		Assert.isFalse(firstElement.elements().hasNext());
		var children = firstElement.iterator();
		Assert.isTrue(children.hasNext());
		var firstChild = children.next();
		Assert.isFalse(children.hasNext());
		Assert.notNull(firstChild);
		Assert.equals(XmlType.CData, firstChild.nodeType);
		Assert.equals("this is cdata", firstChild.nodeValue);
	}

	public function testXmlComment():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2022/basic" xmlns:tests="https://ns.mxhx.dev/2022/tests">
				<mx:Declarations>
					<mx:Xml id="xml"><!-- comment --></mx:Xml>
				</mx:Declarations>
			</tests:TestClass1>
		');
		Assert.notNull(result);
		Assert.isOfType(result.xml, Xml);
		var xml:Xml = result.xml;
		Assert.equals(XmlType.Document, xml.nodeType);
		var firstChild:Xml = xml.firstChild();
		Assert.notNull(firstChild);
		Assert.equals(XmlType.Comment, firstChild.nodeType);
		Assert.equals(" comment ", firstChild.nodeValue);
		Assert.isNull(xml.firstElement());
	}

	public function testXmlCommentChild():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2022/basic" xmlns:tests="https://ns.mxhx.dev/2022/tests">
				<mx:Declarations>
					<mx:Xml id="xml"><element><!-- comment --></element></mx:Xml>
				</mx:Declarations>
			</tests:TestClass1>
		');
		Assert.notNull(result);
		Assert.isOfType(result.xml, Xml);
		var xml:Xml = result.xml;
		Assert.equals(XmlType.Document, xml.nodeType);
		var firstElement:Xml = xml.firstChild();
		Assert.notNull(firstElement);
		Assert.equals(XmlType.Element, firstElement.nodeType);
		Assert.equals("element", firstElement.nodeName);
		Assert.isFalse(firstElement.attributes().hasNext());
		Assert.isFalse(firstElement.elements().hasNext());
		var children = firstElement.iterator();
		Assert.isTrue(children.hasNext());
		var firstChild = children.next();
		Assert.isFalse(children.hasNext());
		Assert.notNull(firstChild);
		Assert.equals(XmlType.Comment, firstChild.nodeType);
		Assert.equals(" comment ", firstChild.nodeValue);
	}

	public function testComplexEnumValueWithoutParameters():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2022/basic" xmlns:tests="https://ns.mxhx.dev/2022/tests">
				<mx:Declarations>
					<tests:TestComplexEnum id="enumValue">
						<tests:TestComplexEnum.One/>
					</tests:TestComplexEnum>
				</mx:Declarations>
			</tests:TestClass1>
		');
		Assert.notNull(result);
		Assert.equals(TestComplexEnum.One, result.enumValue);
	}

	public function testComplexEnumValueWithParameters():Void {
		var result = MXHXComponent.withMarkup('
			<tests:TestClass1 xmlns:mx="https://ns.mxhx.dev/2022/basic" xmlns:tests="https://ns.mxhx.dev/2022/tests">
				<mx:Declarations>
					<tests:TestComplexEnum id="enumValue">
						<tests:TestComplexEnum.Two a="hello" b="123.4"/>
					</tests:TestComplexEnum>
				</mx:Declarations>
			</tests:TestClass1>
		');
		Assert.notNull(result);
		switch (result.enumValue) {
			case TestComplexEnum.Two("hello", 123.4):
				Assert.pass();
			default:
				Assert.fail("Wrong enum value: " + result.enumValue);
		}
	}
}
