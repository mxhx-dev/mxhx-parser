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
import haxe.macro.Expr;
import haxe.macro.Type;

/**
	A symbol, such as a class, field, or event, resolved from an
	[MXHX](http://mxhx.dev) unit or attribute.
**/
enum MXHXSymbol {
	/**
		The resolved symbol is a class.
	**/
	ClassSymbol(c:ClassType, params:Array<haxe.macro.Type>);

	/**
		The resolved symbol is an abstract.
	**/
	AbstractSymbol(a:AbstractType, params:Array<haxe.macro.Type>);

	/**
		The resolved symbol is an enum.
	**/
	EnumSymbol(e:EnumType, params:Array<haxe.macro.Type>);

	/**
		The resolved symbol is a field.
	**/
	FieldSymbol(f:ClassField, t:MXHXSymbol);

	/**
		The resolved symbol is an event.
	**/
	EventSymbol(e:MetadataEntry, t:MXHXSymbol);

	/**
		The resolved symbol is an enum field.
	**/
	EnumFieldSymbol(f:EnumField, t:MXHXSymbol);
}
#end
