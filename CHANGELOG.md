## 1.1.0

* **Breaking:** Archify's whole workflow is now driven by a single `archify.yaml` file you control, split across two commands:
  * **Added `init` command** — writes the default `archify.yaml` (matching today's default architecture) and stops. Running it again when `archify.yaml` already exists just reports that, and points you at `configure`.
  * **`configure` no longer scaffolds immediately** — it now reads `archify.yaml`'s `structure` section and creates exactly the folders/files it describes. If `archify.yaml` doesn't exist yet, it asks whether to run `init` first, then continues scaffolding in the same run.
  * Known files (theme, dio, config, storage, navigation, `main.dart`, `app.dart`, `injection_container.dart`, etc.) keep their existing starter boilerplate via a `template:` key on their node; any file you add without one is created empty — the architecture is fully yours to rename, extend, or trim.
* **Breaking:** Archify no longer touches `pubspec.yaml` at all — it used to auto-inject `dio`, `get_it`, `corextra`, `equatable`, `flutter_bloc`, `device_preview`, and `shared_preferences`, and to strip comments while doing so. It now only prints the `flutter pub add ...` command for you to run yourself. Removed the now-unused `yaml_edit` dependency.
* **Breaking:** `generate <feature>` is now driven by `archify.yaml`'s `feature_root`/`feature_template` keys instead of a hardcoded data/domain/presentation layout — customize what a generated feature looks like the same way you customize the base architecture, including renaming `feature_root` away from `lib/feature`.
  * If `archify.yaml` doesn't exist yet, `generate` asks whether to run `init` first; answering yes creates the default config and continues straight into generation with it.
  * Auto-wiring into `injection_container.dart`/`app.dart` now only runs when the feature template includes a `feature_injection`-templated file (the default does).
* Added **`reset-project` command** (modeled on Expo's `npm run reset-project`): resets `lib/` to a blank single-screen starter, optionally moving existing code to `example/` (or a custom folder via `--example-dir`) first instead of deleting it.
* Migration note: automation/CI that ran `dart run archify configure` expecting an immediate full scaffold now needs `dart run archify init` followed by `dart run archify configure`, and must add the recommended packages to `pubspec.yaml` manually.

## 1.0.8

* Added **custom command** to generate fully custom features based on YAML templates.
* Custom feature generation now supports **dynamic placeholders** like `{feature_name}` in folder and file names.
* Improved **YAML parsing** and validation for nested folders and files.
* Added **backup of existing feature folders** if the feature already exists before regeneration.
* Updated README with **custom command usage examples**.
* Minor improvements and bug fixes in `fs_utils` and `custom_creator`.
