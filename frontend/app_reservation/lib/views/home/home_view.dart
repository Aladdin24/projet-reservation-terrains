// lib/views/home/home_view.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../controllers/terrain_controller.dart';
import '../../controllers/reservation_controller.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    // Contrôleurs
    final terrainController = Get.put(TerrainController());
    final reservationController = Get.put(ReservationController());

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'T-Foot',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 33, 183, 53),
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 2,
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () => Get.toNamed('/my-reservations'),
            color: Colors.grey[700],
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Hero Section
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color.fromARGB(255, 20, 220, 110),
                    Color.fromARGB(255, 17, 216, 34),
                  ],
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 60,
                  horizontal: 20,
                ),
                child: Column(
                  children: [
                    Text(
                      'Réserve ton terrain en 30 secondes',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Trouve le terrain de foot parfait près de chez toi !',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white.withOpacity(0.9),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),

            // Search Section (sans filtre sport)
            Padding(
              padding: const EdgeInsets.all(20),
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            'Trouver un terrain de foot',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey[800],
                            ),
                          ),
                          const SizedBox(width: 35),
                          // Bouton "Près de moi"
                          Obx(
                            () => ElevatedButton.icon(
                              onPressed:
                                  terrainController.isLoadingLocation.value
                                  ? null
                                  : terrainController.getCurrentLocation,
                              icon: terrainController.isLoadingLocation.value
                                  ? const SizedBox(
                                      width: 16,
                                      height: 16,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                      ),
                                    )
                                  : const Icon(Icons.my_location, size: 30),
                              label: const Text(''),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: const Color.fromARGB(
                                  255,
                                  36,
                                  208,
                                  20,
                                ),
                                side: const BorderSide(color: Colors.white),

                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          // Sélecteur de date
                          Expanded(
                            child: GestureDetector(
                              onTap: () async {
                                final picked = await showDatePicker(
                                  context: context,
                                  initialDate:
                                      terrainController.selectedDate.value,
                                  firstDate: DateTime.now(),
                                  lastDate: DateTime(DateTime.now().year + 1),
                                );
                                if (picked != null) {
                                  terrainController.changeDate(picked);
                                }
                              },
                              child: Container(
                                height: 56,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                ),
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey[400]!),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(Icons.calendar_today, size: 20),
                                    const SizedBox(width: 12),
                                    Obx(
                                      () => Text(
                                        DateFormat('dd/MM/yyyy').format(
                                          terrainController.selectedDate.value,
                                        ),
                                        style: const TextStyle(
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(width: 12),

                          // Bouton "Rechercher" (optionnel, car la date ou localisation déclenche déjà la recherche)
                          ElevatedButton(
                            onPressed: () {
                              // Optionnel : forcer un rafraîchissement
                              // terrainController.fetchTerrains();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color.fromARGB(
                                255,
                                17,
                                216,
                                34,
                              ),
                              minimumSize: const Size(120, 56),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text('Rechercher'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Terrains de foot
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Terrains de foot',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Obx(() {
                    if (terrainController.isLoading.value) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    final footTerrains = terrainController.terrains.toList();

                    return GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 16,
                            childAspectRatio: 0.8,
                          ),
                      itemCount: footTerrains.length,
                      itemBuilder: (context, index) {
                        final terrain = footTerrains[index];
                        return TerrainCard(
                          terrain: terrain,
                          onBook: () =>
                              Get.toNamed('/terrain/${terrain['id']}'),
                        );
                      },
                    );
                  }),
                ],
              ),
            ),

            // Mes réservations
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        'Mes réservations',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[800],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Obx(() {
                    if (reservationController.isLoading.value) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    final reservations = reservationController.reservations
                        .where(
                          (r) =>
                              r['statut'] == 'PAYEE' ||
                              r['statut'] == 'CONFIRMEE' ||
                              r['statut'] == 'EN_ATTENTE',
                        )
                        .toList();

                    if (reservations.isEmpty) {
                      return const Text("Aucune réservation à venir.");
                    }
                    // Afficher max 5 réservations
                    final displayedReservations = reservations.take(3).toList();

                    return Column(
                      children: [
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: displayedReservations.length,
                          itemBuilder: (context, index) {
                            final r = displayedReservations[index];
                            return ReservationCard(
                              reservation: r,
                              onCancel: () => reservationController
                                  .cancelReservation(r['id']),
                            );
                          },
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 12),
                          child: Center(
                            child: ElevatedButton(
                              onPressed: () => Get.toNamed('/my-reservations'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                foregroundColor: const Color.fromARGB(
                                  255,
                                  25,
                                  176,
                                  68,
                                ),
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  side: const BorderSide(
                                    color: Color.fromARGB(255, 65, 161, 92),
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: const Text('Voir toutes mes réservations'),
                            ),
                          ),
                        ),
                      ],
                    );
                  }),
                ],
              ),
            ),
          ],
        ),
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
        currentIndex: 0,
        onTap: (index) {
          if (index == 1) {
            Get.toNamed('/terrains');
          } else if (index == 2) {
            Get.toNamed('/my-reservations');
          }
        },
      ),
    );
  }
}

