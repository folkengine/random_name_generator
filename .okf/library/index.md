# Library

The Ruby API, from the outside in.

* [RandomNameGenerator (module)](module.md) - top-level facade: language constants, factory methods, and the syllable-count distribution.
* [RandomNameGenerator::Generator](generator.md) - reads a syllable file into three buckets and assembles a name by walking prefix → middles → suffix.
* [RandomNameGenerator::Syllable](syllable.md) - parses one line of a language file into a syllable plus its position and adjacency rules.
