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

package mxhx.parser;

/**
	Represents different types of tokens in an [MXHX](https://mxhx.dev)
	document parsed with `MXHXParser`.
**/
enum MXHXToken {
	/**
		Represents an XML processing instruction.
	**/
	TProcessingInstruction(value:String);

	/**
		Represents a run of character data that is entirely whitespace.
	**/
	TWhitespace(value:String);

	/**
		Represents a `<!-- -->` XML comment.
	**/
	TComment(value:String);

	/**
		Represents a `<!--- -->` documentation comment.
	**/
	TDocComment(value:String);

	/**
		Represents a tag attribute value.
	**/
	TString(value:String);

	/**
		Represents the start of an open tag, including `<` and the tag name.
	**/
	TOpenTagStart(value:String);

	/**
		Represents the start of a close tag, including `</` and the tag name.
	**/
	TCloseTagStart(value:String);

	/**
		Represents character data that appears between tags.
	**/
	TText(value:String);

	/**
		Represents a `<![CDATA[` block.
	**/
	TCData(value:String);

	/**
		Represents the `>` at the end of a tag.
	**/
	TTagEnd;

	/**
		Represents the `/>` at the end of an empty tag.
	**/
	TEmptyTagEnd;

	/**
		Represents an `xmlns:` namspace attribute.
	**/
	TXmlns(value:String);

	/**
		Represents a tag attribute name, including an optional prefix and an
		optional state name suffix.
	**/
	TName(value:String);

	/**
		Represents an XML Document Type Definition.
	**/
	TDtd(value:String);

	/**
		Represents the `=` sign in a tag attribute.
	**/
	TEquals;

	/**
		Represents the end of file.
	**/
	TEof;
}
