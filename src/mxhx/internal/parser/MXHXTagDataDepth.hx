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
import mxhx.internal.MXHXTagData;
import mxhx.parser.MXHXParserProblem;

/**
	Each `MXHXTagDepth` tracks open and close tags inside of it, and at each
	level, attempts to balance its results if unbalanced, by either adding an
	open tag, adding a close tag or delegating the decision to the next depth.
**/
class MXHXTagDataDepth {
	private var openTags:Array<IMXHXTagData> = [];
	private var closeTags:Array<IMXHXTagData> = [];

	/**
		Returns the depth that we represent.
	**/
	public var depth(default, null):Int;

	/**
		The parent of this object.
	**/
	public var parent:MXHXTagDataDepth;

	/**
		Creates a new `MXHXTagDataDepth` object with th given arguments.
	**/
	public function new(depth:Int) {
		this.depth = depth;
	}

	/**
		Adds an open tag to the list of tags that we are tracking.
	**/
	public function addOpenTag(openTag:IMXHXTagData):Void {
		openTags.push(openTag);
	}

	/**
		Adds a close tag to the list of tags that we are tracking.
	**/
	public function addCloseTag(closeTag:IMXHXTagData):Void {
		closeTags.push(closeTag);
	}

	/**
		If any repairs were done, either there will be tags in the payload, or
		the return value will be `true`, or both.

		To determine if any repairing was done:

		```haxe
		ret = balance(payload, ...);
		did_repair = ret || !payload.isEmpty();
		```
	**/
	public function balance(payload:Array<MXHXTagDataPayload>, prefixMap:Map<IMXHXTagData, PrefixMap>, mxhxData:IMXHXData, data:Array<IMXHXUnitData>,
			problems:Array<MXHXParserProblem>, source:String):Bool {
		ensureOrder();
		final size = openTags.length;
		var didNonPayloadRepair = false;

		var i = 0;
		while (i < openTags.length) {
			var openTag = openTags[i];
			if (closeTags.length > 0) {
				var closeTag = closeTags[closeTags.length - 1];
				if (closeTag.name != openTag.name) {
					// let's determine where to end, and then move all of our tags to our parent
					var insertOffset = -1;
					while (closeTags.length > 0) {
						var pop = closeTags.pop();
						if (pop.name != openTag.name) {
							insertOffset = pop.index;
							if (parent != null) {
								parent.addCloseTag(pop);
							} else {
								// since the parent cannot handle this, we should insert an open tag for this close tag
								var tagData = FakeMXHXTagData.withName(pop.name, false, false);
								tagData.setOffsets(pop.end, pop.end);
								payload.push(new MXHXTagDataPayload(tagData, insertOffset - 1));
								problems.push(produceProblemFromTag(tagData, source));
								if (i + 1 < size) {
									openTag = openTags[++i];
								}
							}
						} else { // punt to the parent
							insertOffset = -1;
							break;
						}
					}
					if (insertOffset != -1) {
						if (!openTag.hasExplicitCloseToken()) {
							// we have an open with no matching close, so let's just make
							// it an empty tag. CMP-916
							cast(openTag, MXHXTagData).setEmptyTag(true);
							didNonPayloadRepair = true; // note a repair, so we can alert caller
							problems.push(produceProblemFromTag(openTag, source));
							// TODO: below (line 230) the old code used to make up a new fake tag and
							// transfer stuff over, and log a problem. We aren't doing that here.
							// Why do they go to all the trouble to clone the tag??
						} else {
							// we don't have a location to insert, meaning we need to drop in an open tag
							// due to the direction of the imbalance
							var tagData = FakeMXHXTagData.withName(openTag.name, true, false);
							tagData.setOffsets(openTag.end, openTag.end);
							payload.push(new MXHXTagDataPayload(tagData, insertOffset));
							problems.push(produceProblemFromTag(tagData, source));
						}
					}
				} else {
					closeTags.pop();
				}
			} else {
				if (parent != null) {
					parent.addOpenTag(openTag);
				} else {
					var pos = openTag.index;
					var tokenSize = data.length;
					while (pos < tokenSize) {
						var currToken = data[pos];
						if ((currToken is MXHXTagData)) {
							var currTag:MXHXTagData = cast currToken;
							if (!currTag.hasExplicitCloseToken()) {
								problems.push(new MXHXParserProblem('${currTag.name} tag (or non-tag inside this tag) is unclosed', 1552, Error,
									currTag.source, currTag.start, currTag.end));
								var fakeMXHXTagData = FakeMXHXTagData.withTag(currTag, true);
								data[pos] = fakeMXHXTagData;
								prefixMap.remove(currTag);
								didNonPayloadRepair = true; // note a repair, so we can alert caller

								// If the original tag had a prefix map, transfer to to the new tag.
								var map = currTag.prefixMap;
								if (map != null) {
									prefixMap.set(fakeMXHXTagData, map);
								}
								break;
							}
						}
						pos++;
					}
					if (!openTag.isEmptyTag()) {
						// this error wasn't in the Royale compiler, but it
						// seems to be necessary in cases where a close tag is
						// missing.
						problems.push(new MXHXParserProblem('${openTag.name} tag (or non-tag inside this tag) is unclosed', 1552, Error, openTag.source,
							openTag.start, openTag.end));
					}
				}
			}
			i++;
		}
		if (parent != null) {
			while (closeTags.length > 0) {
				parent.addCloseTag(closeTags.pop());
			}
		}
		return didNonPayloadRepair;
	}

