# Archify CLI

Archify is a CLI tool for Flutter/Dart developers to quickly scaffold projects and features following clean architecture principles. It helps maintain a consistent structure, reduces boilerplate, and now supports **fully custom project architectures** — including the base project structure itself, driven by an `archify.yaml` file you control.

[![pub package](https://img.shields.io/pub/v/archify.svg)](https://pub.dev/packages/archify)

---

## 📂 Project Structure (Default)

```
project/
├─ lib/
│  └─ core/
│     ├─ api/
│     ├─ config/
│     │  ├─ config.dart
│     │  └─ dio.dart
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
│     │  ├─ dio/
│     │  │  └─ dio_interceptors.dart
│     │  ├─ navigation/
│     │  │  ├─ navigation_utils.dart
│     │  │  └─ navigation.dart
│     │  ├─ route/
│     │  │  └─ route_tracker.dart
│     │  └─ storage/
│     │     ├─ app_storage.dart
│     │     └─ local_storage.dart
│     ├─ widget/
│     │  ├─ global/
│     │  │  └─ custom_snack_bar.dart
│     │  └─ loading/
│     │     └─ loading_dialog.dart
│  └─ app.dart
│  └─ injection_container.dart
│  └─ main.dart
│  └─ root.dart
├─ pubspec.yaml
└─ README.md
```

> ⚠️ This is just the **default**. `configure` writes this layout into an `archify.yaml` file you can freely rename, add to, or delete nodes from before anything is generated.

---

## 🔦 Features

* **Configure Command**
  Two-step, YAML-driven base project scaffolding:

  1. `dart run archify configure` with no `archify.yaml` present writes the default config above and stops — nothing else is touched.
  2. Edit `archify.yaml` however you want (rename folders, drop files, add your own empty ones).
  3. Run `dart run archify configure` again to scaffold exactly what `archify.yaml` describes. Re-running it later after further edits only creates/updates what changed.

  Archify **never edits `pubspec.yaml`** — it prints the packages the default templates expect (`dio`, `get_it`, `corextra`, `equatable`, `flutter_bloc`, `device_preview`, `shared_preferences`) so you can add them yourself with `flutter pub add`.

* **Generate Command**
  Quickly scaffolds a new feature/module with default layers:

  * `data`
  * `domain`
  * `presentation`
  * `[feature]_injection.dart` (for Bloc wiring)

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

* **Automatic Injection & Bloc Wiring**
  (Only for default generate command)

  * Creates `[feature]_injection.dart` for repositories, data sources, and blocs.
  * Automatically updates `injection_container.dart`.
  * Updates `app.dart` `MultiBlocProvider` with new feature blocs.

* **Utils**

  * File & folder creation helpers
  * Pubspec name reader
  * Version management utilities

---

## 🚀 Usage

### Configure project base folders

```bash
# 1) First run: writes the default archify.yaml and stops
dart run archify configure

# 2) Customize archify.yaml however you like, then run again to scaffold
dart run archify configure
```

> ⚠️ Applying `archify.yaml` on an existing project may overwrite `lib/main.dart` if its content differs from what Archify would generate. Archify will prompt before overwriting (unless it looks like the default, untouched Flutter counter app) and keeps a `.bak` copy.

> 📦 Archify never edits `pubspec.yaml`. After scaffolding, add whichever recommended packages you use with `flutter pub add ...` (the exact command is printed and also documented at the top of `archify.yaml`).

---

### Generate a new feature/module (Default)

```bash
dart run archify generate auth
```

Example output:

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
└─ auth_injection.dart
```

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
