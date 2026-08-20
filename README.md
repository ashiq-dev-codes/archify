# Archify CLI

Archify is a CLI tool for Flutter/Dart developers to quickly scaffold projects and features. It helps maintain a consistent structure, reduces boilerplate, and is **architecture-agnostic** — the base project structure and every generated feature are driven entirely by an `archify.yaml` file you control.

[![pub package](https://img.shields.io/pub/v/archify.svg)](https://pub.dev/packages/archify)

> Archify ships with a DDD/Clean-Architecture-flavored default (below) to get you started, but it doesn't know or enforce any particular architecture. `archify.yaml` is just a plain nested tree — a key with nested keys is a folder, a key mapped to a template name is a file, and a blank key is an empty file/folder. `configure` and `generate` just walk whatever tree you put under `structure`/`feature_template`. Rewrite either one completely to follow MVVM, MVC, Redux, or anything else — swap `data`/`domain`/`presentation` for `model`/`view`/`viewmodel`, drop the built-in template names you don't need (untemplated files are just created empty), and Archify follows your architecture, not the other way around. Run `dart run archify templates` any time to see every built-in template name.

---

## 📂 Project Structure (Default)

```
project/
├─ lib/
│  └─ core/
│     ├─ api/
│     ├─ config/
│     ├─ model/
│  └─ feature/
│  └─ shared/
│     ├─ constant/
│     │  └─ constant.dart
│     ├─ path/
│     │  ├─ app_images.dart
│     │  └─ app_svg.dart
│     ├─ theme/
│     │  ├─ app_colors.dart
│     │  ├─ app_themes.dart
│     │  └─ main_theme.dart
│     ├─ utils/
│     ├─ widget/
│     │  ├─ global/
│     │  │  └─ custom_snack_bar.dart
│     │  └─ loading/
│     │     └─ loading_dialog.dart
│  └─ app.dart
│  └─ main.dart
│  └─ root.dart
├─ pubspec.yaml
└─ README.md
```

> ⚠️ This is just the **default**. `init` writes this layout into an `archify.yaml` file you can freely rename, add to, or delete nodes from before anything is generated.
>
> `core/config` and `shared/utils` are empty placeholder folders by default — the networking (`dio_client`/`app_config`), navigation-helper, route-tracker, local-storage, and GetIt `injection_container` boilerplate that used to ship here are now **opt-in**: add the matching template name back into `archify.yaml` yourself (`dart run archify templates` lists them all) if you want that pattern.
>
> `main.dart`, `app.dart`, and `root.dart` are plain Flutter widgets with no third-party imports — `MultiBlocProvider` (flutter_bloc), error logging (corextra), local storage init (shared_preferences), and `DevicePreview` (device_preview) are left as commented-out examples in the generated files for you to uncomment and wire up if you want them.

---

## 🔦 Features

* **Init Command**
  `dart run archify init` writes the default `archify.yaml` above and stops — nothing else is touched. If it already exists, it just reports that and points you at `configure`. Edit `archify.yaml` however you want (rename folders, drop files, add your own empty ones) before scaffolding anything.

* **Configure Command**
  `dart run archify configure` reads `archify.yaml` and scaffolds exactly what it describes. Re-running it later after further edits only creates/updates what changed. If `archify.yaml` doesn't exist yet, it asks whether to run `init` first (which creates it) before continuing — no need to run two separate commands.

  Archify **never edits `pubspec.yaml`**, and neither default needs anything beyond the Flutter SDK — `main.dart`/`app.dart`/`root.dart` only reach for third-party packages (error logging, local storage, device preview) inside commented-out examples you opt into yourself. `configure` prints a reminder for the one opt-in exception: the Cubit/Bloc templates (`equatable`/`flutter_bloc`), if you add them back.

* **Generate Command**
  Driven entirely by `archify.yaml`'s `feature_root`/`feature_template` keys — customize what a generated feature looks like the same way you customize the base architecture. The default template scaffolds:

  * `data`
  * `domain`
  * `presentation` — just a `page` (Flutter SDK only) and an empty `cubit`/`widget` folder; add your own Cubit/state files or a different state-management approach

  If `archify.yaml` doesn't exist yet, `generate` asks whether to run `init` first (which creates it) before continuing with generation — no need to run two separate commands.

* **Custom Command**
  Generate **fully custom features** using a YAML template. Supports:

  * Arbitrary folder/file structures
  * Placeholder `{feature_name}` in file/folder names
  * Nested folders and files
  * Optional injection or any state management structure

* **Reset-Project Command**
  Resets `lib/` back to a blank starter app — modeled directly on Expo's `npm run reset-project`:

  * Prompts to keep your current code (moved to `example/`, or a custom folder via `--example-dir`) or discard it.
  * Writes a fresh `lib/main.dart` with a single centered-text screen, nothing else.

* **Templates Command**
  `dart run archify templates` lists every built-in template name — which ones are in the default `archify.yaml` and which are opt-in — read straight from the same registry `configure`/`generate` use, so it never drifts out of date.

* **Automatic Injection & Bloc Wiring** (opt-in)
  Not included in the default `feature_template` — add a `feature_injection` file node (run `dart run archify templates` for the exact key names) to get:

  * A `[feature]_injection.dart` for repositories, data sources, and blocs.
  * Automatic updates to `injection_container.dart` (add `injection_container.dart: injection_container` back to `structure` too).
  * Insertion into `app.dart`'s `MultiBlocProvider` `providers: [...]` list — you need to wrap `MaterialApp` in a `MultiBlocProvider` yourself first (see the commented example in the generated `app.dart`), since Archify only inserts into an existing list, it doesn't add the wrapper.

* **Utils**

  * File & folder creation helpers
  * Pubspec name reader
  * Version management utilities

---

## 🚀 Usage

### Configure project base folders

```bash
# 1) Create archify.yaml
dart run archify init

# 2) Customize archify.yaml however you like, then scaffold from it
dart run archify configure
```

Skip straight to `configure` if you want — with no `archify.yaml` present it asks whether to run `init` for you first, then continues scaffolding in the same run:

```
❌ No archify.yaml found. Run `dart run archify init` first to create it.
Run init now? [Y/n]:
```

> ⚠️ Applying `archify.yaml` on an existing project may overwrite `lib/main.dart` if its content differs from what Archify would generate. Archify will prompt before overwriting (unless it looks like the default, untouched Flutter counter app) and keeps a `.bak` copy.

> 📦 Archify never edits `pubspec.yaml`. After scaffolding, `configure` prints the exact `flutter pub add ...` command for any opt-in templates that need one.

---

### Generate a new feature/module (Default)

```bash
dart run archify generate auth
```

If `archify.yaml` doesn't exist yet:

```
❌ No archify.yaml found. Run `dart run archify init` first to create it.
Run init now? [Y/n]:
```

Answering yes creates the default `archify.yaml` and immediately continues generating the feature from it — you don't need to run `init` separately first.

`generate` reads the `feature_root` and `feature_template` keys from `archify.yaml`, so you can customize what a generated feature looks like exactly like you customize the base architecture (rename folders, drop layers, add your own empty files, point `feature_root` somewhere other than `lib/feature`). With the default template, `dart run archify generate auth` produces:

```
lib/feature/auth/
├─ data/
│  ├─ data_source_impl/
│  └─ repo_impl/
├─ domain/
│  ├─ data_source/
│  └─ repo/
├─ presentation/
│  ├─ cubit/
│  ├─ page/
│  └─ widget/
```

Prefer MVVM (or anything else)? Replace `feature_template` in `archify.yaml` — no code changes, no flags:

```yaml
feature_root: lib/features

feature_template:
  "{feature_name}":
    model:
      "{feature_name}_model.dart":
    view:
      "{feature_name}_view.dart":
    viewmodel:
      "{feature_name}_viewmodel.dart":
```

`dart run archify generate profile` now produces `lib/features/profile/{model,view,viewmodel}/profile_*.dart` — empty files, since none of them name a built-in template, ready for you to fill in with your own MVVM code.

---

### Generate a fully custom feature

1. Create a YAML template (`custom_feature_template.yaml`):

```yaml
feature:
  "{feature_name}":
    - name: "screens"
      type: folder
      children:
        - name: "{feature_name}_page.dart"
          type: file
    - name: "models"
      type: folder
      children:
        - name: "{feature_name}_model.dart"
          type: file
    - name: "services"
      type: folder
      children:
        - name: "api"
          type: folder
          children:
            - name: "{feature_name}_api.dart"
              type: file
```

2. Run the custom generation:

```bash
dart run archify custom auth --template arch/custom_feature_template.yaml
```

This creates:

```
lib/auth/screens/auth_page.dart
lib/auth/models/auth_model.dart
lib/auth/services/api/auth_api.dart
```

*Supports nested folders and files with dynamic names using `{feature_name}`.*

---

### Reset the project back to a blank starter

```bash
dart run archify reset-project

# Or move existing code to a custom folder name instead of example/
dart run archify reset-project --example-dir old_app
```

You'll be asked:

```
📦 Keep your current code? It will be moved to "example/" instead of deleted. [Y/n]:
```

* **Yes (default):** `lib/` is renamed to `example/` (or your `--example-dir` name) untouched, then a fresh `lib/` is created.
* **No:** `lib/` is deleted entirely, then a fresh `lib/` is created.

Either way, the new `lib/main.dart` is just:

```dart
Center(child: Text('Edit lib/main.dart to get started'))
```

`example/` (or whatever you named it) is never wired into your app — it's an inert copy of your old code for reference, exactly like Expo's `app-example/`. Delete it whenever you're done with it.

---

### Version

```bash
dart run archify version
```
