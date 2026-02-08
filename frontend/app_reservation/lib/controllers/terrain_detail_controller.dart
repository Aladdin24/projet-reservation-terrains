// lib/controllers/terrain_detail_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../services/api_service.dart';

class TerrainDetailController extends GetxController {
  final int terrainId;
  late var terrain = {}.obs;
  var creneaux = <dynamic>[].obs;
  var isLoading = false.obs;
  var selectedDate = DateTime.now().obs;

  TerrainDetailController({required this.terrainId});

  @override
  void onInit() {
    fetchTerrain();
    super.onInit();
  }

  Future<void> fetchTerrain() async {
    try {
      isLoading(true);
      // On récupère le terrain (l'API filtre déjà par date si fournie)
      final data = await ApiService.getTerrains(
        date:
            '${selectedDate.value.year}-${selectedDate.value.month.toString().padLeft(2, '0')}-${selectedDate.value.day.toString().padLeft(2, '0')}',
      );
      final found = data.firstWhere(
        (t) => t['id'] == terrainId,
        orElse: () => {},
      );
      if (found.isEmpty) {
        Get.snackbar('Erreur', 'Terrain non trouvé');
        Get.back();
        return;
      }
      terrain.value = found;
      creneaux.assignAll(found['creneaux'] ?? []);
    } finally {
      isLoading(false);
    }
  }

  void changeDate(DateTime newDate) {
    selectedDate.value = newDate;
    fetchTerrain();
  }

  Future<void> reserveCreneau(int creneauId) async {
    final confirmed = await Get.dialog<bool>(
      AlertDialog(
        title: const Text('Confirmer la réservation'),
        content: const Text(
          'Voulez-vous vraiment réserver ce créneau ? '
          'Cette action est définitive.',
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () => Get.back(result: true),
            child: const Text('Confirmer'),
          ),
        ],
      ),
      barrierDismissible: false,
    );

    if (confirmed != true) return;

    try {
      // Référence de paiement simulée
      final reference = 'sim_${DateTime.now().millisecondsSinceEpoch}';

      Get.dialog(
        const Center(child: CircularProgressIndicator()),
        barrierDismissible: false,
      );

      await ApiService.createReservation(
        creneauId: creneauId,
        type: 'INDIVIDUELLE',
        methodePaiement: 'MOBILE',
        reference: reference,
      );

      Get.back(); // Ferme le loader

      Get.snackbar(
        'Succès',
        'Réservation confirmée 🎉',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

      Get.back(); // Retour écran précédent
    } catch (e) {
      if (Get.isDialogOpen ?? false) {
        Get.back();
      }

      Get.snackbar(
        'Erreur',
        'Impossible de réserver ce créneau.\n${e.toString()}',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
}
