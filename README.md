# Archify CLI

Archify scaffolds a Flutter project and its features from one file you control: `archify.yaml`. It doesn't enforce an architecture — it just creates whatever folders and files you describe.

[![pub package](https://img.shields.io/pub/v/archify.svg)](https://pub.dev/packages/archify)

---

## 🚀 Quickstart

```bash
dart run archify init            # 1. pick an architecture, writes archify.yaml
dart run archify configure       # 2. scaffold the project
dart run archify generate auth   # 3. scaffold a feature
```

`init` asks which architecture to start from — press Enter for the default (DDD). To skip the prompt, pass `--arch`:

```bash
dart run archify init --arch mvvm
```

If you run `configure` or `generate` before `init`, Archify offers to run `init` for you first.

---

## 🏗️ Architectures

| Name | `--arch` key | Shape |
|---|---|---|
| DDD / Clean Architecture | `ddd` (default) | entities, use cases, repositories — one class per responsibility |
| MVVM | `mvvm` | model → repository → view model → view |
| Feature-First | `feature-first` | flatter than DDD, with one service shared across a feature's screens |
| MVC | `mvc` | the simplest option — model, repository, controller, view |
| VGV-Bloc | `vgv-bloc` | the `flutter_bloc` Page/View convention |

Every preset except VGV-Bloc needs nothing beyond the Flutter SDK. VGV-Bloc needs the `flutter_bloc` and `equatable` packages — `init` reminds you.

Run `dart run archify templates` to see every file each preset generates.

Want something else? Rewrite `structure`/`feature_template` in `archify.yaml` yourself — see below.

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
        app_colors.dart: theme_colors   # mapped to a template name → a file with that content
        my_notes.md:                    # blank, has a "." → an empty file
```

`structure` is scaffolded by `configure`. `feature_root` + `feature_template` — the same shape, plus a `{feature_name}` placeholder — are scaffolded by `generate`.

Rewriting either one works with **zero code changes**:

```yaml
feature_root: lib/features
feature_template:
  "{feature_name}":
    model:
      "{feature_name}_model.dart":
    view:
      "{feature_name}_view.dart":
```

`dart run archify generate profile` now produces `lib/features/profile/{model,view}/profile_*.dart` — empty files, since neither maps to a template name. Map one to a built-in key (e.g. `"{feature_name}_model.dart": model`) to pull in real starter content instead — `dart run archify templates` lists every key.

---

## 🔦 Commands

| Command | What it does |
|---|---|
| `init [--arch <name>]` | Creates `archify.yaml`. Prompts for an architecture if `--arch` isn't given. No-ops if `archify.yaml` already exists. |
| `configure` | Scaffolds the project from `archify.yaml`. Safe to re-run. |
| `generate <feature>` | Scaffolds a feature from `feature_template`. Safe to re-run. |
| `custom <feature> --template <file.yaml>` | Scaffolds a feature from a one-off template file instead of `archify.yaml` — see [below](#a-fully-custom-feature). |
| `templates` | Lists every built-in template. |
| `reset-project [--example-dir <name>]` | Resets `lib/` to a blank starter. |
| `version` | Prints the installed version. |

Archify never edits `pubspec.yaml`. After `configure`, it prints the exact `flutter pub add ...` command for anything opt-in you use.

---

## 📂 A closer look: the DDD default

```
lib/
├─ core/
│  ├─ error/       # Failure + Result<T>, no package needed
│  ├─ network/     # connectivity check, no package needed
│  ├─ usecase/     # base UseCase class
│  ├─ api/         # empty — opt-in
│  ├─ config/      # empty — opt-in
│  └─ models/
├─ feature/
├─ shared/         # theme, constants, images, reusable widgets
├─ app.dart
├─ main.dart
└─ root.dart
```

A generated feature (`dart run archify generate auth`):

```
lib/feature/auth/
├─ data/
│  ├─ datasources/       # talks to the outside world
│  ├─ models/            # extends the domain entity
│  └─ repositories/
├─ domain/
│  ├─ entities/
│  ├─ repositories/      # the only thing presentation depends on
│  └─ usecases/
└─ presentation/
   ├─ cubit/    (empty — add your own state management)
   ├─ page/
   └─ widget/
```

### Wiring up state management (opt-in)

Add `injection_container` to `structure`, and `cubit` + `cubit_state` + `feature_injection` to `feature_template`, and Archify generates a full chain: Cubit → use case → repository → data source, registered with GetIt. Two things it leaves for you:

* Wrap `MaterialApp` in a `MultiBlocProvider` — Archify only adds to that list, it doesn't create it.
* Call `ServiceLocator.init()` from `main.dart` — Archify leaves that line commented.

---

## ♻️ Editing `archify.yaml` after the fact

Change `structure` or `feature_template` any time and re-run `configure`/`generate` — Archify keeps your project in sync with the file:

* Add a key → it gets created.
* Remove a key → it gets removed from `lib/` too, instead of being left behind.

Nothing is ever deleted outright. A removed path moves to `.archify/removed/<timestamp>/`, so you can always get it back. Archify only ever touches what it created — tracked in `.archify/manifest.json`, which you should commit alongside `archify.yaml`. Anything you added by hand is never touched.

One exception: files with real code in them, like `app.dart`, are always regenerated fresh. If you've wired in a screen or a theme there, re-apply it after each `configure` run, the same way you already do after `generate`.

---

## A fully custom feature

For a one-off structure you don't want saved into `archify.yaml`:

```yaml
# custom_feature_template.yaml
feature:
  "{feature_name}":
    - name: "screens"
      type: folder
      children:
        - name: "{feature_name}_page.dart"
          type: file
```

```bash
dart run archify custom auth --template custom_feature_template.yaml
```

Files are always created empty. `{feature_name}` works in any folder or file name.

---

## 🔄 Resetting a project

```bash
dart run archify reset-project
```

Moves `lib/` to `example/` (or deletes it, if you say no) and creates a fresh `lib/main.dart`. Add `--example-dir <name>` to rename that backup folder.

---

## Version

```bash
dart run archify version
```
