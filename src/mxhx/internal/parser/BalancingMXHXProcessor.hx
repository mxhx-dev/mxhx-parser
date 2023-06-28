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

import haxe.ds.ArraySort;
import mxhx.parser.MXHXParserProblem;

/**
	The BalancingMXHXProcessor performs a balancing operation over a collection
	of `IMXHXTagData` objects.  It looks for un-balanced MXHX and attempts to 
	add open and close tags in order to create a well-formed, or better-formed,
	DOM.

	The method used is to track tags by their depth, and going from inside out,
	to check for matches add open/close tags if each depth isn't balanced. If a
	depth is unbalanced by close tags, the close tag is promoted to its parent
	depth and dealt with at that level.
**/
class BalancingMXHXProcessor {
	private var depths:Array<MXHXTagDataDepth> = [];
	private var problems:Array<MXHXParserProblem> = [];
	private var source:String = null;

	/**
		Returns `true `if the balance operation resulted in a repaired document
	**/
	public var wasRepaired(default, null):Bool = false;

	/**
		Creates a new `BalancingMXHXProcessor` with the given arguments.
	**/
	public function new(source:String, problems:Array<MXHXParserProblem>) {
		this.source = source;
		this.problems = problems;
	}

	/**
		Initialize our balancing structures from a full `IMXHXUnitData` array. 
	**/
	public function initialize(data:Array<IMXHXUnitData>):Void {
		var index:Int = 0;
		for (i in 0...data.length) {
			var currentUnit = data[i];
			if ((currentUnit is IMXHXTagData)) {
				var currentTag:IMXHXTagData = cast currentUnit;
				if (!currentTag.isEmptyTag()) {
					if (currentTag.isOpenTag()) {
						addOpenTag(currentTag, index);
						index++;
					} else {
						index--;
						addCloseTag(currentTag, index);
					}
				}
			}
		}
	}

	/**
		Balances the MXHX tags.
	**/
	public function balance(data:Array<IMXHXUnitData>, mxhxData:IMXHXData, map:Map<IMXHXTagData, PrefixMap>):Array<IMXHXUnitData> {
		var payload:Array<MXHXTagDataPayload> = [];
		var i = depths.length - 1;
		while (i >= 0) {
			var b = depths[i].balance(payload, map, mxhxData, data, problems, source);
			if (b) {
				wasRepaired = true; // if any iteration returns true, some repair occurred
			}
			i--;
		}
		// sort the collection so we can insert from back to front
		ArraySort.sort(payload, (a, b) -> {
			if (a.position == b.position) {
				return 0;
			}
			if (a.position < b.position) {
				return 1;
			}
			return -1;
		});
		if (payload.length > 0) {
			wasRepaired = true; // If any payload returned, then that also means repairing occurred
			var newTags:Array<IMXHXUnitData> = data.copy();
			var i = payload.length - 1;
			while (i >= 0) {
				var tokenPayload = payload[i];
				newTags.insert(tokenPayload.position, tokenPayload.tagData);
				i--;
			}
			return newTags;
		}
		return data;
	}

	private function getDepth(depth:Int):MXHXTagDataDepth {
		var dep:MXHXTagDataDepth = null;
		if (depth < 0) {
			depth = depth * -1; // take the inverse for the depth if we're unbalanced on the tag side
		}
		if (depths.length > depth) {
			dep = depths[depth];
		} else {
			dep = new MXHXTagDataDepth(depth);
			if (depth - 1 >= 0 && depth - 1 < depths.length) {
				dep.parent = depths[depth - 1];
			}
			depths.push(dep);
		}
		return dep;
	}

	/**
		Keeps track of an open tag.
	**/
	public function addOpenTag(openTag:IMXHXTagData, depth:Int):Void {
		var dep = getDepth(depth);
		dep.addOpenTag(openTag);
	}

	/**
		Keeps track of a close tag.
	**/
	public function addCloseTag(closeTag:IMXHXTagData, depth:Int):Void {
		var dep = getDepth(depth);
		dep.addCloseTag(closeTag);
	}
}
