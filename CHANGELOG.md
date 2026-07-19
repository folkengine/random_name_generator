## Version 4

## 4.0.0 - 2026-07-18

- Raised minimum required Ruby version to 3.4.0 (dropping 3.0–3.3 support).
- Set `.tool-versions` to Ruby 3.4.10.
- Bumped dependencies: `rake` (~> 13.4), `rexml`, `concurrent-ruby`.
- Updated CI workflow and Rubocop settings.

## Version 2

## 2.0.0 - 2021-03-28

- Major Refactor
- Migrated RandomNameGenerator from Class to wrapper module.
- Migrated tests from MiniTest to RSpec.
- Updated license from GPL-3.0 to LGP-L3.0
- Added experimental curse language.
- Moved executable to exe directory.
- Added `bin/run` script to pull in lib directory to gem path.
- Fixed issue with Gemfile.lock created on Apple M1 clashing with GitHub
  Action:
    ```
    $❯ bundle lock --add-platform x86_64-linux
    ```
