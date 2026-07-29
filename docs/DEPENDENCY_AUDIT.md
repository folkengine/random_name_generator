# Dependency Audit

**Audited:** 2026-07-29 at `50cdd80` · Ruby 3.4.10 (+PRISM, arm64-darwin25) · Bundler 4.0.16
**Host license:** LGPL-3.0 — relevant to the extraction license gate (see Cross-cutting findings)
**Scope:** 1 direct shipping dependency (1 third-party, 0 first-party), shipping
graph of **1 gem** excluding the root. Dev-dependencies add **40 gems** that never
ship. Ruby has no target-gating analogue, so there is no separate "all targets"
count — see the appendix for why.
**Amended 2026-07-29 (working tree, post-audit):** finding 4 below recommended
wiring up advisory scanning; that was done in the same session. `bundler-audit`
0.9.3 (+ `thor` 1.5.0) is now in the development group with a CI job, so the
advisory fields below carry real results instead of `unchecked`, and the dev graph
grew 38 → 40. The shipping graph is unchanged at 1 gem.
**Method:** /untangle — evidence commands in the appendix; scores use the 1–5
anchors, verdicts use the controlled vocabulary. Cargo-specific tactics were
swapped for the Ruby equivalents (`gem specification`, gemspec introspection,
`Gemfile.lock` parsing, `rg` census).

## Summary

One row per direct **shipping** dependency. In a Ruby gem, "shipping" means
declared in the `.gemspec` — a `Gemfile` entry is invisible to installed gems.

| Dependency | Version | License | Score | Unique baggage | Effort | Verdict |
|---|---|---|---|---|---|---|
| slop | 4.10.1 | MIT | 1 | 0 gems | S | `replace-std` |

**Headline:** the library core is already dependency-free. `lib/` requires nothing
but `require_relative` — the entire third-party shipping surface of this gem is the
CLI's option parser, in one file, at one call site.

## Cross-cutting findings

**1. Duplicate versions are structurally impossible, not merely absent.**
Bundler resolves to exactly one version per gem in a lockfile, so the `cargo tree -d`
analogue cannot produce output here. This is a property of the ecosystem, not a
clean bill of health earned by this repo — do not read it as an achievement, and
do not expect a future audit to find duplicates unless the packaging model changes.

**2. The whole shipping graph is one leaf gem.** `slop` 4.10.1 has zero runtime
dependencies. The shipping graph is therefore a single node with no subtree, so
there are no "heaviest unique subtrees" to report on the shipping side. All
dependency weight in this repo lives in the dev graph, where it never reaches a
consumer.

**3. Dev-graph weight, for context only (never ships).** Of 40 dev-only gems:
~10 are the `dry-*` / `zeitwerk` / `concurrent-ruby` / `bigdecimal` stack pulled
in by `reek` (via `dry-schema`), ~14 are the `rubocop` + `parser` stack, and 6 are
the `rspec` stack. `reek` is the single heaviest dev dependency by transitive
count. Flagged so nobody mistakes a 41-gem `Gemfile.lock` for a 41-gem install
footprint: consumers install **2** gems (this one + slop), and would install **1**
if the verdict below is executed.

