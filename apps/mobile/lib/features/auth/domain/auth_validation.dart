abstract final class AuthValidation {
  static const minimumPasswordLength = 12;
  static const maximumPasswordLength = 128;
  static const maximumNameLength = 80;
  static const maximumEmailLength = 254;
  static const codeLength = 6;

  static String name(String value) =>
      value.trim().replaceAll(RegExp(r'\s+'), ' ');

  static String email(String value) => value.trim().toLowerCase();

  static bool validName(String value) =>
      name(value).isNotEmpty &&
      name(value).length <= maximumNameLength &&
      !RegExp(r'[\x00-\x1F\x7F]').hasMatch(value);

  static bool validEmail(String value) =>
      email(value).length <= maximumEmailLength &&
      RegExp(r'^[^\s@]+@[^\s@.]+(?:\.[^\s@.]+)+$').hasMatch(email(value));

  static bool validPassword(String value) =>
      value.runes.length >= minimumPasswordLength &&
      value.runes.length <= maximumPasswordLength;

  static bool validCode(String value) => RegExp(r'^\d{6}$').hasMatch(value);
}
