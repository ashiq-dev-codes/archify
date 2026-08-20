# Archify CLI

Archify is a CLI for Flutter/Dart developers that scaffolds a project and its features from a single `archify.yaml` file you control. It's **architecture-agnostic** — Archify doesn't know or enforce DDD, MVVM, or anything else, it just creates whatever folder/file tree you describe.

[![pub package](https://img.shields.io/pub/v/archify.svg)](https://pub.dev/packages/archify)

---

## 🚀 Quickstart

```bash
dart run archify init        # 1. writes the default archify.yaml
# edit archify.yaml if you want a different structure
dart run archify configure   # 2. scaffolds the project from it
dart run archify generate auth   # 3. generate a feature/module
```

If you skip straight to `configure` or `generate` with no `archify.yaml` present, they'll ask to run `init` for you first and then continue — you don't have to run the three commands in strict separate steps.

---

## 📄 How `archify.yaml` works

Each key is a folder or a file, decided by its value:

```yaml
structure:
  lib:
    core:              # nested keys → a folder
      api:             # blank, no "." in the name → an empty folder
    shared:
      theme:
        app_colors.dart: theme_colors   # mapped to a template name → a file with that boilerplate
        my_notes.md:                    # blank, has a "." → an empty file
```

`structure` is scaffolded by `configure`; `feature_root` + `feature_template` (the same shape, plus a `{feature_name}` placeholder) are scaffolded by `generate`. Run `dart run archify templates` any time to see every built-in template name and whether it's in the default `archify.yaml` or opt-in.

Archify ships with a DDD/Clean-Architecture-flavored default to get you started, but rewriting `structure`/`feature_template` to MVVM, MVC, or anything else works with **zero code changes**:

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

`dart run archify generate profile` now produces `lib/features/profile/{model,view,viewmodel}/profile_*.dart` — empty files, ready for your own code, since none of them name a built-in template.

---

## 📂 Default architecture

```
lib/
├─ core/
│  ├─ api/
│  ├─ config/
│  └─ model/
├─ feature/
├─ shared/
│  ├─ constant/
│  │  └─ constant.dart
│  ├─ path/
│  │  ├─ app_images.dart
│  │  └─ app_svg.dart
│  ├─ theme/
│  │  ├─ app_colors.dart
│  │  ├─ app_themes.dart
│  │  └─ main_theme.dart
│  ├─ utils/
│  └─ widget/
│     ├─ global/custom_snack_bar.dart
│     └─ loading/loading_dialog.dart
├─ app.dart
├─ main.dart
└─ root.dart
```

* `core/config` and `shared/utils` are empty on purpose — the networking (`dio_client`/`app_config`), navigation, route-tracking, local-storage, and DI (`injection_container`) helpers that used to live here are now **opt-in**. `dart run archify templates` lists them.
* `main.dart`, `app.dart`, and `root.dart` use nothing beyond the Flutter SDK. MultiBlocProvider, error logging, local storage, and DevicePreview are left as commented-out examples for you to wire up if you want them.
* Archify **never edits `pubspec.yaml`** — after `configure`, it prints the exact `flutter pub add ...` command for whichever opt-in templates need a package.

A generated feature (`dart run archify generate auth`) follows the same idea:

```
lib/feature/auth/
├─ data/
│  ├─ data_source_impl/
│  └─ repo_impl/
├─ domain/
│  ├─ data_source/
│  └─ repo/
└─ presentation/
   ├─ cubit/    (empty — add your own state management)
   ├─ page/
   │  └─ auth_page.dart
   └─ widget/
```

---

## 🔦 Commands

| Command | What it does |
|---|---|
| `init` | Creates `archify.yaml`. No-ops (with a message) if it already exists. |
| `configure` | Scaffolds the project from `archify.yaml`. Safe to re-run — only creates/updates what changed. Prompts before overwriting `lib/main.dart` if it looks like real code (not the default counter app), and keeps a `.bak` copy. |
| `generate <feature>` | Scaffolds a feature from `archify.yaml`'s `feature_template`. |
| `custom <feature> --template <file.yaml>` | Scaffolds a feature from a one-off YAML template instead of `archify.yaml` — see [below](#generate-a-fully-custom-feature). |
| `templates` | Lists every built-in template key. |
| `reset-project [--example-dir <name>]` | Resets `lib/` to a blank single-screen starter — see [below](#reset-a-project-back-to-a-blank-starter). |
| `version` | Prints the installed Archify version. |

### Automatic injection & Bloc wiring (opt-in)

Add a `feature_injection` file to `feature_template` (see `dart run archify templates`) to get:

* A `[feature]_injection.dart` registering the feature's repository, data source, and Cubit with GetIt.
* An automatic import + init call added to `injection_container.dart` — add `injection_container` back to `structure` too.
* An automatic entry in `app.dart`'s `MultiBlocProvider` `providers: [...]` list — you need to wrap `MaterialApp` in a `MultiBlocProvider` yourself first (see the commented example in generated `app.dart`); Archify only inserts into an existing list, it doesn't add the wrapper.

---

## Generate a fully custom feature

For a one-off structure you don't want saved into `archify.yaml`, pass an ad hoc template file instead:

```yaml
# custom_feature_template.yaml
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
```

```bash
dart run archify custom auth --template custom_feature_template.yaml
```

```
lib/auth/screens/auth_page.dart
lib/auth/models/auth_model.dart
```

Files are always created empty; `{feature_name}` works in any folder or file name.

---

## Reset a project back to a blank starter

```bash
dart run archify reset-project
dart run archify reset-project --example-dir old_app   # custom folder name
```

You'll be asked whether to keep your current code:

* **Yes (default):** `lib/` is renamed to `example/` (or your `--example-dir` name), then a fresh `lib/` is created.
* **No:** `lib/` is deleted, then a fresh `lib/` is created.

Either way, the new `lib/main.dart` is just a centered `Text('Edit lib/main.dart to get started')`. The old-code folder is never wired into your app — like Expo's `app-example/`, it's just there for reference until you delete it.

---

## Version

```bash
dart run archify version
```
