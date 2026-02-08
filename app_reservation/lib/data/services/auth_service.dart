import 'package:dio/dio.dart';
import 'package:get/get.dart' as getx;
import '../models/auth_model.dart';
import '../../api/dio_client.dart';
import '../../api/api_constants.dart';
import 'storage_service.dart';

/// Service d'authentification gérant login, register et logout
class AuthService extends getx.GetxService {
  final DioClient _dioClient = getx.Get.find<DioClient>();
  final StorageService _storageService = getx.Get.find<StorageService>();

  // ==================== LOGIN ====================

  /// Se connecter avec téléphone et mot de passe
  /// 
  /// Format téléphone mauritanien: 8 chiffres commençant par 2, 3 ou 4
  /// Exemples: 22345678, 33456789, 44567890
  /// 
  /// Exemple:
  /// ```dart
  /// final response = await authService.login(
  ///   telephone: "22345678",
  ///   password: "motdepasse123",
  /// );
  /// ```
  Future<AuthModel> login({
    required String telephone,
    required String password,
  }) async {
    try {
      print('🔵 Tentative de connexion pour: $telephone');

      final response = await _dioClient.publicDio.post(
        ApiConstants.login,
        data: {
          'telephone': telephone,
          'password': password,
        },
      );

      print('✅ Réponse login reçue: ${response.statusCode}');

      // Vérifier le status code avant de parser
      if (response.statusCode == 200 || response.statusCode == 201) {
        final authModel = AuthModel.fromJson(response.data);
        await _saveAuthData(authModel);
        print('✅ Connexion réussie pour l\'utilisateur: ${authModel.userId}');
        return authModel;
      } else {
        // Status code inattendu
        print('❌ Status code inattendu: ${response.statusCode}');
        throw 'Erreur lors de la connexion (${response.statusCode})';
      }

    } on DioException catch (e) {
      print('❌ Erreur Dio lors du login: ${e.message}');
      
      // Extraire le message d'erreur du backend
      if (e.response != null && e.response!.data != null) {
        final errorData = e.response!.data;
        
        // Si c'est un Map avec des erreurs de champs
        if (errorData is Map<String, dynamic>) {
          // Extraire les messages d'erreur
          final errors = <String>[];
          
          errorData.forEach((key, value) {
            if (value is List) {
              errors.addAll(value.map((e) => e.toString()));
            } else {
              errors.add(value.toString());
            }
          });
          
          if (errors.isNotEmpty) {
            throw errors.join('\n');
          }
        } else if (errorData is String) {
          throw errorData;
        }
      }
      
      // Si pas de message spécifique, utiliser le message par défaut
      throw _dioClient.handleDioError(e);
      
    } catch (e) {
      print('❌ Erreur inattendue lors du login: $e');
      
      // Si c'est déjà un String d'erreur, le relancer
      if (e is String) {
        throw e;
      }
      
      throw 'Une erreur inattendue s\'est produite';
    }
  }

  // ==================== REGISTER ====================

  /// S'inscrire comme utilisateur standard
  /// 
  /// Format téléphone mauritanien: 8 chiffres commençant par 2, 3 ou 4
  /// Exemples: 22345678, 33456789, 44567890
  /// 
  /// Exemple:
  /// ```dart
  /// final response = await authService.register(
  ///   firstName: "Jean",
  ///   lastName: "Dupont",
  ///   telephone: "22345678",
  ///   password: "motdepasse123",
  /// );
  /// ```
  Future<AuthModel> register({
    required String firstName,
    required String lastName,
    required String telephone,
    required String password,
  }) async {
    try {
      print('🔵 Tentative d\'inscription pour: $firstName $lastName ($telephone)');

      // Préparer les données selon l'API backend
      final Map<String, dynamic> data = {
        'first_name': firstName,
        'last_name': lastName,
        'telephone': telephone,
        'password': password,
        'password2': password, // Confirmation (même valeur)
      };

      final response = await _dioClient.publicDio.post(
        ApiConstants.register,
        data: data,
      );

      print('✅ Réponse inscription reçue: ${response.statusCode}');

      // Vérifier le status code avant de parser
      if (response.statusCode == 200 || response.statusCode == 201) {
        final authModel = AuthModel.fromJson(response.data);
        await _saveAuthData(authModel);
        print('✅ Inscription réussie pour l\'utilisateur: ${authModel.userId}');
        return authModel;
      } else {
        // Status code inattendu
        print('❌ Status code inattendu: ${response.statusCode}');
        throw 'Erreur lors de l\'inscription (${response.statusCode})';
      }
      
    } on DioException catch (e) {
      print('❌ Erreur Dio lors de l\'inscription: ${e.message}');
      
      // Extraire le message d'erreur du backend
      if (e.response != null && e.response!.data != null) {
        final errorData = e.response!.data;
        
        // Si c'est un Map avec des erreurs de champs
        if (errorData is Map<String, dynamic>) {
          // Extraire les messages d'erreur
          final errors = <String>[];
          
          errorData.forEach((key, value) {
            if (value is List) {
              errors.addAll(value.map((e) => e.toString()));
            } else {
              errors.add(value.toString());
            }
          });
          
          if (errors.isNotEmpty) {
            throw errors.join('\n');
          }
        }
      }
      
      // Si pas de message spécifique, utiliser le message par défaut
      throw _dioClient.handleDioError(e);
      
    } catch (e) {
      print('❌ Erreur inattendue lors de l\'inscription: $e');
      
      // Si c'est déjà un String d'erreur, le relancer
      if (e is String) {
        throw e;
      }
      
      throw 'Une erreur inattendue s\'est produite';
    }
  }

  // ==================== LOGOUT ====================

