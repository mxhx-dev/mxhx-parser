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
	Represents a tag attribute in [MXHX](https://mxhx.dev).
**/
class MXHXTagAttributeData extends MXHXSourceLocation implements IMXHXTagAttributeData {
	/**
		@see `mxhx.IMXHXTagAttributeData.name`
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
			prefix = null;
			shortName = null;
			stateName = null;
		}
		return name;
	}

	/**
		@see `mxhx.IMXHXTagAttributeData.prefix`
	**/
	public var prefix(default, null):String = null;

	/**
		@see `mxhx.IMXHXTagAttributeData.shortName`
	**/
	public var shortName(default, null):String = null;

	/**
		@see `mxhx.IMXHXTagAttributeData.stateName`
	**/
	public var stateName(default, null):String = null;

	/**
		@see `mxhx.IMXHXTagAttributeData.uri`
	**/
	@:isVar
	public var uri(get, null):String = null;

	private function get_uri():String {
		if (uri == null) {
			if (prefix == null) {
				return null;
			}

			var lookingAt:IMXHXTagData = cast parentTag;

			// For attributes with prefix, parent's parent can be null if
			// parent is the root tag
			while (lookingAt != null && lookingAt.parentTag != null) {
				var depth = lookingAt.parent.getPrefixMapForTag(lookingAt);
				if (depth != null && depth.containsPrefix(prefix)) {
					uri = depth.getUriForPrefix(prefix);
					break;
				}

				lookingAt = lookingAt.parentTag;
			}
		}
		return uri;
	}

	private var valueIncludingDelimiters:String;

	/**
		@see `mxhx.IMXHXTagAttributeData.rawValue`
	**/
	public var rawValue(get, never):String;

	private function get_rawValue():String {
		var value = valueIncludingDelimiters;
		if (value != null && value.length > 0) {
			// length can be one in case of invalid data and then the
			// substring() call fails so, handle it here
			if (value.charAt(0) == value.charAt(value.length - 1) && value.length != 1) {
				value = value.substring(1, value.length - 1);
			} else {
				value = value.substring(1);
			}
		}

		return value;
	}

	/**
		@see `mxhx.IMXHXTagAttributeData.hasValue`
	**/
	public var hasValue(default, null):Bool = false;

	/**
		@see `mxhx.IMXHXTagAttributeData.valueStart`
	**/
	@:isVar
	public var valueStart(get, null):Int = -1;

	private function get_valueStart():Int {
		if (!hasValue) {
			return -1;
		}
		// + 1 for opening quote
		return valueStart + 1;
	}

	/**
		@see `mxhx.IMXHXTagAttributeData.valueEnd`
	**/
	public var valueEnd(get, null):Int;

	private function get_valueEnd():Int {
		if (!hasValue) {
			// If there is no valid "end", then we must return -1. Callers depend on this.
			// See MXHXTagData.findArttributeContainingOffset for an example
			return -1;
		}
		return valueStart + rawValue.length;
	}

	/**
		@see `mxhx.IMXHXTagAttributeData.parentTag`
	**/
	public var parentTag(default, default):IMXHXTagData;

	/**
		Creates a new `MXHXTagAttributeData` object with the given arguments.
	**/
	public function new(?name:String) {
		super();
		this.name = name;
	}

	override public function toString():String {
		return '$name="${escapedRawValue()}" ${super.toString()}';
	}

	/**
		Sets the raw value, including quote delimiters.

		@see `MXHXTagAttributeData.rawValue`
	**/
	public function setValueIncludingDelimeters(value:String):Void {
		valueIncludingDelimiters = value;
		hasValue = valueIncludingDelimiters != null;
	}

	/**
		Sets the raw value start position, including starting quote delimiter.

		@see `MXHXTagAttributeData.valueStart`
	**/
	public function setValueStartIncludingDelimiters(position:Int):Void {
		valueStart = position;
	}

	private function escapedRawValue():String {
		var rawValue = this.rawValue;
		if (rawValue == null) {
			return "";
		}
		return ~/\t/g.replace(~/\n/g.replace(~/\r/g.replace(rawValue, "\\r"), "\\n"), "\\t");
	}
}