**4. Advisory scanning — now wired up (was the audit's one open gap).**
At audit time `bundler-audit` was neither installed nor in the `Gemfile`, so no
advisory database had been consulted and every advisory field read `unchecked`
rather than "clean." That has since been closed in this working tree:

- `gem "bundler-audit", require: false` in the `:development` group.
- A dedicated `audit` job in `.github/workflows/ruby.yml` running
  `bundle exec bundler-audit check --update`.

The job is deliberately **separate** from the `test` matrix rather than a step
inside it, for two reasons: advisory results depend on the gem graph and not the
interpreter, so running them on all three Ruby legs is pure waste; and `test`'s
`head` leg sets `continue-on-error: true`, which would have silently swallowed a
vulnerability report. `--update` fetches the latest `ruby-advisory-db` instead of
trusting the copy bundled with the gem, which means a newly published advisory can
red the build with no code change here — that is the intended behavior of a
security gate, not a flake.

It was **not** added to the default `rake` task. `bundle exec rake` is the
documented local gate (`spec` then `rubocop`) and `--update` requires network
access, so folding it in would slow the inner loop and break offline work. CI is
the right place for a gate with a network dependency.

First run, 2026-07-29: **no vulnerabilities found** across the full 41-gem
dev-inclusive graph, against 1221 advisories (`ruby-advisory-db` commit
`75149eb1b4e2a0b4d56c1d40518e1e6b48747261`). Cost of the change: +2 dev-only gems
(`bundler-audit`, `thor`). Shipping graph unaffected.

**5. Maintenance signal on the sole shipping dep is stale.** `slop` last released
2023-02-26 — ~3.4 years before this audit. Read this as "stable and
feature-complete" rather than "abandoned" (it is a small, finished option parser),
but note there is no active-maintenance signal behind the one gem consumers
inherit.

**6. Dev-tool vocabulary is embedded in shipping source.** 7 `# :reek:…`
suppression directives live in `lib/` (3 in `random_name_generator.rb`, 4 in
`syllable.rb`). These are comments — zero runtime coupling, zero install cost, and
correctly *not* a dependency. Noted only because it means the published source
carries a dev tool's vocabulary; it is not scored and needs no action.

**7. `logger` and `tsort` are forward-compat shims, correctly dev-scoped.** Both
leave Ruby's default gems (4.0 and 4.1 respectively) and are required implicitly by
`reek` (via `dry-core`) and `rubocop`. CI tests Ruby 3.4, 4.0, and head, so these
entries are load-bearing for the dev toolchain on newer Rubies. They are in the
`Gemfile` only and never ship — the right placement. They would become a shipping
concern only if `lib/` ever needed either, which today it does not.

**8. License-gate note for any future vendoring.** The host is **LGPL-3.0**
(copyleft), not the permissive host the standard gate table assumes, so that table
must be re-derived before any copy-in. The practical effect is that the gate is
*looser inbound* than the default table implies: permissive upstreams
(MIT/BSD/ISC/Apache-2.0) can be copied into an LGPL-3.0 host with notices
preserved, and GPL-3.0/LGPL-3.0 upstreams become copyable too (compatible
copyleft) where they would be barred from a permissive host. AGPL and GPL-2.0-only
remain incompatible. No vendoring is proposed in this audit, so nothing rides on
this today.

**9. `docs/` ships in this gem.** The gemspec's file list is `git ls-files` minus
`test|spec|features`, which includes 4 files under `docs/` (this audit will make 5)
and `LICENSE`. Unlike Cargo — where docs folders are routinely excluded and
attribution must be duplicated at the root — attribution placed in `docs/` here
would genuinely reach consumers. Moot under the current verdict (a `replace-std`
carries no license text), but it removes a trap if a future verdict changes.

## Third-party dossiers

### slop 4.10.1

- **License:** MIT · **Last release:** 2023-02-26 · **Advisories:** **none** —
  `bundler-audit` 0.9.3 against `ruby-advisory-db` (1221 advisories, commit
  `75149eb`), checked 2026-07-29. See Cross-cutting finding 4.
- **Features used:** `Slop.parse` with a configuration block; `o.bool` for flag
  declaration (11 flags); auto-generated predicate readers (`opts.elven?` …); and
  `Slop::Options#to_s` via `puts opts` for help rendering. **Not** used: typed
  options (`o.string`/`o.integer`/`o.array`), value coercion, defaults, `separator`,
  banner customization, `Slop::Result#arguments`, validation callbacks, or custom
  error handling. The used slice is "boolean flags + predicates + help text" — a
  small fraction of a 840-LOC gem.
- **Usage census:** shipping: **1 file** (`exe/random_name_generator`), **1 import**,
  **1** `Slop.parse` call site, **11** `o.bool` declarations, **15** predicate call
  sites, **1** help-render site (`puts opts`) — 0 derive sites (no Ruby analogue).
  dev: **0** call sites in `spec/`, `bin/`, or the `Rakefile`.
  The dev half being zero is the notable number: it confirms `slop` is genuinely
  shipping code and rules out `demote-to-dev`. The shipping half being confined to
  `exe/` is what keeps the score at 1.
- **Public API leakage:** **none.** `lib/random_name_generator.rb` and
  `lib/random_name_generator/syllable.rb` require only `require_relative`; no `Slop`
  type, module, or exception appears in any exported signature or return value. The
  library API (`RandomNameGenerator.new`, `#compose`, `.flip_mode`,
  `Syllable`) is slop-free. Library consumers who `require "random_name_generator"`
  never load slop at all — only the `exe/` CLI does. Removal is therefore not a
  breaking change for library consumers.
- **Contract exposure:** the `-?`/`--help` output is user-visible CLI surface, and
  its exact formatting would change (documented under Replaceability). No persisted
  files, no wire formats, no downstream repos consume slop-produced output.
  Generated names are entirely unaffected — they come from `lib/`, which slop never
  touches. Flag *spellings* are the real contract and are preserved exactly.
- **Unique baggage:** **0 gems.** slop has no runtime dependencies; its node is a
  leaf. Removing it removes exactly one node (itself) and nothing else.
- **Replaceability:** **std** — Ruby's `optparse` is a *default gem* (v0.6.0,
  ships with the interpreter, needs no gemspec entry). Verified empirically rather
  than assumed, because two flags in this CLI are genuinely unusual:
  - `-ß` — a **multibyte short flag**. `optparse` parses it correctly, both as
    `-ß` and as `--german-curse`.
  - `-?` — `?` as a short flag character. `optparse` parses it correctly.
  All 13 invocations tested (every short flag, two long forms, and a combined
  `-c -e`) produce the same parse result as slop. Help text renders with
  `--german-curse` present. Unknown flags raise in both
  (`OptionParser::InvalidOption` vs `Slop::UnknownOption`) — neither is rescued in
  the CLI today, so both surface an uncaught traceback; user-visible behavior is
  equivalent, and improving it is a separate concern from this audit.
  Two deltas the swap would introduce, both cosmetic and both in one file:
  1. **Help formatting.** slop emits `usage: exe/random_name_generator [options]`
     with the description column padded to the longest flag; `optparse` emits
     `Usage: <prog> [options]` with descriptions at a fixed 33-column offset. Same
     flags, same descriptions, different whitespace and a capitalized "Usage".
     Matching slop's exact output is possible via `banner=` and hand-built
     `on` strings if byte-identical help output is wanted.
  2. **Predicate ergonomics.** `optparse` fills a hash, so the 15 `opts.elven?`
     sites become `opts[:elven]`. If the predicate style is worth keeping, a
     3-line `Struct`/`Data` wrapper around the hash preserves every call site
     unchanged.
