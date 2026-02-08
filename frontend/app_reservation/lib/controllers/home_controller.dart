import 'dart:convert';
import 'package:app_reservation/controllers/terrain_controller.dart';
import 'package:app_reservation/services/api_service.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';

class HomeController extends GetxController {
  // ==================== CONFIG ====================
  final String baseUrl = "http://10.55.23.68:8000/api";
  // Android emulator = 10.0.2.2
  // téléphone réel = IP PC

  // ==================== STATE ====================
  var userName = "Utilisateur".obs;

  var isLoadingReservations = false.obs;
  var isLoadingTerrains = false.obs;

  var upcomingReservations = <Map<String, dynamic>>[].obs;
  var recommendedTerrains = <Map<String, dynamic>>[].obs;
  var currentPosition = const LocationData(latitude: 0, longitude: 0).obs;
  var selectedDate = DateTime.now().obs;
  var terrains = <dynamic>[].obs;

  double? latitude;
  double? longitude;

  // ==================== INIT ====================
  @override
  void onInit() {
    super.onInit();
    loadHomeData();
  }

  Future<void> refreshData() async {
    await loadHomeData();
  }

  Future<void> loadHomeData() async {
    await getLocation();
    await Future.wait([loadTerrains(), loadReservations()]);
  }

  // ==================== LOCATION ====================
  Future<void> getLocation() async {
    try {
      LocationPermission permission = await Geolocator.requestPermission();

      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        return;
      }

      Position position = await Geolocator.getCurrentPosition();

      latitude = position.latitude;
      longitude = position.longitude;
    } catch (e) {
      print("Erreur GPS: $e");
    }
  }

  // ==================== API TERRAINS ====================
  Future<void> loadTerrains() async {
    try {
      isLoadingTerrains(true);
      final hasLocation =
          currentPosition.value.latitude != 0 &&
          currentPosition.value.longitude != 0;
      final data = await ApiService.getTerrains(
        date:
            '${selectedDate.value.year}-${selectedDate.value.month.toString().padLeft(2, '0')}-${selectedDate.value.day.toString().padLeft(2, '0')}',
        latitude: hasLocation ? currentPosition.value.latitude : null,
        longitude: hasLocation ? currentPosition.value.longitude : null,
      );
      terrains.assignAll(data);
    } catch (e) {
      Get.snackbar('Erreur', e.toString());
    } finally {
      isLoadingTerrains(false);
    }
  }

  // ==================== API RESERVATIONS ====================
  Future<void> loadReservations() async {
    isLoadingReservations.value = true;

    try {
      final response = await http.get(
        Uri.parse("$baseUrl/reservations/my-reservations/"),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(utf8.decode(response.bodyBytes));

        upcomingReservations.value = List<Map<String, dynamic>>.from(data);
      }
    } catch (e) {
      print("Erreur reservations: $e");
    }

    isLoadingReservations.value = false;
  }

  // ==================== ACTIONS UI ====================
  void goToProfile() {}

  void goToSearch() => Get.toNamed('/terrains');

  void filterNearby() async {
    await getLocation();
    await loadTerrains();
  }

  void filterAvailableNow() {}

  void openFilters() {}

  void seeAllReservations() => Get.toNamed('/my-reservations');

  void seeAllTerrains() => Get.toNamed('/terrains');

  void goToTerrainDetails(id) {
    Get.toNamed('/terrain/$id');
  }

  void toggleFavorite(id) {}
}
