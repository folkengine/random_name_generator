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
