/// Data-layer model for user API responses.
class UserModel {
  final int id;
  final String name;
  final String email;
  final String? phone;
  final bool emailVerified;
  final bool totpEnabled;

  const UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.phone,
    this.emailVerified = false,
    this.totpEnabled = false,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as int? ?? 0,
      name: json['name'] as String? ?? '',
      email: json['email'] as String? ?? '',
      phone: json['phone'] as String?,
      emailVerified: json['email_verified'] as bool? ?? false,
      totpEnabled: json['totp_enabled'] as bool? ?? false,
    );
  }
}
