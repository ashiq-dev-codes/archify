import 'package:archify/src/utils/fs_utils.dart';

/// Walks a plain nested YAML mapping — the schema `archify.yaml` uses for
/// its `structure` and `feature_template` sections — creating folders and
/// files as it goes.
///
/// Each key is a folder or file name; its value decides which:
///   - a nested mapping (including `{}`)      → folder, recurse into it
///   - a string                                → file, rendered via
///     [resolveFileContent] using that string as the template key
///   - blank/null, name contains a "."         → empty file
///   - blank/null, name has no "."             → empty folder
///   - explicit empty string `''`              → empty file, regardless of name
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

    if (value is Map) {
      createFolder(path);
      walkYamlTree(
        path,
        value,
        resolveFileContent: resolveFileContent,
        transformName: transformName,
      );
    } else if (value is String && value.isNotEmpty) {
      createFile(path, resolveFileContent(path, value) ?? '');
    } else if (value == null && !name.contains('.')) {
      createFolder(path);
    } else if (value == null || value is String) {
      createFile(path, '');
    } else {
      throw Exception(
        'Invalid value for "$name" — expected a nested mapping (folder), a '
        'template name (file), or blank.',
      );
    }
  });
}
