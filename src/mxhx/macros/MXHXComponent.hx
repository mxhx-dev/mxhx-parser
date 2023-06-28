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

import mxhx.internal.MXHXSourceLocation;
import mxhx.internal.MXHXTextData;
import haxe.CallStack;
#if macro
import haxe.macro.Context;
import haxe.macro.Expr;
import haxe.macro.PositionTools;
import haxe.macro.Type;
import haxe.macro.TypeTools;
import mxhx.parser.MXHXParser;
import sys.FileSystem;
import sys.io.File;
import haxe.io.Path;
#end

/**
	Creates Haxe classes and instances at compile-time using
	[MXHX](https://mxhx.dev) markup.

	Pass an inline markup string to `MXHXComponent.withMarkup()` to create a
	component instance from thee string. The following example creates a
	[Feathers UI](https://feathersui.com) component.

	```haxe
	var instance = XmlComponent.withMarkup(
		'<f:LayoutGroup
			xmlns:mx="https://ns.mxhx.dev/2022/basic"
			xmlns:f="https://ns.feathersui.com/mxhx">
			<f:layout>
				<f:HorizontalLayout gap="10" horizontalAlign="RIGHT"/>
			</f:layout>
			<f:Button id="okButton" text="OK"/>
			<f:Button id="cancelButton" text="Cancel"/>
		</f:LayoutGroup>'
	);
	container.addChild(instance);
	container.okButton.addEventListener(TriggerEvent.TRIGGER, (event) -> {
		trace("triggered the OK button");
	});
	```

	Pass a file path (relative to the current _.hx_ source file) to
	`MXHXComponent.withFile()` to create a component instance from markup saved
	in an external file.

	```haxe
	var instance = MXHXComponent.withFile("path/to/MyClass.mxhx");
**/
class MXHXComponent {
	#if macro
	private static final FILE_PATH_TO_TYPE_DEFINITION:Map<String, TypeDefinition> = [];
	private static final LANGUAGE_URI_BASIC_2022 = "https://ns.mxhx.dev/2022/basic";
	private static final LANGUAGE_URI_FULL_2022 = "https://ns.mxhx.dev/2022/mxhx";
	private static final LANGUAGE_URIS = [
		// @:formatter:off
		LANGUAGE_URI_BASIC_2022,
		LANGUAGE_URI_FULL_2022,
		// @:formatter:on
	];
	private static final PROPERTY_ID = "id";
	private static final PROPERTY_TYPE = "type";
	private static final PROPERTY_XMLNS = "xmlns";
	private static final KEYWORD_THIS = "this";
	private static final KEYWORD_NEW = "new";
	private static final META_DEFAULT_XML_PROPERTY = "defaultXmlProperty";
	private static final META_MARKUP = ":markup";
	private static final META_NO_COMPLETION = ":noCompletion";
	private static final TYPE_ANY = "Any";
	private static final TYPE_ARRAY = "Array";
	private static final TYPE_BOOL = "Bool";
	private static final TYPE_CLASS = "Class";
	private static final TYPE_DYNAMIC = "Dynamic";
	private static final TYPE_EREG = "EReg";
	private static final TYPE_FLOAT = "Float";
	private static final TYPE_INT = "Int";
	private static final TYPE_NULL = "Null";
	private static final TYPE_STRING = "String";
	private static final TYPE_UINT = "UInt";
	private static final TYPE_XML = "Xml";
	private static final VALUE_TRUE = "true";
	private static final VALUE_FALSE = "false";
	private static final VALUE_NAN = "NaN";
	private static final VALUE_INFINITY = "Infinity";
	private static final VALUE_NEGATIVE_INFINITY = "-Infinity";
	private static final TAG_BINDING = "Binding";
	private static final TAG_COMPONENT = "Component";
	private static final TAG_DESIGN_LAYER = "DesignLayer";
	private static final TAG_DECLARATIONS = "Declarations";
	private static final TAG_DEFINITION = "Definition";
	private static final TAG_LIBRARY = "Library";
	private static final TAG_METADATA = "Metadata";
	private static final TAG_MODEL = "Model";
	private static final TAG_PRIVATE = "Private";
	private static final TAG_REPARENT = "Reparent";
	private static final TAG_SCRIPT = "Script";
	private static final TAG_STYLE = "Style";
	private static final INIT_FUNCTION_NAME = "MXHXComponent_initMXHX";
	private static final LANGUAGE_MAPPINGS_2022 = [
		// @:formatter:off
		TYPE_ANY => TYPE_ANY,
		TYPE_ARRAY => TYPE_ARRAY,
		TYPE_BOOL => TYPE_BOOL,
		TYPE_CLASS => TYPE_CLASS,
		TYPE_EREG => TYPE_EREG,
		TYPE_FLOAT => TYPE_FLOAT,
		TYPE_INT => TYPE_INT,
		TYPE_STRING => TYPE_STRING,
		TYPE_UINT => TYPE_UINT,
		TYPE_XML => TYPE_XML,
		// @:formatter:on
	];
	private static final LANGUAGE_TYPES_ASSIGNABLE_BY_TEXT = [
		// @:formatter:off
		TYPE_BOOL,
		TYPE_CLASS,
		TYPE_EREG,
		TYPE_FLOAT,
		TYPE_INT,
		TYPE_STRING,
		TYPE_UINT,
		// @:formatter:on
	];
	private static final ROOT_LANGUAGE_TAGS:Array<String> = [
		// @:formatter:off
		TAG_BINDING,
		TAG_DECLARATIONS,
		TAG_LIBRARY, // must be first child too
		TAG_METADATA,
		TAG_PRIVATE, // must be last child too
		TAG_REPARENT,
		TAG_SCRIPT,
		TAG_STYLE,
		// @:formatter:on
	];
	private static final UNSUPPORTED_LANGUAGE_TAGS:Array<String> = [
		// @:formatter:off
		TAG_BINDING,
		TAG_COMPONENT,
		TAG_DEFINITION,
		TAG_DESIGN_LAYER,
		TAG_LIBRARY,
		TAG_METADATA,
		TAG_MODEL,
		TAG_PRIVATE,
		TAG_REPARENT,
		TAG_SCRIPT,
		TAG_STYLE,
		// @:formatter:on
	];
	private static var componentCounter = 0;
	private static var objectCounter = 0;
	private static var posInfos:{min:Int, max:Int, file:String};
	private static var languageUri:String = null;
	private static var mxhxResolver:MXHXMacroResolver;
	private static var manifests:Map<String, Map<String, String>> = [];
	#end

	/**
		Populates fields in a class using markup in a file. Similar to
		`withFile()`, but it's a build macro instead — which gives developers
		more control over the generated class. For instance, it's possible to
		define additional fields and methods to the class, and to instantiate it
		on demand.
	**/
	public macro static function build(?filePath:String):Array<Field> {
		var localClass = Context.getLocalClass().get();
		if (filePath == null) {
			filePath = localClass.name + ".mxhx";
		}
		var mxhxText = loadMXHXFile(filePath);
		posInfos = {file: filePath, min: 0, max: mxhxText.length};
		createResolver();
		var mxhxParser = new MXHXParser(mxhxText, posInfos.file);
		var mxhxData = mxhxParser.parse();
		if (mxhxData.problems.length > 0) {
			for (problem in mxhxData.problems) {
				reportError(problem.message, sourceLocationToContextPosition(problem));
			}
			return null;
		}

		var superClass = localClass.superClass;
		var resolvedTag = mxhxResolver.resolveTag(mxhxData.rootTag);
		var resolvedType:BaseType = null;
		if (resolvedTag != null) {
			switch (resolvedTag) {
				case ClassSymbol(c, params):
					resolvedType = c;
				case AbstractSymbol(a, params):
					resolvedType = a;
				case EnumSymbol(e, params):
					resolvedType = e;
				default:
			}
		}
		if (resolvedType == null) {
			reportError('Could not resolve super class type for \'${localClass.name}\'', localClass.pos);
			return null;
		}
		var expectedSuperClass = resolvedType.module;
		if (superClass == null || Std.string(superClass.t) != expectedSuperClass) {
			reportError('Class ${localClass.name} must extend ${expectedSuperClass}', localClass.pos);
			return null;
		}

		var buildFields = Context.getBuildFields();
		handleRootTag(mxhxData.rootTag, INIT_FUNCTION_NAME, buildFields);
		return buildFields;
	}

