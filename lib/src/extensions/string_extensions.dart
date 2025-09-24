/// Extensions on non-nullable String for common parsing and formatting.
extension StringExtensions on String {
  // ---------------- Formatting Methods ----------------

  /// Capitalizes the first letter of each word and lowercases the rest.
  ///
  /// Example:
  /// ```dart
  /// 'hello WORLD'.capitalize(); // returns 'Hello World'
  /// ```
  String capitalize() => split(' ')
      .map(
        (word) => word.isNotEmpty
            ? word[0].toUpperCase() + word.substring(1).toLowerCase()
            : '',
      )
      .join(' ');
}
