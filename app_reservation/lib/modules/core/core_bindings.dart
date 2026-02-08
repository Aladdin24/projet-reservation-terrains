import 'package:app_reservation/modules/core/controllers/evaluation_controller.dart';
import 'package:app_reservation/modules/core/controllers/home_controller.dart';
import 'package:app_reservation/modules/core/controllers/main_controller.dart';
import 'package:app_reservation/modules/core/controllers/mes_reservations_controller.dart';
import 'package:app_reservation/modules/core/controllers/notification_controller.dart';
import 'package:app_reservation/modules/core/controllers/profile_controller.dart';
import 'package:app_reservation/modules/core/controllers/reservation_controller.dart';
import 'package:app_reservation/modules/core/controllers/search_terrain_controller.dart';
import 'package:app_reservation/modules/core/controllers/settings_controller.dart';
import 'package:app_reservation/modules/core/controllers/terrain_details_controller.dart';
import 'package:get/get.dart';

class CoreBinding extends Bindings {
  @override
  void dependencies() {
    // ==================== MAIN NAVIGATION ====================
    Get.lazyPut<MainController>(() => MainController());
    
    // ==================== CORE CONTROLLERS ====================
    Get.lazyPut<HomeController>(() => HomeController());
    Get.lazyPut<SearchTerrainController>(() => SearchTerrainController());
    Get.lazyPut<TerrainDetailsController>(() => TerrainDetailsController());
    Get.lazyPut<ReservationController>(() => ReservationController());
    Get.lazyPut<MesReservationsController>(() => MesReservationsController());
    Get.lazyPut<EvaluationController>(() => EvaluationController());
    Get.lazyPut<ProfileController>(() => ProfileController());
    Get.lazyPut<NotificationController>(() => NotificationController());
    Get.lazyPut<SettingsController>(() => SettingsController());
  }
}