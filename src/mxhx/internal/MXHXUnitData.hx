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
	Represents a unit in an [MXHX](https://mxhx.dev) document.
**/
class MXHXUnitData extends MXHXSourceLocation implements IMXHXUnitData {
	/**
		@see `mxhx.IMXHXUnitData.parent`
	**/
	public var parent(default, default):IMXHXData = null;

	/**
		@see `mxhx.IMXHXUnitData.parentUnit`
	**/
	public var parentUnit(get, never):IMXHXUnitData;

	private function get_parentUnit():IMXHXUnitData {
		if (parentUnitIndex == -1) {
			return null;
		}
		return parent.unitAt(parentUnitIndex);
	}

	/**
		@see `mxhx.IMXHXUnitData.index`
	**/
	public var index(default, default):Int = -1;

	/**
		The index of this unit's parent unit within the `IMXHXData`.
	**/
	public var parentUnitIndex(default, default):Int = -1;

	/**
		@see `mxhx.IMXHXUnitData.contentStart`
	**/
	public var contentStart(get, never):Int;

	private function get_contentStart():Int {
		return start;
	}

	/**
		@see `mxhx.IMXHXUnitData.contentEnd`
	**/
	public var contentEnd(get, never):Int;

	private function get_contentEnd():Int {
		return end;
	}

	private function new() {
		super();
	}

	/**
		Sets the location of the unit within its parent `IMXHXData` object.
	**/
	public function setLocation(parent:IMXHXData, index:Int):Void {
		this.parent = parent;
		this.index = index;
		this.source = parent.source;
	}

	/**
		Sets the `start` and `end` offsets.
	**/
	public function setOffsets(start:Int, end:Int):Void {
		this.start = start;
		this.end = end;
	}

	/**
		@see `mxhx.IMXHXUnitData.getPrevious()`
	**/
	public function getPrevious():IMXHXUnitData {
		return parent.unitAt(index - 1);
	}

	/**
		@see `mxhx.IMXHXUnitData.getNext()`
	**/
	public function getNext():IMXHXUnitData {
		return parent.unitAt(index + 1);
	}

	/**
		@see `mxhx.IMXHXUnitData.getNextSiblingUnit()`
	**/
	public function getNextSiblingUnit():IMXHXUnitData {
		var nextUnit = getNext();
		if (nextUnit == null) {
			return null;
		}
		if (nextUnit.parentUnit != parentUnit) {
			return null;
		}
		return nextUnit;
	}

	/**
		@see `mxhx.IMXHXUnitData.getNextTag()`
	**/
	public function getNextTag():IMXHXTagData {
		var nextUnit:IMXHXUnitData = getNext();

		while (true) {
			if (nextUnit == null) {
				return null;
			}
			if ((nextUnit is IMXHXTagData)) {
				return cast nextUnit;
			}
			nextUnit = nextUnit.getNext();
		}
	}

	/**
		@see `mxhx.IMXHXUnitData.containsOffset()`
	**/
	public function containsOffset(offset:Int):Bool {
		return MXHXData.contains(start, end, offset);
	}

	/**
		@see `mxhx.IMXHXUnitData.getContainingTag()`
	**/
	public function getContainingTag(offset:Int):IMXHXTagData {
		var tagNames:Array<String> = [];
		var current:IMXHXUnitData = getPrevious();
		var containingTag:IMXHXTagData = null;

		if (containsOffset(offset) && (this is IMXHXTagData)) {
			var tag:IMXHXTagData = cast this;
			if (tag.isCloseTag()) {
				tagNames.push(tag.name);
			}
		}

		while (current != null && containingTag == null) {
			if ((current is IMXHXTagData)) {
				var currentTag:IMXHXTagData = cast current;

				if (currentTag.isCloseTag()) {
					tagNames.push(currentTag.name);
				} else if (currentTag.isOpenTag() && !currentTag.isEmptyTag()) {
					var stackName = "";
					while (stackName == currentTag.name && tagNames.length > 0) {
						stackName = tagNames.pop();
					}
					if (stackName == currentTag.name) {
						containingTag = currentTag;
					}
				}
			}

			current = current.getPrevious();
		}

		return containingTag;
	}

	/**
		@see `mxhx.IMXHXUnitData.clone()`
	**/
	public function clone():IMXHXUnitData {
		throw "Not implemented";
	}
}
