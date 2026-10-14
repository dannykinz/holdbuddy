class SettingsPreview {
  const SettingsPreview({
    required this.email,
    required this.partners,
    required this.files,
    required this.deadlines,
    required this.blocked,
  });
  final String email;
  final List<String> partners;
  final int files;
  final int deadlines;
  final int blocked;
}
