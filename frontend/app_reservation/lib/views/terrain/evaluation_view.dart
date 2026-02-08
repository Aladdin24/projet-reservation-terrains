// lib/views/terrain/evaluation_view.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/evaluation_controller.dart';

class EvaluationView extends StatelessWidget {
  const EvaluationView({super.key});

  @override
  Widget build(BuildContext context) {
    final terrainId = int.parse(Get.parameters['terrain_id']!);
    final terrainNom = Get.parameters['terrain_nom']!;
    final controller = Get.put(
      EvaluationController(terrainId: terrainId, terrainNom: terrainNom),
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Évaluer le terrain')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Terrain : $terrainNom',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 24),

            // Sélection de la note (étoiles)
            const Text(
              'Votre note :',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Obx(() {
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (index) {
                  final isFilled = index < controller.selectedNote.value;
                  return IconButton(
                    icon: Icon(
                      isFilled ? Icons.star : Icons.star_border,
                      color: Colors.amber,
                      size: 40,
                    ),
                    onPressed: () => controller.selectNote(index + 1),
                  );
                }),
              );
            }),
            const SizedBox(height: 24),

            // Commentaire
            const Text(
              'Commentaire (optionnel) :',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: controller.commentaireController,
              maxLines: 4,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Décrivez votre expérience...',
              ),
            ),
            const SizedBox(height: 24),

            // Bouton d'envoi
            Obx(() {
              return ElevatedButton(
                onPressed: controller.isLoading.value
                    ? null
                    : controller.submitEvaluation,
                child: controller.isLoading.value
                    ? const CircularProgressIndicator()
                    : const Text('Envoyer l\'évaluation'),
              );
            }),
          ],
        ),
      ),
    );
  }
}
