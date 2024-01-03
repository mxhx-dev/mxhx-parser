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
	Represents an open tag, a close tag, or an empty tag in
	[MXHX](https://mxhx.dev).
**/
interface IMXHXTagData extends IMXHXUnitData {
	/**
		Gets the complete name of this tag, including optional prefix and
		optional state name suffix, such as `"mx:Any"`.
	**/
	var name(default, never):String;

	/**
		Gets the prefix of this tag. If the tag does not have a prefix, this
		method returns `null`.
	**/
	var prefix(default, never):String;

	/**
		Gets the state name suffix for this tag. If the tag does not have a
		state name suffix, this method returns `null`.
	**/
	var stateName(default, never):String;

	/**
		Gets the short name of this tag, not including the prefix or state name
		suffix.
	**/
	var shortName(default, never):String;

	/**
		Gets the URI of this attribute. If the attribute prefix is `null`, this
		method also returns `null`.
	**/
	var uri(get, never):String;

	/**
		Gets the tag that contains this tag. If the document is not balanced
		before this tag, this method returns `null`.
	**/
	var parentTag(get, never):IMXHXTagData;

	/**
		Gets all of the content in this tag.
	**/
	var contentData(get, never):Array<IMXHXTagContentData>;

	/**
		Gets all of the attributes in this tag.
	**/
	var attributeData(get, never):Array<IMXHXTagAttributeData>;

	/**
		Gets the namespace mappings specified on this tag. Does not include
		the composite prefix mappings inherited from the parent tag, the root
		tag, or any other ancestor tags in between.

		@see `IMXHXTagData.compositePrefixMap`
	**/
	var prefixMap(get, never):PrefixMap;

	/**
		Gets the namespace mappings that apply to this tag, taking ancestor tags
		into account.

		@see `IMXHXTagData.prefixMap`
	**/
	var compositePrefixMap(get, never):PrefixMap;

	/**
		Determines whether this tag does not actually exist within the MXHX
		document that is its source, but may have been created as a post-process
		step of MXHX repair.
	**/
	function isImplicit():Bool;

	/**
		Determines whether this tag is an open tag, meaning that it starts with
		`<` (and not `</`, which would be a close tag).
	**/
	function isOpenTag():Bool;

	/**
		Determines whether this tag is a close tag, meaning that it starts with
		`</`.
	**/
	function isCloseTag():Bool;

	/**
		Determines whether this tag is empty, meaning that it ends with `/>`.
	**/
	function isEmptyTag():Bool;

	/**
		Determines whether this tag has an actual close token (`>` or `/>`),
		and was not closed as a post-process step of MXHX repair.
	**/
	function hasExplicitCloseToken():Bool;

	/**
	 * Determines whether the specified offset falls inside the attribute list
	 * of this tag.
	 */
	function isOffsetInAttributeList(offset:Int):Bool;

	/**
		Gets the attribute in this tag that has the specified name.
	**/
	function getAttributeData(name:String):IMXHXTagAttributeData;

	/**
		Gets the raw value for the specified attribute name, which does not
		include quotes.
	**/
	function getRawAttributeValue(name:String):String;

	/**
		Gets the first child unit inside this tag, which may be a tag or text.
		If there is no child unit, this method returns `null`.
	**/
	function getFirstChildUnit():IMXHXUnitData;

	/**
		Gets the first child open tag of this tag. Returns `null` if there is
		no first child tag.

		_First child_ means the first open (or maybe empty) tag found before a
		close tag. If this is a close tag, this method starts looking after the
		corresponding start tag.
	**/
	function getFirstChildTag(includeEmptyTags:Bool):IMXHXTagData;

	/**
		Gets the next sibling open tag of this tag. Returns `null` if there is
		no next sibling tag.

		_Sibling_ is defined as the first open (or maybe empty) tag after this
		tag's close tag. If this is a close tag, this method starts looking
		after the corresponding start tag.
	**/
	function getNextSiblingTag(includeEmptyTags:Bool):IMXHXTagData;

	/**
		Finds the open tag that matches this tag. Returns `null` if this tag is
		an open or empty tag.

		Returns `null` if a surrounding tag is unbalanced; this is determined by
		backing up to the innermost parent tag with a different tag.
	**/
	function findMatchingOpenTag():IMXHXTagData;

	/**
		Finds the close tag that matches this tag. Returns `null` if this tag is
		a close or empty tag.

		Returns `null` if a surrounding tag is unbalanced; this is determined by
		backing up to the innermost parent tag with a different tag.
	**/
	function findMatchingCloseTag():IMXHXTagData;
}
