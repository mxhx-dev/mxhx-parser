package mxhx.internal.parser.hxparse;

/**
	A NoMatch exception is thrown if an outer token matching fails.

	Matching can continue because no tokens have been consumed.
**/
@:dox(hide)
class NoMatch<T> extends ParserError {
	/**
		The token which was encountered and could not be matched.
	**/
	public var token(default, null):T;

	/**
		Creates a new NoMatch exception.
	**/
	public function new(pos:Position, token:T) {
		super(pos);
		this.token = token;
	}

	override public function toString() {
		return 'No match: $token';
	}
}
