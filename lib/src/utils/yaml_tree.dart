import 'package:archify/src/utils/fs_utils.dart';

/// What a single classified `archify.yaml` tree entry is.
enum YamlNodeKind {
  /// A nested mapping — recurse into it as a folder.
  folder,

  /// A leaf — created as a file (empty, or rendered from a template).
  file,
}

/// A single `name: value` entry from an `archify.yaml` tree (`structure` or
/// `feature_template`), classified per the schema both `walkYamlTree` and
/// `collectYamlTreePaths` follow.
class YamlNode {
  const YamlNode(this.kind, this.templateKey);

  final YamlNodeKind kind;

  /// The template key for a file mapped to one (e.g. `theme_colors`), or
  /// `null` for an empty file/folder.
  final String? templateKey;
}

/// Classifies a single `name: value` entry:
///   - a nested mapping (including `{}`)      → folder
///   - a non-empty string                      → file, templateKey = value
///   - blank/null, name contains a "."         → empty file
///   - blank/null, name has no "."             → empty folder
///   - explicit empty string `''`              → empty file, regardless of name
///
/// Throws a descriptive [Exception] on malformed input.
YamlNode classifyYamlNode(String name, dynamic value) {
  if (value is Map) return const YamlNode(YamlNodeKind.folder, null);
  if (value is String && value.isNotEmpty) {
    return YamlNode(YamlNodeKind.file, value);
  }
  if (value == null && !name.contains('.')) {
    return const YamlNode(YamlNodeKind.folder, null);
  }
  if (value == null || value is String) {
    return const YamlNode(YamlNodeKind.file, null);
  }
  throw Exception(
    'Invalid value for "$name" — expected a nested mapping (folder), a '
    'template name (file), or blank.',
  );
}

/// Walks a plain nested YAML mapping — the schema `archify.yaml` uses for
/// its `structure` and `feature_template` sections — creating folders and
/// files as it goes.
///
/// [transformName] can rewrite a key before it's used (e.g. substituting the
/// `{feature_name}` placeholder).
///
/// Throws a descriptive [Exception] on malformed input.
void walkYamlTree(
  String basePath,
  dynamic node, {
  required String? Function(String path, String templateKey) resolveFileContent,
  String Function(String name)? transformName,
}) {
  if (node is! Map) {
    throw Exception('Expected a mapping under "$basePath"');
  }

  node.forEach((key, value) {
    var name = key.toString();
    if (transformName != null) name = transformName(name);
    final path = basePath.isEmpty ? name : '$basePath/$name';

    final classified = classifyYamlNode(name, value);
    switch (classified.kind) {
      case YamlNodeKind.folder:
        createFolder(path);
        if (value is Map) {
          walkYamlTree(
            path,
            value,
            resolveFileContent: resolveFileContent,
            transformName: transformName,
          );
        }
      case YamlNodeKind.file:
        final templateKey = classified.templateKey;
        final content =
            templateKey == null
                ? ''
                : (resolveFileContent(path, templateKey) ?? '');
        createFile(path, content);
    }
  });
}

/// Walks the same tree shape as [walkYamlTree] but only collects every path
/// it would touch — no filesystem writes.
///
/// Used to compute "what does this `archify.yaml` currently want to exist",
/// so a later run can tell what's been removed since the last one and
/// reconcile it away (see `reconcileRemovedPaths`).
Set<String> collectYamlTreePaths(
  String basePath,
  dynamic node, {
  String Function(String name)? transformName,
}) {
  if (node is! Map) {
    throw Exception('Expected a mapping under "$basePath"');
  }

  final paths = <String>{};

  node.forEach((key, value) {
    var name = key.toString();
    if (transformName != null) name = transformName(name);
    final path = basePath.isEmpty ? name : '$basePath/$name';

    paths.add(path);

    final classified = classifyYamlNode(name, value);
    if (classified.kind == YamlNodeKind.folder && value is Map) {
      paths.addAll(
        collectYamlTreePaths(path, value, transformName: transformName),
      );
    }
  });

  return paths;
}
