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

import mxhx.parser.MXHXParserProblem;

/**
	Represents the syntax, but not the semantics, of an [MXHX](https://mxhx.dev)
	file.

	The file is represented as a sequence of "units", one for each open tag,
	close tag, and block of text.

	No meaning is assigned to any tag, attribute, or text.
**/
interface IMXHXData {
	/**
		Gets the path to the file on disk that created this `IMXHXData`.
	**/
	var source(default, never):String;

	/**
		Get all of the MXHX units found in this `IMXHXData`.
	**/
	var units(default, never):Array<IMXHXUnitData>;

	/**
		Gets the root tag of this `IMXHXData`. Returns `null` if there is no
		root tag.
	**/
	var rootTag(get, never):IMXHXTagData;

	/**
		Gets the parser problems found during the creation of this `IMXHXData`.
	**/
	var problems(default, never):Array<MXHXParserProblem>;

	/**
		Gets an MXHX unit by index. Returns `null` if the index is out of range.
	**/
	function unitAt(index:Int):IMXHXUnitData;

	/**
		Returns the `PrefixMap` for the given `IMXHXTagData`. This method will
		not walk up the chain of prefix maps if this tag does not physically
		have uri->namespace mappings.
	**/
	function getPrefixMapForTag(tagData:IMXHXTagData):PrefixMap;

	/**
		Similar to `findTagContainingOffset()`, but if the unit inside offset is a
		text node, will return the surrounding tag instead.
	**/
	function findTagOrSurroundingTagContainingOffset(offset:Int):IMXHXTagData;
}
