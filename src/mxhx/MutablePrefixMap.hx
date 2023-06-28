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
	A mutable version of a `PrefixMap` that allows additions and removals of
	namespaces.
**/
class MutablePrefixMap extends PrefixMap {
	/**
		Creates a new `MutablePrefixMap` object with the given arguments.
	**/
	public function new(?prefixMap:PrefixMap) {
		super(prefixMap);
	}

	/**
		Creates an immutable copy of this prefix map and all of its values.
	**/
	public function toImmutable():PrefixMap {
		return new PrefixMap(this);
	}

	/**
		Add a prefix and its uri to the map.
	**/
	public function add(uri:String, prefix:String, onlyIfUnique:Bool = false):Void {
		var prefixesForUri = uriToPrefix.get(uri);
		if (prefixesForUri == null) {
			prefixesForUri = [];
		}
		if (onlyIfUnique) {
			if (!prefixes.exists(prefix)) {
				prefixes.set(prefix, true);
				prefixesForUri.set(prefix, true);
				uriToPrefix.set(uri, prefixesForUri);
			}
		} else {
			prefixes.set(prefix, true);
			prefixesForUri.set(prefix, true);
			uriToPrefix.set(uri, prefixesForUri);
		}
	}

	/**
		Adds all information from one `PrefixMap` to another.
	**/
	public function addAll(prefixMap:PrefixMap, onlyIfUnique:Bool = false):Void {
		for (uri => prefixesForUri in prefixMap.uriToPrefix) {
			for (prefix => value in prefixesForUri) {
				if (value) {
					add(uri, prefix, onlyIfUnique);
				}
			}
		}
	}

	/**
		Removes a prefix from the map.
	**/
	public function remove(prefix:String):Void {
		prefixes.remove(prefix);
		for (uri => prefixesForUri in uriToPrefix) {
			if (prefixesForUri.exists(prefix)) {
				prefixesForUri.remove(prefix);
			}
		}
	}
}