	/**
		Instantiates a component from a file containing markup.

		Calling `withFile()` multiple times will re-use the same generated
		class each time.
	**/
	public macro static function withFile(filePath:String):Expr {
		filePath = resolveFilePath(filePath);
		var typeDef:TypeDefinition = null;
		if (FILE_PATH_TO_TYPE_DEFINITION.exists(filePath)) {
			// for duplicate files, re-use the existing type definition
			typeDef = FILE_PATH_TO_TYPE_DEFINITION.get(filePath);
		}
		if (typeDef == null) {
			var mxhxText = loadMXHXFile(filePath);
			var componentName = Path.withoutExtension(Path.withoutDirectory(filePath));
			typeDef = createTypeDefinitionFromString(mxhxText, componentName);
			FILE_PATH_TO_TYPE_DEFINITION.set(filePath, typeDef);
		}
		if (typeDef == null) {
			return macro null;
		}
		var typePath = {name: typeDef.name, pack: typeDef.pack};
		return macro new $typePath();
	}

	/**
		Instantiates a component from markup.
	**/
	public macro static function withMarkup(input:ExprOf<String>):Expr {
		posInfos = PositionTools.getInfos(input.pos);
		// skip the quotes
		posInfos.min++;
		posInfos.max--;
		var mxhxText:String = null;
		switch (input.expr) {
			case EMeta({name: META_MARKUP}, {expr: EConst(CString(s))}):
				mxhxText = s;
			case EConst(CString(s)):
				mxhxText = s;
			case _:
				throw new haxe.macro.Expr.Error("Expected markup or string literal", input.pos);
		}
		var componentName = 'MXHXComponent_InlineMarkup_${componentCounter}';
		componentCounter++;
		var typeDef = createTypeDefinitionFromString(mxhxText, componentName);
		if (typeDef == null) {
			return macro null;
		}
		var typePath = {name: typeDef.name, pack: typeDef.pack};
		return macro new $typePath();
	}

	#if macro
	/**
		Adds a custom mapping from a namespace URI to a list of components in
		the namespace.
	**/
	public static function registerMappings(uri:String, mappings:Map<String, String>):Void {
		manifests.set(uri, mappings);
	}

	/**
		Adds a custom mapping from a namespace URI to a list of components in
		the namespace using a manifest file.
	**/
	public static function registerManifest(uri:String, manifestPath:String):Void {
		if (!FileSystem.exists(manifestPath)) {
			Context.fatalError('Manifest file not found: ${manifestPath}', Context.currentPos());
		}
		var content = File.getContent(manifestPath);
		var xml:Xml = null;
		try {
			xml = Xml.parse(content);
		} catch (e:Dynamic) {
			reportError('Error parsing invalid XML in manifest file: ${manifestPath}', Context.currentPos());
			return;
		}
		var mappings:Map<String, String> = [];
		for (componentXml in xml.firstElement().elementsNamed("component")) {
			var xmlName = componentXml.get("id");
			var qname = componentXml.get("class");
			mappings.set(xmlName, qname);
		}
		manifests.set(uri, mappings);
	}

	private static function createResolver():Void {
		mxhxResolver = new MXHXMacroResolver();
		mxhxResolver.registerManifest(LANGUAGE_URI_BASIC_2022, LANGUAGE_MAPPINGS_2022);
		mxhxResolver.registerManifest(LANGUAGE_URI_FULL_2022, LANGUAGE_MAPPINGS_2022);
		for (uri => mappings in manifests) {
			mxhxResolver.registerManifest(uri, mappings);
		}
	}

	private static function createTypeDefinitionFromString(mxhxText:String, componentName:String):TypeDefinition {
		var mxhxParser = new MXHXParser(mxhxText, posInfos.file);
		var mxhxData = mxhxParser.parse();
		if (mxhxData.problems.length > 0) {
			for (problem in mxhxData.problems) {
				reportError(problem.message, sourceLocationToContextPosition(problem));
			}
			return null;
		}
		createResolver();
		var typeDef:TypeDefinition = createTypeDefinitionFromMXHXData(mxhxData, componentName);
		mxhxResolver = null;
		if (typeDef == null) {
			return null;
		}
		return typeDef;
	}

	private static function createTypeDefinitionFromMXHXData(mxhxData:IMXHXData, componentName:String):TypeDefinition {
		var buildFields:Array<Field> = [];
		var rootTag = mxhxData.rootTag;
		var resolvedTag = handleRootTag(rootTag, INIT_FUNCTION_NAME, buildFields);

		var resolvedType:BaseType = null;
		var resolvedClass:ClassType = null;
		if (resolvedTag != null) {
			switch (resolvedTag) {
				case ClassSymbol(c, params):
					resolvedClass = c;
					resolvedType = c;
				case AbstractSymbol(a, params):
					resolvedClass = null;
					resolvedType = a;
				case EnumSymbol(e, params):
					resolvedClass = null;
					resolvedType = e;
				default:
					resolvedClass = null;
					resolvedType = null;
			}
		}

		var typeDef:TypeDefinition = null;
		if (resolvedClass != null) {
			var superClassTypePath = {name: resolvedClass.name, pack: resolvedClass.pack};
			typeDef = macro class $componentName extends $superClassTypePath {};
		} else if (resolvedType != null) {
			reportError('Tag ${rootTag.name} cannot be used as a base class', sourceLocationToContextPosition(rootTag));
			typeDef = macro class $componentName {};
		} else {
			reportError('Tag ${rootTag.name} could not be resolved to a class', sourceLocationToContextPosition(rootTag));
			typeDef = macro class $componentName {};
		}
		for (buildField in buildFields) {
			typeDef.fields.push(buildField);
		}
		Context.defineType(typeDef);
		return typeDef;
	}

	private static function handleRootTag(tagData:IMXHXTagData, initFunctionName:String, buildFields:Array<Field>):MXHXSymbol {
		objectCounter = 0;
		var prefixMap = tagData.parent.getPrefixMapForTag(tagData);
		var languageUris:Array<String> = [];
		for (uri in prefixMap.getAllUris()) {
			if (LANGUAGE_URIS.indexOf(uri) != -1) {
				languageUris.push(uri);
				if (uri == LANGUAGE_URI_FULL_2022) {
					var prefixes = prefixMap.getPrefixesForUri(uri);
					for (prefix in prefixes) {
						var attrData = tagData.getAttributeData('xmlns:$prefix');
						if (attrData != null) {
							Context.warning('Namespace \'$uri\' is experimental. Using namespace \'$LANGUAGE_URI_BASIC_2022\' instead is recommended.',
								sourceLocationToContextPosition(attrData));
						}
					}
				}
			}
		}
		if (languageUris.length > 1) {
			for (uri in languageUris) {
				var prefixes = prefixMap.getPrefixesForUri(uri);
				for (prefix in prefixes) {
					var attrData = tagData.getAttributeData('xmlns:$prefix');
					if (attrData != null) {
						reportError("Only one language namespace may be used in an MXHX document.", sourceLocationToContextPosition(attrData));
					}
				}
			}
		}
		if (languageUris.length > 0) {
			languageUri = languageUris[0];
		} else {
			languageUri = null;
		}
		var resolvedTag = mxhxResolver.resolveTag(tagData);
		var generatedFields:Array<Field> = [];
		var bodyExprs:Array<Expr> = [];
		var attributeAndChildNames:Map<String, Bool> = [];
		handleAttributesOfInstanceTag(tagData, resolvedTag, KEYWORD_THIS, bodyExprs, attributeAndChildNames);
		handleChildUnitsOfInstanceTag(tagData, resolvedTag, KEYWORD_THIS, generatedFields, bodyExprs, attributeAndChildNames);
		var constructorExprs:Array<Expr> = [];
		constructorExprs.push(macro this.$initFunctionName());
		var fieldPos = sourceLocationToContextPosition(tagData);
		var existingConstructor = Lambda.find(buildFields, f -> f.name == KEYWORD_NEW);
		if (existingConstructor != null) {
			switch (existingConstructor.kind) {
				case FFun(f):
					var blockExprs:Array<Expr> = null;
					var superIndex = -1;
					switch (f.expr.expr) {
						case EBlock(exprs):
							blockExprs = exprs;
							for (i in 0...blockExprs.length) {
								var exprInBlock = exprs[i];
								switch (exprInBlock.expr) {
									case ECall(e, params):
										switch (e.expr) {
											case EConst(CIdent("super")):
												superIndex = i;
											default:
										}
									default:
								}
							}
						default:
					}
					if (superIndex == -1) {
						constructorExprs = constructorExprs.concat(blockExprs);
					} else {
						var beginning = blockExprs.slice(0, superIndex + 1);
						var end = blockExprs.slice(superIndex + 1);
						constructorExprs = beginning.concat(constructorExprs).concat(end);
					}
					f.expr = macro $b{constructorExprs};
					existingConstructor.kind = FFun(f);
				default:
			}
		} else {
			if (resolvedTag != null) {
				switch (resolvedTag) {
					case ClassSymbol(c, params):
						constructorExprs.unshift(macro super());
					default:
				}
			}
			buildFields.push({
				name: KEYWORD_NEW,
				pos: fieldPos,
				kind: FFun({
					args: [],
					ret: macro :Void,
					expr: macro $b{constructorExprs}
				}),
				access: [APublic]
			});
		}
		buildFields.push({
			name: initFunctionName,
			pos: fieldPos,
			kind: FFun({
				args: [],
				ret: macro :Void,
				expr: macro $b{bodyExprs},
			}),
			access: [APrivate],
			meta: [
				{
					name: META_NO_COMPLETION,
					pos: fieldPos
				}
			]
		});
		for (field in generatedFields) {
			buildFields.push(field);
		}
		var id:String = null;
		var idAttr = tagData.getAttributeData(PROPERTY_ID);
		if (idAttr != null) {
			reportError('id attribute is not allowed on the root tag of a component.', sourceLocationToContextPosition(idAttr));
		}
		return resolvedTag;
	}

