// lib/controllers/evaluation_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../services/api_service.dart';

class EvaluationController extends GetxController {
  final int terrainId;
  final String terrainNom;
  final TextEditingController commentaireController = TextEditingController();
  var selectedNote = 0.obs;
  var isLoading = false.obs;

  EvaluationController({required this.terrainId, required this.terrainNom});

  void selectNote(int note) {
    selectedNote.value = note;
  }

  Future<void> submitEvaluation() async {
    if (selectedNote.value == 0) {
      Get.snackbar('Erreur', 'Veuillez sélectionner une note.');
      return;
    }

    try {
      isLoading(true);
      await ApiService.submitEvaluation(
        terrainId: terrainId,
        note: selectedNote.value,
        commentaire: commentaireController.text.trim(),
      );

      Get.snackbar(
        'Succès',
        'Évaluation envoyée !',
        backgroundColor: Colors.green,
      );
      Get.back(); // Retour à la page précédente
    } catch (e) {
      // ⚡ Afficher l'alerte / snackbar plutôt que de rethrow
      Get.dialog(
        AlertDialog(
          title: const Text('Impossible d\'évaluer le terrain'),
          content: Text(e.toString()),
          actions: [
            TextButton(onPressed: () => Get.back(), child: const Text('OK')),
          ],
        ),
      );
    } finally {
      isLoading(false);
    }
  }
}
