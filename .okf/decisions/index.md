# Decisions

* [Randomness is injected, never global](injected-randomness.md) - generators take a `random:` keyword so specs can seed them; `srand` and global state are banned.
* [slop is a runtime dependency](slop-runtime-dependency.md) - the CLI ships inside the gem, so its option parser must be in the gemspec.
* [Ruby 3.4 is the floor](ruby-3-4-minimum.md) - version 4.0.0 dropped Ruby 3.0–3.3; CI tests 3.4, 4.0, and head.