- **Score:** **1** — Contained: leaf usage, a single file, one narrow API surface,
  and no public API leakage. It matches the anchor precisely.
- **Effort:** **S** — under an hour, one file (`exe/random_name_generator`), plus
  removing one gemspec line. No `/epic` needed.
- **Verdict:** `replace-std` — the standard library covers **100%** of the used
  surface, verified against the two exotic flags that were the only real risk.

  The case for removal: it takes the gem to **zero runtime dependencies**, which is
  a categorical change rather than an incremental one — `gem install
  random_name_generator` would pull nothing at all. That matches the design ethos
  already stated in `CLAUDE.md` ("Pure file-in/string-out: no network, no threads")
  and it retires a standing maintenance tax the codebase has already had to reason
  about explicitly: the gemspec carries a two-line comment explaining why slop must
  be a *runtime* dep rather than a Gemfile entry, and that subtlety is a live
  footgun for anyone editing dependency declarations. It also removes the repo's
  only exposure to a gem with no maintenance signal since 2023.

  The case for `keep`, stated fairly: slop is MIT, zero-dep, 840 LOC, and works
  today. Score 1 / effort S means the ownership cost of keeping it is genuinely
  low, and swapping a working parser buys no new capability. Anyone who prefers
  `opts.elven?` over `opts[:elven]` and byte-identical help output can defensibly
  keep it.

  Removal wins on the balance because the payoff is not tree size — dropping 1 gem
  from a 1-gem graph is trivially small in absolute terms, and this audit should
  not pretend otherwise. The payoff is that the *count reaches zero*: a
  dependency-free gem needs no supply-chain audit, no advisory watch, and no
  runtime-vs-dev-dep reasoning at all, and it gets there for well under an hour of
  work in a single file with no API break for library consumers.

  **Execution note:** this is a `replace-std`, so no code is copied and no
  attribution or `VENDORED.md` ledger entry is required. To perform it, run
  `/untangle extract slop` — the approval gate applies. The CLI must be exercised
  manually as part of verification: `bundle exec rake` will **not** catch a
  regression here, because no spec covers `exe/random_name_generator` (see Notes).

