import '../../../core/theme/app_colors.dart';

/// Domain entity representing an authenticated user.
/// Contains profile info, authentication status, and security preferences.
class UserEntity {
  final int id;
  final String name;
  final String email;
  final String? phone;
  final bool emailVerified;
  final bool totpEnabled;
  final String? totpSecret;
  final int? balance;

  const UserEntity({
    required this.id,
    required this.name,
    required this.email,
    this.phone,
    this.emailVerified = false,
    this.totpEnabled = false,
    this.totpSecret,
    this.balance,
  });

  /// Short first name for greeting display.
  String get firstName => name.split(' ').first;

  /// Initial avatar colors derived from the user's name hash.
  List<Color> get avatarColors {
    final palette = [
      AppColors.primary,
      AppColors.green,
      AppColors.violet,
      AppColors.amber,
      AppColors.red,
      AppColors.gold,
    ];
    final idx = name.isNotEmpty ? name.codeUnitAt(0) % palette.length : 0;
    return [palette[idx], palette[(idx + 1) % palette.length]];
  }

  /// Whether this user has full security enabled (email + TOTP).
  bool get isFullySecured => emailVerified && totpEnabled;
}
