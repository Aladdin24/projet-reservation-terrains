// TODO: Implement dio_client.dart
import 'package:dio/dio.dart';
import 'package:get/get.dart' as getx;
import 'api_constants.dart';
import 'interceptors.dart';

class DioClient extends getx.GetxService {
  late Dio _publicDio;
  late Dio _privateDio;
  late Dio _uploadDio;

  /// Instance Dio PUBLIQUE (sans authentification)
  /// Utilisée pour: Login, Register
  Dio get publicDio => _publicDio;

  /// Instance Dio PRIVÉE (avec authentification automatique)
  /// Utilisée pour: Terrains, Réservations, Profil, etc.
  Dio get privateDio => _privateDio;

  /// Instance Dio UPLOAD (pour upload de fichiers avec authentification)
  /// Utilisée pour: Upload d'images, documents
  Dio get uploadDio => _uploadDio;

  DioClient() {
    _initializePublicDio();
    _initializePrivateDio();
    _initializeUploadDio();
  }

  // ==================== PUBLIC DIO ====================
  
  /// Initialiser l'instance Dio publique (sans auth)
  void _initializePublicDio() {
    _publicDio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: ApiConstants.connectTimeout,
        receiveTimeout: ApiConstants.receiveTimeout,
        sendTimeout: ApiConstants.sendTimeout,
        headers: ApiConstants.jsonHeaders,
        validateStatus: (status) {
          // Accepter tous les codes de statut pour gérer les erreurs manuellement
          return status != null && status < 500;
        },
      ),
    );

    // Ajouter uniquement le logging interceptor pour le debug
    _publicDio.interceptors.add(
      LoggingInterceptor(enabled: true), // Mettre à false en production
    );
  }

  // ==================== PRIVATE DIO ====================
  
  /// Initialiser l'instance Dio privée (avec auth)
  void _initializePrivateDio() {
    _privateDio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: ApiConstants.connectTimeout,
        receiveTimeout: ApiConstants.receiveTimeout,
        sendTimeout: ApiConstants.sendTimeout,
        headers: ApiConstants.jsonHeaders,
        validateStatus: (status) {
          return status != null && status < 500;
        },
      ),
    );

    // Ajouter les intercepteurs dans l'ordre IMPORTANT
    _privateDio.interceptors.addAll([
      AuthInterceptor(),                    // 1. Ajoute le token
      RefreshTokenInterceptor(_privateDio), // 2. Gère le refresh
      RetryInterceptor(),                   // 3. Retry en cas d'erreur
      LoggingInterceptor(enabled: true),    // 4. Log les requêtes
    ]);
  }

  // ==================== UPLOAD DIO ====================
  
  /// Initialiser l'instance Dio pour les uploads
  void _initializeUploadDio() {
    _uploadDio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: ApiConstants.uploadTimeout,
        receiveTimeout: ApiConstants.uploadTimeout,
        sendTimeout: ApiConstants.uploadTimeout,
        headers: ApiConstants.multipartHeaders,
        validateStatus: (status) {
          return status != null && status < 500;
        },
      ),
    );

    // Ajouter les intercepteurs
    _uploadDio.interceptors.addAll([
      AuthInterceptor(),
      RefreshTokenInterceptor(_uploadDio),
      LoggingInterceptor(enabled: true),
    ]);
  }

  // ==================== ERROR HANDLING ====================

  /// Gérer les erreurs Dio de manière centralisée
  String handleDioError(DioException error) {
    String errorMessage = '';

    switch (error.type) {
      case DioExceptionType.connectionTimeout:
        errorMessage = 'Délai de connexion expiré. Vérifiez votre connexion internet.';
        break;

      case DioExceptionType.sendTimeout:
        errorMessage = 'Délai d\'envoi expiré. Vérifiez votre connexion internet.';
        break;

      case DioExceptionType.receiveTimeout:
        errorMessage = 'Délai de réception expiré. Le serveur met trop de temps à répondre.';
        break;

      case DioExceptionType.badResponse:
        errorMessage = _handleResponseError(error.response);
        break;

      case DioExceptionType.cancel:
        errorMessage = 'Requête annulée';
        break;

      case DioExceptionType.connectionError:
        errorMessage = 'Erreur de connexion. Vérifiez votre connexion internet.';
        break;

      case DioExceptionType.badCertificate:
        errorMessage = 'Erreur de certificat SSL';
        break;

      case DioExceptionType.unknown:
        errorMessage = 'Une erreur inattendue s\'est produite';
        break;

      default:
        errorMessage = 'Une erreur s\'est produite';
    }

    return errorMessage;
  }

  /// Gérer les erreurs de réponse selon le code HTTP
  String _handleResponseError(Response? response) {
    if (response == null) {
      return 'Aucune réponse du serveur';
    }

    final statusCode = response.statusCode;
    final data = response.data;

    // Essayer de récupérer le message d'erreur du backend
    String? backendMessage;
    if (data is Map<String, dynamic>) {
      backendMessage = data['message'] as String? ??
          data['error'] as String? ??
          data['detail'] as String?;
    } else if (data is String) {
      backendMessage = data;
    }

    switch (statusCode) {
      case 400:
        return backendMessage ?? 'Requête invalide. Vérifiez les données envoyées.';

      case 401:
        return backendMessage ?? 'Non autorisé. Veuillez vous reconnecter.';

      case 403:
        return backendMessage ?? 'Accès interdit. Vous n\'avez pas les permissions nécessaires.';

      case 404:
        return backendMessage ?? 'Ressource non trouvée';

      case 409:
        return backendMessage ?? 'Conflit. La ressource existe déjà.';

      case 422:
        return backendMessage ?? 'Données de validation incorrectes';

      case 429:
        return backendMessage ?? 'Trop de requêtes. Veuillez réessayer plus tard.';

      case 500:
        return backendMessage ?? 'Erreur serveur. Veuillez réessayer plus tard.';

      case 502:
        return 'Passerelle incorrecte. Le serveur est temporairement indisponible.';

      case 503:
        return 'Service temporairement indisponible. Veuillez réessayer plus tard.';

      case 504:
        return 'Délai d\'attente de la passerelle dépassé';

      default:
        return backendMessage ?? 
            'Erreur ${statusCode ?? "inconnue"}: ${response.statusMessage ?? ""}';
    }
  }

  // ==================== UTILITY METHODS ====================

  /// Vérifier la connexion internet
  Future<bool> hasInternetConnection() async {
    try {
      final response = await _publicDio.get(
        '/ping',
        options: Options(
          receiveTimeout: const Duration(seconds: 5),
          sendTimeout: const Duration(seconds: 5),
        ),
      );
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  /// Annuler toutes les requêtes en cours
  void cancelAllRequests() {
    _publicDio.close(force: true);
    _privateDio.close(force: true);
    _uploadDio.close(force: true);
  }

  /// Fermer proprement les clients Dio
  void dispose() {
    _publicDio.close();
    _privateDio.close();
    _uploadDio.close();
  }
}