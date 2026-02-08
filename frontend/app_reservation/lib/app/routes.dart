// lib/app/routes.dart
import 'package:app_reservation/home_binding.dart';
import 'package:app_reservation/views/terrain/evaluation_view.dart';
import 'package:app_reservation/views/terrain/terrain_map_view.dart';
import 'package:get/get.dart';
import '../views/auth/login_view.dart';
import '../views/auth/register_view.dart';
import '../views/home/home_view.dart';
import '../views/terrain/terrain_list_view.dart';
import '../views/terrain/terrain_detail_view.dart';
import '../views/profile/my_reservations_view.dart';

class AppRoutes {
  static final routes = [
    GetPage(name: '/login', page: () => const LoginView()),
    // GetPage(name: '/register', page: () => const RegisterView()),
    //GetPage(name: '/home', page: () => const HomeView()),
    GetPage(name: '/terrains', page: () => const TerrainListView()),
    GetPage(
      name: '/terrain/:id',
      page: () => const TerrainDetailView(),
      parameters: {'id': '1'},
    ),
    GetPage(name: '/my-reservations', page: () => const MyReservationsView()),
    GetPage(name: '/evaluate', page: () => const EvaluationView()),
    GetPage(name: '/home', page: () => HomeView(), binding: HomeBinding()),
    GetPage(name: '/map', page: () => const TerrainMapView()),
  ];
}
