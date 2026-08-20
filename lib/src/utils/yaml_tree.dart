import 'package:archify/src/utils/fs_utils.dart';

/// Walks a `{name, type, children}` YAML node list — the schema shared by
/// `archify.yaml`'s `structure` and `feature_template` sections — creating
/// folders and files as it goes.
///
/// [resolveFileContent] renders a file node's content given its resolved
/// path and the raw node map; return `null` for an empty file.
/// [transformName] can rewrite a node's `name` before it's used (e.g.
/// substituting the `{feature_name}` placeholder).
///
/// Throws a descriptive [Exception] on malformed input.
void walkYamlTree(
  String basePath,
  dynamic items, {
  required String? Function(String path, Map node) resolveFileContent,
  String Function(String name)? transformName,
}) {
  if (items is! List) {
    throw Exception('Expected a list of nodes under "$basePath"');
  }

  for (final item in items) {
    if (item is! Map ||
        !item.containsKey('name') ||
        !item.containsKey('type')) {
      throw Exception(
        'Each node must be a map with "name" and "type" under "$basePath"',
      );
    }

    var name = item['name'].toString();
    if (transformName != null) name = transformName(name);
    final type = item['type'].toString();
    final path = basePath.isEmpty ? name : '$basePath/$name';

    if (type == 'folder') {
      createFolder(path);

      final children = item['children'];
      if (children != null) {
        if (children is! List) {
          throw Exception('"children" of "$name" must be a list');
        }
        walkYamlTree(
          path,
          children,
          resolveFileContent: resolveFileContent,
          transformName: transformName,
        );
      }
    } else if (type == 'file') {
      createFile(path, resolveFileContent(path, item) ?? '');
    } else {
      throw Exception(
        'Invalid type "$type" for "$name". Must be "folder" or "file".',
      );
    }
  }
}
