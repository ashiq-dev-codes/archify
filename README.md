# Archify CLI

Archify is a CLI tool for Flutter/Dart developers to quickly scaffold projects and features following clean architecture principles. It helps maintain a consistent structure and reduces boilerplate.

[![pub package](https://img.shields.io/pub/v/archify.svg)](https://pub.dev/packages/archify)

---

## 📂 Project Structure

```
project/
├─ lib/
│  └─ core/
│     ├─ api/
│     ├─ config/
│     │  ├─ config.dart
│     │  └─ dio.dart
│     ├─ model/
│  └─ features/
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
│     │  │  └─ dio_intrepters.dart
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

---

## ⚡️ Features

* **Configure Command**
  Creates the base project structure under `lib/core` and `lib/shared` with common folders like:

  * `config`
  * `api`
  * `model`
  * `utils`
  * `widgets`

* **Generate Command**
  Quickly scaffolds a new feature/module with layers:

  * `data`
  * `domain`
  * `presentation`
  * `[feature]_injection.dart`

* **Automatic Injection & Blocs Wiring**
  When you generate a feature, Archify will also:

  * Create `[feature]_injection.dart` for registering repositories, data sources, and blocs.
  * Automatically update `injection_container.dart` with init and clear functions.
  * Update `app.dart` `MultiBlocProvider` with your new feature blocs.

* **Utils**

  * File & folder creation helpers
  * Pubspec name reader
  * Version management utilities

---

## 🚀 Usage

### Configure project base folders

```bash
dart run archify configure
```

> ⚠️ **Note:** Running this on an existing project may overwrite some files. Archify will prompt for confirmation to avoid accidental data loss.

### Generate a new feature/module

```bash
dart run archify generate auth
```

### Example

```bash
dart run archify generate profile
```

This generates:

```
lib/features/profile/
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
└─ profile_injection.dart
```

---
