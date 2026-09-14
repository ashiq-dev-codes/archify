# Archify CLI

Archify is a CLI for Flutter/Dart developers that scaffolds a project and its features from a single `archify.yaml` file you control. It's **architecture-agnostic** — Archify doesn't know or enforce DDD, MVVM, or anything else, it just creates whatever folder/file tree you describe.

[![pub package](https://img.shields.io/pub/v/archify.svg)](https://pub.dev/packages/archify)

---

## 🚀 Quickstart

```bash
dart run archify init        # 1. pick an architecture, writes archify.yaml
# edit archify.yaml if you want to tweak the structure
dart run archify configure   # 2. scaffolds the project from it
dart run archify generate auth   # 3. generate a feature/module
```

`init` prompts for an architecture (Enter keeps the default, DDD) — or skip the prompt with `dart run archify init --arch mvvm`. `dart run archify init --arch` with no value, or any unrecognized name, prints the available keys.

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

Archify ships two full architecture presets you pick between at `init` time — **DDD/Clean Architecture** (the default) and **MVVM**, both scaffolded with real starter content, not empty files. `dart run archify generate profile` under the MVVM preset produces `lib/feature/profile/{model,view,viewmodel}/profile_*.dart`, where the view is a `StatefulWidget` already wired to a `ChangeNotifier` view model via `ListenableBuilder` — no state-management package required.

For anything beyond those two — MVC, or your own house style — rewrite `structure`/`feature_template` yourself; it works with **zero code changes**:

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

`dart run archify generate profile` now produces `lib/features/profile/{model,view,viewmodel}/profile_*.dart` — empty files, ready for your own code, since none of these map to a template key (`"{feature_name}_model.dart":` is blank). Map one to a built-in key (`"{feature_name}_model.dart": model`, `: view`, `: viewmodel`) to pull in the same starter content the MVVM preset uses — see `dart run archify templates`.

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
* `main.dart`, `app.dart`, and `root.dart` use nothing beyond the Flutter SDK, and don't assume any other generated file exists either — theming, DI, and your first screen are left as commented-out spots in `app.dart` for you to wire up, exactly like MultiBlocProvider, error logging, local storage, and DevicePreview already were.
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
| `init [--arch <ddd\|mvvm>]` | Creates `archify.yaml` from the chosen architecture preset (prompts if `--arch` is omitted). No-ops (with a message) if `archify.yaml` already exists. |
| `configure` | Scaffolds the project from `archify.yaml`. Safe to re-run — creates/updates what changed **and backs up what you removed** (see [below](#editing-archifyyaml-after-the-fact)). Prompts before overwriting `lib/main.dart` if it looks like real code (not the default counter app), and keeps a `.bak` copy. |
| `generate <feature>` | Scaffolds a feature from `archify.yaml`'s `feature_template`. Re-running it for an existing feature reconciles it the same way `configure` does. |
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

## Editing `archify.yaml` after the fact

`structure` and `feature_template` are meant to be rewritten, not just written once — `configure`/`generate` fully reconcile the tree to match what's currently in the YAML, in both directions:

* Add a key → the file/folder gets created next run, like always.
* Remove a key → whatever it created gets pulled out of `lib/` next run too, instead of being left behind stale.

Nothing is ever deleted outright. A path Archify stops managing is moved to `.archify/removed/<timestamp>/...`, preserving where it was — recoverable, not destroyed, the same way `configure` keeps a `.bak` of `lib/main.dart` before touching it. It's safe to delete that folder (or gitignore it) once you're sure you don't need it back.

This only ever touches paths Archify itself created. To know which ones that is, `configure`/`generate` keep a manifest at `.archify/manifest.json` recording what the last run produced — **commit it** alongside `archify.yaml` so reconciliation stays consistent across machines and CI. Anything you added by hand inside those same folders (a widget you wrote in `shared/widget/` after scaffolding, say) was never in the manifest, so it's never touched.

Note this doesn't extend to files with real Dart code in them that Archify regenerates unconditionally, like `app.dart` — if you've wired in a `home:` screen or a theme, re-running `configure` overwrites it back to the bare template. Re-apply your wiring after each `configure` run, the same way you already do after `generate`.

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
