// TODO: Implement register_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/services/auth_service.dart';
import '../../../routes/app_routes.dart';

class RegisterController extends GetxController {
  // ==================== SERVICES ====================
  
  final AuthService _authService = Get.find<AuthService>();

  // ==================== FORM CONTROLLERS ====================
  
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final telephoneController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  // ==================== REACTIVE VARIABLES ====================
  
  /// État du loading (bouton d'inscription)
  final isLoading = false.obs;

  /// Visibilité des mots de passe
  final isPasswordVisible = false.obs;
  final isConfirmPasswordVisible = false.obs;

  /// Messages d'erreur pour chaque champ
  final firstNameError = RxnString();
  final lastNameError = RxnString();
  final telephoneError = RxnString();
  final passwordError = RxnString();
  final confirmPasswordError = RxnString();

  // ==================== GETTERS ====================

  /// Vérifier si le formulaire est valide
  bool get isFormValid {
    return firstNameController.text.isNotEmpty &&
        lastNameController.text.isNotEmpty &&
        telephoneController.text.isNotEmpty &&
        passwordController.text.isNotEmpty &&
        confirmPasswordController.text.isNotEmpty &&
        firstNameError.value == null &&
        lastNameError.value == null &&
        telephoneError.value == null &&
        passwordError.value == null &&
        confirmPasswordError.value == null;
  }

  // ==================== LIFECYCLE ====================

  @override
  void onInit() {
    super.onInit();
    _setupListeners();
  }

  @override
  void onClose() {
    firstNameController.dispose();
    lastNameController.dispose();
    telephoneController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }

  // ==================== SETUP ====================

  /// Configurer les listeners pour validation en temps réel
  void _setupListeners() {
    firstNameController.addListener(_validateFirstName);
    lastNameController.addListener(_validateLastName);
    telephoneController.addListener(_validateTelephone);
    passwordController.addListener(_validatePassword);
    confirmPasswordController.addListener(_validateConfirmPassword);
  }

  // ==================== VALIDATION ====================

  /// Valider le prénom en temps réel
  void _validateFirstName() {
    final firstName = firstNameController.text;

    if (firstName.isEmpty) {
      firstNameError.value = null;
      return;
    }

    if (firstName.length < 2) {
      firstNameError.value = 'Minimum 2 caractères';
    } else if (firstName.length > 50) {
      firstNameError.value = 'Maximum 50 caractères';
    } else {
      firstNameError.value = null;
    }
  }

  /// Valider le nom en temps réel
  void _validateLastName() {
    final lastName = lastNameController.text;

    if (lastName.isEmpty) {
      lastNameError.value = null;
      return;
    }

    if (lastName.length < 2) {
      lastNameError.value = 'Minimum 2 caractères';
    } else if (lastName.length > 50) {
      lastNameError.value = 'Maximum 50 caractères';
    } else {
      lastNameError.value = null;
    }
  }

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
    if (!RegExp(r'^[234][0-9]{7}$').hasMatch(cleanPhone)) {
      telephoneError.value = 'Format invalide (ex: 22345678)';
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
    } else if (password.length > 128) {
      passwordError.value = 'Maximum 128 caractères';
    } else {
      passwordError.value = null;
    }

    // Re-valider la confirmation si elle existe
    if (confirmPasswordController.text.isNotEmpty) {
      _validateConfirmPassword();
    }
  }

  /// Valider la confirmation du mot de passe
  void _validateConfirmPassword() {
    final password = passwordController.text;
    final confirmPassword = confirmPasswordController.text;

    if (confirmPassword.isEmpty) {
      confirmPasswordError.value = null;
      return;
    }

    if (confirmPassword != password) {
      confirmPasswordError.value = 'Les mots de passe ne correspondent pas';
    } else {
      confirmPasswordError.value = null;
    }
  }

  // ==================== ACTIONS ====================

  /// Toggle visibilité du mot de passe
  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  /// Toggle visibilité de la confirmation
  void toggleConfirmPasswordVisibility() {
    isConfirmPasswordVisible.value = !isConfirmPasswordVisible.value;
  }

  /// Inscription
  Future<void> register() async {
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
      final authModel = await _authService.register(
        firstName: firstNameController.text.trim(),
        lastName: lastNameController.text.trim(),
        telephone: cleanPhone,
        password: passwordController.text,
      );

      // Afficher message de succès
      Get.snackbar(
        'Inscription réussie',
        'Bienvenue ${authModel.telephone} !',
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
      
      // ✅ CORRECTION: Redirection vers HOME au lieu de LOGIN
      Get.offAllNamed(AppRoutes.MAIN);

    } catch (e) {
      // Afficher l'erreur
      String errorMessage = e.toString();
      
      // Personnaliser certains messages d'erreur
      if (errorMessage.contains('already exists') || 
          errorMessage.contains('déjà utilisé')) {
        errorMessage = 'Ce numéro de téléphone est déjà utilisé';
      }

      Get.snackbar(
        'Erreur d\'inscription',
        errorMessage,
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

    // Valider prénom
    if (firstNameController.text.isEmpty) {
      firstNameError.value = 'Le prénom est requis';
      isValid = false;
    } else {
      _validateFirstName();
      if (firstNameError.value != null) {
        isValid = false;
      }
    }

    // Valider nom
    if (lastNameController.text.isEmpty) {
      lastNameError.value = 'Le nom est requis';
      isValid = false;
    } else {
      _validateLastName();
      if (lastNameError.value != null) {
        isValid = false;
      }
    }

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

    // Valider confirmation
    if (confirmPasswordController.text.isEmpty) {
      confirmPasswordError.value = 'La confirmation est requise';
      isValid = false;
    } else {
      _validateConfirmPassword();
      if (confirmPasswordError.value != null) {
        isValid = false;
      }
    }

    return isValid;
  }

  /// Navigation vers la page de connexion
  void goToLogin() {
    Get.back();
  }
}