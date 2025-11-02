# Usage

## CLI

### General help

List commands:

```
$ unisec --help

Commands:
  unisec bidi [SUBCOMMAND]
  unisec blocks [SUBCOMMAND]
  unisec confusables [SUBCOMMAND]
  unisec dump [SUBCOMMAND]
  unisec grep REGEXP                              # Search for Unicode code point names by regular expression
  unisec normalize [SUBCOMMAND]
  unisec planes [SUBCOMMAND]
  unisec properties [SUBCOMMAND]
  unisec size INPUT                               # All kinf of size information about a Unicode string
  unisec surrogates [SUBCOMMAND]
  unisec versions                                 # Version of anything related to Unicode as used in unisec
```

List sub-commands:

```
$ unisec surrogates --help
Commands:
  unisec surrogates from HIGH LOW                 # Code point ⬅️ Surrogates
  unisec surrogates to NAME                       # Code point ➡️ Surrogates
```

Sub-command help:

```
$ unisec surrogates from --help
Command:
  unisec surrogates from

Usage:
  unisec surrogates from HIGH LOW

Description:
  Code point ⬅️ Surrogates

Arguments:
  HIGH                              # REQUIRED High surrogate (in hexadecimal (0xXXXX), decimal (0dXXXX), binary (0bXXXX) or as text)
  LOW                               # REQUIRED Low surrogate (in hexadecimal (0xXXXX), decimal (0dXXXX), binary (0bXXXX) or as text)

Options:
  --help, -h                        # Print this help
```

### Examples

- **BiDi**
  - [Spoof](https://noraj.github.io/unisec/yard/Unisec/CLI/Commands/Bidi/Spoof)
- **Blocks**
  - [List](https://noraj.github.io/unisec/yard/Unisec/CLI/Commands/Blocks/List)
  - [Search](https://noraj.github.io/unisec/yard/Unisec/CLI/Commands/Blocks/Search)
- **Confusables**
  - [List](https://noraj.github.io/unisec/yard/Unisec/CLI/Commands/Confusables/List)
  - [Randomize](https://noraj.github.io/unisec/yard/Unisec/CLI/Commands/Confusables/Randomize)
- [Grep](https://noraj.github.io/unisec/yard/Unisec/CLI/Commands/Grep)
- **Dump**
  - [Dec](https://noraj.github.io/unisec/yard/Unisec/CLI/Commands/Dump/Dec)
  - [Hex](https://noraj.github.io/unisec/yard/Unisec/CLI/Commands/Dump/Hex)
- **Normalize**
  - [All](https://noraj.github.io/unisec/yard/Unisec/CLI/Commands/Normalize/All)
  - [Replace](https://noraj.github.io/unisec/yard/Unisec/CLI/Commands/Normalize/Replace)
- **Planes**
  - [List](https://noraj.github.io/unisec/yard/Unisec/CLI/Commands/Planes/List)
  - [Search](https://noraj.github.io/unisec/yard/Unisec/CLI/Commands/Planes/Search)
- **Properties**
  - [Char](https://noraj.github.io/unisec/yard/Unisec/CLI/Commands/Properties/Char)
  - [Codepoints](https://noraj.github.io/unisec/yard/Unisec/CLI/Commands/Properties/Codepoints)
  - [List](https://noraj.github.io/unisec/yard/Unisec/CLI/Commands/Properties/List)
- [Size](https://noraj.github.io/unisec/yard/Unisec/CLI/Commands/Size)
- **Surrogates**
  - [From](https://noraj.github.io/unisec/yard/Unisec/CLI/Commands/Surrogates/From)
  - [To](https://noraj.github.io/unisec/yard/Unisec/CLI/Commands/Surrogates/To)
- [Versions](https://noraj.github.io/unisec/yard/Unisec/CLI/Commands/Versions)

[Library documentation for commands](https://noraj.github.io/unisec/yard/Unisec/CLI/Commands).

## Library

See examples in [the library documentation](https://noraj.github.io/unisec/yard/Unisec).

- [Unisec::Bidi](https://noraj.github.io/unisec/yard/Unisec/Bidi)
- [Unisec::Blocks](https://noraj.github.io/unisec/yard/Unisec/Blocks)
- [Unisec::Confusables](https://noraj.github.io/unisec/yard/Unisec/Confusables)
- [Unisec::Decdump](https://noraj.github.io/unisec/yard/Unisec/Decdump)
- [Unisec::Hexdump](https://noraj.github.io/unisec/yard/Unisec/Hexdump)
- [Unisec::Normalization](https://noraj.github.io/unisec/yard/Unisec/Normalization)
- [Unisec::Planes](https://noraj.github.io/unisec/yard/Unisec/Planes)
- [Unisec::Properties](https://noraj.github.io/unisec/yard/Unisec/Properties)
- [Unisec::Rugrep](https://noraj.github.io/unisec/yard/Unisec/Rugrep)
- [Unisec::Size](https://noraj.github.io/unisec/yard/Unisec/Size)
- [Unisec::Surrogates](https://noraj.github.io/unisec/yard/Unisec/Surrogates)
- [Unisec::Versions](https://noraj.github.io/unisec/yard/Unisec/Versions)
