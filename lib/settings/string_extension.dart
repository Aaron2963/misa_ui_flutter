extension StringExtension on String {
  String toLowerCamelCase() {
    return this[0].toLowerCase() + substring(1);
  }
}