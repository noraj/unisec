# Changelog

All notable changes to this project will be documented in this file.

The format is partially following [Keep a Changelog](https://keepachangelog.com/en/1.1.0/), except that the changes are grouped by meaningfulness type (features, updates, chores) and not by change type (added, changed, deprecated, removed, fixed, security). Instead, change types are added as prefixed label + special breaking change label.

Starting from version 1.0.0, this project will adheres to [Break Versioning](https://www.taoensso.com/break-versioning). Until then, version 0.x.x is considerd beta and breaking changes may be introduced in each version.

## Unreleased

### Chores

- **Fixed** missing erb dependency causing runtime crash ([#119](https://github.com/noraj/unisec/issues/119))

## [0.0.9](https://github.com/noraj/unisec/releases/tag/0.0.9) - 2026-06-28

### Features

- **Added** reverse normalization
  - Lib: `Unisec::Normalization.reverse_normalize`
  - CLI: `unisec normalize reverse`
- **Added** reverse hexdump (search which characters will give this resulting encoded value)
  - Lib: `Unisec::Hexdump.reverse`
  - CLI: `unisec dump rev`
- **Added** reverse blocks search (search in which Unicode block a given character is)
  - Lib: `Unisec::Blocks.reverse`
  - CLI: `unisec blocks reverse`
- **Added** reverse planes search (search in which Unicode plane a given character is)
  - Lib: `Unisec::Planes.reverse`
  - CLI: `unisec planes reverse`
- **Added** planes block search (search in which Unicode plane a block is)
  - Lib: `Unisec::Planes.block`
  - CLI: `unisec planes block`
- **Added** new utils method:
  - `Unisec::Utils::Arguments.to_array_of_sym`
  - `Unisec::Utils::Arguments.argenc2enc`
- **Added** shell completion for CLI
- **Changed** Also display the short form of the subcategory in `Properties.char`
- **Changed** `Properties.char` now also display the plane

### Chores

- **Breaking change** - **Removed** support for Ruby 3.2 ([EOL](https://www.ruby-lang.org/en/downloads/branches/))

## [0.0.8](https://github.com/noraj/unisec/releases/tag/0.0.8) - 2026-03-01

### Features

- **Added** new CLI commands:
  - `unisec dump codepoints standard`: Code point dump (standard format) [#32][#32]
  - `unisec dump codepoints integer`: Code point dump (integer format) [#32][#32]
- **Changed** the `properties char` command to also return the code point in numeric value [#29](https://github.com/noraj/unisec/issues/29)
- **Added** utils method:
  - `Unisec::Utils::String.chars2intcodepoints`

### Chores

- **Fixed** gem release based on outdated commit
- **Fixed** `char2codepoint` and `chars2codepoints` documentation examples

[#32]:https://github.com/noraj/unisec/issues/32

## [0.0.7](https://github.com/noraj/unisec/releases/tag/0.0.7) - 2026-03-01

### Features

- **Added** new `Unisec::Decdump` class to provide decimal dumps
  - CLI impact:
    - change `unisec hexdump` ➡️ `unisec dump hex`
    - new `unisec dump dec`
- **Breaking change** - **Changed** Moved `deccp2stdhexcp`, `char2codepoint` and `chars2codepoints` from `Properties` to `Utils`
- **Added** blocks & planes [#43](https://github.com/noraj/unisec/issues/43)
  - Lib: `Unisec::Blocks` & `Unisec::Planes`
  - CLI:
    - `unisec blocks list` - List all Unicode blocks
    - `unisec blocks search` - Search for a specific block
    - `unisec blocks invalid` - List all invalid and unassigned ranges
    - `unisec planes list` - List all Unicode planes
    - `unisec planes search` - Search for a specific plane
- **Added** new utils method:
  - `Unisec::Utils::String.to_range`
  - `Unisec::Utils::Range.range2codepoint_range`
  - `String.to_bool`
  - `Range.include_range?`
- **Changed** `Unisec::Utils::String.convert` was improved:
  - To support `:char` as `target_type`

### Updates

- **Changed** Update DerivedName from 15.1.0 to 17.0.0
- **Changed** Dependencies update

### Chores

- **Added** support for [Ruby 3.4](https://www.ruby-lang.org/en/news/2024/12/25/ruby-3-4-0-released/) & [4.0](https://www.ruby-lang.org/en/news/2025/12/25/ruby-4-0-0-released/)
- **Breaking change** - **Removed** support for Ruby 3.0 & 3.1 ([EOL](https://www.ruby-lang.org/en/downloads/branches/))
- **Added** tests for `Utils`
- **Added** a rake task to update Unicode data files
- **Changed** Enhanced installation documentation

## [0.0.6](https://github.com/noraj/unisec/releases/tag/0.0.6) - 2024-05-17

### Features

- _Prepare a XSS payload for HTML escape bypass (HTML escape followed by NFKC / NFKD normalization)_
  - **Changed** Renamed CLI command `normalize` into `normalize all`
  - **Added** a new method `replace_bypass` in the class `Unisec::Normalization`
  - **Added** a new CLI command `normalize replace` (using the new `replace_bypass` method)

## [0.0.5](https://github.com/noraj/unisec/releases/tag/0.0.5) - 2026-02-16

### Features

- **Added** a new class `Unisec::Normalization` and CLI command `normalize` to output all normalization forms

### Updates

- **Changed** Dependencies updated

### Chores

- **Changed** Enhanced documentation

## [0.0.4](https://github.com/noraj/unisec/releases/tag/0.0.4) 2024-01-23

### Features

- **Added** a new class `Unisec::Bidi::Spoof` and CLI command `bidi spoof` to craft payloads for attack using BiDi code points like RtLO, for example, for spoofing a domain name or a file name
- **Added** a new helper method: `Unisec::Utils::String.grapheme_reverse`: Reverse a string by graphemes (not by code points)
- **Added** an `--enc` option for `unisec hexdump` to output only in the specified encoding
- **Changed** `unisec hexdump` can now read from STDIN if the input equals to `-`

## [0.0.3](https://github.com/noraj/unisec/releases/tag/0.0.3) - 2023-10-18

### Features

- **Added** a new class `Unisec::Rugrep` and CLI command `grep` to search for Unicode code point names by regular expression
- **Added** a new method `Unisec::Properties.deccp2stdhexcp`: Convert from decimal code point to standardized format hexadecimal code point

### Chores

- **Changed** Enhanced tests: `assert_equal(true, test)` ➡️ `assert(test)`
- **Changed** Enhanced SEO: better description

## [0.0.2](https://github.com/noraj/unisec/releases/tag/0.0.2) - 2023-08-18

### Features

- **Added** 2 new classes (and corresponding CLI command):
  - `Unisec::Versions`: Version of Unicode, ICU, CLDR, gems used in Unisec
  - `Unisec::Size`: Code point, grapheme, UTF-8/UTF-16/UTF-32 byte/unit size

## [0.0.1](https://github.com/noraj/unisec/releases/tag/0.0.1) - 2023-07-21

### Features

- **Added** Initial version
