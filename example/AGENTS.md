# Example App

Rules for `example/`. Repo-wide rules are in [../AGENTS.md](../AGENTS.md).

This Flutter app is archify's real output: `init` with the default preset, then `configure`, then `generate auth`. Users look at it to see what archify produces, so it must match what the CLI generates today.

- Don't hand-edit generated files, including `.archify/manifest.json`. Change the preset or template, re-run the CLI here (`dart run archify configure`, `dart run archify generate auth`), and commit the result.
- Keep `archify.yaml` identical to the default preset.
- It's a Flutter app: run `flutter pub get` here before analyzing or running it. The package's own checks skip this folder.
- Native platform folders are kept out of the published package by [../.pubignore](../.pubignore). Add any new platform folder there.