	private static function handleAttributesOfInstanceTag(tagData:IMXHXTagData, parentSymbol:MXHXSymbol, targetIdentifier:String, initExprs:Array<Expr>,
			attributeAndChildNames:Map<String, Bool>):Void {
		for (attribute in tagData.attributeData) {
			handleAttributeOfInstanceTag(attribute, parentSymbol, targetIdentifier, initExprs, attributeAndChildNames);
		}
	}

	private static function handleAttributeOfInstanceTag(attrData:IMXHXTagAttributeData, parentSymbol:MXHXSymbol, targetIdentifier:String,
			initExprs:Array<Expr>, attributeAndChildNames:Map<String, Bool>):Void {
		if (attrData.name == PROPERTY_XMLNS || attrData.prefix == PROPERTY_XMLNS) {
			// skip xmlns="" or xmlns:prefix=""
			return;
		}
		if (attributeAndChildNames.exists(attrData.name)) {
			reportError('Field \'${attrData.name}\' is already specified for element \'${attrData.parentTag.name}\'',
				sourceLocationToContextPosition(attrData));
			return;
		}
		attributeAndChildNames.set(attrData.name, true);
		if (attrData.stateName != null) {
			errorStatesNotSupported(attrData);
			return;
		}
		var resolved = mxhxResolver.resolveAttribute(attrData);
		if (resolved == null) {
			var isAnyOrDynamic = switch (parentSymbol) {
				case AbstractSymbol(a, params): a.pack.length == 0 && (a.name == TYPE_ANY || a.name == TYPE_DYNAMIC);
				default: null;
			}
			if (isAnyOrDynamic && attrData.name != PROPERTY_ID) {
				var valueExpr = createValueExprForDynamic(attrData.rawValue);
				var setExpr = macro Reflect.setField($i{targetIdentifier}, $v{attrData.shortName}, ${valueExpr});
				initExprs.push(setExpr);
				return;
			}
			if (attrData.name == PROPERTY_ID) {
				// id is a special attribute that doesn't need to resolve
				return;
			}
			if (attrData.name == PROPERTY_TYPE) {
				// type is a special attribute of Array that doesn't need to resolve
				switch (parentSymbol) {
					case ClassSymbol(c, params):
						if (c.pack.length == 0 && c.name == TYPE_ARRAY) {
							return;
						}
					default:
				}
			}
			errorAttributeUnexpected(attrData);
			return;
		}
		switch (resolved) {
			case EventSymbol(e, t):
				if (languageUri == LANGUAGE_URI_BASIC_2022) {
					errorEventsNotSupported(attrData);
					return;
				} else {
					var eventName = MXHXMacroTools.getEventName(e);
					var eventExpr = Context.parse(attrData.rawValue, sourceLocationToContextPosition(attrData));
					var addEventExpr = macro $i{targetIdentifier}.addEventListener($v{eventName}, (event) -> ${eventExpr});
					initExprs.push(addEventExpr);
				}
			case FieldSymbol(f, t):
				var attrValue = handleTextContent(attrData.rawValue, attrData);
				var valueExpr = createValueExprForFieldAttribute(f, attrValue, attrData);
				var fieldName = f.name;
				var setExpr = macro $i{targetIdentifier}.$fieldName = ${valueExpr};
				initExprs.push(setExpr);
			default:
				errorAttributeUnexpected(attrData);
		}
	}

	private static function handleXmlTag(tagData:IMXHXTagData, generatedFields:Array<Field>):Expr {
		var localVarName = "object";
		var childTypePath:TypePath = {name: TYPE_XML, pack: []};

		var id:String = null;
		var idAttr = tagData.getAttributeData(PROPERTY_ID);
		if (idAttr != null) {
			id = idAttr.rawValue;
		}
		var setIDExpr:Expr = null;

		if (id != null) {
			generatedFields.push({
				name: id,
				pos: sourceLocationToContextPosition(idAttr),
				kind: FVar(TPath(childTypePath)),
				access: [APublic]
			});
			setIDExpr = macro this.$id = $i{localVarName};
		} else {
			id = Std.string(objectCounter);
			objectCounter++;
		}

		var xmlDoc = Xml.createDocument();
		var current = tagData.getFirstChildUnit();
		var parentStack:Array<Xml> = [xmlDoc];
		var tagDataStack:Array<IMXHXTagData> = [];
		while (current != null) {
			if ((current is IMXHXTagData)) {
				var tagData:IMXHXTagData = cast current;
				if (tagData.isOpenTag()) {
					var elementChild = Xml.createElement(tagData.name);
					for (attrData in tagData.attributeData) {
						elementChild.set(attrData.name, attrData.rawValue);
					}
					parentStack[parentStack.length - 1].addChild(elementChild);
					if (!tagData.isEmptyTag()) {
						parentStack.push(elementChild);
						tagDataStack.push(tagData);
					}
				}
			} else if ((current is IMXHXTextData)) {
				var textData:IMXHXTextData = cast current;
				var textChild = switch (textData.textType) {
					case Text | Whitespace: Xml.createPCData(textData.content);
					case CData: Xml.createCData(textData.content);
					case Comment | DocComment: Xml.createComment(textData.content);
				}
				parentStack[parentStack.length - 1].addChild(textChild);
			} else if ((current is IMXHXInstructionData)) {
				var instructionData:IMXHXInstructionData = cast current;
				var instructionChild = Xml.createProcessingInstruction(instructionData.instructionText);
				parentStack[parentStack.length - 1].addChild(instructionChild);
			}
			if (tagDataStack.length > 0 && tagDataStack[tagDataStack.length - 1] == current) {
				// ust added a tag to the stack, so read its children
				var tagData:IMXHXTagData = cast current;
				current = tagData.getFirstChildUnit();
			} else {
				current = current.getNextSiblingUnit();
			}
			// if the top-most tag on the stack has no more child units,
			// return to its parent tag
			while (current == null && tagDataStack.length > 0) {
				var parentTag = tagDataStack.pop();
				parentStack.pop();
				current = parentTag.getNextSiblingUnit();
			}
		}

		var xmlString = xmlDoc.toString();
		return macro Xml.parse($v{xmlString});
	}

