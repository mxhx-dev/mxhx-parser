# MXHX Parser

A specialized XML parser for the [MXHX](https://mxhx.dev) markup language that returns a tree of units that represent the syntax, but not the semantics, of the document. Units in the generated result include open tags, close tags, attributes, and text content. Reports errors when the MXHX syntax is invalid, but also supports "repairing" the tree — allowing for real-time code intelligence in MXHX tooling, such as editors and IDEs.

A separate library, such as [mxhx-component](https://github.com/mxhx-dev/mxhx-component), is required to assign meaning to each tag, attribute, or block of text.
