// TODO: Implement api_constants.dart
class ApiConstants {
  // ==================== BASE URL ====================

  /// URL de base de l'API
  /// 🔴 PRODUCTION: https://votre-domaine.com
  /// 🟡 DÉVELOPPEMENT LOCAL: http://localhost:8000
  /// 🟢 ANDROID EMULATOR: http://10.0.2.2:8000
  ///  'http://192.168.100.127:8000';  http://192.168.100.127:8000
  static const String baseUrl = 'http://172.16.196.49:8000';

  // ==================== AUTH ENDPOINTS ====================

  /// POST - Se connecter (Utilisateur Standard)
  static const String login = '/api/auth/login/';

  /// POST - S'inscrire (Utilisateur Standard)
  static const String register = '/api/auth/register/';

  /// POST - Rafraîchir le token
  static const String authTokenRefresh = '/api/auth/token/refresh/';

  // ==================== RESERVATIONS ENDPOINTS ====================

  /// POST - Créer une réservation
  /// GET - Liste des réservations (avec query params)
  static const String reservations = '/api/reservations/';

  /// GET - Liste de mes réservations
  static const String myReservations = '/api/reservations/my-reservations/';

  /// POST - Annuler une réservation
  /// Utilisation: ApiConstants.cancelReservation(123)
  static String cancelReservation(int reservationId) {
    return '/api/reservations/$reservationId/cancel/';
  }

  // ==================== TERRAINS ENDPOINTS ====================

  /// GET - Liste des terrains (avec filtres optionnels)
  static const String terrains = '/api/terrains/';

  /// GET - Détail d'un terrain
  /// Utilisation: ApiConstants.terrainDetail(5)
  static String terrainDetail(int id) {
    return '/api/terrains/$id/';
  }

  /// POST - Créer une évaluation pour un terrain
  static const String evaluations = '/api/terrains/evaluations/';

  // ==================== TOKEN ENDPOINTS ====================

  /// POST - Obtenir un token
  static const String token = '/api/token/';

  /// POST - Rafraîchir le token
  static const String tokenRefresh = '/api/token/refresh/';

  // ==================== TIMEOUT CONFIGURATION ====================

  /// Délai de connexion (30 secondes)
  static const Duration connectTimeout = Duration(seconds: 30);

  /// Délai de réception (30 secondes)
  static const Duration receiveTimeout = Duration(seconds: 30);

  /// Délai d'envoi (30 secondes)
  static const Duration sendTimeout = Duration(seconds: 30);

  /// Délai pour les uploads (5 minutes)
  static const Duration uploadTimeout = Duration(minutes: 5);

  // ==================== HEADERS ====================

  /// Headers par défaut pour les requêtes JSON
  static const Map<String, String> jsonHeaders = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  /// Headers pour les uploads multipart
  static const Map<String, String> multipartHeaders = {
    'Content-Type': 'multipart/form-data',
    'Accept': 'application/json',
  };

  // ==================== PAGINATION ====================

  /// Limite par défaut pour la pagination
  static const int defaultPageSize = 10;

  /// Limite maximale pour la pagination
  static const int maxPageSize = 100;
}
