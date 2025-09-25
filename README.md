# Archify CLI

A sample command-line application with an entrypoint in `bin/`, organized library code in `lib/`, and example unit tests in `test/`.  
Archify helps you **configure** and **generate** project structures with a clean architecture for Flutter/Dart projects.

---

## 📂 Project Structure

```
archify/
├─ bin/
│  └─ archify.dart                 # CLI entrypoint
├─ lib/
│  └─ src/
│     ├─ archify_cli.dart          # CLI bootstrap
│     ├─ commands/                 # Command modules
│     │  ├─ configure/             # Project configuration commands
│     │  │  ├─ folders/            # Folder creators for core/shared
│     │  │  │  ├─ core/
│     │  │  │  │  ├─ api/
│     │  │  │  │  │  └─ api_creator.dart
│     │  │  │  │  ├─ config/
│     │  │  │  │  │  └─ config_creator.dart
│     │  │  │  │  ├─ model/
│     │  │  │  │  │  └─ model_creator.dart
│     │  │  │  └─ shared/
│     │  │  │     └─ folders.dart
│     │  │  ├─ packages/
│     │  │  │  └─ packages.dart
│     │  │  ├─ readme/
│     │  │  │  └─ readme.dart
│     │  │  └─ configure.dart
│     │  ├─ generate/              # Feature/module generator
│     │  │  └─ generate.dart
│     │  └─ utils/                 # Shared utilities
│     │     ├─ pubspec_utils.dart
│     │     └─ version_utils.dart
│  └─ archify.dart
├─ pubspec.yaml
└─ README.md
```

---

## ⚡️ Features

- **Configure Command**  
  Creates the base project structure under `lib/core` and `lib/shared` with common folders like:
  - `config`
  - `api`
  - `model`
  - `utils`
  - `widgets`

- **Generate Command**  
  Quickly scaffolds a new feature/module with layers:
  - `data`
  - `domain`
  - `presentation`
  - `[feature]_injection.dart`

- **Utils**  
  - File & folder creation helpers  
  - Pubspec name reader  
  - Version management utilities  

---

## 🚀 Usage

Run the CLI from the root of your project:

```bash
# Configure project base folders
dart run archify configure

# Generate a new feature/module
dart run archify generate auth
```

## 🛠️ Example
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