	private static function handleInstanceTag(tagData:IMXHXTagData, assignedToType:Type, generatedFields:Array<Field>):Expr {
		var resolvedTag = mxhxResolver.resolveTag(tagData);
		if (resolvedTag == null) {
			errorTagUnexpected(tagData);
			return null;
		}
		var resolvedType:BaseType = null;
		var resolvedTypeParams:Array<Type> = null;
		var resolvedClass:ClassType = null;
		var resolvedEnum:EnumType = null;
		var isArray = false;
		if (resolvedTag != null) {
			switch (resolvedTag) {
				case ClassSymbol(c, params):
					resolvedType = c;
					resolvedTypeParams = params;
					resolvedClass = c;
					resolvedEnum = null;
					isArray = resolvedType.pack.length == 0 && resolvedType.name == TYPE_ARRAY;
				case AbstractSymbol(a, params):
					resolvedType = a;
					resolvedTypeParams = params;
					resolvedClass = null;
					resolvedEnum = null;
					isArray = false;
				case EnumSymbol(e, params):
					resolvedType = e;
					resolvedTypeParams = params;
					resolvedClass = null;
					resolvedEnum = e;
					isArray = false;
				case EnumFieldSymbol(f, t):
					switch (t) {
						case EnumSymbol(e, params):
							resolvedType = e;
							resolvedTypeParams = params;
							resolvedClass = null;
							resolvedEnum = e;
							isArray = false;
						default:
							errorTagUnexpected(tagData);
					}
					return createInitExpr(tagData.parentTag, resolvedType, resolvedEnum, generatedFields);
				default:
					errorTagUnexpected(tagData);
			}
		}

		var localVarName = "object";
		var setFieldExprs:Array<Expr> = [];
		var attributeAndChildNames:Map<String, Bool> = [];
		handleAttributesOfInstanceTag(tagData, resolvedTag, localVarName, setFieldExprs, attributeAndChildNames);
		handleChildUnitsOfInstanceTag(tagData, resolvedTag, localVarName, generatedFields, setFieldExprs, attributeAndChildNames);

		var childTypePath:TypePath = null;
		if (resolvedType == null) {
			// this shouldn't happen
			childTypePath = {name: TYPE_DYNAMIC, pack: []};
		} else {
			childTypePath = {name: resolvedType.name, pack: resolvedType.pack};
			if (isArray) {
				var paramType:ComplexType = null;
				if (resolvedTypeParams.length > 0) {
					switch (resolvedTypeParams[0]) {
						case null:
							// if null, the type was explicit, but could not be resolved
							var attrData = tagData.getAttributeData(PROPERTY_TYPE);
							if (attrData != null) {
								reportError('The type parameter \'${attrData.rawValue}\' for tag \'<${tagData.name}>\' cannot be resolved',
									sourceLocationToContextPosition(attrData));
							} else {
								reportError('Resolved tag \'<${tagData.name}>\' to type \'${resolvedType.name}\', but type parameter is missing',
									sourceLocationToContextPosition(attrData));
							}
						case TMono(t):
							// if TMono, the type was not specified
							if (t.get() == null && assignedToType != null) {
								// if this is being assigned to a field, we can
								// infer the correct type from the field's type
								switch (assignedToType) {
									case TInst(t, params):
										var classType = t.get();
										if (classType.pack.length == 0 && classType.name == TYPE_ARRAY && params.length > 0) {
											paramType = TypeTools.toComplexType(params[0]);
										}
									default:
								}
							}
							if (paramType == null) {
								// finally, try to infer the correct type from
								// the items in the array
								var currentChild = tagData.getFirstChildTag(true);
								var resolvedChildType:Type = null;
								while (currentChild != null) {
									var currentChildType = mxhxResolver.resolveTagAsMacroType(currentChild);
									resolvedChildType = MXHXMacroTools.getUnifiedType(currentChildType, resolvedChildType);
									if (resolvedChildType == null) {
										reportError('Arrays of mixed types are only allowed if the type is forced to Array<Dynamic>',
											sourceLocationToContextPosition(currentChild));
									}
									currentChild = currentChild.getNextSiblingTag(true);
								}
								if (resolvedChildType != null) {
									paramType = TypeTools.toComplexType(resolvedChildType);
								}
							}
						default:
							paramType = TypeTools.toComplexType(resolvedTypeParams[0]);
					}
					if (paramType == null) {
						paramType = TPath({name: TYPE_DYNAMIC, pack: []});
					}
					childTypePath.params = [TPType(paramType)];
				}
			}
		}

		var returnTypePath = childTypePath;
		if (resolvedType != null && !isArray && resolvedType.params.length > 0) {
			returnTypePath = {name: TYPE_DYNAMIC, pack: []};
		}
		var id:String = null;
		var idAttr = tagData.getAttributeData(PROPERTY_ID);
		if (idAttr != null) {
			id = idAttr.rawValue;
		}
		var setIDExpr:Expr = null;
		if (id != null) {
			generatedFields.push({
				name: id,
				pos: sourceLocationToContextPosition(idAttr),
				kind: FVar(TPath(childTypePath)),
				access: [APublic]
			});
			setIDExpr = macro this.$id = $i{localVarName};
		} else {
			// field names can't start with a number, so starting a generated
			// id with a number won't conflict with real fields
			id = Std.string(objectCounter);
			objectCounter++;
		}
		if (setIDExpr != null) {
			setFieldExprs.push(setIDExpr);
		}
		var bodyExpr:Expr = null;
		if (resolvedEnum != null || isLanguageTypeAssignableFromText(resolvedType)) {
			// no need for a function. return the simple expression.
			// handleChildUnitsOfInstanceTag() checks for too many children
			// so no need to worry about that here
			return setFieldExprs[0];
		} else if (resolvedClass == null) {
			bodyExpr = macro {
				var $localVarName:Dynamic = {};
				$b{setFieldExprs};
				return $i{localVarName};
			}
		} else {
			bodyExpr = macro {
				var $localVarName = new $childTypePath();
				$b{setFieldExprs};
				return $i{localVarName};
			}
		}
		var functionName = "createMXHXObject_" + id;
		var fieldPos = sourceLocationToContextPosition(idAttr != null ? idAttr : tagData);

		generatedFields.push({
			name: functionName,
			pos: fieldPos,
			kind: FFun({
				args: [],
				ret: TPath(returnTypePath),
				expr: bodyExpr
			}),
			access: [APrivate],
			meta: [
				{
					name: META_NO_COMPLETION,
					pos: fieldPos
				}
			]
		});
		return macro $i{functionName}();
	}

	private static function tagContainsOnlyText(tagData:IMXHXTagData):Bool {
		var child = tagData.getFirstChildUnit();
		do {
			if ((child is IMXHXTextData)) {
				var textData:IMXHXTextData = cast child;
				switch (textData.textType) {
					case Text | CData | Whitespace:
					default:
						if (!canIgnoreTextData(textData)) {
							return false;
						}
				}
			} else {
				return false;
			}
			child = child.getNextSiblingUnit();
		} while (child != null);
		return true;
	}

	private static function handleInstanceTagEnumValue(tagData:IMXHXTagData, t:BaseType, generatedFields:Array<Field>):Expr {
		var initExpr = createEnumFieldInitExpr(tagData, generatedFields);
		var idAttr = tagData.getAttributeData(PROPERTY_ID);
		if (idAttr != null) {
			var id = idAttr.rawValue;
			var typePath:TypePath = {pack: t.pack, name: t.name, params: null};
			if (t.pack.length == 0 && t.name == TYPE_CLASS) {
				typePath.params = [TPType(TPath({pack: [], name: TYPE_DYNAMIC}))];
			}
			generatedFields.push({
				name: id,
				pos: sourceLocationToContextPosition(idAttr),
				kind: FVar(TPath(typePath)),
				access: [APublic]
			});
			initExpr = macro this.$id = $initExpr;
		}
		return initExpr;
	}

