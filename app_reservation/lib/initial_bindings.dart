import 'package:app_reservation/api/dio_client.dart';
import 'package:get/get.dart';
import 'data/services/auth_service.dart';
import 'data/services/storage_service.dart';

/// Bindings initiaux - Services globaux disponibles partout
class InitialBindings extends Bindings {
  @override
  void dependencies() {
    print('🔧 InitialBindings: Début initialisation...');
    
    // StorageService déjà initialisé dans main.dart
    if (!Get.isRegistered<StorageService>()) {
      print('⚠️ StorageService non trouvé');
      Get.putAsync(() => StorageService().init(), permanent: true);
    } else {
      print('✅ StorageService OK');
    }
    
    // DioClient
    Get.put(DioClient(), permanent: true);
    print('✅ DioClient OK');
    
    // AuthService
    Get.put(AuthService(), permanent: true);
    print('✅ AuthService OK');
    
    print('✅ InitialBindings: Terminé');
  }
}