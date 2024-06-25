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
	Represents a tag in [MXHX](https://mxhx.dev).
**/
class MXHXTagData extends MXHXUnitData implements IMXHXTagData {
	/**
		@see `mxhx.IMXHXTagData.name`
	**/
	public var name(default, set):String = null;

	private function set_name(value:String):String {
		if (name == value) {
			return name;
		}
		name = value;
		if (name != null) {
			var nameParts = name.split(":");
			if (nameParts.length > 1) {
				prefix = nameParts[0];
				shortName = nameParts[1];
			} else {
				prefix = "";
				shortName = nameParts[0];
			}
			var shortNameParts = shortName.split(".");
			if (shortNameParts.length > 1) {
				shortName = shortNameParts[0];
				stateName = shortNameParts[1];
			} else {
				stateName = null;
			}
		} else {
			shortName = null;
			prefix = null;
			stateName = null;
		}
		return name;
	}

	/**
		@see `mxhx.IMXHXTagData.prefix`
	**/
	public var prefix(default, null):String = null;

	/**
		@see `mxhx.IMXHXTagData.shortName`
	**/
	public var shortName(default, null):String = null;

	/**
		@see `mxhx.IMXHXTagData.stateName`
	**/
	public var stateName(default, null):String = null;

	/**
		@see `mxhx.IMXHXTagData.uri`
	**/
	@:isVar
	public var uri(get, null):String = null;

	private function get_uri():String {
		if (uri == null) {
			if (parent == null) {
				return null;
			}
			var lookingAt:IMXHXTagData = this;
			// walk up our chain to find the correct uri for our namespace
			// first one wins
			while (lookingAt != null) {
				var depth = parent.getPrefixMapForTag(lookingAt);
				if (depth != null && depth.containsPrefix(prefix)) {
					uri = depth.getUriForPrefix(prefix);
					break;
				}

				lookingAt = lookingAt.parentTag;
			}
		}
		return uri;
	}

	/**
		@see `mxhx.IMXHXTagData.parentTag`
	**/
	public var parentTag(get, never):IMXHXTagData;

	private function get_parentTag():IMXHXTagData {
		var parentUnit = this.parentUnit;
		if ((parentUnit is IMXHXTagData)) {
			return cast parentUnit;
		}
		return null;
	}

	private var attributeMap:Map<String, IMXHXTagAttributeData> = [];

	/**
		@see `mxhx.IMXHXTagData.attributeData`
	**/
	@:isVar
	public var attributeData(get, set):Array<IMXHXTagAttributeData> = [];

	private function get_attributeData():Array<IMXHXTagAttributeData> {
		return attributeData;
	}

	private function set_attributeData(value:Array<IMXHXTagAttributeData>):Array<IMXHXTagAttributeData> {
		contentData = value.map(function(item):IMXHXTagContentData {
			return item;
		});
		return attributeData;
	}

	/**
		@see `mxhx.IMXHXTagData.contentData`
	**/
	@:isVar
	public var contentData(get, set):Array<IMXHXTagContentData> = [];

	private function get_contentData():Array<IMXHXTagContentData> {
		return contentData;
	}

	private function set_contentData(value:Array<IMXHXTagContentData>):Array<IMXHXTagContentData> {
		contentData = value;
		@:bypassAccessor attributeData = value.filter(item -> (item is IMXHXTagAttributeData)).map(function(item):IMXHXTagAttributeData {
			return cast item;
		});
		attributeMap.clear();
		if (attributeData.length > 0) {
			minAttrStart = 0x7FFFFFFF;
			for (attribute in attributeData) {
				var attrStart = attribute.start;
				if (minAttrStart > attrStart) {
					minAttrStart = attrStart;
				}
				attributeMap.set(attribute.name, attribute);
			}
		} else {
			minAttrStart = -1;
		}
		return contentData;
	}

	/**
		@see `mxhx.IMXHXTagData.prefixMap`
	**/
	public var prefixMap(get, never):PrefixMap;

	private function get_prefixMap():PrefixMap {
		return parent.getPrefixMapForTag(this);
	}

	/**
		@see `mxhx.IMXHXTagData.compositePrefixMap`
	**/
	public var compositePrefixMap(get, never):PrefixMap;

	private function get_compositePrefixMap():PrefixMap {
		var compMap = new MutablePrefixMap();
		var lookingAt:IMXHXTagData = this;
		while (lookingAt != null) {
			var depth = parent.getPrefixMapForTag(lookingAt);
			if (depth != null) {
				compMap.addAll(depth, true);
			}
			lookingAt = lookingAt.parentTag;
		}
		return compMap;
	}

	override private function get_contentStart():Int {
		return start + (closeTag ? 2 : 1);
	}

	override private function get_contentEnd():Int {
		return end - (explicitCloseToken ? (emptyTag ? 2 : 1) : 0);
	}

	private var attributesStart(get, never):Int;

	private function get_attributesStart():Int {
		if (minAttrStart != -1) {
			return minAttrStart;
		}
		return contentStart + name.length;
	}

	private var minAttrStart:Int = -1;
	private var closeTag:Bool = false;
	private var emptyTag:Bool = false;
	private var explicitCloseToken:Bool = false;

	/**
		Creates a new `MXHXTagData` object with the given arguments.
	**/
	public function new() {
		super();
	}

	/**
		Copies data from another tag.
	**/
	public function copyFrom(other:MXHXTagData) {
		name = other.name;
		closeTag = other.closeTag;
		emptyTag = other.emptyTag;
		explicitCloseToken = other.explicitCloseToken;
		contentData = other.contentData.map(data -> {
			var cloned = (cast data.clone() : MXHXTagContentData);
			cloned.parentTag = this;
			return (cast cloned : IMXHXTagContentData);
		});
		setOffsets(other.start, other.end);
	}

	/**
		Initializes the tag from a start value.
	**/
	public function init(value:String):Void {
		emptyTag = false;
		closeTag = false;
		explicitCloseToken = false;
		if (StringTools.startsWith(value, "</")) {
			closeTag = true;
			name = value.substr(2);
		} else {
			name = value.substr(1);
		}
	}

	/**
		@see `mxhx.IMXHXTagData.isOpenTag()`
	**/
	public function isOpenTag():Bool {
		return !closeTag;
	}

	/**
		@see `mxhx.IMXHXTagData.isCloseTag()`
	**/
	public function isCloseTag():Bool {
		return closeTag;
	}

	/**
		@see `mxhx.IMXHXTagData.isEmptyTag()`
	**/
	public function isEmptyTag():Bool {
		return emptyTag;
	}

	/**
		Sets whether the tag is empty or not.
	**/
	public function setEmptyTag(value:Bool):Void {
		emptyTag = value;
	}

	/**
		@see `mxhx.IMXHXTagData.isImplicit()`
	**/
	public function isImplicit():Bool {
		return false;
	}

	/**
		@see `mxhx.IMXHXTagData.hasExplicitCloseToken()`
	**/
	public function hasExplicitCloseToken():Bool {
		return explicitCloseToken;
	}

	/**
		Sets whether the tag has an explicit close token or not.
	**/
	public function setExplicitCloseToken(value:Bool):Void {
		explicitCloseToken = value;
	}

	/**
		@see `mxhx.IMXHXTagData.isOffsetInAttributeList()`
	**/
	public function isOffsetInAttributeList(offset:Int):Bool {
		return MXHXData.contains(attributesStart, end, offset);
	}

	/**
		@see `mxhx.IMXHXTagData.getAttributeData()`
	**/
	public function getAttributeData(name:String):IMXHXTagAttributeData {
		if (name == null) {
			return null;
		}
		return attributeMap.get(name);
	}

	/**
		@see `mxhx.IMXHXTagData.getRawAttributeValue()`
	**/
	public function getRawAttributeValue(name:String):String {
		var attrData = getAttributeData(name);
		if (attrData == null) {
			return null;
		}
		return attrData.rawValue;
	}

	/**
		@see `mxhx.IMXHXTagData.findMatchingOpenTag()`
	**/
	public function findMatchingOpenTag():IMXHXTagData {
		return findMatchingOpenTagInternal(false);
	}

	/**
		@see `mxhx.IMXHXTagData.findMatchingCloseTag()`
	**/
	public function findMatchingCloseTag():IMXHXTagData {
		return findMatchingCloseTagInternal(false);
	}

	override public function getNextSiblingUnit():IMXHXUnitData {
		var unit:IMXHXUnitData = this;
		if (isOpenTag() && !isEmptyTag()) {
			unit = findMatchingCloseTag();
		}
		if (unit == null) {
			return null;
		}
		var nextUnit = unit.getNext();
		if (nextUnit == null) {
			return null;
		}
		if (nextUnit.parentUnit != parentUnit) {
			return null;
		}
		return nextUnit;
	}

	/**
		@see `mxhx.IMXHXTagData.getFirstChildUnit()`
	**/
	public function getFirstChildUnit():IMXHXUnitData {
		// If this tag is <foo/> then it has no child units.
		if (!isOpenTag() || isEmptyTag()) {
			return null;
		}

		var next = getNext();

		// If this tag is followed immediately by its end tag,
		// as in <foo></foo>, then it has no child units.
		if (next == findMatchingCloseTag()) {
			return null;
		}

		// Otherwise, the first child unit is the unit after the tag.
		return next;
	}

	/**
		@see `mxhx.IMXHXTagData.getFirstChildTag()`
	**/
	public function getFirstChildTag(includeEmptyTags:Bool):IMXHXTagData {
		var nextTag:IMXHXTagData = null;
		if (isEmptyTag()) {
			return null;
		}
		if (isOpenTag()) {
			nextTag = getNextTag();
		} else {
			// This is a close tag.  Start at the corresponding open tag.
			var openTag:IMXHXTagData = getContainingTag(start);
			nextTag = openTag.getNextTag();
		}
		// Skip any text blocks to find the next actual tag.  If it's an open tag,
		// that is our first child.  Otherwise it's a close tag, return null.
		while (true) {
			if (nextTag == null || nextTag.isCloseTag()) {
				return null;
			}
			if ((nextTag.isOpenTag() && !nextTag.isEmptyTag()) || (nextTag.isEmptyTag() && includeEmptyTags)) {
				return nextTag;
			}
			nextTag = nextTag.getNextTag();
		}
	}

	/**
		@see `mxhx.IMXHXTagData.getNextSiblingTag()`
	**/
	public function getNextSiblingTag(includeEmptyTags:Bool):IMXHXTagData {
		var nextTag:IMXHXTagData = null;
		// Be sure we're starting at the close tag, then get the next tag.
		if (isCloseTag() || isEmptyTag()) {
			nextTag = getNextTag();
		} else {
			var closeTag:IMXHXTagData = findMatchingCloseTag();
			if (closeTag == null) {
				return null;
			}
			nextTag = closeTag.getNextTag();
		}
		while (true) {
			if (nextTag == null || nextTag.isCloseTag()) {
				return null;
			}
			if ((nextTag.isOpenTag() && !nextTag.isEmptyTag()) || (nextTag.isEmptyTag() && includeEmptyTags)) {
				return nextTag;
			}
			nextTag = nextTag.getNextTag();
		}
	}

	override public function clone():MXHXTagData {
		var cloned = new MXHXTagData();
		cloned.setLocation(parent, index);
		cloned.parentUnitIndex = parentUnitIndex;
		cloned.copyFrom(this);
		return cloned;
	}

	override public function toString():String {
		return '<${closeTag ? "/" : ""}$name${emptyTag ? "/" : ""}> ${super.toString()}';
	}

	private function findMatchingOpenTagInternal(includeImplicit:Bool):IMXHXTagData {
		if (isOpenTag()) {
			return null;
		}
		// Back up to the first surrounding tag that has a different name, and ensure
		// that *it* is balanced, saving our expected return value along the way.
		var startTag:IMXHXTagData = this;
		while (true) {
			var parentTag = startTag.getContainingTag(startTag.start);
			if (parentTag == null) {
				break;
			}
			startTag = parentTag;
			startTag = startTag.findMatchingCloseTag();
			if (parentTag.name != name) {
				break;
			}
		}
		// Now walk through the tags starting at startTag.  Once we pop ourselves
		// off the tagStack, we've found our candidate result -- but keep going
		// until the stack is null, to ensure that we're balanced out to the
		// surrounding tag.
		var tagStack:Array<IMXHXTagData> = [];
		var result:IMXHXTagData = null;
		var i = startTag.index;
		while (i >= 0) {
			var unit = parent.unitAt(i);
			if ((unit is IMXHXTagData)) {
				var tag:IMXHXTagData = cast unit;
				if (tag.isEmptyTag()) {
					// skip
					i--;
					continue;
				} else if (tag.isCloseTag()) {
					tagStack.push(tag);
				} else if (tag.isOpenTag()) {
					if (tagStack.length == 0) {
						return null; // unbalanced
					}
					var popped = tagStack.pop();
					// check the short name in case the namespace is not spelled properly
					if (popped.name != tag.name && popped.shortName != tag.shortName) {
						return null; // unbalanced
					}
					if (popped == this) {
						// this is our result -- remember it.
						result = tag;
					}
					if (tagStack.length == 0) {
						if (result != null && result.isImplicit() && !includeImplicit) {
							return null;
						}
						return result;
					}
				}
			}
			i--;
		}
		return null;
	}

	private function findMatchingCloseTagInternal(includeImplicit:Bool):IMXHXTagData {
		if (isCloseTag() || isEmptyTag()) {
			return null;
		}
		// Back up to the first surrounding tag that has a different name, and ensure
		// that *it* is balanced, saving our expected return value along the way.
		var startTag:IMXHXTagData = this;
		while (true) {
			var parentTag = startTag.getContainingTag(startTag.start);
			if (parentTag == null) {
				break;
			}
			startTag = parentTag;
			if (parentTag.name != name) {
				break;
			}
		}
		// Now walk through the tags starting at startTag.  Once we pop ourselves
		// off the tagStack, we've found our candidate result -- but keep going
		// until the stack is null, to ensure that we're balanced out to the
		// surrounding tag.
		var tagStack:Array<IMXHXTagData> = [];
		var result:IMXHXTagData = null;
		for (i in startTag.index...parent.numUnits) {
			var unit = parent.unitAt(i);
			if ((unit is IMXHXTagData)) {
				var tag:IMXHXTagData = cast unit;
				if (tag.isEmptyTag()) {
					// skip
					continue;
				} else if (tag.isOpenTag()) {
					tagStack.push(tag);
				} else if (tag.isCloseTag()) {
					if (tagStack.length == 0) {
						return null; // unbalanced
					}
					var popped = tagStack.pop();
					// check the short name in case the namespace is not spelled properly
					if (popped.name != tag.name && popped.shortName != tag.shortName) {
						return null; // unbalanced
					}
					if (popped == this) {
						// this is our result -- remember it.
						result = tag;
					}
					if (tagStack.length == 0) {
						if (result != null && result.isImplicit() && !includeImplicit) {
							return null;
						}
						return result;
					}
				}
			}
		}
		return null;
	}
}
