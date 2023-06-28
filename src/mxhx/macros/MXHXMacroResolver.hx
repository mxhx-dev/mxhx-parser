/*
	Licensed under the Apache License, Version 2.0 (the "License");
	you may not use this file except in compliance with the License.
	You may obtain a copy of the License at

	http://www.apache.org/licenses/LICENSE-2.0

	Unless required by applicable law or agreed to in writing, software
	distributed under the License is distributed on an "AS IS" BASIS,
	WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
	See the License for the specific language governing permissions and
	limitations under the License.
 */

package mxhx.macros;

#if macro
import haxe.macro.Context;
import haxe.macro.Type;
import mxhx.macros.MXHXSymbol;

/**
	Resolves symbols referenced in an [MXHX](https://mxhx.dev/) document.
**/
class MXHXMacroResolver {
	private var manifests:Map<String, Map<String, String>> = [];

	public function new() {}

	/**
		Registers the classes available in a particular MXHX namespace.
	**/
	public function registerManifest(uri:String, mappings:Map<String, String>):Void {
		manifests.set(uri, mappings);
	}

	/**
		Resolves the `haxe.macro.Type` that an MXHX tag represents.
	**/
	public function resolveTagAsMacroType(tag:IMXHXTagData):Type {
		if (tag.stateName != null) {
			return null;
		}
		var prefix = tag.prefix;
		var uri = tag.uri;
		var localName = tag.shortName;

		if (uri != null && manifests.exists(uri)) {
			var mappings = manifests.get(uri);
			if (mappings.exists(localName)) {
				var qname = mappings.get(localName);
				var type = resolveMacroTypeForQname(qname);
				if (type != null) {
					return type;
				}
			}
		}

		if (uri != "*" && !StringTools.endsWith(uri, ".*")) {
			return null;
		}
		var qname = uri.substr(0, uri.length - 1) + localName;
		var qnameType = resolveMacroTypeForQname(qname);
		if (qnameType == null) {
			return null;
		}
		return qnameType;
	}

	/**
		Resolves the symbol that an MXHX tag represents.
	**/
	public function resolveTag(tag:IMXHXTagData):MXHXSymbol {
		if (tag == null) {
			return null;
		}
		if (!hasValidPrefix(tag)) {
			return null;
		}
		var resolvedProperty = resolveTagAsPropertySymbol(tag);
		if (resolvedProperty != null) {
			return resolvedProperty;
		}
		var resolvedEvent = resolveTagAsEventSymbol(tag);
		if (resolvedEvent != null) {
			return resolvedEvent;
		}
		var resolvedType = resolveTagAsTypeSymbol(tag);
		if (resolvedType != null) {
			return resolvedType;
		}
		return null;
	}

	/**
		Resolves a field of a tag.
	**/
	public function resolveTagField(tag:IMXHXTagData, fieldName:String):MXHXSymbol {
		var tagSymbol = resolveTag(tag);
		var field = resolveFieldByName(tagSymbol, fieldName);
		if (field != null) {
			return field;
		}
		return null;
	}

	/**
		Resolves the symbol that an MXHX tag attribute represents.
	**/
	public function resolveAttribute(attribute:IMXHXTagAttributeData):MXHXSymbol {
		if (attribute == null) {
			return null;
		}
		var tag:IMXHXTagData = attribute.parentTag;
		var tagSymbol = resolveTag(tag);
		if (tagSymbol == null) {
			return null;
		}
		var field = resolveFieldByName(tagSymbol, attribute.shortName);
		if (field != null) {
			return field;
		}
		var event = resolveEventByName(tagSymbol, attribute.shortName);
		if (event != null) {
			return event;
		}
		return null;
	}

	private function resolveTagAsPropertySymbol(tag:IMXHXTagData):MXHXSymbol {
		var parentSymbol = resolveParentTag(tag);
		if (parentSymbol == null) {
			return null;
		}
		return resolveFieldByName(parentSymbol, tag.shortName);
	}

	private function resolveTagAsEventSymbol(tag:IMXHXTagData):MXHXSymbol {
		var parentSymbol = resolveParentTag(tag);
		if (parentSymbol == null) {
			return null;
		}
		return resolveEventByName(parentSymbol, tag.shortName);
	}

