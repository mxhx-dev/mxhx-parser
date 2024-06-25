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
	Represents one unit of [MXHX](https://mxhx.dev).
**/
interface IMXHXUnitData extends IMXHXSourceLocation {
	/**
		Gets the `IMXHXData` object representing the MXHX document that contains
		this unit.
	**/
	var parent(default, never):IMXHXData;

	/**
		Gets the `IMXHXUnitData` which is the hierarchical parent of this unit.
	**/
	var parentUnit(get, never):IMXHXUnitData;

	/**
		Get this unit's position in the `IMXHXData`.
	**/
	var index(default, never):Int;

	/**
		Returns the first character of the actual content of the unit For most
		units this is the same as `start`, but for things like tags which have
		"junk punctuation" around them, `start` will return the junk
		punctuation, whereas `contentStart` will get the content inside the
		punctuation.
	**/
	var contentStart(get, never):Int;

	/**
		Returns the offset after the last character of actual content. See
		`contentStart` for more details.
	**/
	var contentEnd(get, never):Int;

	/**
		Gets the previous MXHX unit in the parent `IMXHXData`. Returns `null` if
		there is no next unit.
	**/
	function getPrevious():IMXHXUnitData;

	/**
		Gets the next MXHX unit in the parent `IMXHXData`. Returns `null` if
		there is no next unit.
	**/
	function getNext():IMXHXUnitData;

	/**
		Gets the next sibling unit after this unit. The next sibling unit may be
		a tag or text. If there is no sibling unit after this one, this method
		returns `null`.
	**/
	function getNextSiblingUnit():IMXHXUnitData;

	/**
		Gets the next tag after this unit. If there is no tag after this unit,
		this method returns `null`.
	**/
	function getNextTag():IMXHXTagData;

	/**
		Determines if this unit contains the given offset. This operation
		excludes the `start` value and includes the `end` value.
	**/
	function containsOffset(offset:Int):Bool;

	/**
		Get the nearest containing tag. Moving backwards through the list of
		tokens for this MXHX file, this is the first open tag that is found
		where a corresponding close has not also been found.
	**/
	function getContainingTag(offset:Int):IMXHXTagData;

	/**
		Creates a copy of the unit data.
	**/
	function clone():IMXHXUnitData;
}
