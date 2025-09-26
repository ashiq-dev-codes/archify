## 1.0.2

* Initial release of Archify CLI.
* Added **configure command** to create base project structure (`lib/core`, `lib/shared`).
* Added **generate command** to scaffold new features/modules with clean architecture layers (`data`, `domain`, `presentation`).
* Automatic creation of `[feature]_injection.dart` for repository, data source, and bloc registration.
* Automatic updates to `injection_container.dart` with init/clear functions.
* Automatic updates to `app.dart` `MultiBlocProvider` with feature blocs.
* Pubspec management utilities (`pubspec_manager`) for adding default packages.
* File and folder creation helpers.
* Version management utilities.
* README updated with examples, usage, and project structure.