	private function resolveTagAsTypeSymbol(tag:IMXHXTagData):MXHXSymbol {
		var prefix = tag.prefix;
		var uri = tag.uri;
		var localName = tag.shortName;

		if (uri != null && manifests.exists(uri)) {
			var mappings = manifests.get(uri);
			if (mappings.exists(localName)) {
				var qname = mappings.get(localName);
				if (qname == "Array") {
					var typeAttr = tag.getAttributeData("type");
					if (typeAttr != null) {
						var arrayType = Context.getType(localName);
						var arrayClassType = switch (arrayType) {
							case TInst(t, params): t.get();
							default: null;
						}
						var itemType:Type = null;
						try {
							itemType = Context.getType(typeAttr.rawValue);
						} catch (e:Dynamic) {
							// return null;
						}
						if (tag.stateName != null) {
							return null;
						}
						return ClassSymbol(arrayClassType, [itemType]);
					}
				}
				var type = resolveTypeSymbolForQname(qname);
				if (type != null) {
					switch (type) {
						case EnumSymbol(e, params):
							if (tag.stateName == null) {
								return type;
							}
							if (!e.constructs.exists(tag.stateName)) {
								return null;
							}
							var enumField = e.constructs.get(tag.stateName);
							return EnumFieldSymbol(enumField, type);
						default:
							if (tag.stateName != null) {
								return null;
							}
							return type;
					}
				}
			}
		}
		if (tag.stateName != null) {
			return null;
		}

		if (uri != "*" && !StringTools.endsWith(uri, ".*")) {
			return null;
		}
		var qname = uri.substr(0, uri.length - 1) + localName;
		var qnameType = resolveTypeSymbolForQname(qname);
		if (qnameType == null) {
			return null;
		}
		return qnameType;
	}

	private function resolveMacroTypeForQname(qname:String):Type {
		var qnameType:haxe.macro.Type = null;
		try {
			return Context.getType(qname);
		} catch (e:Dynamic) {
			return null;
		}
	}

	private function resolveTypeSymbolForQname(qname:String):MXHXSymbol {
		var qnameType = resolveMacroTypeForQname(qname);
		if (qnameType == null) {
			return null;
		}
		return switch (qnameType) {
			case TInst(t, params): ClassSymbol(t.get(), params);
			case TAbstract(t, params): AbstractSymbol(t.get(), params);
			case TEnum(t, params): EnumSymbol(t.get(), params);
			default:
				null;
		}
	}

	private function hasValidPrefix(tag:IMXHXTagData):Bool {
		var prefixMap = tag.compositePrefixMap;
		if (prefixMap == null) {
			return false;
		}
		return prefixMap.containsPrefix(tag.prefix) && prefixMap.containsUri(tag.uri);
	}

	private function resolveParentTag(tag:IMXHXTagData):MXHXSymbol {
		var parentTag = tag.parentTag;
		if (parentTag == null) {
			return null;
		}
		if (parentTag.prefix != tag.prefix) {
			return null;
		}
		var resolvedParent = resolveTag(parentTag);
		if (resolvedParent != null) {
			return resolvedParent;
		}
		return null;
	}

	private function resolveFieldByName(symbol:MXHXSymbol, name:String):MXHXSymbol {
		var current = symbol;
		while (current != null) {
			var resolved = resolveFieldByNameInternal(current, name);
			if (resolved != null) {
				return resolved;
			}
			var resolvedClass:ClassType = switch (current) {
				case ClassSymbol(c, _): c;
				default: null;
			}
			if (resolvedClass == null) {
				break;
			}
			var superClass = resolvedClass.superClass;
			if (superClass == null) {
				break;
			}
			current = ClassSymbol(superClass.t.get(), superClass.params);
		}
		return null;
	}

	private function resolveFieldByNameInternal(symbol:MXHXSymbol, name:String):MXHXSymbol {
		var resolvedClass:ClassType = switch (symbol) {
			case ClassSymbol(c, _): c;
			default: null;
		}
		if (resolvedClass == null) {
			return null;
		}
		var fields = resolvedClass.fields.get();
		for (field in fields) {
			if (field.name == name) {
				return FieldSymbol(field, symbol);
			}
		}
		return null;
	}

	private function resolveEventByName(type:MXHXSymbol, name:String):MXHXSymbol {
		var current = type;
		while (current != null) {
			var resolved = resolveEventByNameInternal(current, name);
			if (resolved != null) {
				return resolved;
			}
			var resolvedClass:ClassType = switch (current) {
				case ClassSymbol(c, _): c;
				default: null;
			}
			if (resolvedClass == null) {
				break;
			}
			var superClass = resolvedClass.superClass;
			if (superClass == null) {
				break;
			}
			current = ClassSymbol(superClass.t.get(), superClass.params);
		}
		return null;
	}

	private function resolveEventByNameInternal(symbol:MXHXSymbol, name:String) {
		var resolvedType:BaseType = switch (symbol) {
			case ClassSymbol(c, _): c;
			case AbstractSymbol(a, _): a;
			case EnumSymbol(e, _): e;
			default: null;
		}
		if (resolvedType == null) {
			return null;
		}
		var events = resolvedType.meta.extract(":event").filter(eventMeta -> eventMeta.params.length == 1);
		for (meta in events) {
			if (MXHXMacroTools.getEventName(meta) == name) {
				return EventSymbol(meta, symbol);
			}
		}
		return null;
	}
}
#end
