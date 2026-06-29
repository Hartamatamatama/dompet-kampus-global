/// Domain entity for OTP verification data returned by the server.
class OtpEntity {
  final int? expiresIn;
  final String? type;
  final bool sent;

  const OtpEntity({this.expiresIn, this.type, this.sent = true});
}
