## 1.1.1

**New: pick an architecture**

* `init` now lets you choose an architecture instead of always writing the DDD default — `dart run archify init --arch mvvm`, or leave `--arch` off to be prompted.
* Two brand-new presets: **Feature-First** (flatter than DDD, with one service shared across a feature) and **MVC** (the simplest option). Both need nothing beyond the Flutter SDK.
* A third new preset, **VGV-Bloc**, follows the `flutter_bloc` Page/View convention — it's the one preset that needs a package, and `init` reminds you which.
* DDD and MVVM got a real cleanup too: entities, use cases, and repositories are now in the right layer instead of a flattened shortcut.

**New: `archify.yaml` stays in sync**

* `configure` and `generate` now remove what you remove. Deleting a key from `archify.yaml` deletes the matching file/folder from your project on the next run — nothing is left behind stale, and nothing is ever destroyed outright (removed files are backed up under `.archify/removed/`).

**Fixes**

* `app.dart` no longer references a theme file that might not exist, if you customized `structure`.

**Also**

* Added a full, runnable Flutter `example/` app (previously just a script) so you can try the CLI against a real project.

## 1.1.0

Archify is now driven entirely by a single `archify.yaml` file you control, instead of hardcoding one architecture.

**New commands**

* `init` — creates the default `archify.yaml`. Running it again when the file already exists just reports that instead of overwriting it.
* `configure` — reads `archify.yaml` and scaffolds the project from it. Creates `archify.yaml` first (via `init`) if it doesn't exist yet, then continues in the same run.
* `templates` — lists every built-in template key, split into what's in the default `archify.yaml` and what's opt-in. Reads from the same registry `configure`/`generate` use, so it can't drift out of date.
* `reset-project` — modeled on Expo's `npm run reset-project`. Resets `lib/` to a blank single-screen starter, optionally moving your existing code to `example/` first instead of deleting it.

**Breaking changes**

* `configure` no longer scaffolds a project immediately — see `init`/`configure` above. Automation/CI relying on the old one-shot behavior now needs to call `init` then `configure`.
* `generate <feature>` is driven by `archify.yaml`'s `feature_root`/`feature_template` keys instead of a hardcoded data/domain/presentation layout.
* `archify.yaml` uses a simpler nested-mapping schema instead of the old `{name, type, children, template}` list. A key with nested keys is a folder; a key mapped to a template name is a file:
  ```yaml
  structure:
    lib:
      core:
        api:
      shared:
        theme:
          app_colors.dart: theme_colors
  ```
  Any `archify.yaml` written before this version needs converting to this shape — run `dart run archify init` in an empty folder to see the new format.
* Archify no longer edits `pubspec.yaml`. `configure` prints the exact `flutter pub add ...` command instead, for the packages the optional Cubit/Bloc templates need.
* The default architecture is leaner: networking, navigation, storage, and DI helpers are no longer scaffolded by default. They're all still available — add the template name back into `archify.yaml` yourself (`dart run archify templates` lists them). `main.dart`, `app.dart`, and `root.dart` no longer import any third-party package.

**Also**

* Removed the now-unused `yaml_edit` and `path` dependencies.
* Cleaned up generated boilerplate — files now carry at most one short "add your X here" comment instead of speculative example code.
* Documented that Archify is architecture-agnostic, not DDD-specific: rewriting `structure`/`feature_template` to MVVM, MVC, or anything else works with zero code changes.

## 1.0.8

* Added **custom command** to generate fully custom features based on YAML templates.
* Custom feature generation now supports **dynamic placeholders** like `{feature_name}` in folder and file names.
* Improved **YAML parsing** and validation for nested folders and files.
* Added **backup of existing feature folders** if the feature already exists before regeneration.
* Updated README with **custom command usage examples**.
* Minor improvements and bug fixes in `fs_utils` and `custom_creator`.
