# Example App Instructions

Rules for `example/`. Package-wide rules are in [../AGENTS.md](../AGENTS.md).

This Flutter app is archify's output: `init` with the default preset, then `configure` and `generate auth`. It shows users what archify produces, so it must match what the CLI really generates.

- Don't hand-edit generated files. Change the preset or template, then regenerate by running the CLI here (`dart run archify configure`, `dart run archify generate <feature>`), and commit the result. `.archify/manifest.json` is CLI output too.
- `archify.yaml` here is a copy of the default preset. Keep it identical when the default changes.
- It's a Flutter app: run `flutter pub get` here before analyzing or running it. The package's own checks skip it.
- Its platform folders are kept out of the published package by [../.pubignore](../.pubignore). List any new platform folder there too.
