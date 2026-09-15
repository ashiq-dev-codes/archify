import 'dart:io';

/// Moves every path in [previousPaths] that is no longer in [currentPaths]
/// out of the working tree and into a timestamped folder under
/// `.archify/removed/`, preserving each path's original relative location.
///
/// Nothing is ever deleted outright — a path Archify stops managing is
/// backed up, not destroyed, the same way `configure` backs up `main.dart`
/// and `custom` backs up a feature it's about to recreate.
///
/// Returns the paths actually moved (empty if nothing changed).
List<String> reconcileRemovedPaths({
  required Set<String> previousPaths,
  required Set<String> currentPaths,
}) {
  final removed = previousPaths.difference(currentPaths);
  if (removed.isEmpty) return const [];

  final roots = _removalRoots(removed);
  if (roots.isEmpty) return const [];

  final backupRoot =
      '.archify/removed/${DateTime.now().millisecondsSinceEpoch}';
  final moved = <String>[];

  for (final path in roots) {
    final type = FileSystemEntity.typeSync(path);
    if (type == FileSystemEntityType.notFound) continue;

    final destination = '$backupRoot/$path';
    final destinationParent =
        destination.contains('/')
            ? destination.substring(0, destination.lastIndexOf('/'))
            : destination;
    Directory(destinationParent).createSync(recursive: true);

    if (type == FileSystemEntityType.directory) {
      Directory(path).renameSync(destination);
    } else {
      File(path).renameSync(destination);
    }

    moved.add(path);
    print('🗑️  No longer in archify.yaml, backed up: $path → $destination');
  }

  return moved;
}

/// Reduces [removed] to its maximal (shallowest) paths only — moving a
/// folder already takes every path nested under it with it, so a removed
/// child of an already-removed folder needs no separate move of its own.
List<String> _removalRoots(Set<String> removed) {
  final sorted =
      removed.toList()
        ..sort((a, b) => a.split('/').length.compareTo(b.split('/').length));

  final roots = <String>[];
  for (final path in sorted) {
    final coveredByRoot = roots.any(
      (root) => path == root || path.startsWith('$root/'),
    );
    if (!coveredByRoot) roots.add(path);
  }
  return roots;
}
