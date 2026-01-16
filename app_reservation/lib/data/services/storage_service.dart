// TODO: Implement storage_service.dart
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';

/// Service de stockage sécurisé utilisant flutter_secure_storage
/// Tous les tokens et données sensibles sont chiffrés
class StorageService extends GetxService {
  late FlutterSecureStorage _secureStorage;

  // ==================== STORAGE KEYS ====================
  
  static const String _keyAccessToken = 'access_token';
  static const String _keyRefreshToken = 'refresh_token';
  static const String _keyUserId = 'user_id';
  static const String _keyTelephone = 'telephone';
  static const String _keyIsLoggedIn = 'is_logged_in';
  static const String _keyUserData = 'user_data';

  // ==================== ANDROID OPTIONS ====================
  
  /// Configuration pour Android avec chiffrement
  AndroidOptions _getAndroidOptions() => const AndroidOptions(
        encryptedSharedPreferences: true,
      );

  // ==================== iOS OPTIONS ====================
  
  /// Configuration pour iOS
  IOSOptions _getIOSOptions() => const IOSOptions(
        accessibility: KeychainAccessibility.first_unlock,
      );

  // ==================== INITIALIZATION ====================
  
  /// Initialiser le service de stockage
  Future<StorageService> init() async {
    _secureStorage = const FlutterSecureStorage();
    print('✅ StorageService initialisé');
    return this;
  }

  // ==================== ACCESS TOKEN ====================
  
  /// Sauvegarder le token d'accès
  Future<void> saveAccessToken(String token) async {
    try {
      await _secureStorage.write(
        key: _keyAccessToken,
        value: token,
        aOptions: _getAndroidOptions(),
        iOptions: _getIOSOptions(),
      );
      print('✅ Access token sauvegardé');
    } catch (e) {
      print('❌ Erreur sauvegarde access token: $e');
      rethrow;
    }
  }

  /// Récupérer le token d'accès
  Future<String?> getAccessToken() async {
    try {
      final token = await _secureStorage.read(
        key: _keyAccessToken,
        aOptions: _getAndroidOptions(),
        iOptions: _getIOSOptions(),
      );
      return token;
    } catch (e) {
      print('❌ Erreur lecture access token: $e');
      return null;
    }
  }

  /// Supprimer le token d'accès
  Future<void> deleteAccessToken() async {
    try {
      await _secureStorage.delete(
        key: _keyAccessToken,
        aOptions: _getAndroidOptions(),
        iOptions: _getIOSOptions(),
      );
    } catch (e) {
      print('❌ Erreur suppression access token: $e');
    }
  }

  // ==================== REFRESH TOKEN ====================
  
  /// Sauvegarder le refresh token
  Future<void> saveRefreshToken(String token) async {
    try {
      await _secureStorage.write(
        key: _keyRefreshToken,
        value: token,
        aOptions: _getAndroidOptions(),
        iOptions: _getIOSOptions(),
      );
      print('✅ Refresh token sauvegardé');
    } catch (e) {
      print('❌ Erreur sauvegarde refresh token: $e');
      rethrow;
    }
  }

  /// Récupérer le refresh token
  Future<String?> getRefreshToken() async {
    try {
      final token = await _secureStorage.read(
        key: _keyRefreshToken,
        aOptions: _getAndroidOptions(),
        iOptions: _getIOSOptions(),
      );
      return token;
    } catch (e) {
      print('❌ Erreur lecture refresh token: $e');
      return null;
    }
  }

  /// Supprimer le refresh token
  Future<void> deleteRefreshToken() async {
    try {
      await _secureStorage.delete(
        key: _keyRefreshToken,
        aOptions: _getAndroidOptions(),
        iOptions: _getIOSOptions(),
      );
    } catch (e) {
      print('❌ Erreur suppression refresh token: $e');
    }
  }

  // ==================== USER INFO ====================

  /// Sauvegarder l'ID utilisateur
  Future<void> saveUserId(int userId) async {
    try {
      await _secureStorage.write(
        key: _keyUserId,
        value: userId.toString(),
        aOptions: _getAndroidOptions(),
        iOptions: _getIOSOptions(),
      );
    } catch (e) {
      print('❌ Erreur sauvegarde user ID: $e');
      rethrow;
    }
  }

  /// Récupérer l'ID utilisateur
  Future<int?> getUserId() async {
    try {
      final value = await _secureStorage.read(
        key: _keyUserId,
        aOptions: _getAndroidOptions(),
        iOptions: _getIOSOptions(),
      );
      return value != null ? int.tryParse(value) : null;
    } catch (e) {
      print('❌ Erreur lecture user ID: $e');
      return null;
    }
  }

  /// Sauvegarder le téléphone
  Future<void> saveTelephone(String telephone) async {
    try {
      await _secureStorage.write(
        key: _keyTelephone,
        value: telephone,
        aOptions: _getAndroidOptions(),
        iOptions: _getIOSOptions(),
      );
    } catch (e) {
      print('❌ Erreur sauvegarde téléphone: $e');
      rethrow;
    }
  }

