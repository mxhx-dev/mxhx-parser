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
	Represents an XML processing instruction in [MXHX](https://mxhx.dev).
**/
class MXHXInstructionData extends MXHXUnitData implements IMXHXInstructionData {
	/**
		@see `mxhx.IMXHXInstructionData.instructionText`
	**/
	public var instructionText(default, set):String = null;

	private function set_instructionText(value:String):String {
		if (instructionText == value) {
			return instructionText;
		}
		instructionText = value;
		if (instructionText != null) {
			var targetEndIndex = instructionText.length - 2;
			var contentStartIndex = targetEndIndex;
			var whitespaceMatcher = ~/[ \t\r\n]+/;
			if (whitespaceMatcher.match(instructionText)) {
				targetEndIndex = whitespaceMatcher.matchedPos().pos;
				contentStartIndex = whitespaceMatcher.matchedPos().pos + whitespaceMatcher.matchedPos().len;
			}
			target = instructionText.substring(2, targetEndIndex);
			var hasEnd = StringTools.endsWith(instructionText, "?>");
			content = instructionText.substring(contentStartIndex, instructionText.length - (hasEnd ? 2 : 0));
		} else {
			target = "";
			content = "";
		}
		return instructionText;
	}

	/**
		@see `mxhx.IMXHXInstructionData.target`
	**/
	public var target(default, default):String = null;

	/**
		@see `mxhx.IMXHXInstructionData.content`
	**/
	public var content(default, default):String = null;

	/**
		Creates a new `MXHXInstructionData` object with the given arguments.
	**/
	public function new(?instructionText:String) {
		super();
		this.instructionText = instructionText;
	}

	override public function toString():String {
		return '<?$target ${escapedContent()}?> ${super.toString()}';
	}

	private function escapedContent():String {
		if (content == null) {
			return "";
		}
		return ~/\t/g.replace(~/\n/g.replace(~/\r/g.replace(content, "\\r"), "\\n"), "\\t");
	}
}
