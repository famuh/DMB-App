
/// A class representing the response for a guest session.
/// This class is used to parse the response received from the guest session API.
class GuestSessionResponse {
  /// Indicates whether the guest session was created successfully.
  final bool success;

  /// The unique identifier for the guest session.
  final String guestSessionId;

  /// The expiration time of the guest session.
  final String expiresAt;

  /// Creates a [GuestSessionResponse] with the specified [success],
  /// [guestSessionId], and [expiresAt].
  GuestSessionResponse({
    required this.success,
    required this.guestSessionId,
    required this.expiresAt,
  });

  /// Factory method to create a [GuestSessionResponse] from a JSON response.
  factory GuestSessionResponse.fromJson(Map<String, dynamic> json) {
    return GuestSessionResponse(
      success: json['success'],
      guestSessionId: json['guest_session_id'],
      expiresAt: json['expires_at'],
    );
  }
}
