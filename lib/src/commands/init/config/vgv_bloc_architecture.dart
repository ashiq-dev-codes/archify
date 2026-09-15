/// The `archify.yaml` content written by
/// `dart run archify init --arch vgv-bloc` — the Very Good Ventures /
/// `flutter_bloc` feature convention: a `Page` that provides the `Bloc` and
/// handles routing, and a `View` that's pure UI reading `Bloc` state — full
/// `Bloc`/`Event`/`State` (not a `Cubit`). Unlike the other presets, this one
/// genuinely needs a package: the whole point is `flutter_bloc` + `equatable`,
/// so `init` prints a reminder to add them before you generate a feature.
///
/// Deliberately doesn't scaffold VGV's flavors/multi-entrypoint convention
/// (`main_development.dart`/`main_staging.dart`/`main_production.dart`) —
/// `archify.yaml` only models a single `main.dart` today.
const vgvBlocArchifyConfig = '''
# archify.yaml — the project tree Archify scaffolds. It's just folders and
# files; rewrite it into any architecture you want (DDD, MVVM, whatever) —
# Archify only reads this file, it has no opinions of its own.
#
#   folder:                       # nested keys = a folder
#     file.dart: template_key       # a file, filled with a built-in template
#     other.dart:                    # blank + has a "." = an empty file
#     empty_folder:                   # blank + no "." = an empty folder
#
# `structure` scaffolds via `dart run archify configure`.
# `feature_root` + `feature_template` scaffold via `dart run archify generate <name>`
# (use `{feature_name}` in any key name there).
#
# All built-in template keys: `dart run archify templates`
# Full docs: https://pub.dev/packages/archify

version: 1 # archify.yaml schema version — no need to touch this

# Base project structure — scaffolded by `dart run archify configure`
structure:
  lib:
    core: # app-wide config, api client, error handling, shared models
      api:
      config:
      error:
        failures.dart: core_failures
        exceptions.dart: core_exceptions
      network:
        network_info.dart: core_network_info
      models:
    feature: # generated features live here
    shared: # reusable theme, widgets, constants, utils
      constant:
        constant.dart: constant
      path:
        app_images.dart: path_images
        app_svg.dart: path_svg
      theme:
        app_colors.dart: theme_colors
        app_themes.dart: theme_themes
        main_theme.dart: theme_main
      utils:
      widget:
        global:
          custom_snack_bar.dart: custom_snack_bar
        loading:
          loading_dialog.dart: loading_dialog
    app.dart: app
    main.dart: main
    root.dart: root

# Per-feature structure — scaffolded by `dart run archify generate <name>`
feature_root: lib/feature

feature_template:
  "{feature_name}":
    data:
      "{feature_name}_repository.dart": repository
    bloc: # full Bloc — Event-driven, not a Cubit
      "{feature_name}_bloc.dart": vgv_bloc
      "{feature_name}_event.dart": vgv_event
      "{feature_name}_state.dart": vgv_state
    view: # Page provides the Bloc + route; View is the actual UI
      "{feature_name}_page.dart": vgv_page
      "{feature_name}_view.dart": vgv_view
      widgets:
''';
