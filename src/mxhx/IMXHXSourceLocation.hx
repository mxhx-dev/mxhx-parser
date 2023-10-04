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

package mxhx;

/**
	This interface provides information about where something (a token, a tag,
	an attribute, text, etc.) appears in [MXHX](https://mxhx.dev) source code.
**/
interface IMXHXSourceLocation {
	/**
		Gets the zero-based absolute starting offset.
	**/
	var start(default, never):Int;

	/**
		Gets the zero-based absolute ending offset.
	**/
	var end(default, never):Int;

	/**
		Gets the source file path.
	**/
	var source(default, never):String;

	/**
		Gets the zero-based starting line number.
	**/
	var line(default, never):Int;

	/**
		Gets the zero-based ending line number.
	**/
	var endLine(default, never):Int;

	/**
		Gets the zero-based starting column number.
	**/
	var column(default, never):Int;

	/**
		Gets the zero-based ending column number.
	**/
	var endColumn(default, never):Int;
}
