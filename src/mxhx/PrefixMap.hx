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
	A `PrefixMap` contains a collection of prefix to namespace mappings found in
	[MXHX](https://mxhx.dev) documents. This object is **immutable**. For a
	mutable version, look at `MutablePrefixMap`.
**/
class PrefixMap {
	private var prefixes:Map<String, Bool> = [];
	private var uriToPrefix:Map<String, Map<String, Bool>> = [];

	/**
		Creates a new `PrefixMap` object with the given arguments.
	**/
	public function new(?prefixMap:PrefixMap) {
		if (prefixMap != null) {
			prefixes = prefixMap.prefixes.copy();
			for (key => value in prefixMap.uriToPrefix) {
				uriToPrefix.set(key, value.copy());
			}
		}
	}

	/**
		Creates a mutable copy of this prefix map and all of its values.
	**/
	public function toMutable():MutablePrefixMap {
		return new MutablePrefixMap(this);
	}

	/**
		Returns the namespace URIfor the given prefix. The first prefix found in
		the map will win, if there are duplicates.
	**/
	public function getUriForPrefix(prefix:String):String {
		for (uri => set in uriToPrefix) {
			if (set.exists(prefix)) {
				return uri;
			}
		}
		return null;
	}

	/**
		Returns `true` if the given prefix exists somewhere in this map.
	**/
	public function containsPrefix(prefix:String):Bool {
		return prefixes.get(prefix) == true;
	}

	/**
		Checks whether the map contains a reference to the given namespace URI.
	**/
	public function containsUri(uri:String):Bool {
		return uriToPrefix.exists(uri);
	}

	/**
		Returns all of the prefixes known to this map.
	**/
	public function getAllPrefixes():Array<String> {
		var result:Array<String> = [];
		for (prefix => value in prefixes) {
			if (value) {
				result.push(prefix);
			}
		}
		return result;
	}

	/**
		Returns all the namespace URIs known to this map.
	**/
	public function getAllUris():Array<String> {
		var result:Array<String> = [];
		var keys = uriToPrefix.keys();
		while (keys.hasNext()) {
			result.push(keys.next());
		}
		return result;
	}

	/**
		Returns the prefix that is used to reference the given namespace URI.
	**/
	public function getPrefixesForUri(uri:String):Array<String> {
		var result:Array<String> = [];
		var prefixes = uriToPrefix.get(uri);
		if (prefixes != null) {
			var keys = prefixes.keys();
			while (keys.hasNext()) {
				result.push(keys.next());
			}
		}
		return result;
	}
}
