# Commands, Presets and Templates

Rules for `lib/src/commands/`. Repo-wide rules are in [../../../AGENTS.md](../../../AGENTS.md).

Everything here lands in users' projects. Changing a preset or template changes what every new user gets.

## Commands

- Each command lives in its own folder and is dispatched from the `switch` in [archify_cli.dart](../archify_cli.dart).
- A new command or flag needs its `switch` case, a line in `_printUsage`, a README entry and a test.

## Presets (`init/config/`)

- A preset is one `<name>_architecture.dart` file holding its `archify.yaml` as a const string, plus an entry in `architecturePresets` in [architectures.dart](init/config/architectures.dart).
- Set `packageNote` if the preset needs a package, and add the preset to the README's Architectures table.
- Every preset file repeats the same comment block at the top of its YAML. Change it in all of them.
- `example/archify.yaml` is a copy of the default preset (`defaultArchitectureKey`). Update it when the default changes.

## Templates

- Register structure templates in `structureTemplates` ([templates.dart](configure/config/templates.dart)) and feature templates in `featureTemplates` ([feature_templates.dart](generate/feature_templates.dart)). That's all `archify templates` needs to list them.
- Templates are Dart `'''` strings with interpolation (`$packageName`, `${featureName.toPascalCase()}`). Write a literal `$` as `\$`.
- Import paths in a template must match the folder layout of every preset that uses it. Check them against each preset's YAML.
- Generated screens and widgets must look polished and be easy to use out of the box:
  - Style them through the generated theme (`app_themes.dart`, `app_colors.dart`) or `Theme.of(context)`, never with inline colors or font sizes.
  - Layouts must not overflow on small screens or with large system text.
  - Show loading, empty and error states, never a blank screen.
  - Build them with Flutter's own widgets, no UI packages.
- If a template needs a package, add it to `recommendedPackages` ([recommended_packages.dart](configure/config/recommended_packages.dart)) so `configure` prints it in its `flutter pub add` reminder.

## Editing files that already exist

- Some commands patch user files in place, e.g. [injection_wiring.dart](generate/injection_wiring.dart) edits `lib/injection_container.dart` and `lib/app.dart`.
- Such edits must only insert what's missing, so running the command twice changes nothing.
- If the file is missing, print an ❌ and skip it. Never create a user file just to patch it.
