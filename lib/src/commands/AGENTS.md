# Command Instructions

Rules for `lib/src/commands/`. Package-wide rules are in [../../../AGENTS.md](../../../AGENTS.md).

Everything here ends up in users' projects: changing a preset or template changes what every new user gets.

## Commands

- Each command has its own folder and is dispatched from the `switch` in [archify_cli.dart](../archify_cli.dart), which also prints the help. A new command or flag needs its case there, its help text, a README entry and a test.

## Presets (`init/config/`)

- A preset is one `<name>_architecture.dart` file holding its `archify.yaml` as a const string, plus an entry in `architecturePresets` in [architectures.dart](init/config/architectures.dart). Set `packageNote` if it needs packages, and add it to the README's Architectures table.
- The comment block at the top of the YAML is repeated in every preset file. Change it in all of them.

## Templates

- Structure templates are registered in `structureTemplates` ([templates.dart](configure/config/templates.dart)), feature templates in `featureTemplates` ([feature_templates.dart](generate/feature_templates.dart)). Registering one there is all `archify templates` needs to list it.
- Templates are Dart `'''` strings that use interpolation (`$packageName`, `${featureName.toPascalCase()}`). Write a literal `$` as `\$`.
- Import paths inside a template must match the folder layout of every preset that uses it. Check them against each preset's YAML.
- A template that needs a package goes in `recommendedPackages` ([recommended_packages.dart](configure/config/recommended_packages.dart)) and must be named in the reminder that `_printPackageReminder` prints in [configure.dart](configure/configure.dart).
