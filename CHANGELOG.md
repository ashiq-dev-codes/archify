## 1.1.0

* **Behavior change:** `configure` is now driven by `archify.yaml` instead of scaffolding immediately.
  * First run (no `archify.yaml` present) only writes the default config file and stops — no folders, no `pubspec.yaml` edits.
  * Edit `archify.yaml` to customize the base architecture however you want (rename, add, or remove folders/files).
  * Run `configure` again to scaffold exactly what `archify.yaml` describes; re-running after further edits only creates/updates what changed.
  * Known files (theme, dio, config, storage, navigation, `main.dart`, `app.dart`, `injection_container.dart`, etc.) keep their existing starter boilerplate via a `template:` key; any file you add without one is created empty.
* **Behavior change:** Archify no longer touches `pubspec.yaml` at all — it used to auto-inject `dio`, `get_it`, `corextra`, `equatable`, `flutter_bloc`, `device_preview`, and `shared_preferences`, and to strip comments while doing so. It now only prints the `flutter pub add ...` command for you to run yourself.
* Migration note: automation/CI that ran `dart run archify configure` expecting an immediate full scaffold now needs a second invocation (after `archify.yaml` is created), and must add the recommended packages manually.
* Removed the now-unused `yaml_edit` dependency.

## 1.0.8

* Added **custom command** to generate fully custom features based on YAML templates.
* Custom feature generation now supports **dynamic placeholders** like `{feature_name}` in folder and file names.
* Improved **YAML parsing** and validation for nested folders and files.
* Added **backup of existing feature folders** if the feature already exists before regeneration.
* Updated README with **custom command usage examples**.
* Minor improvements and bug fixes in `fs_utils` and `custom_creator`.