	private static function createEnumFieldInitExpr(tagData:IMXHXTagData, generatedFields:Array<Field>):Expr {
		var child = tagData.getFirstChildUnit();
		var childTag:IMXHXTagData = null;
		do {
			if ((child is IMXHXTagData)) {
				if (childTag != null) {
					errorTagUnexpected(cast child);
					break;
				}
				childTag = cast child;
			} else if ((child is IMXHXTextData)) {
				var textData:IMXHXTextData = cast child;
				if (!canIgnoreTextData(textData)) {
					errorTextUnexpected(textData);
					break;
				}
			}
			child = child.getNextSiblingUnit();
		} while (child != null);
		if (childTag == null) {
			errorTagUnexpected(tagData);
		}
		var resolvedTag = mxhxResolver.resolveTag(childTag);
		if (resolvedTag == null) {
			errorTagUnexpected(childTag);
		}
		switch (resolvedTag) {
			case EnumFieldSymbol(f, t):
				var resolvedEnum:EnumType;
				switch (t) {
					case EnumSymbol(e, params):
						resolvedEnum = e;
					default:
				}
				switch (f.type) {
					case TEnum(t, params):
						var fieldName = f.name;
						if (resolvedEnum != null) {
							var resolvedEnumName = resolvedEnum.name;
							if (resolvedEnum.pack.length > 0) {
								var fieldExprParts = resolvedEnum.pack.concat([resolvedEnum.name, fieldName]);
								return macro $p{fieldExprParts};
							}
						}
						return macro $i{fieldName};
					case TFun(args, ret):
						var initArgs:Array<Expr> = [];
						var attrLookup:Map<String, IMXHXTagAttributeData> = [];
						var tagLookup:Map<String, IMXHXTagData> = [];
						for (attrData in childTag.attributeData) {
							attrLookup.set(attrData.shortName, attrData);
						}
						var grandChildTag = childTag.getFirstChildTag(true);
						while (grandChildTag != null) {
							tagLookup.set(grandChildTag.shortName, grandChildTag);
							grandChildTag = grandChildTag.getNextSiblingTag(true);
						}
						for (arg in args) {
							var argName = arg.name;
							if (attrLookup.exists(argName)) {
								var attrData = attrLookup.get(argName);
								attrLookup.remove(argName);
								var valueExpr = createValueExprForType(arg.t, attrData.rawValue, false, attrData);
								initArgs.push(valueExpr);
							} else if (tagLookup.exists(argName)) {
								var grandChildTag = tagLookup.get(argName);
								tagLookup.remove(argName);
								var valueExpr = createValueExprForFieldTag(grandChildTag, null, null, arg.t, generatedFields);
								initArgs.push(valueExpr);
							} else if (arg.opt) {
								initArgs.push(macro null);
							} else {
								reportError('Value \'${arg.name}\' is required by tag \'<${childTag.name}>\'', sourceLocationToContextPosition(childTag));
							}
						}
						for (tagName => grandChildTag in tagLookup) {
							errorTagUnexpected(grandChildTag);
						}
						for (attrName => attrData in attrLookup) {
							errorAttributeUnexpected(attrData);
						}
						var fieldName = f.name;
						if (resolvedEnum != null) {
							var resolvedEnumName = resolvedEnum.name;
							if (resolvedEnum.pack.length > 0) {
								var fieldExprParts = resolvedEnum.pack.concat([resolvedEnum.name, fieldName]);
								return macro $p{fieldExprParts}($a{initArgs});
							}
						}
						return macro $i{fieldName}($a{initArgs});
					default:
						errorTagUnexpected(childTag);
				}
			default:
				errorUnexpected(childTag);
				return null;
		}
		return null;
	}

	private static function handleInstanceTagAssignableFromText(tagData:IMXHXTagData, t:BaseType, e:EnumType, generatedFields:Array<Field>):Expr {
		var initExpr:Expr = null;
		var child = tagData.getFirstChildUnit();
		var pendingText:String = null;
		var pendingTextIncludesCData = false;
		do {
			if (child == null) {
				if (initExpr != null) {
					errorTagUnexpected(tagData);
				} else {
					initExpr = createDefaultValueExprForBaseType(t, tagData);
				}
				// no more children
				break;
			} else if ((child is IMXHXTextData)) {
				var textData:IMXHXTextData = cast child;
				switch (textData.textType) {
					case Text:
						var content = handleTextContent(textData.content, textData);
						if (pendingText == null) {
							pendingText = "";
						}
						pendingText += content;
					case CData:
						if (pendingText == null) {
							pendingText = "";
						}
						pendingText += textData.content;
						pendingTextIncludesCData = true;
					case Whitespace:
						if (t.name == TYPE_STRING && t.pack.length == 0) {
							if (pendingText == null) {
								pendingText = "";
							}
							pendingText += textData.content;
						}
					default:
						if (!canIgnoreTextData(textData)) {
							errorTextUnexpected(textData);
							break;
						}
				}
			} else {
				errorUnexpected(child);
			}
			child = child.getNextSiblingUnit();
			if (child == null && pendingText != null) {
				if (e != null) {
					var value = StringTools.trim(pendingText);
					initExpr = macro $i{value};
				} else {
					initExpr = createValueExprForBaseType(t, pendingText, pendingTextIncludesCData, tagData);
				}
			}
		} while (child != null || initExpr == null);
		var idAttr = tagData.getAttributeData(PROPERTY_ID);
		if (idAttr != null) {
			var id = idAttr.rawValue;
			var typePath:TypePath = {pack: t.pack, name: t.name, params: null};
			if (t.pack.length == 0 && t.name == TYPE_CLASS) {
				typePath.params = [TPType(TPath({pack: [], name: TYPE_DYNAMIC}))];
			}
			generatedFields.push({
				name: id,
				pos: sourceLocationToContextPosition(idAttr),
				kind: FVar(TPath(typePath)),
				access: [APublic]
			});
			initExpr = macro this.$id = $initExpr;
		}
		return initExpr;
	}

	private static function handleTextContent(text:String, sourceLocation:IMXHXSourceLocation):String {
		var startIndex = 0;
		do {
			var bindingStartIndex = text.indexOf("{", startIndex);
			if (bindingStartIndex == -1) {
				break;
			}
			startIndex = bindingStartIndex + 1;
			if (bindingStartIndex > 0 && text.charAt(bindingStartIndex - 1) == "\\") {
				// remove the escaped { character
				text = text.substr(0, bindingStartIndex - 1) + text.substr(bindingStartIndex);
				startIndex--;
			} else {
				// valid start of binding if previous character is not a backslash
				var bindingEndIndex = text.indexOf("}", bindingStartIndex + 1);
				if (bindingEndIndex != -1) {
					errorBindingNotSupported(sourceLocation);
					return null;
				}
			}
		} while (true);
		return text;
	}

	private static function handleChildUnitsOfDeclarationsTag(tagData:IMXHXTagData, generatedFields:Array<Field>, initExprs:Array<Expr>):Void {
		var current = tagData.getFirstChildUnit();
		while (current != null) {
			handleChildUnitOfArrayOrDeclarationsTag(current, generatedFields, initExprs);
			current = current.getNextSiblingUnit();
		}
	}

	private static function createInitExpr(tagData:IMXHXTagData, t:BaseType, e:EnumType, generatedFields:Array<Field>):Expr {
		var initExpr:Expr = null;
		if (t.pack.length == 0 && t.name == TYPE_XML) {
			initExpr = handleXmlTag(tagData, generatedFields);
		} else if (e != null) {
			if (!tagContainsOnlyText(tagData)) {
				initExpr = handleInstanceTagEnumValue(tagData, t, generatedFields);
			} else {
				initExpr = handleInstanceTagAssignableFromText(tagData, t, e, generatedFields);
			}
		} else if (isLanguageTypeAssignableFromText(t)) {
			initExpr = handleInstanceTagAssignableFromText(tagData, t, e, generatedFields);
		} else {
			initExpr = handleInstanceTag(tagData, null, generatedFields);
		}
		var id = tagData.getRawAttributeValue(PROPERTY_ID);
		if (id != null) {
			initExpr = macro this.$id = $initExpr;
		}
		return initExpr;
	}

	private static function handleChildUnitOfArrayOrDeclarationsTag(unitData:IMXHXUnitData, generatedFields:Array<Field>, initExprs:Array<Expr>):Void {
		if ((unitData is IMXHXInstructionData)) {
			// safe to ignore
			return;
		}
		if ((unitData is IMXHXTextData)) {
			var textData:IMXHXTextData = cast unitData;
			if (!canIgnoreTextData(textData)) {
				errorTextUnexpected(textData);
			}
			return;
		}
		if (!(unitData is IMXHXTagData)) {
			errorUnexpected(unitData);
			return;
		}

		var tagData:IMXHXTagData = cast unitData;
		var parentIsRoot = tagData.parentTag == tagData.parent.rootTag;
		if (!checkUnsupportedLanguageTag(tagData)) {
			return;
		}
		if (!checkRootLanguageTag(tagData)) {
			return;
		}
		var resolvedTag = mxhxResolver.resolveTag(tagData);
		if (resolvedTag == null) {
			errorTagUnexpected(tagData);
			return;
		} else {
			switch (resolvedTag) {
				case ClassSymbol(c, params):
					var initExpr = createInitExpr(tagData, c, null, generatedFields);
					initExprs.push(initExpr);
					return;
				case AbstractSymbol(a, params):
					var initExpr = createInitExpr(tagData, a, null, generatedFields);
					initExprs.push(initExpr);
					return;
				case EnumSymbol(e, params):
					var initExpr = createInitExpr(tagData, e, e, generatedFields);
					initExprs.push(initExpr);
					return;
				default:
					errorTagUnexpected(tagData);
					return;
			}
		}
	}

