# Document formats

Most of the time, when writing a document, I want a document format with the following properties:

* Fast to write using a plain text editor
* Easy to parse into an AST

An AST is a programming-friendly representation of a document.
ASTs reduce the effort required to write tools such as a program that validates links in a document.
Ideally, ASTs contain information to track a document element to the position it occupies in the original document.
With this information, if you write a tool such as a spell checker, then you can highlight misspelled works precisely in the original document.

On top of that, some features that I don't always need:

* Math support
* Sophisticated code blocks.
  For example, being able to highlight arbitrary parts of code blocks (not syntax highlighting).
* Diagram support

## Existing formats

### Markdown

* Easy to write using a plain text editor
* Has good AST parsers with position information
* Has math support
* Does not support sophisticated code blocks
* There are many extensions with support for math, diagrams, and many others
* Is very popular and supported everywhere
* However, there is a wide variety of variants and quirks
* Especifically, because Markdown was not designed with parsing in mind, so tools based on different parsers can have differences in behavior

### [Djot](https://djot.net/)

It is very similar to Markdown, except:

* It is designed for parsing, so independent parsing implementations are very compatible with each other
* It is not so popular, so there are less extension and tool support

### [AsciiDoc](https://asciidoc.org/)

Compared to Markdown:

* It's more complex to write, but mostly because it's different and more powerful
* There are attempts to write better parsers, but good parsers with position information are not available yet
* Supports sophisticated code blocks
* It has a smaller ecosystem than Markdown, but many good quality tools such as Antora

### [Typst](https://typst.app/)

Checks all my boxes, except:

* It is designed for parsing and it has an AST, but it is not easy to access
* Currently Typst is very oriented towards generating paged documents (e.g. PDF)
* It includes a full programming language, which is mostly good (very extensible), but this might increase complexity undesirably

Typst is very new and is not yet very popular.

[Typesetter](https://codeberg.org/haydn/typesetter) is a desktop application that embeds Typst, so no additional setup is needed.
However, Typesetter is only available as a Flatpak.

### TODO: other formats

- https://github.com/nota-lang/nota
- https://github.com/christianvoigt/argdown
- https://github.com/nvim-neorg
- https://github.com/podlite/podlite/
- https://orgmode.org/
- https://github.com/sile-typesetter/sile

## Creating your own formats

https://github.com/spc476/MOPML someone created its own lightweight format using Lua and PEGs.

https://tratt.net/laurie/blog/2020/which_parsing_approach.html has information about choosing parsing approaches.
