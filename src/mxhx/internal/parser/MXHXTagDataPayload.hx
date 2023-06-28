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

package mxhx.internal.parser;

/**

	This class stores the new `IMXHXTagData` object, as well as the index in
	which we should insert it into the parent `IMXHXData` object once balancing
	is complete.
**/
class MXHXTagDataPayload {
	/**
		The `IMXHXTagData` that should be inserted into its parent
		`IMXHXData` object.
	**/
	public var tagData(default, null):IMXHXTagData;

	/**
		Returns the position where we should insert our payload.
	**/
	public var position(default, null):Int;

	/**
		Creates a new `MXHXTagDataPayload` with the given arguments.
	**/
	public function new(tagData:IMXHXTagData, position:Int) {
		this.tagData = tagData;
		this.position = position;
	}
}
