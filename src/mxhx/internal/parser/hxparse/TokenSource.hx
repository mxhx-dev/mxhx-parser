package mxhx.internal.parser.hxparse;

/**
	Defines the structure of a type usable as input for a `Parser`.
**/
@:dox(hide)
typedef TokenSource<Token> = {
	/**
		Returns the next token
	**/
	function token():Token;

	/**
		Returns the current `Position` of `this` TokenSource.
	**/
	function curPos():Position;
}
