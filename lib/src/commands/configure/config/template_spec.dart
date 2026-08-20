/// Metadata + content generator for one built-in `template:` key.
///
/// Every registry (`structureTemplates`, `featureTemplates`) is the single
/// source of truth for both dispatch (rendering a file's content) and
/// discovery (`dart run archify templates`) — add a key once here and both
/// stay in sync automatically.
class TemplateSpec<T extends Function> {
  const TemplateSpec({
    required this.description,
    required this.isDefault,
    required this.build,
  });

  /// One-line human description shown by `dart run archify templates`.
  final String description;

  /// Whether this key is included in the shipped default `archify.yaml`
  /// (vs. an opt-in the developer adds back themselves).
  final bool isDefault;

  final T build;
}
