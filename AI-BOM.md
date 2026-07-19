# AI Bill of Materials — random_name_generator

_Last updated: 2026-07-19 · random_name_generator v4.0.2_

An inventory of every AI component associated with this repository — development
tools used to build it, AI-generated content shipped within it, and external AI
services it integrates with (current or planned). Modeled on the SBOM concept
applied to AI systems.

**AI was first used in the `4.0.0` release.** Everything through the `3.x` line
was authored without AI assistance.

---

## 1. Development Tools

AI tools used to author this codebase. Not part of the shipped gem, but relevant
to provenance.

| Tool | Vendor | Role | Notes |
|------|--------|------|-------|
| Claude Code | Anthropic | AI coding assistant | Introduced in 4.0.0; drives the [`lang-gen`](./.claude/skills/lang-gen/SKILL.md) skill and general maintenance |

---

## 2. AI Audits

Formal code reviews performed by AI models. Full reports in `docs/`.

| Date | Model | Report | Version |
|------|-------|--------|---------|
| 2026-07-19 | Claude Fable 5 | [`docs/AUDIT_Fable_5.md`](./docs/AUDIT_Fable_5.md) | v4.0.2 |

---

## 3. AI-Generated Content

Syllable data and tooling produced with AI assistance and shipped in the gem.
All output was human-reviewed before commit.

| Artifact | Type | Tool | Notes |
|----------|------|------|-------|
| [`lang-gen`](./.claude/skills/lang-gen/SKILL.md) | Claude Code skill | — | Generates a fully integrated language from a plain-English theme |
| [German Curse](./lib/languages/experimental/german-curse.txt) (`GERMAN_CURSE`) | Language syllable file | `lang-gen` | Experimental; seeded from real roots, extended with invented syllables |
| [Demonic](./lib/languages/experimental/demonic.txt) (`DEMONIC`) | Language syllable file | `lang-gen` | Experimental; completed from infernal-name source lists |
| [Portable lang-gen prompt](./docs/superpowers/specs/2026-07-19-lang-gen-portable-prompt.md) | Text prompt | — | LLM-agnostic version of the skill |

---

## 4. Algorithms Implemented

Generative logic built directly into the gem. **No machine-learning models and
no external ML dependencies** — all name generation is deterministic,
in-process, and driven by plain syllable-adjacency rules.

| Algorithm | Location | Notes |
|-----------|----------|-------|
| Probabilistic syllable composition | `RandomNameGenerator::Generator` | Random prefix/middle/suffix assembly honoring `+v`/`+c`/`-v`/`-c` adjacency flags |
| Syllable parsing / classification | `RandomNameGenerator::Syllable` | Parses each language-file line into a flagged syllable |

This is a rules-based random generator, not an AI/ML system. It is listed here
for completeness so the boundary between "AI-assisted authoring" and "AI at
runtime" is explicit.

---

## 5. External AI Integrations

random_name_generator ships **zero external AI service dependencies**. It makes
no network calls and requires no API keys. None are planned.

| Service | Type | Status |
|---------|------|--------|
| — | — | None (current or planned) |

---

## 6. References

| Document | Purpose |
|----------|---------|
| [`docs/AUDIT_Fable_5.md`](./docs/AUDIT_Fable_5.md) | Full-codebase audit with empirically verified findings |
| [`.claude/skills/lang-gen/SKILL.md`](./.claude/skills/lang-gen/SKILL.md) | The lang-gen language-generation skill |
| [`README.md`](./README.md) | Project overview, including the lang-gen workflow |
| [`docs/superpowers/specs/2026-07-19-lang-gen-portable-prompt.md`](./docs/superpowers/specs/2026-07-19-lang-gen-portable-prompt.md) | Paste-into-any-LLM version of the prompt |