## First-party dependencies

None. All authors/repository fields on the shipping dependency point to
third parties (`slop` → `github.com/leejarvis/slop`), so the absorption rubric does
not apply to this repo.

## Dev-dependencies

Light touch — these never ship to consumers. No duplicate versions exist in this
graph (structurally impossible under Bundler; see Cross-cutting finding 1).
`pry` and `rake` sit at `Gemfile` top level rather than in the `:development`
group; this has no effect on shipping, since only the gemspec determines what
consumers inherit.

| Dependency | Version | License | Role |
|---|---|---|---|
| rake | 13.4.2 | MIT | Task runner; `rake` = `spec` + `rubocop` (the gate) |
| bundler-audit | 0.9.3 | GPL-3.0-or-later | Advisory scanner; CI-only gate. Brings `thor` 1.5.0 (MIT). The only non-permissive license in the graph, and the only copyleft one besides the host — benign here: it is an unmodified standalone executable run as a separate process, never linked into the gem and never shipped, and GPL-3.0 is compatible with the LGPL-3.0 host regardless |
| rspec | 3.12.0 | MIT | Test framework |
| rubocop | 1.66.1 | MIT | Linter; source of truth for style (`.rubocop.yml`) |
| rubocop-rake | 0.6.0 | MIT | RuboCop plugin for Rake files |
| rubocop-rspec | 3.1.0 | MIT | RuboCop plugin for specs |
| reek | 6.3.0 | MIT | Smell detector; heaviest dev subtree (~10 transitive gems) |
| pry | 0.14.2 | MIT | REPL for `bin/console` |
| logger | 1.7.0 | Ruby, BSD-2-Clause | Shim: leaves default gems in Ruby 4.0; `reek` needs it implicitly |
| tsort | 0.2.0 | Ruby, BSD-2-Clause | Shim: leaves default gems in Ruby 4.1; `rubocop` needs it implicitly |

## Evidence appendix

Raw, diffable outputs for the next audit to compare against.

### Graph-size baselines

Counted by resolving the gemspec's runtime dependencies transitively, and by
parsing the `GEM` section of `Gemfile.lock` — **not** from a raw lockfile line
count, which conflates dev and shipping.

| Baseline | Unique gems excluding root |
|---|---|
| Shipping graph (gemspec runtime deps, transitive) | **1** (`slop`) |
| Shipping graph, all platforms | **1** — identical |
| Dev-inclusive graph (`Gemfile.lock` `GEM` section) | **41** |
| Dev-only (never ships) | **40** |

At audit time (commit `50cdd80`) these were 39 / 38; the `bundler-audit` + `thor`
addition described in finding 4 accounts for the difference. Shipping graph
unchanged.

On the "all platforms" row: `Gemfile.lock` declares `PLATFORMS` as
`arm64-darwin-21`, `arm64-darwin-24`, `arm64-darwin-25`, `x86_64-linux`, but no gem
in the graph is platform-gated and none is a native extension, so the shipping
count is platform-invariant. Ruby also has no analogue of Cargo's optional/
feature-gated dependency edges, so there is no inactive-edge correction to make.

Dev-inclusive graph, full list (41):
```
ast, bigdecimal, bundler-audit, coderay, concurrent-ruby, diff-lcs,
dry-configurable, dry-core, dry-inflector, dry-initializer, dry-logic, dry-schema,
dry-types, json, language_server-protocol, logger, method_source, parallel, parser,
pry, racc, rainbow, rake, reek, regexp_parser, rexml, rspec, rspec-core,
rspec-expectations, rspec-mocks, rspec-support, rubocop, rubocop-ast, rubocop-rake,
rubocop-rspec, ruby-progressbar, slop, thor, tsort, unicode-display_width, zeitwerk
```

### Duplicate versions (`cargo tree -d` analogue)

Empty — and structurally so. Bundler resolves one version per gem per lockfile;
duplicate-version bloat is not expressible. Shipping/dev partitioning is therefore
vacuous here. Recorded explicitly so a future audit does not read the blank as
"not checked."

