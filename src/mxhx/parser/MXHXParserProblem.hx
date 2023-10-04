/*
	Licensed to the Apache Software Foundation (ASF) under one or more
	contributor license agreements.  See the NOTICE file distributed with
	this work for additional information regarding copyright ownership.
	The ASF licenses this file to You under the Apache License, Version 2.0
	(the "License"); you may not use this file except in compliance with
	the License.  You may obtain a copy of the License at

	http://www.apache.org/licenses/LICENSE-2.0

	Unless required by applicable law or agreed to in writing, software
	distributed under the License is distributed on an "AS IS" BASIS,
	WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
	See the License for the specific language governing permissions and
	limitations under the License.
 */

package mxhx.parser;

/**
	A problem, such as an error or warning, discovered while attempting to
	parse an [MXHX](https://mxhx.dev) document.
**/
class MXHXParserProblem implements IMXHXSourceLocation {
	/**
		@see `mxhx.IMXHXSourceLocation.source`
	**/
	public var source(default, null):String;

	/**
		@see `mxhx.IMXHXSourceLocation.start`
	**/
	public var start(default, null):Int;

	/**
		@see `mxhx.IMXHXSourceLocation.end`
	**/
	public var end(default, null):Int;

	/**
		@see `mxhx.IMXHXSourceLocation.line`
	**/
	public var line(default, default):Int;

	/**
		@see `mxhx.IMXHXSourceLocation.endLine`
	**/
	public var endLine(default, default):Int;

	/**
		@see `mxhx.IMXHXSourceLocation.column`
	**/
	public var column(default, default):Int;

	/**
		@see `mxhx.IMXHXSourceLocation.endColumn`
	**/
	public var endColumn(default, default):Int;

	/**
		A message describing the problem.
	**/
	public var message(default, null):String;

	/**
		A numeric code associated with the problem type.
	**/
	public var code(default, null):Null<Int>;

	/**
		The severity of a problem, indicating if it is an error or warning.
	**/
	public var severity(default, null):MXHXParserProblemSeverity;

	/**
		Creates a new `MXHXParserProblem` object with the given arguments.
	**/
	public function new(message:String, code:Null<Int>, severity:MXHXParserProblemSeverity, source:String, start:Int, end:Int, line:Int, column:Int,
			endLine:Int, endColumn:Int) {
		this.message = message;
		this.code = code;
		this.severity = severity;
		this.source = source;
		this.start = start;
		this.end = end;
		this.line = line;
		this.column = column;
		this.endLine = endLine;
		this.endColumn = endColumn;
	}
}
