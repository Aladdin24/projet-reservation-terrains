// lib/controllers/terrain_controller.dart
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../services/api_service.dart';
import 'package:geolocator/geolocator.dart';

class TerrainController extends GetxController {
  var terrains = <dynamic>[].obs;
  var isLoading = false.obs;
  var selectedDate = DateTime.now().obs;

  var currentPosition = const LocationData(latitude: 0, longitude: 0).obs;
  var isLoadingLocation = false.obs;

  var viewMode = 'list'.obs; // 'list' ou 'card'

  var mapMarkers = <Marker>[].obs;
  var initialCameraPosition = const CameraPosition(
    target: LatLng(0, 0),
    zoom: 12,
  ).obs;

  final PolylinePoints polylinePoints = PolylinePoints();
  var polylines = <Polyline>{}.obs;
  String? _directionsApiKey =
      'AIzaSyB5EkxN3CxrZAemoRvRAeuQq1QqclMPJ2o'; // ← À remplacer

  @override
  void onInit() {
    fetchTerrains();
    super.onInit();
  }

  Future<void> showDirectionsToTerrain(
    double terrainLat,
    double terrainLng,
  ) async {
    if (currentPosition.value.latitude == 0) {
      Get.snackbar('Erreur', 'Impossible d’obtenir votre position.');
      return;
    }

    try {
      final result = await polylinePoints.getRouteBetweenCoordinates(
        request: PolylineRequest(
          origin: PointLatLng(
            currentPosition.value.latitude,
            currentPosition.value.longitude,
          ),
          destination: PointLatLng(terrainLat, terrainLng),
          mode: TravelMode.driving,
        ),
        googleApiKey: _directionsApiKey!,
      );

      if (result.points.isNotEmpty) {
        final points = result.points
            .map((e) => LatLng(e.latitude, e.longitude))
            .toList();

        polylines.value = {
          Polyline(
            polylineId: const PolylineId('route'),
            points: points,
            color: Colors.blue,
            width: 5,
            // Optionnel : flèches de direction
            // patterns: [PatternItem.dash(10), PatternItem.gap(10)],
          ),
        };
      } else {
        Get.snackbar('Erreur', 'Aucun itinéraire trouvé.');
      }
    } catch (e) {
      Get.snackbar('Erreur', 'Impossible de charger l’itinéraire.');
    }
  }

  void clearDirections() {
    polylines.value = {};
  }

  Future<void> loadMapMarkers() async {
    final markers = <Marker>[];

    for (var terrain in terrains) {
      final lat = double.tryParse(terrain['latitude'].toString());
      final lng = double.tryParse(terrain['longitude'].toString());

      if (lat != null && lng != null) {
        final note = double.tryParse(
          terrain['note_moyenne']?.toString() ?? '0',
        );

        markers.add(
          Marker(
            markerId: MarkerId(terrain['id'].toString()),
            position: LatLng(lat, lng),

            onTap: () {
              Get.defaultDialog(
                title: terrain['nom'],
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(terrain['adresse']),
                    const SizedBox(height: 12),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton.icon(
                          onPressed: () {
                            Get.back();
                            Get.toNamed('/terrain/${terrain['id']}');
                          },
                          icon: const Icon(Icons.visibility, size: 16),
                          label: const Text('Voir'),
                        ),

                        ElevatedButton.icon(
                          onPressed: () {
                            Get.back();
                            showDirectionsToTerrain(lat, lng);
                          },
                          icon: const Icon(Icons.directions, size: 16),
                          label: const Text('Itinéraire'),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },

            infoWindow: InfoWindow(
              title: terrain['nom'],
              snippet: terrain['adresse'],
            ),
          ),
        );
      }
    }

    mapMarkers.assignAll(markers);
  }

  Future<void> setMapInitialPosition() async {
    if (currentPosition.value.latitude != 0) {
      initialCameraPosition.value = CameraPosition(
        target: LatLng(
          currentPosition.value.latitude,
          currentPosition.value.longitude,
        ),
        zoom: 13,
      );
    } else {
      // Fallback: Casablanca ou Paris
      initialCameraPosition.value = const CameraPosition(
        target: LatLng(33.5731, -7.5898), // Casablanca
        zoom: 10,
      );
    }
  }

  void toggleViewMode() {
    viewMode.value = viewMode.value == 'list' ? 'card' : 'list';
  }

  Future<void> fetchTerrains() async {
    try {
      isLoading(true);
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
      isLoading(false);
    }
  }

  Future<void> getCurrentLocation() async {
    try {
      isLoadingLocation(true);

      // Vérifier les permissions
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        Get.snackbar('Erreur', 'Veuillez activer la localisation.');
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          Get.snackbar('Erreur', 'Autorisation de localisation refusée.');
          return;
        }
      }

      // Obtenir la position
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      currentPosition.value = LocationData(
        latitude: position.latitude,
        longitude: position.longitude,
      );

      // Recharger les terrains avec la position
      fetchTerrains();
    } catch (e) {
      Get.snackbar('Erreur', 'Impossible d’obtenir la localisation.');
    } finally {
      isLoadingLocation(false);
    }
  }

  void changeDate(DateTime newDate) {
    selectedDate.value = newDate;
    fetchTerrains();
  }
}

// Classe utilitaire
class LocationData {
  final double latitude;
  final double longitude;
  const LocationData({required this.latitude, required this.longitude});
}