### Per-dep census

Shipping = `lib/` + `exe/` (both are packaged; `exe/random_name_generator` is the
installed executable). Dev = `spec/`, `bin/`, `Rakefile`, config files.

| Dep | Shipping files | Shipping call sites | Declarations | Dev-side count |
|---|---|---|---|---|
| slop | 1 (`exe/random_name_generator`) | 1 `Slop.parse` + 15 predicates + 1 `puts opts` = 17 | 11 `o.bool` | 0 |

Predicate call-site breakdown (15 total):
```
2  opts.roman?      2  opts.goblin?     2  opts.elven?    2  opts.cyrillic?
1  opts.xrated?     1  opts.klingon?    1  opts.help?     1  opts.german_curse?
1  opts.flipmode?   1  opts.demonic?    1  opts.belter?
```

All `require` statements, shipping side — the leakage evidence:
```
lib/random_name_generator.rb:3:  require_relative "random_name_generator/version"
lib/random_name_generator.rb:4:  require_relative "random_name_generator/syllable"
exe/random_name_generator:5:     require "random_name_generator"
exe/random_name_generator:6:     require "slop"
```
`lib/` has no third-party `require` of any kind.

Non-dependency coupling, for the record: 7 `# :reek:…` comment directives in
shipping source (`lib/random_name_generator.rb` ×3, `lib/random_name_generator/syllable.rb` ×4).

### Unique baggage

| Dep | Direct-edge removal | Node-vanishes |
|---|---|---|
| slop | 1 gem leaves (`slop`) | 1 gem leaves (`slop`); **0** additional |

Both numbers coincide because slop is a leaf with zero runtime dependencies.

### Replaceability verification (slop → optparse)

`optparse` confirmed a default gem: `Gem::Specification.find_by_name("optparse")`
→ `default_gem? == true`, version `0.6.0`. Requires no gemspec entry.

Parse-equivalence run against a prototype CLI declaring all 11 flags via
`OptionParser#on`:

| Input | slop | optparse |
|---|---|---|
| `-e` `-g` `-r` `-k` `-b` `-f` `-c` `-x` `-d` | parses | parses (all 9) |
| `-ß` (multibyte short flag) | `german_curse? => true` | `{german_curse: true}` |
| `-?` | `help? => true` | `{help: true}` |
| `--german-curse`, `--cyrillic` (long forms) | parses | parses |
| `-c -e` (combined) | parses both | `{cyrillic: true, elven: true}` |
| `-Z` (unknown) | raises `Slop::UnknownOption` | raises `OptionParser::InvalidOption` |
| help render | `usage: … [options]`, padded to longest flag | `Usage: … [options]`, 33-col offset |

### Packaging facts

```
executables:      ["random_name_generator"]
total files:      67
exe files:        ["exe/random_name_generator"]
docs/ shipped:    4 files
LICENSE shipped:  true
```

### Tool availability

| Tool | Status |
|---|---|
| `gem specification` / gemspec introspection | ran — versions, licenses, runtime deps, release dates |
| `Gemfile.lock` parsing | ran — dev-inclusive graph |
| `rg` census | ran — per-dep shipping/dev split |
| `optparse` equivalence harness | ran — see above; ad-hoc, written for this audit |
| `bundler-audit` (`cargo audit` analogue) | **added during this audit** (finding 4). v0.9.3, `check --update` → no vulnerabilities across 41 gems vs 1221 advisories, db commit `75149eb`, 2026-07-29. Now enforced by the `audit` CI job |
| `cargo machete`/`udeps` analogue | **no Ruby equivalent** — unused-dep detection done by hand via the `rg` census above |
| `cargo license` analogue | not needed — licenses read directly from installed gem specs |

## Notes (human)

<!-- Never regenerated. Add anything you want preserved across audit refreshes. -->

- Out-of-scope observation, recorded because the verdict above depends on it:
  there is **no spec covering `exe/random_name_generator`**. `bundle exec rake`
  (`spec` + `rubocop`) exercises `lib/` only, so any change to the CLI's option
  parsing — including the `replace-std` above — must be verified by running the
  executable by hand across all 11 flags. A characterization spec that shells out
  to `exe/random_name_generator` for each flag would make that verdict safe to
  execute under the normal gate.
