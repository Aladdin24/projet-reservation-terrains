import 'package:get/get.dart';
import 'controllers/splash_controller.dart';
import 'controllers/login_controller.dart';
import 'controllers/register_controller.dart';

class AuthBinding extends Bindings {
  @override
  void dependencies() {
    print('🎯 ============================================');
    print('🎯 AuthBinding.dependencies() APPELÉ');
    print('🎯 ============================================');
    
    try {
      // SplashController
      print('🎯 Enregistrement SplashController...');
      Get.lazyPut<SplashController>(() {
        print('🎯 --> Création instance SplashController');
        return SplashController();
      });
      print('✅ SplashController enregistré');
      
      // LoginController
      print('🎯 Enregistrement LoginController...');
      Get.lazyPut<LoginController>(() {
        print('🎯 --> Création instance LoginController');
        return LoginController();
      });
      print('✅ LoginController enregistré');
      
      // RegisterController
      print('🎯 Enregistrement RegisterController...');
      Get.lazyPut<RegisterController>(() {
        print('🎯 --> Création instance RegisterController');
        return RegisterController();
      });
      print('✅ RegisterController enregistré');
      
      print('🎯 ============================================');
      print('✅ AuthBinding: Tous les controllers enregistrés !');
      print('🎯 ============================================');
    } catch (e) {
      print('❌ ============================================');
      print('❌ ERREUR dans AuthBinding: $e');
      print('❌ ============================================');
      rethrow;
    }
  }
} 


// // TODO: Implement bindings.dart
// import 'package:app_reservation/modules/auth/controllers/login_controller.dart';
// import 'package:app_reservation/modules/auth/controllers/register_controller.dart';
// import 'package:app_reservation/modules/auth/controllers/splash_controller.dart';
// import 'package:get/get.dart';

// class AuthBinding extends Bindings {
//   @override
//   void dependencies() {
//     Get.lazyPut<SplashController>(() => SplashController());  // ✅ AJOUTER
//     Get.lazyPut<LoginController>(() => LoginController());
//     Get.lazyPut<RegisterController>(() => RegisterController());
//   }
// }