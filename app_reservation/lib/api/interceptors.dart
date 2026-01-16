// TODO: Implement interceptors.dart
import 'package:dio/dio.dart';
import 'package:get/get.dart' as getx;
import '../data/services/storage_service.dart';
import 'api_constants.dart';

// ==================== AUTH INTERCEPTOR ====================

/// Intercepteur pour ajouter automatiquement le token d'authentification
class AuthInterceptor extends Interceptor {
  final StorageService _storageService = getx.Get.find<StorageService>();

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // Récupérer le token d'accès
    final token = await _storageService.getAccessToken();

    // Ajouter le token dans les headers si disponible
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    print('🔵 REQUEST[${options.method}] => ${options.path}');
    return handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    print('✅ RESPONSE[${response.statusCode}] => ${response.requestOptions.path}');
    return handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    print('❌ ERROR[${err.response?.statusCode}] => ${err.requestOptions.path}');
    print('❌ Message: ${err.message}');
    return handler.next(err);
  }
}

// ==================== REFRESH TOKEN INTERCEPTOR ====================

/// Intercepteur pour gérer automatiquement le rafraîchissement du token
class RefreshTokenInterceptor extends Interceptor {
  final Dio _dio;
  final StorageService _storageService = getx.Get.find<StorageService>();
  
  // Pour éviter les appels multiples simultanés de refresh
  bool _isRefreshing = false;
  final List<RequestOptions> _requestsQueue = [];

  RefreshTokenInterceptor(this._dio);

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    // Vérifier si c'est une erreur 401 (Non autorisé)
    if (err.response?.statusCode == 401) {
      print('🔄 Token expiré (401), tentative de rafraîchissement...');

      // Si un refresh est déjà en cours, ajouter à la file d'attente
      if (_isRefreshing) {
        _requestsQueue.add(err.requestOptions);
        return;
      }

      _isRefreshing = true;

      try {
        // Récupérer le refresh token
        final refreshToken = await _storageService.getRefreshToken();

        if (refreshToken == null || refreshToken.isEmpty) {
          print('❌ Pas de refresh token disponible');
          await _handleLogout();
          return handler.reject(err);
        }

        // Créer une nouvelle instance Dio pour éviter les intercepteurs
        final refreshDio = Dio(
          BaseOptions(
            baseUrl: ApiConstants.baseUrl,
            headers: ApiConstants.jsonHeaders,
          ),
        );

        // Faire la requête de refresh
        final response = await refreshDio.post(
          ApiConstants.authTokenRefresh,
          data: {'refresh': refreshToken},
        );

        if (response.statusCode == 200) {
          // Sauvegarder le nouveau access token
          final newAccessToken = response.data['access'];
          await _storageService.saveAccessToken(newAccessToken);

          // Si un nouveau refresh token est fourni, le sauvegarder aussi
          if (response.data.containsKey('refresh')) {
            final newRefreshToken = response.data['refresh'];
            await _storageService.saveRefreshToken(newRefreshToken);
          }

          print('✅ Token rafraîchi avec succès');

          // Retry la requête originale avec le nouveau token
          final retryResponse = await _retryRequest(
            err.requestOptions,
            newAccessToken,
          );

          _isRefreshing = false;

          // Traiter les requêtes en file d'attente
          await _processQueue(newAccessToken);

          return handler.resolve(retryResponse);
        }
      } catch (e) {
        print('❌ Erreur lors du rafraîchissement du token: $e');
        _isRefreshing = false;
        await _handleLogout();
        return handler.reject(err);
      }
    }

    return handler.next(err);
  }

  /// Retry une requête avec le nouveau token
  Future<Response> _retryRequest(
    RequestOptions requestOptions,
    String newToken,
  ) async {
    final options = Options(
      method: requestOptions.method,
      headers: {
        ...requestOptions.headers,
        'Authorization': 'Bearer $newToken',
      },
    );

    return await _dio.request(
      requestOptions.path,
      data: requestOptions.data,
      queryParameters: requestOptions.queryParameters,
      options: options,
    );
  }

  /// Traiter les requêtes en file d'attente
  Future<void> _processQueue(String newToken) async {
    for (var request in _requestsQueue) {
      try {
        await _retryRequest(request, newToken);
      } catch (e) {
        print('❌ Erreur lors du traitement de la file d\'attente: $e');
      }
    }
    _requestsQueue.clear();
  }

  /// Déconnecter l'utilisateur et rediriger vers login
  Future<void> _handleLogout() async {
    await _storageService.logout();
    getx.Get.offAllNamed('/login');
  }
}

// ==================== LOGGING INTERCEPTOR ====================

/// Intercepteur pour logger les requêtes (à utiliser uniquement en développement)
class LoggingInterceptor extends Interceptor {
  final bool enabled;

  LoggingInterceptor({this.enabled = true});

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (!enabled) return handler.next(options);

    print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    print('📤 REQUEST');
    print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    print('Method: ${options.method}');
    print('URL: ${options.baseUrl}${options.path}');
    print('Headers: ${options.headers}');
    print('QueryParameters: ${options.queryParameters}');
    if (options.data != null) {
      print('Data: ${options.data}');
    }
    print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    return handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (!enabled) return handler.next(response);

    print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    print('📥 RESPONSE');
    print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    print('Status Code: ${response.statusCode}');
    print('Status Message: ${response.statusMessage}');
    print('Data: ${response.data}');
    print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    return handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (!enabled) return handler.next(err);

    print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    print('⛔ ERROR');
    print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    print('Type: ${err.type}');
    print('Message: ${err.message}');
    print('Error: ${err.error}');
    if (err.response != null) {
      print('Status Code: ${err.response?.statusCode}');
      print('Data: ${err.response?.data}');
    }
    print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    return handler.next(err);
  }
}

// ==================== RETRY INTERCEPTOR ====================

/// Intercepteur pour retry automatiquement en cas d'erreur réseau
class RetryInterceptor extends Interceptor {
  final int maxRetries;
  final Duration retryDelay;

  RetryInterceptor({
    this.maxRetries = 3,
    this.retryDelay = const Duration(seconds: 2),
  });

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    // Retry uniquement pour les erreurs de connexion
    if (err.type == DioExceptionType.connectionTimeout ||
        err.type == DioExceptionType.receiveTimeout ||
        err.type == DioExceptionType.connectionError) {
      
      final requestOptions = err.requestOptions;
      final retries = requestOptions.extra['retries'] ?? 0;

      if (retries < maxRetries) {
        print('🔄 Retry ${retries + 1}/$maxRetries pour ${requestOptions.path}');

        // Attendre avant de retry
        await Future.delayed(retryDelay);

        // Incrémenter le compteur de retries
        requestOptions.extra['retries'] = retries + 1;

        // Retry la requête
        try {
          final dio = Dio();
          final response = await dio.request(
            requestOptions.path,
            data: requestOptions.data,
            queryParameters: requestOptions.queryParameters,
            options: Options(
              method: requestOptions.method,
              headers: requestOptions.headers,
            ),
          );
          return handler.resolve(response);
        } catch (e) {
          return handler.next(err);
        }
      }
    }

    return handler.next(err);
  }
}