	private static function handleChildUnitsOfInstanceTag(tagData:IMXHXTagData, parentSymbol:MXHXSymbol, targetIdentifier:String,
			generatedFields:Array<Field>, initExprs:Array<Expr>, attributeAndChildNames:Map<String, Bool>):Void {
		var parentType:BaseType = null;
		var parentClass:ClassType = null;
		var parentEnum:EnumType = null;
		var isArray = false;
		if (parentSymbol != null) {
			switch (parentSymbol) {
				case ClassSymbol(c, params):
					parentType = c;
					parentClass = c;
					parentEnum = null;
					isArray = c.pack.length == 0 && (c.name == TYPE_ARRAY);
				case AbstractSymbol(a, params):
					parentType = a;
					parentClass = null;
					parentEnum = null;
				case EnumSymbol(e, params):
					parentType = e;
					parentClass = null;
					parentEnum = e;
				default:
			}
		}

		if (parentEnum != null || isLanguageTypeAssignableFromText(parentType)) {
			initExprs.push(createInitExpr(tagData, parentType, parentEnum, generatedFields));
			return;
		}

		var defaultProperty:String = null;
		var currentClass = parentClass;
		while (currentClass != null) {
			defaultProperty = getDefaultProperty(currentClass);
			if (defaultProperty != null) {
				break;
			}
			var superClass = currentClass.superClass;
			if (superClass == null) {
				break;
			}
			currentClass = superClass.t.get();
		}
		if (defaultProperty != null) {
			handleChildUnitsOfInstanceTagWithDefaultProperty(tagData, parentSymbol, defaultProperty, targetIdentifier, generatedFields, initExprs,
				attributeAndChildNames);
			return;
		}

		var arrayChildren:Array<IMXHXUnitData> = isArray ? [] : null;
		var current = tagData.getFirstChildUnit();
		while (current != null) {
			handleChildUnitOfInstanceTag(current, parentSymbol, targetIdentifier, generatedFields, initExprs, attributeAndChildNames, arrayChildren);
			current = current.getNextSiblingUnit();
		}
		if (!isArray) {
			return;
		}

		var arrayExprs:Array<Expr> = [];
		for (child in arrayChildren) {
			handleChildUnitOfArrayOrDeclarationsTag(child, generatedFields, arrayExprs);
		}
		for (i in 0...arrayExprs.length) {
			var arrayExpr = arrayExprs[i];
			var initExpr = macro $i{targetIdentifier}[$v{i}] = $arrayExpr;
			initExprs.push(initExpr);
		}
	}

	private static function handleChildUnitsOfInstanceTagWithDefaultProperty(tagData:IMXHXTagData, parentSymbol:MXHXSymbol, defaultProperty:String,
			targetIdentifier:String, generatedFields:Array<Field>, initExprs:Array<Expr>, attributeAndChildNames:Map<String, Bool>):Void {
		var defaultChildren:Array<IMXHXUnitData> = [];
		var current = tagData.getFirstChildUnit();
		while (current != null) {
			handleChildUnitOfInstanceTag(current, parentSymbol, targetIdentifier, generatedFields, initExprs, attributeAndChildNames, defaultChildren);
			current = current.getNextSiblingUnit();
		}

		if (defaultChildren.length == 0) {
			return;
		}
		var resolvedField = mxhxResolver.resolveTagField(tagData, defaultProperty);
		var field = switch (resolvedField) {
			case FieldSymbol(f, t): f;
			case null: null;
			default: null;
		}
		if (field == null) {
			Context.fatalError('Default property \'${defaultProperty}\' not found for tag \'<${tagData.name}>\'', sourceLocationToContextPosition(tagData));
			return;
		}

		var fieldName = field.name;
		attributeAndChildNames.set(fieldName, true);

		var valueExpr = createValueExprForFieldTag(tagData, defaultChildren, field, null, generatedFields);
		var initExpr = macro $i{targetIdentifier}.$fieldName = ${valueExpr};
		initExprs.push(initExpr);
	}

	private static function checkUnsupportedLanguageTag(tagData:IMXHXTagData):Bool {
		for (unsupportedTagShortName in UNSUPPORTED_LANGUAGE_TAGS) {
			if (isLanguageTag(unsupportedTagShortName, tagData)) {
				errorTagNotSupported(tagData);
				return false;
			}
		}
		return true;
	}

	private static function checkRootLanguageTag(tagData:IMXHXTagData):Bool {
		for (rootTagShortName in ROOT_LANGUAGE_TAGS) {
			if (isLanguageTag(rootTagShortName, tagData)) {
				reportError('Tag \'<${tagData.name}>\' must be a child of the root element', sourceLocationToContextPosition(tagData));
				return false;
			}
		}
		return true;
	}

	private static function handleChildUnitOfInstanceTag(unitData:IMXHXUnitData, parentSymbol:MXHXSymbol, targetIdentifier:String,
			generatedFields:Array<Field>, initExprs:Array<Expr>, attributeAndChildNames:Map<String, Bool>, defaultChildren:Array<IMXHXUnitData>):Void {
		if ((unitData is IMXHXTagData)) {
			var tagData:IMXHXTagData = cast unitData;
			var parentIsRoot = tagData.parentTag == tagData.parent.rootTag;
			if (!checkUnsupportedLanguageTag(tagData)) {
				return;
			}
			if (!parentIsRoot) {
				if (!checkRootLanguageTag(tagData)) {
					return;
				}
			} else {
				if (isLanguageTag(TAG_DECLARATIONS, tagData)) {
					checkForInvalidAttributes(tagData, false);
					handleChildUnitsOfDeclarationsTag(tagData, generatedFields, initExprs);
					return;
				}
			}
			var resolvedTag = mxhxResolver.resolveTag(tagData);
			if (resolvedTag == null) {
				var isAnyOrDynamic = switch (parentSymbol) {
					case AbstractSymbol(a, params): a.pack.length == 0 && (a.name == TYPE_ANY || a.name == TYPE_DYNAMIC);
					default: false;
				}
				if (isAnyOrDynamic && tagData.prefix == tagData.parentTag.prefix) {
					checkForInvalidAttributes(tagData, false);
					if (tagData.stateName != null) {
						errorStatesNotSupported(tagData);
						return;
					}
					var fieldName = tagData.shortName;
					var valueExpr = createValueExprForFieldTag(tagData, null, null, null, generatedFields);
					var initExpr = macro $i{targetIdentifier}.$fieldName = ${valueExpr};
					initExprs.push(initExpr);
					return;
				}
				errorTagUnexpected(tagData);
				return;
			} else {
				switch (resolvedTag) {
					case EventSymbol(e, t):
						if (languageUri == LANGUAGE_URI_BASIC_2022) {
							errorEventsNotSupported(tagData);
							return;
						} else {
							var eventName = MXHXMacroTools.getEventName(e);
							var eventExpr:Expr = null;
							var unitData = tagData.getFirstChildUnit();
							while (unitData != null) {
								if (eventExpr != null) {
									errorUnexpected(unitData);
									return;
								}
								if ((unitData is IMXHXTextData)) {
									var textData:IMXHXTextData = cast unitData;
									if (canIgnoreTextData(textData)) {
										continue;
									}
									eventExpr = Context.parse(textData.content, sourceLocationToContextPosition(textData));
								} else {
									errorUnexpected(unitData);
									return;
								}
								unitData = unitData.getNextSiblingUnit();
							}
							if (eventExpr == null) {
								eventExpr = macro return;
							}
							var addEventExpr = macro $i{targetIdentifier}.addEventListener($v{eventName}, (event) -> ${eventExpr});
							initExprs.push(addEventExpr);
						}
					case FieldSymbol(f, t):
						if (attributeAndChildNames.exists(tagData.name)) {
							reportError('Field \'${tagData.name}\' is already specified for element \'${tagData.parentTag.name}\'',
								sourceLocationToContextPosition(tagData));
							return;
						}
						attributeAndChildNames.set(tagData.name, true);
						if (tagData.stateName != null) {
							errorStatesNotSupported(tagData);
							return;
						}
						checkForInvalidAttributes(tagData, false);
						var fieldName = f.name;
						var valueExpr = createValueExprForFieldTag(tagData, null, f, null, generatedFields);
						var initExpr = macro $i{targetIdentifier}.$fieldName = ${valueExpr};
						initExprs.push(initExpr);
						return;
					case ClassSymbol(c, params):
						if (defaultChildren == null) {
							errorTagUnexpected(tagData);
							return;
						}
						defaultChildren.push(unitData);
						return;
					case AbstractSymbol(a, params):
						if (defaultChildren == null) {
							errorTagUnexpected(tagData);
							return;
						}
						defaultChildren.push(unitData);
						return;
					case EnumSymbol(e, params):
						if (defaultChildren == null) {
							errorTagUnexpected(tagData);
							return;
						}
						defaultChildren.push(unitData);
						return;
					default:
						errorTagUnexpected(tagData);
						return;
				}
			}
		} else if ((unitData is IMXHXTextData)) {
			var textData:IMXHXTextData = cast unitData;
			if (canIgnoreTextData(textData)) {
				return;
			}
			if (defaultChildren == null) {
				errorTextUnexpected(textData);
				return;
			}
			defaultChildren.push(unitData);
			return;
		} else if ((unitData is IMXHXInstructionData)) {
			// safe to ignore
			return;
		} else {
			errorUnexpected(unitData);
			return;
		}
	}

