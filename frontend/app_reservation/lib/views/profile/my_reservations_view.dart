// lib/views/profile/my_reservations_view.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/reservation_controller.dart';

class MyReservationsView extends StatelessWidget {
  const MyReservationsView({super.key});

  String _getStatusLabel(String statut) {
    switch (statut) {
      case 'PAYEE':
        return 'Payée';
      case 'CONFIRMEE':
        return 'Confirmée';
      case 'ANNULEE':
      case 'REMBOURSEE':
        return 'Annulée';
      case 'EN_ATTENTE':
        return 'En attente';
      default:
        return statut;
    }
  }

  Color _getStatusColor(String statut) {
    switch (statut) {
      case 'PAYEE':
        return Colors.green;
      case 'CONFIRMEE':
        return Colors.blue;
      case 'ANNULEE':
      case 'REMBOURSEE':
        return Colors.red;
      case 'EN_ATTENTE':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ReservationController());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mes réservations'),
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

        if (controller.reservations.isEmpty) {
          return const Center(child: Text('Vous n’avez aucune réservation.'));
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: controller.reservations.length,
          itemBuilder: (context, index) {
            final r = controller.reservations[index];
            final isCancelable =
                r['statut'] == 'PAYEE' ||
                r['statut'] == 'EN_ATTENTE' ||
                r['statut'] == 'CONFIRMEE';

            final reservationDate = DateTime.parse(
              '${r['date_reservation']}T${r['heure_fin']}',
            );
            final now = DateTime.now();
            final isPast = reservationDate.isBefore(now);
            final isPayee = r['statut'] == 'PAYEE';
            final isEvaluable = isPast && isPayee;

            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          r['terrain_nom'],
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: _getStatusColor(
                              r['statut'],
                            ).withOpacity(0.2),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            _getStatusLabel(r['statut']),
                            style: TextStyle(
                              color: _getStatusColor(r['statut']),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text('📅 ${r['date_reservation']}'),
                    Text('⏰ ${r['heure_debut']} – ${r['heure_fin']}'),
                    Text('💰 ${r['prix_total']} €'),
                    const SizedBox(height: 12),
                    if (isCancelable)
                      Row(
                        children: [
                          ElevatedButton.icon(
                            onPressed: () {
                              Get.defaultDialog(
                                title: "Annuler la réservation",
                                content: const Text(
                                  "Êtes-vous sûr de vouloir annuler cette réservation ?",
                                ),
                                confirm: ElevatedButton(
                                  onPressed: () {
                                    controller.cancelReservation(r['id']);
                                    Get.back(); // Ferme la dialog
                                  },
                                  child: const Text("Oui, annuler"),
                                ),
                                cancel: TextButton(
                                  onPressed: () => Get.back(),
                                  child: const Text("Non"),
                                ),
                              );
                            },
                            icon: const Icon(Icons.cancel, size: 16),
                            label: const Text("Annuler"),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.redAccent,
                            ),
                          ),
                        ],
                      ),
                    if (isEvaluable)
                      ElevatedButton.icon(
                        onPressed: () {
                          Get.toNamed(
                            '/evaluate',
                            parameters: {
                              'terrain_id': r['terrain_id']
                                  .toString(), // ⚠️ ATTENTION : ce n'est pas l'ID du terrain !
                              'terrain_nom': r['terrain_nom'],
                            },
                          );
                        },
                        icon: const Icon(Icons.rate_review, size: 16),
                        label: const Text("Évaluer"),
                      ),
                  ],
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