  /// Récupérer le téléphone
  Future<String?> getTelephone() async {
    try {
      final telephone = await _secureStorage.read(
        key: _keyTelephone,
        aOptions: _getAndroidOptions(),
        iOptions: _getIOSOptions(),
      );
      return telephone;
    } catch (e) {
      print('❌ Erreur lecture téléphone: $e');
      return null;
    }
  }

  // ==================== LOGIN STATE ====================

  /// Marquer l'utilisateur comme connecté
  Future<void> setLoggedIn(bool value) async {
    try {
      await _secureStorage.write(
        key: _keyIsLoggedIn,
        value: value.toString(),
        aOptions: _getAndroidOptions(),
        iOptions: _getIOSOptions(),
      );
    } catch (e) {
      print('❌ Erreur sauvegarde login state: $e');
    }
  }

  /// Vérifier si l'utilisateur est connecté
  Future<bool> isLoggedIn() async {
    try {
      final token = await getAccessToken();
      final value = await _secureStorage.read(
        key: _keyIsLoggedIn,
        aOptions: _getAndroidOptions(),
        iOptions: _getIOSOptions(),
      );
      return token != null && token.isNotEmpty && value == 'true';
    } catch (e) {
      print('❌ Erreur vérification login state: $e');
      return false;
    }
  }

  // ==================== BULK OPERATIONS ====================

  /// Sauvegarder toutes les données de connexion en une seule fois
  Future<void> saveLoginData({
    required String accessToken,
    required String refreshToken,
    required int userId,
    required String telephone,
  }) async {
    try {
      await Future.wait([
        saveAccessToken(accessToken),
        saveRefreshToken(refreshToken),
        saveUserId(userId),
        saveTelephone(telephone),
        setLoggedIn(true),
      ]);
      print('✅ Toutes les données de connexion sauvegardées');
    } catch (e) {
      print('❌ Erreur sauvegarde données de connexion: $e');
      rethrow;
    }
  }

  /// Récupérer toutes les données de connexion
  Future<Map<String, dynamic>> getLoginData() async {
    try {
      final results = await Future.wait([
        getAccessToken(),
        getRefreshToken(),
        getUserId(),
        getTelephone(),
        isLoggedIn(),
      ]);

      return {
        'accessToken': results[0],
        'refreshToken': results[1],
        'userId': results[2],
        'telephone': results[3],
        'isLoggedIn': results[4],
      };
    } catch (e) {
      print('❌ Erreur lecture données de connexion: $e');
      return {};
    }
  }

  // ==================== LOGOUT ====================

  /// Déconnexion - Supprimer toutes les données sécurisées
  Future<void> logout() async {
    try {
      await _secureStorage.deleteAll(
        aOptions: _getAndroidOptions(),
        iOptions: _getIOSOptions(),
      );
      print('✅ Déconnexion réussie - Toutes les données supprimées');
    } catch (e) {
      print('❌ Erreur lors de la déconnexion: $e');
      rethrow;
    }
  }

  // ==================== GENERIC METHODS ====================

  /// Sauvegarder une valeur générique
  Future<void> write(String key, String value) async {
    try {
      await _secureStorage.write(
        key: key,
        value: value,
        aOptions: _getAndroidOptions(),
        iOptions: _getIOSOptions(),
      );
    } catch (e) {
      print('❌ Erreur écriture $key: $e');
      rethrow;
    }
  }

  /// Lire une valeur générique
  Future<String?> read(String key) async {
    try {
      return await _secureStorage.read(
        key: key,
        aOptions: _getAndroidOptions(),
        iOptions: _getIOSOptions(),
      );
    } catch (e) {
      print('❌ Erreur lecture $key: $e');
      return null;
    }
  }

  /// Supprimer une clé spécifique
  Future<void> delete(String key) async {
    try {
      await _secureStorage.delete(
        key: key,
        aOptions: _getAndroidOptions(),
        iOptions: _getIOSOptions(),
      );
    } catch (e) {
      print('❌ Erreur suppression $key: $e');
    }
  }

  /// Vérifier si une clé existe
  Future<bool> containsKey(String key) async {
    try {
      final value = await read(key);
      return value != null;
    } catch (e) {
      return false;
    }
  }

  /// Récupérer toutes les clés
  Future<Map<String, String>> readAll() async {
    try {
      return await _secureStorage.readAll(
        aOptions: _getAndroidOptions(),
        iOptions: _getIOSOptions(),
      );
    } catch (e) {
      print('❌ Erreur lecture de toutes les clés: $e');
      return {};
    }
  }

  // ==================== CLEANUP ====================

  /// Nettoyer le service
  @override
  void onClose() {
    print('🗑️ StorageService fermé');
    super.onClose();
  }
}