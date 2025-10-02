# Archify CLI

Archify is a CLI tool for Flutter/Dart developers to quickly scaffold projects and features following clean architecture principles. It helps maintain a consistent structure, reduces boilerplate, and now supports **fully custom project architectures**.

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

> ⚠️ You can still customize your project structure completely using **custom templates**.

---

## 🔦 Features

* **Configure Command**
  Creates the base project structure under `lib/core` and `lib/shared` with common folders like:

  * `config`
  * `api`
  * `model`
  * `utils`
  * `widgets`

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
dart run archify configure
```

> ⚠️ Running this on an existing project may overwrite files. Archify will prompt before overwriting.

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

### Version

```bash
dart run archify version
```
