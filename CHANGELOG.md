## 1.1.0

* **Breaking:** Archify's whole workflow is now driven by a single `archify.yaml` file you control, split across two commands:
  * **Added `init` command** — writes the default `archify.yaml` (matching today's default architecture) and stops. Running it again when `archify.yaml` already exists just reports that, and points you at `configure`.
  * **`configure` no longer scaffolds immediately** — it now reads `archify.yaml`'s `structure` section and creates exactly the folders/files it describes. If `archify.yaml` doesn't exist yet, it asks whether to run `init` first, then continues scaffolding in the same run.
  * Known files (theme, storage, navigation, `main.dart`, `app.dart`, etc.) keep their existing starter boilerplate via a `template:` key on their node; any file you add without one is created empty — the architecture is fully yours to rename, extend, or trim.
* **Breaking:** Leaned out the default architecture — `core/config/{config.dart,dio.dart}`, `shared/utils/{dio,navigation,route,storage}`, and root-level `injection_container.dart` are no longer scaffolded by default (the same goes for `generate`'s default `feature_template`, which no longer includes the `feature_injection` wiring file, since it depended on `injection_container.dart`). `app.dart` and `main.dart` no longer reference any of them. All of the underlying templates (`app_config`, `dio_client`, `dio_interceptor`, `navigation_utils`, `navigation`, `route_tracker`, `app_storage`, `local_storage`, `injection_container`, `feature_injection`) still exist — add their node back into your `archify.yaml` (documented at the top of the generated file) if you want that boilerplate.
* **Breaking:** `main.dart`, `app.dart`, and `root.dart` no longer use any third-party package — removed `MultiBlocProvider` (flutter_bloc) from `app.dart`, `AppLogger`/error-logging (corextra) and `SharedPreferences` init (shared_preferences) from `main.dart`, and `DevicePreview` (device_preview) from `root.dart`. Each is left as a commented-out example showing how to add it back; wiring a generated feature's blocs into `app.dart` via the opt-in `feature_injection` template now also requires manually re-adding the `MultiBlocProvider` wrapper first.
* **Breaking:** Archify no longer touches `pubspec.yaml` at all — it used to auto-inject `dio`, `get_it`, `corextra`, `equatable`, `flutter_bloc`, `device_preview`, and `shared_preferences`, and to strip comments while doing so. Neither default (`structure` nor `feature_template`) needs any package now, so `configure` only prints a `flutter pub add equatable flutter_bloc` reminder for the opt-in Cubit/Bloc templates. Removed the now-unused `yaml_edit` dependency.
* **Breaking:** `generate <feature>` is now driven by `archify.yaml`'s `feature_root`/`feature_template` keys instead of a hardcoded data/domain/presentation layout — customize what a generated feature looks like the same way you customize the base architecture, including renaming `feature_root` away from `lib/feature`.
  * If `archify.yaml` doesn't exist yet, `generate` asks whether to run `init` first; answering yes creates the default config and continues straight into generation with it.
  * `presentation/cubit` is now scaffolded as an empty folder — the `{feature_name}_cubit.dart`/`_state.dart` files are opt-in (`template: cubit`/`cubit_state`), so you add your own state-management files by hand instead of getting Bloc/Cubit boilerplate whether you want it or not.
  * Auto-wiring into `injection_container.dart`/`app.dart` now only runs when the feature template includes a `feature_injection`-templated file (opt-in, see above).
* Added **`reset-project` command** (modeled on Expo's `npm run reset-project`): resets `lib/` to a blank single-screen starter, optionally moving existing code to `example/` (or a custom folder via `--example-dir`) first instead of deleting it.
* Stripped speculative "Example:" placeholder comments and commented-out Sentry/tracker/example-override snippets from every `configure` and `generate` template — generated files (base architecture and features alike) now carry at most one short "add your X here" hint instead of prescribing code you may never use. Fixed the opt-in `app_storage` template along the way: it no longer depends on a `preferences` global in `main.dart` (removed above) and now manages its own `SharedPreferences` instance.
* Documented explicitly (README + `archify.yaml`) that Archify is architecture-agnostic, not DDD-specific — the shipped DDD/Clean-Architecture layout is a starting point, not a constraint. Rewriting `structure`/`feature_template` to an MVVM (`model`/`view`/`viewmodel`), MVC, or any other shape works with zero code changes.
* **Breaking:** Replaced `archify.yaml`'s verbose `{name, type: folder|file, children, template}` list schema with a plain nested mapping that reads like an actual file tree — nested keys are a folder, a key mapped to a template name is a file, and a blank key is an empty file (if the name has a `.`) or empty folder (if it doesn't):
  ```yaml
  structure:
    lib:
      core:
        api:
      shared:
        theme:
          app_colors.dart: theme_colors
  ```
  This cuts the default `archify.yaml` to roughly a third of its previous length and removes an entire category of hand-editing mistakes (forgetting `type: file`, misplacing `children:`). The same shape applies to `feature_template`.
* Cut `archify.yaml`'s header from ~85 lines of comments to about a dozen — the exhaustive built-in template list and narrative docs moved out to a new **`templates` command** and the README, so the file itself only explains the folder/file/template rule.
* Added **`dart run archify templates`**: lists every built-in template key (which are in the default `archify.yaml`, which are opt-in) read directly from the same registries `configure`/`generate` dispatch against, so the list can never drift out of sync with what the code actually supports.
* Migration note: automation/CI that ran `dart run archify configure` expecting an immediate full scaffold now needs `dart run archify init` followed by `dart run archify configure`, must add the recommended packages to `pubspec.yaml` manually, and any hand-written `archify.yaml` needs converting to the new nested-mapping shape (`dart run archify init` in a fresh directory to see the new format).

## 1.0.8

* Added **custom command** to generate fully custom features based on YAML templates.
* Custom feature generation now supports **dynamic placeholders** like `{feature_name}` in folder and file names.
* Improved **YAML parsing** and validation for nested folders and files.
* Added **backup of existing feature folders** if the feature already exists before regeneration.
* Updated README with **custom command usage examples**.
* Minor improvements and bug fixes in `fs_utils` and `custom_creator`.