  /// Se déconnecter
  Future<void> logout() async {
    try {
      print('🔵 Déconnexion en cours...');
      await _storageService.logout();
      print('✅ Déconnexion réussie');
    } catch (e) {
      print('❌ Erreur lors de la déconnexion: $e');
      throw 'Erreur lors de la déconnexion';
    }
  }

  // ==================== HELPERS ====================

  Future<bool> isLoggedIn() async {
    return await _storageService.isLoggedIn();
  }

  Future<int?> getCurrentUserId() async {
    return await _storageService.getUserId();
  }

  Future<String?> getCurrentUserTelephone() async {
    return await _storageService.getTelephone();
  }

  Future<String?> getAccessToken() async {
    return await _storageService.getAccessToken();
  }

  Future<void> _saveAuthData(AuthModel authModel) async {
    await _storageService.saveLoginData(
      accessToken: authModel.access,
      refreshToken: authModel.refresh,
      userId: authModel.userId,
      telephone: authModel.telephone,
    );
  }
}


// import 'package:dio/dio.dart';
// import 'package:get/get.dart' as getx;
// import '../models/auth_model.dart';
// import '../../api/dio_client.dart';
// import '../../api/api_constants.dart';
// import 'storage_service.dart';

// /// Service d'authentification gérant login, register et logout
// class AuthService extends getx.GetxService {
//   final DioClient _dioClient = getx.Get.find<DioClient>();
//   final StorageService _storageService = getx.Get.find<StorageService>();

//   // ==================== LOGIN ====================

//   /// Se connecter avec téléphone et mot de passe
//   /// 
//   /// Format téléphone mauritanien: 8 chiffres commençant par 2, 3 ou 4
//   /// Exemples: 22345678, 33456789, 44567890
//   /// 
//   /// Exemple:
//   /// ```dart
//   /// final response = await authService.login(
//   ///   telephone: "22345678",
//   ///   password: "motdepasse123",
//   /// );
//   /// ```
//   Future<AuthModel> login({
//     required String telephone,
//     required String password,
//   }) async {
//     try {
//       print('🔵 Tentative de connexion pour: $telephone');

//       final response = await _dioClient.publicDio.post(
//         ApiConstants.login,
//         data: {
//           'telephone': telephone,
//           'password': password,
//         },
//       );

//       print('✅ Réponse login reçue: ${response.statusCode}');

//       final authModel = AuthModel.fromJson(response.data);

//       await _saveAuthData(authModel);

//       print('✅ Connexion réussie pour l\'utilisateur: ${authModel.userId}');

//       return authModel;
//     } on DioException catch (e) {
//       print('❌ Erreur Dio lors du login: ${e.message}');
//       throw _dioClient.handleDioError(e);
//     } catch (e) {
//       print('❌ Erreur inattendue lors du login: $e');
//       throw 'Une erreur inattendue s\'est produite';
//     }
//   }

//   // ==================== REGISTER ====================

//   /// S'inscrire comme utilisateur standard
//   /// 
//   /// Format téléphone mauritanien: 8 chiffres commençant par 2, 3 ou 4
//   /// Exemples: 22345678, 33456789, 44567890
//   /// 
//   /// Exemple:
//   /// ```dart
//   /// final response = await authService.register(
//   ///   firstName: "Jean",
//   ///   lastName: "Dupont",
//   ///   telephone: "22345678",
//   ///   password: "motdepasse123",
//   /// );
//   /// ```
//   Future<AuthModel> register({
//     required String firstName,
//     required String lastName,
//     required String telephone,
//     required String password,
//   }) async {
//     try {
//       print('🔵 Tentative d\'inscription pour: $firstName $lastName ($telephone)');

//       // Préparer les données selon l'API backend
//       final Map<String, dynamic> data = {
//         'first_name': firstName,
//         'last_name': lastName,
//         'telephone': telephone,
//         'password': password,
//         'password2': password, // Confirmation (même valeur)
//       };

//       final response = await _dioClient.publicDio.post(
//         ApiConstants.register,
//         data: data,
//       );

//       print('✅ Réponse inscription reçue: ${response.statusCode}');

//       final authModel = AuthModel.fromJson(response.data);

//       await _saveAuthData(authModel);

//       print('✅ Inscription réussie pour l\'utilisateur: ${authModel.userId}');

//       return authModel;
//     } on DioException catch (e) {
//       print('❌ Erreur Dio lors de l\'inscription: ${e.message}');
//       throw _dioClient.handleDioError(e);
//     } catch (e) {
//       print('❌ Erreur inattendue lors de l\'inscription: $e');
//       throw 'Une erreur inattendue s\'est produite';
//     }
//   }

//   // ==================== LOGOUT ====================

//   /// Se déconnecter
//   Future<void> logout() async {
//     try {
//       print('🔵 Déconnexion en cours...');
//       await _storageService.logout();
//       print('✅ Déconnexion réussie');
//     } catch (e) {
//       print('❌ Erreur lors de la déconnexion: $e');
//       throw 'Erreur lors de la déconnexion';
//     }
//   }

//   // ==================== HELPERS ====================

//   Future<bool> isLoggedIn() async {
//     return await _storageService.isLoggedIn();
//   }

//   Future<int?> getCurrentUserId() async {
//     return await _storageService.getUserId();
//   }

//   Future<String?> getCurrentUserTelephone() async {
//     return await _storageService.getTelephone();
//   }

//   Future<String?> getAccessToken() async {
//     return await _storageService.getAccessToken();
//   }

//   Future<void> _saveAuthData(AuthModel authModel) async {
//     await _storageService.saveLoginData(
//       accessToken: authModel.access,
//       refreshToken: authModel.refresh,
//       userId: authModel.userId,
//       telephone: authModel.telephone,
//     );
//   }
// }