	private static function createValueExprForFieldTag(tagData:IMXHXTagData, childUnits:Array<IMXHXUnitData>, field:ClassField, fieldType:Type,
			generatedFields:Array<Field>):Expr {
		var isArray = false;
		var isString = false;
		var fieldName:String = tagData.shortName;
		if (field != null) {
			fieldName = field.name;
			fieldType = field.type;
		}
		var currentFieldType = fieldType;
		while (currentFieldType != null) {
			switch (currentFieldType) {
				case TInst(t, params):
					var classType = t.get();
					isArray = classType.pack.length == 0 && classType.name == TYPE_ARRAY;
					isString = classType.pack.length == 0 && classType.name == TYPE_STRING;
					currentFieldType = null;
				case TLazy(f):
					currentFieldType = f();
				default:
					currentFieldType = null;
			}
		}
		var firstChildIsArrayTag = false;
		var valueExprs:Array<Expr> = [];
		var current = (childUnits != null) ? childUnits.shift() : tagData.getFirstChildUnit();
		while (current != null) {
			if (!isArray && valueExprs.length > 0) {
				// when the type is not array, multiple children are not allowed
				var isWhitespace = (current is IMXHXTextData) && cast(current, IMXHXTextData).textType == Whitespace;
				if (!isWhitespace) {
					errorUnexpected(current);
					return null;
				}
			}
			var valueExpr = createValueExprForUnitData(current, fieldType, generatedFields);
			if (valueExpr != null) {
				if (valueExprs.length == 0 && (current is IMXHXTagData)) {
					var tagData:IMXHXTagData = cast current;
					if (tagData.shortName == TYPE_ARRAY && tagData.uri == languageUri) {
						firstChildIsArrayTag = true;
					}
				}
				valueExprs.push(valueExpr);
			}
			current = (childUnits != null) ? childUnits.shift() : current.getNextSiblingUnit();
		}
		if (valueExprs.length == 0 && !isArray) {
			if (isString) {
				return macro "";
			}
			reportError('Value for field \'${fieldName}\' must not be empty', sourceLocationToContextPosition(tagData));
			return null;
		}

		if (isArray) {
			if (valueExprs.length == 1 && firstChildIsArrayTag) {
				return valueExprs[0];
			}

			var result:Array<Expr> = [];
			var localVarName = "array_" + fieldName;
			if (fieldType != null) {
				var localVarType = TypeTools.toComplexType(fieldType);
				result.push(macro var $localVarName:$localVarType = []);
			} else {
				result.push(macro var $localVarName:Array<Dynamic> = []);
			}
			for (i in 0...valueExprs.length) {
				var valueExpr = valueExprs[i];
				var initExpr = macro $i{localVarName}[$v{i}] = ${valueExpr};
				result.push(initExpr);
			}
			result.push(macro $i{localVarName});
			return macro $b{result};
		}
		// not an array
		return valueExprs[0];
	}

	private static function createValueExprForUnitData(unitData:IMXHXUnitData, assignedToType:Type, generatedFields:Array<Field>):Expr {
		if ((unitData is IMXHXTagData)) {
			var tagData:IMXHXTagData = cast unitData;
			return handleInstanceTag(tagData, assignedToType, generatedFields);
		} else if ((unitData is IMXHXTextData)) {
			var textData:IMXHXTextData = cast unitData;
			if (canIgnoreTextData(textData)) {
				return null;
			}
			if (assignedToType != null) {
				var fromCdata = switch (textData.textType) {
					case CData: true;
					default: false;
				}
				return createValueExprForType(assignedToType, textData.content, fromCdata, unitData);
			}
			return createValueExprForDynamic(textData.content);
		} else if ((unitData is IMXHXInstructionData)) {
			// safe to ignore
			return null;
		} else {
			errorUnexpected(unitData);
			return null;
		}
	}

	private static function isLanguageTag(expectedShortName:String, tagData:IMXHXTagData):Bool {
		return tagData != null && tagData.shortName == expectedShortName && LANGUAGE_URIS.indexOf(tagData.uri) != -1;
	}

	private static function isLanguageTypeAssignableFromText(t:BaseType):Bool {
		return t != null && t.pack.length == 0 && LANGUAGE_TYPES_ASSIGNABLE_BY_TEXT.contains(t.name);
	}

	private static function canIgnoreTextData(textData:IMXHXTextData):Bool {
		if (textData == null) {
			return true;
		}
		return switch (textData.textType) {
			case Whitespace | Comment | DocComment: true;
			default: false;
		}
	}

	private static function checkForInvalidAttributes(tagData:IMXHXTagData, allowId:Bool):Void {
		for (attrData in tagData.attributeData) {
			if (allowId && attrData.name == PROPERTY_ID) {
				continue;
			}
			reportError('Unknown field \'${attrData.name}\'', sourceLocationToContextPosition(attrData));
		}
	}

	private static function createValueExprForDynamic(value:String):Expr {
		if (value == VALUE_TRUE || value == VALUE_FALSE) {
			var boolValue = value == VALUE_TRUE;
			return macro $v{boolValue};
		}
		if (~/^-?[0-9]+?$/.match(value)) {
			var intValue = Std.parseInt(value);
			if (intValue == null) {
				var uintAsFloatValue = Std.parseFloat(value);
				var uintAsIntValue:UInt = Std.int(uintAsFloatValue);
				return macro $v{uintAsIntValue};
			}
			return macro $v{intValue};
		}
		if (~/^-?[0-9]+(\.[0-9]+)?(e\-?\d+)?$/.match(value)) {
			var floatValue = Std.parseFloat(value);
			return macro $v{floatValue};
		}
		if (~/^-?0x[0-9a-fA-F]+$/.match(value)) {
			var intValue = Std.parseInt(value);
			return macro $v{intValue};
		}
		if (value == VALUE_NAN) {
			return macro Math.NaN;
		} else if (value == VALUE_INFINITY) {
			return macro Math.POSITIVE_INFINITY;
		} else if (value == VALUE_NEGATIVE_INFINITY) {
			return macro Math.NEGATIVE_INFINITY;
		}
		// it can always be parsed as a string
		return macro $v{value};
	}

	private static function createValueExprForFieldAttribute(field:ClassField, value:String, attrData:IMXHXTagAttributeData):Expr {
		if (!field.isPublic) {
			reportError('Cannot set field \'${field.name}\' because it is not public', sourceLocationToContextPosition(attrData));
		}
		switch (field.kind) {
			case FVar(read, write):
			default:
				reportError('Cannot set field \'${field.name}\'', sourceLocationToContextPosition(attrData));
		}
		return createValueExprForType(field.type, value, false, attrData);
	}

	private static function createValueExprForType(type:Type, value:String, fromCdata:Bool, location:IMXHXSourceLocation):Expr {
		var baseType:BaseType = null;
		while (baseType == null) {
			switch (type) {
				case TInst(t, params):
					baseType = t.get();
					break;
				case TAbstract(t, params):
					var abstractType = t.get();
					if (abstractType.name == TYPE_NULL) {
						type = params[0];
					} else {
						if (abstractType.meta.has(":enum")) {
							return macro $i{value};
						} else {
							baseType = abstractType;
						}
					}
				case TEnum(t, params):
					var enumType = t.get();
					baseType = enumType;
					if (enumType.names.indexOf(value) != -1) {
						return macro $i{value};
					}
					reportError('Cannot parse a value of type \'${enumType.name}\' from \'${value}\'', sourceLocationToContextPosition(location));
					break;
				case TLazy(f):
					type = f();
				default:
					reportError('Cannot parse a value of type \'${type.getName()}\' from \'${value}\'', sourceLocationToContextPosition(location));
			}
		}
		if ((baseType.pack.length != 0 || baseType.name != TYPE_STRING) && value.length == 0) {
			reportError('Value of type \'${baseType.name}\' cannot be empty', sourceLocationToContextPosition(location));
		}
		return createValueExprForBaseType(baseType, value, fromCdata, location);
	}

