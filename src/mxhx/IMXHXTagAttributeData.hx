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
	Represents an attribute of a tag in [MXHX](https://mxhx.dev).
**/
interface IMXHXTagAttributeData extends IMXHXTagContentData {
	/**
		Gets the complete name of this attribute, including optional prefix and
		optional state name suffix, such as `"s:width.over"`.
	**/
	var name(default, never):String;

	/**
		Gets the prefix of this attribute. If the attribute does not have a
		prefix, this method returns `null`.
	**/
	var prefix(default, never):String;

	/**
		Gets the short name of this attribute, not including the prefix or
		state name suffix.
	**/
	var shortName(default, never):String;

	/**
		Gets the state name for this attribute. If the attribute does not have a
		state name suffix, this method returns `null`.
	**/
	var stateName(default, never):String;

	/**
		Gets the URI of this attribute. If the attribute prefix is `null`, this
		method also returns `null`.
	**/
	var uri(get, never):String;

	/**
		Gets the value of this attribute as a string. The delimiting quotes are
		_not_ included.
	**/
	var rawValue(get, never):String;

	/**
		Returns `true` if this attribute has a value.
	**/
	var hasValue(default, never):Bool;

	/**
		Gets the starting offset of this attribute's value. If the attribute
		does not have a value, returns `-1`.
	**/
	var valueStart(get, never):Int;

	/**
		Gets the ending offset of this attribute's value. If the attribute
		does not have a value, returns `-1`.
	**/
	var valueEnd(get, never):Int;
}
