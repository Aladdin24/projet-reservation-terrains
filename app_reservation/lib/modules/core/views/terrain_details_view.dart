// TODO: Implement terrain_details_view.dart
// TODO: Implement mes_reservations_view.dart
import 'package:app_reservation/modules/core/controllers/terrain_details_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TerrainDetailsView extends GetView<TerrainDetailsController> {
  const TerrainDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('Mes Réservations'),
        backgroundColor: const Color(0xFF4CAF50),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: const Center(
        child: Text(
          'Page des réservations\nEn développement',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey,
          ),
        ),
      ),
    );
  }
}