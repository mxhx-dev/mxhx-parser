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

import haxe.macro.Type;
#if macro
import haxe.macro.Context;
import haxe.macro.Expr.Error;
import haxe.macro.Expr.MetadataEntry;
import haxe.macro.Type.BaseType;

/**
	Utility functions for MXHX macros.
**/
class MXHXMacroTools {
	/**
		Gets the name of an event from an `:event` metadata entry.
	**/
	public static function getEventName(eventMeta:MetadataEntry):String {
		if (eventMeta.name != ":event") {
			throw new Error("getEventNames() requires :event meta", Context.currentPos());
		}
		var typedExprDef = Context.typeExpr(eventMeta.params[0]).expr;
		if (typedExprDef == null) {
			return null;
		}
		return switch (typedExprDef) {
			case TConst(TString(s)): s;
			case TField(e, FStatic(c, cf)):
				var classField = cf.get();
				var expr = classField.expr().expr;
				switch (expr) {
					case TConst(TString(s)): s;
					default: null;
				}
			default: null;
		};
	}

	/**
		Gets the type of an event from an `:event` metadata entry.
	**/
	public static function getEventType(eventMeta:MetadataEntry):String {
		if (eventMeta.name != ":event") {
			throw new Error("getEventType() requires :event meta", Context.currentPos());
		}
		var typedExprType = Context.typeExpr(eventMeta.params[0]).t;
		return switch (typedExprType) {
			case TAbstract(t, params):
				var qname = getQName(t.get());
				if ("openfl.events.EventType" != qname) {
					return "openfl.events.Event";
				}
				switch (params[0]) {
					case TInst(t, params): t.toString();
					default: null;
				}
			default: "openfl.events.Event";
		};
	}

	/**
		Gets the fully qualified name of a type.
	**/
	public static function getQName(t:BaseType):String {
		var qname = t.name;
		if (t.pack.length > 0) {
			qname = t.pack.join(".") + "." + qname;
		}
		return qname;
	}

	public static function getUnifiedType(t1:Type, t2:Type):Type {
		if (t1 == null) {
			return t2;
		} else if (t2 == null) {
			return t1;
		}
		var current = t2;
		while (current != null) {
			if (Context.unify(t1, current)) {
				return current;
			}
			current = switch (current) {
				case TInst(t, params):
					var classType = t.get();
					var superClass = classType.superClass;
					if (superClass != null) {
						TInst(superClass.t, superClass.params);
					} else {
						null;
					}
				default:
					null;
			}
		}
		return null;
	}
}
#end