	private static function createDefaultValueExprForBaseType(t:BaseType, location:IMXHXSourceLocation):Expr {
		if (t.pack.length == 0) {
			switch (t.name) {
				case TYPE_BOOL:
					return macro false;
				case TYPE_EREG:
					return macro ~//;
				case TYPE_FLOAT:
					return macro Math.NaN;
				case TYPE_INT:
					return macro 0;
				case TYPE_STRING:
					if ((location is IMXHXTagData)) {
						var parentTag = cast(location, IMXHXTagData).parentTag;
						if (isLanguageTag(TAG_DECLARATIONS, parentTag)) {
							return macro null;
						}
					}
					return macro "";
				case TYPE_UINT:
					return macro 0;
				default:
					return macro null;
			}
		}
		return macro null;
	}

	private static function createValueExprForBaseType(t:BaseType, value:String, fromCdata:Bool, location:IMXHXSourceLocation):Expr {
		if (t.pack.length == 0) {
			switch (t.name) {
				case TYPE_BOOL:
					value = StringTools.trim(value);
					if (value == VALUE_TRUE || value == VALUE_FALSE) {
						var boolValue = value == VALUE_TRUE;
						return macro $v{boolValue};
					}
				case TYPE_CLASS:
					value = StringTools.trim(value);
					var typeParts = value.split(".");
					return macro $p{typeParts};
				case TYPE_EREG:
					value = StringTools.trim(value);
					if (value.length == 0) {
						return macro ~//;
					}
					// if not empty, must start with ~/ and have final / before flags
					if (!~/^~\/.*?\/[a-z]*$/.match(value)) {
						reportError('Cannot parse a value of type \'${t.name}\' from \'${value}\'', sourceLocationToContextPosition(location));
						return null;
					}
					var endSlashIndex = value.lastIndexOf("/");
					var expression = value.substring(2, endSlashIndex);
					var flags = value.substr(endSlashIndex + 1);
					return macro new EReg($v{expression}, $v{flags});
				case TYPE_FLOAT:
					value = StringTools.trim(value);
					if (value == VALUE_NAN) {
						return macro Math.NaN;
					} else if (value == VALUE_INFINITY) {
						return macro Math.POSITIVE_INFINITY;
					} else if (value == VALUE_NEGATIVE_INFINITY) {
						return macro Math.NEGATIVE_INFINITY;
					}
					if (~/^-?0x[0-9a-fA-F]+$/.match(value)) {
						var floatValue = Std.parseInt(value);
						return macro $v{floatValue};
					}
					if (~/^-?[0-9]+(\.[0-9]+)?(e\-?\d+)?$/.match(value)) {
						var floatValue = Std.parseFloat(value);
						return macro $v{floatValue};
					}
				case TYPE_INT:
					value = StringTools.trim(value);
					var intValue = Std.parseInt(value);
					if (intValue != null) {
						return macro $v{intValue};
					}
				case TYPE_STRING:
					if ((location is IMXHXTagData)) {
						if (fromCdata) {
							var parentTag = cast(location, IMXHXTagData).parentTag;
							if (value.length == 0 && isLanguageTag(TAG_DECLARATIONS, parentTag)) {
								return macro null;
							}
							return macro $v{value};
						}
						var trimmed = StringTools.trim(value);
						var parentTag = cast(location, IMXHXTagData).parentTag;
						if (trimmed.length == 0 && isLanguageTag(TAG_DECLARATIONS, parentTag)) {
							return macro null;
						}
						return macro $v{trimmed};
					}
					return macro $v{value};
				case TYPE_UINT:
					value = StringTools.trim(value);
					if (!StringTools.startsWith(value, "-")) {
						var uintValue = Std.parseInt(value);
						if (uintValue != null) {
							return macro $v{uintValue};
						}
						var uintAsFloatValue = Std.parseFloat(value);
						var uintAsIntValue:UInt = Std.int(uintAsFloatValue);
						return macro $v{uintAsIntValue};
					}
				default:
			}
		}
		reportError('Cannot parse a value of type \'${t.name}\' from \'${value}\'', sourceLocationToContextPosition(location));
		return null;
	}

	private static function getDefaultProperty(t:BaseType):String {
		var metaDefaultXmlProperty = META_DEFAULT_XML_PROPERTY;
		if (!t.meta.has(metaDefaultXmlProperty)) {
			metaDefaultXmlProperty = ":" + metaDefaultXmlProperty;
			if (!t.meta.has(metaDefaultXmlProperty)) {
				return null;
			}
		}
		var defaultPropertyMeta = t.meta.extract(metaDefaultXmlProperty)[0];
		if (defaultPropertyMeta.params.length != 1) {
			reportError('The @${metaDefaultXmlProperty} meta must have one property name', defaultPropertyMeta.pos);
		}
		var param = defaultPropertyMeta.params[0];
		var propertyName:String = null;
		switch (param.expr) {
			case EConst(c):
				switch (c) {
					case CString(s, kind):
						propertyName = s;
					default:
				}
			default:
		}
		if (propertyName == null) {
			reportError('The @${META_DEFAULT_XML_PROPERTY} meta param must be a string', param.pos);
			return null;
		}
		return propertyName;
	}

	private static function errorTagNotSupported(tagData:IMXHXTagData):Void {
		reportError('Tag \'<${tagData.name}>\' is not supported by the \'${languageUri}\' namespace', sourceLocationToContextPosition(tagData));
	}

	private static function errorStatesNotSupported(sourceLocation:IMXHXSourceLocation):Void {
		reportError('States are not supported by the \'${languageUri}\' namespace', sourceLocationToContextPosition(sourceLocation));
	}

	private static function errorEventsNotSupported(sourceLocation:IMXHXSourceLocation):Void {
		reportError('Events are not supported by the \'${languageUri}\' namespace', sourceLocationToContextPosition(sourceLocation));
	}

	private static function errorBindingNotSupported(sourceLocation:IMXHXSourceLocation):Void {
		reportError('Binding is not supported by the \'${languageUri}\' namespace', sourceLocationToContextPosition(sourceLocation));
	}

	private static function errorTagUnexpected(tagData:IMXHXTagData):Void {
		reportError('Tag \'<${tagData.name}>\' is unexpected', sourceLocationToContextPosition(tagData));
	}

	private static function errorTextUnexpected(textData:IMXHXTextData):Void {
		reportError('The \'${textData.content}\' value is unexpected', sourceLocationToContextPosition(textData));
	}

	private static function errorAttributeUnexpected(attrData:IMXHXTagAttributeData):Void {
		reportError('Attribute \'${attrData.name}\' is unexpected', sourceLocationToContextPosition(attrData));
	}

	private static function reportError(message:String, position:Position):Void {
		#if (haxe_ver >= 4.3)
		Context.reportError(message, position);
		#else
		Context.error(message, position);
		#end
	}

	private static function errorUnexpected(unitData:IMXHXUnitData):Void {
		if ((unitData is IMXHXTagData)) {
			errorTagUnexpected(cast unitData);
			return;
		} else if ((unitData is IMXHXTextData)) {
			errorTextUnexpected(cast unitData);
			return;
		} else if ((unitData is IMXHXTagAttributeData)) {
			errorAttributeUnexpected(cast unitData);
			return;
		}
		reportError('MXHX data is unexpected', sourceLocationToContextPosition(unitData));
	}

	private static function sourceLocationToContextPosition(location:IMXHXSourceLocation):Position {
		if (location.source == posInfos.file) {
			return Context.makePosition({
				min: posInfos.min + location.start,
				max: posInfos.min + location.end,
				file: posInfos.file
			});
		}
		return Context.makePosition({file: location.source, min: location.start, max: location.end});
	}

	private static function resolveFilePath(filePath:String):String {
		if (Path.isAbsolute(filePath)) {
			return filePath;
		}
		var modulePath = Context.getPosInfos(Context.currentPos()).file;
		if (!Path.isAbsolute(modulePath)) {
			modulePath = FileSystem.absolutePath(modulePath);
		}
		modulePath = Path.directory(modulePath);
		return Path.join([modulePath, filePath]);
	}

	private static function loadMXHXFile(filePath:String):String {
		filePath = resolveFilePath(filePath);
		if (!FileSystem.exists(filePath)) {
			throw 'MXHX component file not found: ${filePath}';
		}
		return File.getContent(filePath);
	}
	#end
}
