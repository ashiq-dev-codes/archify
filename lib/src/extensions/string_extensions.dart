/// Extensions on non-nullable String for common parsing and formatting.
extension StringExtensions on String {
  /// Converts `snake_case` or `kebab-case` to PascalCase
  ///
  /// Example:
  /// ```dart
  /// 'app_settings'.toPascalCase(); // AppSettings
  /// 'user-profile-info'.toPascalCase(); // UserProfileInfo
  /// ```
  String toPascalCase() {
    return split(RegExp(r'[_\-]'))
        .map(
          (word) =>
              word.isEmpty
                  ? ''
                  : word[0].toUpperCase() + word.substring(1).toLowerCase(),
        )
        .join();
  }

  /// Converts `snake_case` or `kebab-case` to camelCase
  ///
  /// Example:
  /// ```dart
  /// 'app_settings'.toCamelCase(); // appSettings
  /// 'user-profile-info'.toCamelCase(); // userProfileInfo
  /// ```
  String toCamelCase() {
    final pascal = toPascalCase();
    if (pascal.isEmpty) return '';
    return pascal[0].toLowerCase() + pascal.substring(1);
  }
}