// --- Widgets réutilisables (inchangés) ---

class TerrainCard extends StatelessWidget {
  final dynamic terrain;
  final VoidCallback onBook;

  const TerrainCard({super.key, required this.terrain, required this.onBook});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: Image.network(
              terrain['image_url'] ?? const Icon(Icons.sports_soccer, size: 60),
              height: 100,
              width: double.infinity,
              fit: BoxFit.cover,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Center(child: Icon(Icons.sports_soccer, size: 60));
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  terrain['nom'] ?? 'Terrain',
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
                    const Icon(Icons.star, size: 16, color: Colors.amber),
                    Text(
                      ' ${terrain['note_moyenne']?.toStringAsFixed(1) ?? '0.0'}/5',
                      style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    ),
                    if (terrain.containsKey('distance'))
                      if (terrain['distance'] != null)
                        Text(
                          '  À ${terrain['distance'].toStringAsFixed(1)} km',
                          style: const TextStyle(color: Colors.green),
                        ),
                  ],
                ),
                const SizedBox(height: 5),
                // ✅ BOUTON RESPONSIVE
                SizedBox(
                  width: double.infinity,
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(
                      maxWidth: 160,
                      maxHeight: 30,
                    ),
                    child: ElevatedButton(
                      onPressed: onBook,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 17, 218, 81),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(
                          vertical: 8,
                          horizontal: 12,
                        ),
                        textStyle: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      child: const Text('Réserver'),
                    ),
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

class ReservationCard extends StatelessWidget {
  final dynamic reservation;
  final VoidCallback onCancel;

  const ReservationCard({
    super.key,
    required this.reservation,
    required this.onCancel,
  });

  // Helper pour obtenir le label et la couleur du statut
  Map<String, dynamic> _getStatusInfo(String? statut) {
    switch (statut) {
      case 'PAYEE':
        return {'label': 'Confirmée', 'color': Colors.green};
      case 'CONFIRMEE':
        return {'label': 'Confirmée', 'color': Colors.blue};
      case 'EN_ATTENTE':
        return {'label': 'En attente', 'color': Colors.orange};
      case 'ANNULEE':
      case 'REMBOURSEE':
        return {'label': 'Annulée', 'color': Colors.red};
      default:
        return {'label': 'Inconnu', 'color': Colors.grey};
    }
  }

  @override
  Widget build(BuildContext context) {
    final statutInfo = _getStatusInfo(reservation['statut']);
    final terrainNom = reservation['terrain_nom'] ?? 'Terrain';
    final dateStr = reservation['date_reservation'];
    final heureDebut = reservation['heure_debut'];
    final heureFin = reservation['heure_fin'];

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // En-tête avec nom du terrain et statut
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    terrainNom,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      overflow: TextOverflow.ellipsis,
                    ),
                    maxLines: 1,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: statutInfo['color'].withOpacity(0.15),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: statutInfo['color'], width: 1),
                  ),
                  child: Text(
                    statutInfo['label'],
                    style: TextStyle(
                      color: statutInfo['color'],
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Détails : date + prix
            Row(
              children: [
                const Icon(Icons.calendar_today, size: 90, color: Colors.green),
                const SizedBox(width: 6),
                Column(
                  children: [
                    Text(
                      dateStr,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      '$heureDebut - $heureFin',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                Text(
                  '${reservation['prix_total']} MRU',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.green,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
