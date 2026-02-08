// lib/views/terrain/terrain_list_view.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/terrain_controller.dart';

class TerrainListView extends StatelessWidget {
  const TerrainListView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(TerrainController());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Terrains de foot'),
        actions: [
          // Toggle vue
          Obx(
            () => IconButton(
              icon: Icon(
                controller.viewMode.value == 'list' ? Icons.map : Icons.list,
              ),
              onPressed: () {
                if (controller.viewMode.value == 'list') {
                  Get.toNamed('/map');
                } else {
                  controller.toggleViewMode(); // ou retour à la liste
                }
              },
            ),
          ),
          IconButton(
            onPressed: () => Get.offAllNamed('/home'),
            icon: const Icon(Icons.home),
          ),
        ],
      ),
      body: Column(
        children: [
          // Barre de contrôle
          Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Sélecteur de date
                Expanded(
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
                const SizedBox(width: 12),
                // Bouton "Près de moi"
                Obx(
                  () => ElevatedButton.icon(
                    onPressed: controller.isLoadingLocation.value
                        ? null
                        : controller.getCurrentLocation,
                    icon: controller.isLoadingLocation.value
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.my_location, size: 16),
                    label: const Text('Près de moi'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Liste ou Cartes
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              if (controller.terrains.isEmpty) {
                return const Center(child: Text('Aucun terrain disponible.'));
              }

              final footTerrains = controller.terrains
                  .where(
                    (t) => true,
                  ) // ⚽ Tous les terrains sont de foot (pas de champ "sport")
                  .toList();

              if (controller.viewMode.value == 'list') {
                return ListView.builder(
                  itemCount: footTerrains.length,
                  itemBuilder: (context, index) {
                    final terrain = footTerrains[index];
                    return _buildListTile(terrain);
                  },
                );
              } else {
                return GridView.builder(
                  padding: const EdgeInsets.all(16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 0.8,
                  ),
                  itemCount: footTerrains.length,
                  itemBuilder: (context, index) {
                    final terrain = footTerrains[index];
                    return _buildCard(terrain);
                  },
                );
              }
            }),
          ),
        ],
      ),
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
          if (index == 0) {
            Get.offAllNamed('/home');
          } else if (index == 2) {
            Get.toNamed('/my-reservations');
          }
        },
      ),
    );
  }

  // Mode LISTE
  Widget _buildListTile(dynamic terrain) {
    final note = (terrain['note_moyenne'] as num?)?.toDouble();
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ListTile(
        contentPadding: const EdgeInsets.all(8),
        leading: terrain['image_url'] != null
            ? ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  terrain['image_url'],
                  width: 60,
                  height: 60,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      const Icon(Icons.image, size: 60),
                ),
              )
            : const Icon(Icons.sports_soccer, size: 60),
        title: Text(terrain['nom']),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(terrain['adresse']),
            if (terrain.containsKey('distance') && terrain['distance'] != null)
              Text(
                'À ${terrain['distance'].toStringAsFixed(1)} km',
                style: const TextStyle(color: Colors.green),
              ),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.star, size: 16, color: Colors.amber),
                Text(
                  '${note?.toStringAsFixed(1) ?? '0.0'}/5',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ],
        ),
        trailing: ElevatedButton(
          onPressed: () => Get.toNamed('/terrain/${terrain['id']}'),
          child: const Text('Voir'),
        ),
      ),
    );
  }

  // Mode CARTE (comme dans votre template)
  Widget _buildCard(dynamic terrain) {
    final note = (terrain['note_moyenne'] as num?)?.toDouble();
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: Image.network(
              terrain['image_url'] ??
                  'https://images.unsplash.com/photo-1546519638-68e109498ffc?auto=format&fit=crop&w=800&q=60',
              height: 120,
              width: double.infinity,
              fit: BoxFit.cover,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Container(
                  height: 120,
                  color: Colors.grey[200],
                  child: const Center(child: CircularProgressIndicator()),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Badge "Football"
                const SizedBox(height: 8),
                Text(
                  terrain['nom'],
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.star, size: 14, color: Colors.amber),
                    Text(
                      '${note?.toStringAsFixed(1) ?? '0.0'}/5',
                      style: const TextStyle(fontSize: 14),
                    ),
                    const Spacer(),
                    Text(
                      '${terrain['creneaux']?.first['tarif'] ?? 'N/A'} MRU/H',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Get.toNamed('/terrain/${terrain['id']}'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4f46e5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('Réserver'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
