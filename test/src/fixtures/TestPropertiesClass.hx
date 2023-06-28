package fixtures;

@:event("change")
class TestPropertiesClass {
	public function new() {}

	public var any:Any;
	public var boolean:Bool;
	public var ereg:EReg;
	public var float:Float;
	public var integer:Int;
	public var string:String;
	public var unsignedInteger:UInt;
	public var enumValue:TestPropertyEnum;
	public var strict:TestPropertiesClass;
	public var array:Array<String>;
	public var type:Class<Dynamic>;
	public var complexEnum:TestComplexEnum;
}
