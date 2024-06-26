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

import mxhx.parser.MXHXParserProblem;

/**
	Represents an [MXHX](https://mxhx.dev) document.
**/
class MXHXData implements IMXHXData {
	/**
		Test whether the offset is contained within the range from start to end.
		This test excludes the start position and includes the end position,
		which is how you want things to work for code hints.
	**/
	public static function contains(start:Int, end:Int, offset:Int):Bool {
		return start < offset && end >= offset;
	}

	/**
		@see `mxhx.IMXHXData.source`
	**/
	public var source(default, default):String = null;

	/**
		@see `mxhx.IMXHXData.numUnits`
	**/
	public var numUnits(get, never):Int;

	private function get_numUnits():Int {
		return units.length;
	}

	/**
		Get all of the MXHX units found in this `MXHXData`.
	**/
	public var units(default, default):Array<IMXHXUnitData> = [];

	private var prefixMapMap:Map<IMXHXTagData, PrefixMap> = [];

	/**
		@see `mxhx.IMXHXData.problems`
	**/
	public var problems(default, never):Array<MXHXParserProblem> = [];

	/**
		@see `mxhx.IMXHXData.rootTag`
	**/
	public var rootTag(get, never):IMXHXTagData;

	private function get_rootTag():IMXHXTagData {
		for (unit in units) {
			if ((unit is IMXHXTagData)) {
				return cast unit;
			}
		}
		return null;
	}

	/**
		Creates a new `MXHXData` object with the given arguments.
	**/
	public function new(?source:String) {
		this.source = source;
	}

	/**
		@see `mxhx.IMXHXData.unitAt()`
	**/
	public function unitAt(i:Int):IMXHXUnitData {
		if (i < 0 || i >= units.length) {
			return null;
		}
		return units[i];
	}

	/**
		@see `mxhx.IMXHXData.getPrefixMapForTag()`
	**/
	public function getPrefixMapForTag(tagData:IMXHXTagData):PrefixMap {
		if (tagData == null) {
			return null;
		}
		var result = prefixMapMap.get(tagData);
		if (result != null) {
			return result;
		}
		if (tagData.isCloseTag()) {
			var openTagData = tagData.findMatchingOpenTag();
			if (openTagData != null) {
				return prefixMapMap.get(openTagData);
			}
		}
		return null;
	}

	/**
		Get the unit that contains this offset. Returns `null`, if no unit
		contains the offset.
	**/
	public function findUnitContainingOffset(offset:Int):IMXHXUnitData {
		var unit = findNearestUnit(offset);
		if (unit != null && unit.containsOffset(offset)) {
			return unit;
		}
		return null;
	}

	/**
		Get the open, close, or empty tag that contains this offset. Note that if
		offset is inside a text node, this returns `null`. If you want the
		surrounding tag in that case, use
		`findTagOrSurroundingTagContainingOffset()` instead.

		@see `MXHXData.findTagOrSurroundingTagContainingOffset()`
	**/
	public function findTagContainingOffset(offset:Int):IMXHXTagData {
		var unit = findUnitContainingOffset(offset);
		if (unit != null && (unit is IMXHXTagData)) {
			return cast unit;
		}
		return null;
	}

	/**
		@see `IMXHXData.findTagOrSurroundingTagContainingOffset()`
	**/
	public function findTagOrSurroundingTagContainingOffset(offset:Int):IMXHXTagData {
		var unit = findUnitContainingOffset(offset);
		if (unit != null) {
			if ((unit is IMXHXTagData)) {
				return cast unit;
			} else if ((unit is IMXHXTextData)) {
				return unit.getContainingTag(unit.start);
			}
		}
		return null;
	}

	/**
		Inserts a prefix and URI mapping to the `MXHXData`, but it does so
		without inserting `xmlns` attributes. Intended for advanced tooling that
		manipulates `MXHXData` and parsable MXHX code.
	**/
	public function addToPrefixMapForTag(tagData:IMXHXTagData, uri:String, prefix:String, onlyIfUnique:Bool = false):Void {
		var prefixMap = prefixMapMap.get(tagData);
		if (prefixMap == null) {
			prefixMap = new PrefixMap();
			prefixMapMap.set(tagData, prefixMap);
		}
		var mutablePrefixMap = prefixMap.toMutable();
		mutablePrefixMap.add(uri, prefix, onlyIfUnique);
		prefixMapMap.set(tagData, mutablePrefixMap.toImmutable());
	}

	@:dox(hide)
	public function toString():String {
		var result = "";
		for (i in 0...units.length) {
			var unit = units[i];
			result += (i > 0 ? "\n" : "") + '[$i] $unit';
		}
		return result;
	}

	/**
		@see `mxhx.IMXHXData.clone()`
	**/
	public function clone():MXHXData {
		var cloned = new MXHXData(source);
		cloned.units = units.map(unit -> {
			var clonedUnit = (cast unit.clone() : MXHXUnitData);
			clonedUnit.parent = cloned;
			if ((unit is IMXHXTagData)) {
				var tag:IMXHXTagData = cast unit;
				var prefixMap = prefixMapMap.get(tag);
				if (prefixMap != null) {
					cloned.prefixMapMap.set(cast clonedUnit, new PrefixMap(prefixMap));
				}
			}
			return (cast clonedUnit : IMXHXUnitData);
		});
		return cloned;
	}

	/**
		If the offset is contained within an MXHX unit, get that unit. If it's
		not, then get the first unit that follows the offset.
	**/
	private function findNearestUnit(offset:Int):IMXHXUnitData {
		// Use the cursor as a fast search hint. But only if the cursor is at or before the
		// are of interest.
		var startOffset = 0;
		// if (cursor.getOffset() <= offset) {
		// 	startOffset = cursor.getUnitIndex();
		// }

		// Sanity check
		if (startOffset < 0 || startOffset >= units.length) {
			startOffset = 0;
		}

		// Now iterate though the units and find the first one that is acceptable
		var ret:IMXHXUnitData = null;
		var i = startOffset;
		while (i < units.length && ret == null) {
			var unit = units[i];

			// unit is a match if it "contains" the offset.
			// We are using a somewhat bizarre form of "contains" here, in that we are
			// using getStart() and getContentEnd(). This asymmetric mismatch is for several reasons:
			//      * it's the only way to match the existing (Flex) behavior
			//      * If our cursor is before the <, we want to match the tag.
			//              example:     |<foo   >  will find "foo" as the nearest tag.
			//      So we need to use start here (not content start)
			//      * If our cursor is between two tags, we want to match the NEXT one, not the previous one
			//              example:   <bar >|<foo>  should match foo, not bar

			if (MXHXData.contains(unit.start, unit.contentEnd, offset)) {
				ret = unit;
			}
				// if we find a unit that starts after the offset, then it must
			// be the "first one after", so return it
			else if (unit.start >= offset) {
				ret = unit;
			}
			i++;
		}

		// If we found something, update the cursor for the next search
		// if (ret != null) {
		// 	cursor.setCursor(offset, ret.getIndex());
		// }
		return ret;
	}
}
