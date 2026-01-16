// TODO: Implement app_pages.dart
import 'package:app_reservation/modules/auth/views/splash_view.dart';
import 'package:app_reservation/modules/core/controllers/home_controller.dart';
import 'package:app_reservation/modules/core/core_bindings.dart';
import 'package:app_reservation/modules/core/views/evaluation_view.dart';
import 'package:app_reservation/modules/core/views/home_view.dart';
import 'package:app_reservation/modules/core/views/main_view.dart';
import 'package:app_reservation/modules/core/views/mes_reservations_view.dart';
import 'package:app_reservation/modules/core/views/notifications_view.dart';
import 'package:app_reservation/modules/core/views/profile_view.dart';
import 'package:app_reservation/modules/core/views/reservation_view.dart';
import 'package:app_reservation/modules/core/views/search_terrain_view.dart';
import 'package:app_reservation/modules/core/views/settings_view.dart';
import 'package:app_reservation/modules/core/views/terrain_details_view.dart';
import 'package:get/get.dart';
import '../modules/auth/views/login_view.dart';
import '../modules/auth/views/register_view.dart';
import '../modules/auth/auth_bindings.dart';
import 'app_routes.dart';

class AppPages {
  static final List<GetPage<dynamic>> pages = [
    // ==================== AUTH PAGES ====================
     GetPage(
      name: AppRoutes.SPLASH,
      page: () => const SplashView(),
      binding: AuthBinding(),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 300),
    ),
    GetPage(
      name: AppRoutes.LOGIN,
      page: () => const LoginView(),
      binding: AuthBinding(),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 300),
    ),
    
    GetPage(
      name: AppRoutes.REGISTER,
      page: () => const RegisterView(),
      binding: AuthBinding(),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 300),
    ),
    GetPage(
  name: AppRoutes.HOME,
  page: () => const HomeView(),
  binding:  BindingsBuilder(() {
    Get.lazyPut<HomeController>(() => HomeController());
  }),
),

    
    // ==================== MAIN ROUTE ====================
    GetPage(
      name: AppRoutes.MAIN,
      page: () => const MainView(),
      binding: CoreBinding(),
    ),
    
    // ==================== CORE ROUTES ====================
    GetPage(
      name: AppRoutes.HOME,
      page: () => const HomeView(),
      binding: CoreBinding(),
    ),

    GetPage(
      name: AppRoutes.SEARCH_TERRAIN,
      page: () => const SearchTerrainView(),
      binding: CoreBinding(),
    ),
    GetPage(
      name: AppRoutes.TERRAIN_DETAILS,
      page: () => const TerrainDetailsView(),
      binding: CoreBinding(),
    ),
    GetPage(
      name: AppRoutes.RESERVATION,
      page: () => const ReservationView(),
      binding: CoreBinding(),
    ),
    GetPage(
      name: AppRoutes.MES_RESERVATIONS,
      page: () => const MesReservationsView(),
      binding: CoreBinding(),
    ),
    GetPage(
      name: AppRoutes.EVALUATION,
      page: () => const EvaluationView(),
      binding: CoreBinding(),
    ),
    GetPage(
      name: AppRoutes.PROFILE,
      page: () => const ProfileView(),
      binding: CoreBinding(),
    ),
    GetPage(
      name: AppRoutes.NOTIFICATIONS,
      page: () => const NotificationsView(),
      binding: CoreBinding(),
    ),
    GetPage(
      name: AppRoutes.SETTINGS,
      page: () => const SettingsView(),
      binding: CoreBinding(),
    ),
  ];
 
}

