import mxhx.parser.MXHXParser;

class Main {
	public static function main():Void {
		var parser = new MXHXParser("", "file.mxhx");
		var mxhxData = parser.parse();
	}
}
