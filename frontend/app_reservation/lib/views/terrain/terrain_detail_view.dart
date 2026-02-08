// lib/views/terrain/terrain_detail_view.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/terrain_detail_controller.dart';

class TerrainDetailView extends StatelessWidget {
  const TerrainDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    final terrainId = int.parse(Get.parameters['id']!);
    final controller = Get.put(TerrainDetailController(terrainId: terrainId));

    return Scaffold(
      appBar: AppBar(
        title: Obx(() => Text(controller.terrain.value['nom'] ?? 'Terrain')),
        actions: [
          IconButton(
            onPressed: () => Get.offAllNamed('/home'),
            icon: const Icon(Icons.home),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final terrain = controller.terrain.value;
        final creneaux = controller.creneaux;

        return Column(
          children: [
            // Image + info
            if (terrain['image_url'] != null)
              Image.network(
                terrain['image_url'],
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  height: 200,
                  color: Colors.grey[300],
                  child: const Icon(Icons.image, size: 60),
                ),
              ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    terrain['adresse'] ?? '',
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber),
                      Text(
                        '${terrain['note_moyenne']?.toStringAsFixed(1) ?? '0.0'}/5',
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Sélecteur de date
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  const Text('Disponible le : '),
                  TextButton(
                    onPressed: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: controller.selectedDate.value,
                        firstDate: DateTime.now(),
                        lastDate: DateTime(DateTime.now().year + 1),
                      );
                      if (picked != null) {
                        controller.changeDate(picked);
                      }
                    },
                    child: Obx(
                      () => Text(
                        '${controller.selectedDate.value.day}/${controller.selectedDate.value.month}/${controller.selectedDate.value.year}',
                        style: const TextStyle(color: Colors.blue),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Liste des créneaux
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Créneaux disponibles',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: creneaux.isEmpty
                  ? const Center(
                      child: Text('Aucun créneau disponible pour cette date.'),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: creneaux.length,
                      itemBuilder: (context, index) {
                        final c = creneaux[index];
                        if (!c['disponible'])
                          return const SizedBox(); // Ne pas afficher les indisponibles

                        return Card(
                          margin: const EdgeInsets.only(bottom: 8),
                          child: ListTile(
                            title: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('${c['date']}'),
                                const SizedBox(width: 16),
                                Text('${c['heure_debut']} – ${c['heure_fin']}'),
                              ],
                            ),
                            subtitle: Text('${c['tarif']} MRU'),
                            trailing: ElevatedButton(
                              onPressed: () =>
                                  controller.reserveCreneau(c['id']),
                              child: const Text('Réserver'),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        );
      }),
    );
  }
}
