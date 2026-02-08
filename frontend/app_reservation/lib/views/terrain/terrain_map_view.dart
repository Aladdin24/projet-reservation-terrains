// lib/views/terrain/terrain_map_view.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../controllers/terrain_controller.dart';

class TerrainMapView extends StatelessWidget {
  const TerrainMapView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<TerrainController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Carte des terrains'),
        actions: [
          IconButton(
            onPressed: () => Get.offAllNamed('/home'),
            icon: const Icon(Icons.home),
          ),
        ],
      ),
      body: Obx(() {
        return GoogleMap(
          initialCameraPosition: controller.initialCameraPosition.value,
          markers: controller.mapMarkers.toSet(),
          polylines: controller.polylines.value, // ← Utilisez `polylines`
          myLocationEnabled: true,
          myLocationButtonEnabled: true,
          zoomControlsEnabled: true,
          onMapCreated: (_) {
            controller.setMapInitialPosition();
            controller.loadMapMarkers();
          },
          onLongPress: (position) {
            controller.clearDirections(); // Efface l'itinéraire
          },
          // onMarkerTapped: (marker) async {
          //   final terrain = controller.terrains.firstWhere(
          //     (t) => t['id'].toString() == marker.markerId.value,
          //     orElse: () => null,
          //   );
          //   if (terrain == null) return;

          //   Get.defaultDialog(
          //     title: terrain['nom'],
          //     content: Column(
          //       mainAxisSize: MainAxisSize.min,
          //       children: [
          //         Text(terrain['adresse']),
          //         const SizedBox(height: 12),
          //         Row(
          //           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          //           children: [
          //             ElevatedButton.icon(
          //               onPressed: () {
          //                 Get.back();
          //                 Get.toNamed('/terrain/${terrain['id']}');
          //               },
          //               icon: const Icon(Icons.visibility, size: 16),
          //               label: const Text('Voir'),
          //             ),
          //             ElevatedButton.icon(
          //               onPressed: () {
          //                 Get.back();
          //                 controller.showDirectionsToTerrain(
          //                   terrain['latitude'],
          //                   terrain['longitude'],
          //                 );
          //               },
          //               icon: const Icon(Icons.directions, size: 16),
          //               label: const Text('Itinéraire'),
          //             ),
          //           ],
          //         ),
          //       ],
          //     ),
          //     confirm: null,
          //     cancel: null,
          //   );
          // },
        );
      }),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Accueil'),
          BottomNavigationBarItem(
            icon: Icon(Icons.sports_soccer),
            label: 'Foot',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
        ],
        currentIndex: 1,
        onTap: (index) {
          if (index == 0)
            Get.offAllNamed('/home');
          else if (index == 2)
            Get.toNamed('/my-reservations');
        },
      ),
    );
  }
}
