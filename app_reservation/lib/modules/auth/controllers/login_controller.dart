import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/services/auth_service.dart';
import '../../../routes/app_routes.dart';

class LoginController extends GetxController {
  // ==================== SERVICES ====================
  
  final AuthService _authService = Get.find<AuthService>();

  // ==================== FORM CONTROLLERS ====================
  
  final telephoneController = TextEditingController();
  final passwordController = TextEditingController();

  // ==================== REACTIVE VARIABLES ====================
  
  /// État du loading (bouton de connexion)
  final isLoading = false.obs;

  /// Visibilité du mot de passe
  final isPasswordVisible = false.obs;

  /// Se souvenir de moi
  final rememberMe = false.obs;

  /// Messages d'erreur pour chaque champ
  final telephoneError = RxnString();
  final passwordError = RxnString();

  // ==================== GETTERS ====================

  /// Vérifier si le formulaire est valide
  bool get isFormValid {
    return telephoneController.text.isNotEmpty &&
        passwordController.text.isNotEmpty &&
        telephoneError.value == null &&
        passwordError.value == null;
  }

  // ==================== LIFECYCLE ====================

  @override
  void onInit() {
    super.onInit();
    _setupListeners();
    _loadSavedCredentials();
  }

  @override
  void onClose() {
    telephoneController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  // ==================== SETUP ====================

  /// Configurer les listeners pour validation en temps réel
  void _setupListeners() {
    telephoneController.addListener(_validateTelephone);
    passwordController.addListener(_validatePassword);
  }

  /// Charger les identifiants sauvegardés si "Se souvenir" était activé
  Future<void> _loadSavedCredentials() async {
    // TODO: Implémenter si vous voulez la fonctionnalité "Se souvenir"
    // final savedPhone = await _storageService.read('saved_phone');
    // if (savedPhone != null) {
    //   telephoneController.text = savedPhone;
    //   rememberMe.value = true;
    // }
  }

  // ==================== VALIDATION ====================

  /// Valider le numéro de téléphone en temps réel
  void _validateTelephone() {
    final phone = telephoneController.text;

    if (phone.isEmpty) {
      telephoneError.value = null;
      return;
    }

    // Supprimer les espaces
    final cleanPhone = phone.replaceAll(' ', '');

    // Vérifier le format mauritanien: 8 chiffres commençant par 2, 3 ou 4
    // Exemples valides: 22345678, 33456789, 44567890
    if (!RegExp(r'^[234][0-9]{7}$').hasMatch(cleanPhone)) {
      telephoneError.value = 'Format invalide (ex: 22345678, 33456789, 44567890)';
    } else {
      telephoneError.value = null;
    }
  }

  /// Valider le mot de passe en temps réel
  void _validatePassword() {
    final password = passwordController.text;

    if (password.isEmpty) {
      passwordError.value = null;
      return;
    }

    if (password.length < 6) {
      passwordError.value = 'Minimum 6 caractères';
    } else {
      passwordError.value = null;
    }
  }

  // ==================== ACTIONS ====================

  /// Toggle visibilité du mot de passe
  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  /// Toggle "Se souvenir de moi"
  void toggleRememberMe(bool? value) {
    rememberMe.value = value ?? false;
  }

  /// Connexion
  Future<void> login() async {
    // Cacher le clavier
    FocusScope.of(Get.context!).unfocus();

    // Validation finale
    if (!_validateForm()) {
      return;
    }

    try {
      isLoading.value = true;

      // Nettoyer le numéro de téléphone
      final cleanPhone = telephoneController.text.replaceAll(' ', '');

      // Appeler le service d'authentification
      final authModel = await _authService.login(
        telephone: cleanPhone,
        password: passwordController.text,
      );

      // Sauvegarder les identifiants si "Se souvenir" est activé
      if (rememberMe.value) {
        // TODO: Sauvegarder le téléphone
        // await _storageService.write('saved_phone', cleanPhone);
      }

      // Afficher message de succès
      Get.snackbar(
        'Connexion réussie',
        'Bienvenue ${authModel.telephone}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
        margin: const EdgeInsets.all(16),
        borderRadius: 8,
        icon: const Icon(Icons.check_circle, color: Colors.white),
      );

      // Redirection vers HOME après un court délai
      await Future.delayed(const Duration(milliseconds: 500));
      Get.offAllNamed(AppRoutes.MAIN);

    } catch (e) {
      // Afficher l'erreur
      Get.snackbar(
        'Erreur de connexion',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
        margin: const EdgeInsets.all(16),
        borderRadius: 8,
        icon: const Icon(Icons.error, color: Colors.white),
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// Validation complète du formulaire avant soumission
  bool _validateForm() {
    bool isValid = true;

    // Valider téléphone
    if (telephoneController.text.isEmpty) {
      telephoneError.value = 'Le numéro de téléphone est requis';
      isValid = false;
    } else {
      _validateTelephone();
      if (telephoneError.value != null) {
        isValid = false;
      }
    }

    // Valider mot de passe
    if (passwordController.text.isEmpty) {
      passwordError.value = 'Le mot de passe est requis';
      isValid = false;
    } else {
      _validatePassword();
      if (passwordError.value != null) {
        isValid = false;
      }
    }

    return isValid;
  }

  /// Navigation vers la page d'inscription
  void goToRegister() {
    Get.toNamed(AppRoutes.REGISTER);
  }

  /// Mot de passe oublié
  void forgotPassword() {
    // TODO: Implémenter la fonctionnalité mot de passe oublié
    Get.snackbar(
      'Fonctionnalité bientôt disponible',
      'La réinitialisation du mot de passe sera bientôt disponible',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.orange,
      colorText: Colors.white,
      duration: const Duration(seconds: 2),
      margin: const EdgeInsets.all(16),
      borderRadius: 8,
    );
  }

  // ==================== HELPERS ====================

  /// Formater le numéro de téléphone pendant la saisie
  /// Format mauritanien: XX XX XX XX (8 chiffres)
  String formatPhoneNumber(String value) {
    // Supprimer tous les espaces
    value = value.replaceAll(' ', '');

    // Limiter à 8 caractères
    if (value.length > 8) {
      value = value.substring(0, 8);
    }

    // Formater: XX XX XX XX
    if (value.length > 2) {
      value = '${value.substring(0, 2)} ${value.substring(2)}';
    }
    if (value.length > 5) {
      value = '${value.substring(0, 5)} ${value.substring(5)}';
    }
    if (value.length > 8) {
      value = '${value.substring(0, 8)} ${value.substring(8)}';
    }

    return value;
  }
}


// // TODO: Implement login_controller.dart
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import '../../../data/services/auth_service.dart';
// import '../../../routes/app_routes.dart';

// class LoginController extends GetxController {
//   // ==================== SERVICES ====================
  
//   final AuthService _authService = Get.find<AuthService>();

//   // ==================== FORM CONTROLLERS ====================
  
//   final telephoneController = TextEditingController();
//   final passwordController = TextEditingController();

//   // ==================== REACTIVE VARIABLES ====================
  
//   /// État du loading (bouton de connexion)
//   final isLoading = false.obs;

//   /// Visibilité du mot de passe
//   final isPasswordVisible = false.obs;

//   /// Se souvenir de moi
//   final rememberMe = false.obs;

//   /// Messages d'erreur pour chaque champ
//   final telephoneError = RxnString();
//   final passwordError = RxnString();

//   // ==================== GETTERS ====================

//   /// Vérifier si le formulaire est valide
//   bool get isFormValid {
//     return telephoneController.text.isNotEmpty &&
//         passwordController.text.isNotEmpty &&
//         telephoneError.value == null &&
//         passwordError.value == null;
//   }

//   // ==================== LIFECYCLE ====================

//   @override
//   void onInit() {
//     super.onInit();
//     _setupListeners();
//     _loadSavedCredentials();
//   }

//   @override
//   void onClose() {
//     telephoneController.dispose();
//     passwordController.dispose();
//     super.onClose();
//   }

//   // ==================== SETUP ====================

//   /// Configurer les listeners pour validation en temps réel
//   void _setupListeners() {
//     telephoneController.addListener(_validateTelephone);
//     passwordController.addListener(_validatePassword);
//   }

//   /// Charger les identifiants sauvegardés si "Se souvenir" était activé
//   Future<void> _loadSavedCredentials() async {
//     // TODO: Implémenter si vous voulez la fonctionnalité "Se souvenir"
//     // final savedPhone = await _storageService.read('saved_phone');
//     // if (savedPhone != null) {
//     //   telephoneController.text = savedPhone;
//     //   rememberMe.value = true;
//     // }
//   }

//   // ==================== VALIDATION ====================

//   /// Valider le numéro de téléphone en temps réel
//   void _validateTelephone() {
//     final phone = telephoneController.text;

//     if (phone.isEmpty) {
//       telephoneError.value = null;
//       return;
//     }

//     // Supprimer les espaces
//     final cleanPhone = phone.replaceAll(' ', '');

//     // Vérifier le format mauritanien: 0XXXXXXXX (9 chiffres)
//     if (!RegExp(r'^0[0-9]{8}$').hasMatch(cleanPhone)) {
//       telephoneError.value = 'Format invalide (ex: 06XXXXXXX)';
//     } else {
//       telephoneError.value = null;
//     }
//   }

//   /// Valider le mot de passe en temps réel
//   void _validatePassword() {
//     final password = passwordController.text;

//     if (password.isEmpty) {
//       passwordError.value = null;
//       return;
//     }

//     if (password.length < 6) {
//       passwordError.value = 'Minimum 6 caractères';
//     } else {
//       passwordError.value = null;
//     }
//   }

//   // ==================== ACTIONS ====================

//   /// Toggle visibilité du mot de passe
//   void togglePasswordVisibility() {
//     isPasswordVisible.value = !isPasswordVisible.value;
//   }

//   /// Toggle "Se souvenir de moi"
//   void toggleRememberMe(bool? value) {
//     rememberMe.value = value ?? false;
//   }

//   /// Connexion
//   Future<void> login() async {
//     // Cacher le clavier
//     FocusScope.of(Get.context!).unfocus();

//     // Validation finale
//     if (!_validateForm()) {
//       return;
//     }

//     try {
//       isLoading.value = true;

//       // Nettoyer le numéro de téléphone
//       final cleanPhone = telephoneController.text.replaceAll(' ', '');

//       // Appeler le service d'authentification
//       final authModel = await _authService.login(
//         telephone: cleanPhone,
//         password: passwordController.text,
//       );

//       // Sauvegarder les identifiants si "Se souvenir" est activé
//       if (rememberMe.value) {
//         // TODO: Sauvegarder le téléphone
//         // await _storageService.write('saved_phone', cleanPhone);
//       }

//       // Afficher message de succès
//       Get.snackbar(
//         'Connexion réussie',
//         'Bienvenue ${authModel.telephone}',
//         snackPosition: SnackPosition.BOTTOM,
//         backgroundColor: Colors.green,
//         colorText: Colors.white,
//         duration: const Duration(seconds: 2),
//         margin: const EdgeInsets.all(16),
//         borderRadius: 8,
//         icon: const Icon(Icons.check_circle, color: Colors.white),
//       );

//       // Redirection vers HOME après un court délai
//       await Future.delayed(const Duration(milliseconds: 500));
//       Get.offAllNamed(AppRoutes.HOME);

//     } catch (e) {
//       // Afficher l'erreur
//       Get.snackbar(
//         'Erreur de connexion',
//         e.toString(),
//         snackPosition: SnackPosition.BOTTOM,
//         backgroundColor: Colors.red,
//         colorText: Colors.white,
//         duration: const Duration(seconds: 3),
//         margin: const EdgeInsets.all(16),
//         borderRadius: 8,
//         icon: const Icon(Icons.error, color: Colors.white),
//       );
//     } finally {
//       isLoading.value = false;
//     }
//   }

//   /// Validation complète du formulaire avant soumission
//   bool _validateForm() {
//     bool isValid = true;

//     // Valider téléphone
//     if (telephoneController.text.isEmpty) {
//       telephoneError.value = 'Le numéro de téléphone est requis';
//       isValid = false;
//     } else {
//       _validateTelephone();
//       if (telephoneError.value != null) {
//         isValid = false;
//       }
//     }

//     // Valider mot de passe
//     if (passwordController.text.isEmpty) {
//       passwordError.value = 'Le mot de passe est requis';
//       isValid = false;
//     } else {
//       _validatePassword();
//       if (passwordError.value != null) {
//         isValid = false;
//       }
//     }

//     return isValid;
//   }

//   /// Navigation vers la page d'inscription
//   void goToRegister() {
//     Get.toNamed(AppRoutes.REGISTER);
//   }

//   /// Mot de passe oublié
//   void forgotPassword() {
//     // TODO: Implémenter la fonctionnalité mot de passe oublié
//     Get.snackbar(
//       'Fonctionnalité bientôt disponible',
//       'La réinitialisation du mot de passe sera bientôt disponible',
//       snackPosition: SnackPosition.BOTTOM,
//       backgroundColor: Colors.orange,
//       colorText: Colors.white,
//       duration: const Duration(seconds: 2),
//       margin: const EdgeInsets.all(16),
//       borderRadius: 8,
//     );
//   }

//   // ==================== HELPERS ====================

//   /// Formater le numéro de téléphone pendant la saisie
//   String formatPhoneNumber(String value) {
//     // Supprimer tous les espaces
//     value = value.replaceAll(' ', '');

//     // Limiter à 9 caractères
//     if (value.length > 9) {
//       value = value.substring(0, 9);
//     }

//     // Formater: XX XX XX XX XX
//     if (value.length > 2) {
//       value = '${value.substring(0, 2)} ${value.substring(2)}';
//     }
//     if (value.length > 5) {
//       value = '${value.substring(0, 5)} ${value.substring(5)}';
//     }
//     if (value.length > 8) {
//       value = '${value.substring(0, 8)} ${value.substring(8)}';
//     }
//     if (value.length > 11) {
//       value = '${value.substring(0, 11)} ${value.substring(11)}';
//     }

//     return value;
//   }
// }