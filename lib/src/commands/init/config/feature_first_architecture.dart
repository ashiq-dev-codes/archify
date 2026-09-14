/// The `archify.yaml` content written by
/// `dart run archify init --arch feature-first` — a flatter alternative to
/// the DDD preset: one concrete repository (no interface split), a plain
/// model, and an `application/` service layer that holds business logic
/// independent of any single screen — multiple controllers can share one
/// service, unlike MVVM's view model. No third-party package required.
const featureFirstArchifyConfig = '''
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
    data: # one concrete repository — no interface/impl split
      "{feature_name}_repository.dart": repository
    domain: # the plain, framework-free shape of this feature's data
      "{feature_name}_model.dart": model
    application: # business logic, reusable across more than one screen
      "{feature_name}_service.dart": service
    presentation:
      controllers:
        "{feature_name}_controller.dart": controller
      views:
        "{feature_name}_screen.dart": screen
      widgets:
''';
