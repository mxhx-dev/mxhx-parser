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

package mxhx.internal;

/**
	Represents a source location in [MXHX](https://mxhx.dev).
**/
class MXHXSourceLocation implements IMXHXSourceLocation {
	public function new(?source:String, start:Int = -1, end:Int = -1) {
		this.source = source;
		this.start = start;
		this.end = end;
	}

	/**
		@see `mxhx.IMXHXSourceLocation.source`
	**/
	public var source(default, default):String;

	/**
		@see `mxhx.IMXHXSourceLocation.start`
	**/
	public var start(default, default):Int;

	/**
		@see `mxhx.IMXHXSourceLocation.end`
	**/
	public var end(default, default):Int;

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

	@:dox(hide)
	public function toString():String {
		return 'loc: ${start != -1 ? Std.string(start) : "?"}-${end != -1 ? Std.string(end) : "?"} ${source != null ? source : "?"}';
	}
}
