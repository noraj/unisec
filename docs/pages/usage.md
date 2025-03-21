# Usage

## CLI

### General help

List commands:

```
$ unisec --help

Commands:
  unisec bidi [SUBCOMMAND]
  unisec confusables [SUBCOMMAND]
  unisec dump [SUBCOMMAND]
  unisec grep REGEXP                              # Search for Unicode code point names by regular expression
  unisec normalize [SUBCOMMAND]
  unisec properties [SUBCOMMAND]
  unisec size INPUT                               # All kinf of size information about a Unicode string
  unisec surrogates [SUBCOMMAND]
  unisec versions
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
  - [Spoof](https://.github.io/unisec/yard/Unisec/CLI/Commands/Bidi/Spoof)
- **Confusables**
  - [List](https://.github.io/unisec/yard/Unisec/CLI/Commands/Confusables/List)
  - [Randomize](https://.github.io/unisec/yard/Unisec/CLI/Commands/Confusables/Randomize)
- [Grep](https://.github.io/unisec/yard/Unisec/CLI/Commands/Grep)
- **Dump**
  - [Dec](https://.github.io/unisec/yard/Unisec/CLI/Commands/Dump/Dec)
  - [Hex](https://.github.io/unisec/yard/Unisec/CLI/Commands/Dump/Hex)
- **Normalize**
  - [All](https://.github.io/unisec/yard/Unisec/CLI/Commands/Normalize/All)
  - [Replace](https://.github.io/unisec/yard/Unisec/CLI/Commands/Normalize/Replace)
- **Properties**
  - [Char](https://.github.io/unisec/yard/Unisec/CLI/Commands/Properties/Char)
  - [Codepoints](https://.github.io/unisec/yard/Unisec/CLI/Commands/Properties/Codepoints)
  - [List](https://.github.io/unisec/yard/Unisec/CLI/Commands/Properties/List)
- [Size](https://.github.io/unisec/yard/Unisec/CLI/Commands/Size)
- **Surrogates**
  - [From](https://.github.io/unisec/yard/Unisec/CLI/Commands/Surrogates/From)
  - [To](https://.github.io/unisec/yard/Unisec/CLI/Commands/Surrogates/To)
- [Versions](https://.github.io/unisec/yard/Unisec/CLI/Commands/Versions)

[Library documentation for commands](https://.github.io/unisec/yard/Unisec/CLI/Commands).

## Library

See examples in [the library documentation](https://.github.io/unisec/yard/Unisec).

- [Unisec::Bidi](https://.github.io/unisec/yard/Unisec/Bidi)
- [Unisec::Confusables](https://.github.io/unisec/yard/Unisec/Confusables)
- [Unisec::Decdump](https://.github.io/unisec/yard/Unisec/Decdump)
- [Unisec::Hexdump](https://.github.io/unisec/yard/Unisec/Hexdump)
- [Unisec::Normalization](https://.github.io/unisec/yard/Unisec/Normalization)
- [Unisec::Properties](https://.github.io/unisec/yard/Unisec/Properties)
- [Unisec::Rugrep](https://.github.io/unisec/yard/Unisec/Rugrep)
- [Unisec::Size](https://.github.io/unisec/yard/Unisec/Size)
- [Unisec::Surrogates](https://.github.io/unisec/yard/Unisec/Surrogates)
- [Unisec::Versions](https://.github.io/unisec/yard/Unisec/Versions)
