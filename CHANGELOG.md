# Changelog
All notable changes to this project will be documented in this file.

This project uses [Semantic Versioning][sv].

## [Unreleased][new]

## [0.2.0][0.2.0] — 2020-01-28

### Added
- Add an explicit copyright notice and the MIT license.
- Add a Code of Conduct declaring our commitment to an open, inclusive
  environment.
- Add a README.
- Add this change log.
- Create `CommandParser` class to segregate command line parsing methods.
- Print the version when the `-v|--version` switch is given.
- Display a brief summary of the program in the Usage message.

## [0.1.0][0.1.0] — 2020-01-27

### Added
- Prompt for a password to check when one is not provided on the command line.
- Display a usage message when the `-h|--help` switch is given.

### Changed
- The password may be specified using the `-p|--password` flag.

## [0.0.0][0.0.0] — 2019-05-13

### Added
- Create the project. Provide a command line utility to validate a given
  password against a public database of known data breaches.

---
_This file is composed with [GitHub Flavored Markdown][gfm]._

[gfm]: https://github.github.com/gfm/
[sv]: https://semver.org

[new]: https://github.com/petejh/amipwned/compare/HEAD..v0.2.0
[0.2.0]: https://github.com/petejh/amipwned/releases/tag/v0.2.0
[0.1.0]: https://github.com/petejh/amipwned/releases/tag/v0.1.0
[0.0.0]: https://github.com/petejh/amipwned/releases/tag/v0.0.0