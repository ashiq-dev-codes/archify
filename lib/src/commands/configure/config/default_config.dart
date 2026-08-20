import 'package:archify/src/commands/configure/config/recommended_packages.dart';

/// The default `archify.yaml` content written the first time
/// `dart run archify configure` runs in a project.
String get defaultArchifyConfig => '''
# ─────────────────────────────────────────────────────────────────────────
# Archify project architecture
# ─────────────────────────────────────────────────────────────────────────
# This file defines the folder/file structure that `dart run archify configure`
# scaffolds into your project. It ships with Archify's default clean
# architecture layout below — customize it however you like:
#   • rename, add, or remove folders and files
#   • delete anything you don't need
#   • add plain files/folders with no "template" key — they're created empty
#
# Each node is either:
#   - name: <folder_name>
#     type: folder
#     children: [...]        # optional, a list of nested nodes
#
#   - name: <file_name>
#     type: file
#     template: <key>         # optional, fills the file with Archify's default
#                              # boilerplate for that key. Omit it for an empty file.
#
# Built-in "structure" template keys:
#   main, app, root, injection_container, app_config, dio_client, constant,
#   path_images, path_svg, theme_colors, theme_themes, theme_main,
#   dio_interceptor, navigation_utils, navigation, route_tracker,
#   app_storage, local_storage, custom_snack_bar, loading_dialog
#
# ⚠️ Archify never edits pubspec.yaml. This default architecture expects the
# following packages — add whichever you actually use yourself:
#   flutter pub add ${recommendedPackages.join(' ')}
#
# ⚠️ Built-in templates hardcode import paths that match the layout below
# (e.g. "package:<your_app>/shared/theme/main_theme.dart"). If you rename a
# folder that a template imports from, update the generated file's imports
# to match.
#
# Run `dart run archify configure` again any time after editing this file to
# (re)scaffold the project — existing files are left untouched unless their
# content differs from the template.
# ─────────────────────────────────────────────────────────────────────────
#
# `dart run archify generate <name>` is driven by the two keys below instead:
#
#   feature_root: <folder>       # where generated features are placed
#   feature_template: [...]      # same {name, type, children, template} nodes
#                                 # as "structure", plus a `{feature_name}`
#                                 # placeholder you can use in any node's name
#
# Built-in "feature_template" template keys:
#   data_source, repo, data_source_impl, repo_impl, cubit, cubit_state, page,
#   feature_injection
#
# `feature_injection` is special: when present, Archify also wires the
# generated feature into `injection_container.dart` and `app.dart`'s
# MultiBlocProvider automatically. Remove that node (and adjust the rest) if
# you're not using GetIt/Bloc for a feature.
# ─────────────────────────────────────────────────────────────────────────

version: 1

structure:
  - name: lib
    type: folder
    children:
      - name: core
        type: folder
        children:
          - name: api
            type: folder
          - name: config
            type: folder
            children:
              - name: config.dart
                type: file
                template: app_config
              - name: dio.dart
                type: file
                template: dio_client
          - name: model
            type: folder

      - name: feature
        type: folder

      - name: shared
        type: folder
        children:
          - name: constant
            type: folder
            children:
              - name: constant.dart
                type: file
                template: constant

          - name: path
            type: folder
            children:
              - name: app_images.dart
                type: file
                template: path_images
              - name: app_svg.dart
                type: file
                template: path_svg

          - name: theme
            type: folder
            children:
              - name: app_colors.dart
                type: file
                template: theme_colors
              - name: app_themes.dart
                type: file
                template: theme_themes
              - name: main_theme.dart
                type: file
                template: theme_main

          - name: utils
            type: folder
            children:
              - name: dio
                type: folder
                children:
                  - name: dio_interceptors.dart
                    type: file
                    template: dio_interceptor
              - name: navigation
                type: folder
                children:
                  - name: navigation_utils.dart
                    type: file
                    template: navigation_utils
                  - name: navigation.dart
                    type: file
                    template: navigation
              - name: route
                type: folder
                children:
                  - name: route_tracker.dart
                    type: file
                    template: route_tracker
              - name: storage
                type: folder
                children:
                  - name: app_storage.dart
                    type: file
                    template: app_storage
                  - name: local_storage.dart
                    type: file
                    template: local_storage

          - name: widget
            type: folder
            children:
              - name: global
                type: folder
                children:
                  - name: custom_snack_bar.dart
                    type: file
                    template: custom_snack_bar
              - name: loading
                type: folder
                children:
                  - name: loading_dialog.dart
                    type: file
                    template: loading_dialog

      - name: app.dart
        type: file
        template: app
      - name: injection_container.dart
        type: file
        template: injection_container
      - name: main.dart
        type: file
        template: main
      - name: root.dart
        type: file
        template: root

feature_root: lib/feature

feature_template:
  - name: "{feature_name}"
    type: folder
    children:
      - name: data
        type: folder
        children:
          - name: data_source_impl
            type: folder
            children:
              - name: "{feature_name}_data_source_impl.dart"
                type: file
                template: data_source_impl
          - name: repo_impl
            type: folder
            children:
              - name: "{feature_name}_repo_impl.dart"
                type: file
                template: repo_impl

      - name: domain
        type: folder
        children:
          - name: data_source
            type: folder
            children:
              - name: "{feature_name}_data_source.dart"
                type: file
                template: data_source
          - name: repo
            type: folder
            children:
              - name: "{feature_name}_repo.dart"
                type: file
                template: repo

      - name: presentation
        type: folder
        children:
          - name: cubit
            type: folder
            children:
              - name: "{feature_name}_cubit.dart"
                type: file
                template: cubit
              - name: "{feature_name}_state.dart"
                type: file
                template: cubit_state
          - name: page
            type: folder
            children:
              - name: "{feature_name}_page.dart"
                type: file
                template: page
          - name: widget
            type: folder

      - name: "{feature_name}_injection.dart"
        type: file
        template: feature_injection
''';
