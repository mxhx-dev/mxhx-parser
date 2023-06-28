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
	Represents a block of text character data in [MXHX](https://mxhx.dev).
**/
class MXHXTextData extends MXHXUnitData implements IMXHXTextData {
	/**
		@see `mxhx.IMXHXTextData.content`
	**/
	public var content(default, default):String = null;

	/**
		@see `mxhx.IMXHXTextData.textType`
	**/
	public var textType(default, default):MXHXTextType = null;

	/**
		Creates a new `MXHXTextData` object with the given arguments.
	**/
	public function new(?content:String, ?textType:MXHXTextType) {
		super();
		this.content = content;
		if (textType == null) {
			textType = Text;
		}
		this.textType = textType;
	}

	override public function toString():String {
		return '$textType "${escapedContent()}" ${super.toString()}';
	}

	private function escapedContent():String {
		if (content == null) {
			return "";
		}
		return ~/\t/g.replace(~/\n/g.replace(~/\r/g.replace(content, "\\r"), "\\n"), "\\t");
	}
}
