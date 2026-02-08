import 'package:get/get.dart';
import '../../../data/services/auth_service.dart';
import '../../../routes/app_routes.dart';

class SplashController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    print('🎯 SplashController.onInit() appelé');
  }

  @override
  void onReady() {
    super.onReady();
    print('🔵 SplashController.onReady() appelé !');
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    try {
      print('🔵 SplashController: Début vérification');
      
      // Attendre 2 secondes pour l'animation
      await Future.delayed(const Duration(seconds: 2));

      // Vérifier si AuthService est disponible
      if (!Get.isRegistered<AuthService>()) {
        print('❌ AuthService non trouvé, redirection LOGIN');
        Get.offAllNamed(AppRoutes.LOGIN);
        return;
      }

      final authService = Get.find<AuthService>();
      
      // Vérifier connexion
      final isLoggedIn = await authService.isLoggedIn();
      print('🔍 Auto-login: $isLoggedIn');

      if (isLoggedIn) {
        // Récupérer les infos utilisateur
        final userId = await authService.getCurrentUserId();
        final telephone = await authService.getCurrentUserTelephone();
        print('✅ Connecté: ID=$userId, Tel=$telephone');
        
        // Redirection HOME
        print('🔄 Redirection vers HOME...');
        Get.offAllNamed(AppRoutes.MAIN);
      } else {
        print('❌ Non connecté');
        
        // Redirection LOGIN
        print('🔄 Redirection vers LOGIN...');
        Get.offAllNamed(AppRoutes.LOGIN);
      }
    } catch (e) {
      print('❌ Erreur vérification: $e');
      print('🔄 Redirection vers LOGIN par sécurité...');
      
      // En cas d'erreur, rediriger vers LOGIN
      Get.offAllNamed(AppRoutes.LOGIN);
    }
  }
}