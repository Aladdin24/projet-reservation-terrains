/// Modèle d'authentification retourné par l'API
class AuthModel {
  final String access;
  final String refresh;
  final int userId;
  final String telephone;

  AuthModel({
    required this.access,
    required this.refresh,
    required this.userId,
    required this.telephone,
  });

  /// Créer depuis JSON - Gère 2 formats de backend
  factory AuthModel.fromJson(Map<String, dynamic> json) {
  // Format Register : avec objet "user" imbriqué
  if (json.containsKey('user') && json['user'] is Map) {
    final user = json['user'] as Map<String, dynamic>;
    return AuthModel(
      access: json['access'],
      refresh: json['refresh'],
      userId: _parseUserId(user['id']),        // ✅ Register
      telephone: _parseTelephone(user['telephone']),
    );
  } else {
    // Format Login : direct
    return AuthModel(
      access: json['access'],
      refresh: json['refresh'],
      userId: _parseUserId(json['user_id']),   // ✅ Login
      telephone: _parseTelephone(json['telephone']),
    );
  }
}

  static int _parseUserId(dynamic value) {
    if (value is int) return value;
    if (value is String) return int.parse(value);
    throw Exception('Invalid user_id type: ${value.runtimeType}');
  }

  static String _parseTelephone(dynamic value) {
    if (value is String) return value;
    if (value is int) return value.toString();
    throw Exception('Invalid telephone type: ${value.runtimeType}');
  }

  Map<String, dynamic> toJson() {
    return {
      'access': access,
      'refresh': refresh,
      'user_id': userId,
      'telephone': telephone,
    };
  }

  @override
  String toString() => 'AuthModel(userId: $userId, telephone: $telephone)';
}