	// Sorts the tags we have encountered
	private function ensureOrder():Void {
		ArraySort.sort(openTags, (o1:IMXHXTagData, o2:IMXHXTagData) -> {
			if (o1.index == o2.index)
				return 0;
			if (o1.index < o2.index)
				return -1;
			return 1;
		});
		ArraySort.sort(closeTags, (o1:IMXHXTagData, o2:IMXHXTagData) -> {
			if (o1.index == o2.index)
				return 0;
			if (o1.index < o2.index)
				return 1;
			return -1;
		});
	}

	private function produceProblemFromTag(tagData:IMXHXTagData, source:String):MXHXParserProblem {
		if ((tagData is MXHXTagData)) {
			var tag:MXHXTagData = cast tagData;
			if (tag.source == null) {
				tag.source = source;
			}
		}
		return new MXHXParserProblem('${tagData.name} tag (or non-tag inside this tag) is unclosed', 1552, Error, tagData.source, tagData.start, tagData.end);
	}
}

/**
	Fake `IMXHXTagData` that we add to our parent `IMXHXData`
**/
private class FakeMXHXTagData extends MXHXTagData {
	private static final MXHX_TAG_ATTRIBUTE_DATAS:Array<IMXHXTagAttributeData> = [];

	public static function withName(name:String, closeTag:Bool, emptyTag:Bool):FakeMXHXTagData {
		var tagData = new FakeMXHXTagData();
		tagData.name = name;
		tagData.closeTag = closeTag;
		tagData.emptyTag = emptyTag;
		return tagData;
	}

	public static function withTag(tag:MXHXTagData, emptyTag:Bool):FakeMXHXTagData {
		var tagData = new FakeMXHXTagData();
		tagData.copyFrom(tag);
		tagData.emptyTag = emptyTag;
		return tagData;
	}

	private function new() {
		super();
	}

	override public function getRawAttributeValue(attributeName:String):String {
		// API allows for null, so return null since we don't have attrs
		return null;
	}

	override private function get_attributeData():Array<IMXHXTagAttributeData> {
		// return empty array since our value for children is null
		return MXHX_TAG_ATTRIBUTE_DATAS;
	}

	override public function isImplicit():Bool {
		return true;
	}
}
