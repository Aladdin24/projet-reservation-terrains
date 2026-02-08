// lib/controllers/reservation_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../services/api_service.dart';

class ReservationController extends GetxController {
  var reservations = <dynamic>[].obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    fetchReservations();
    super.onInit();
  }

  Future<void> fetchReservations() async {
    try {
      isLoading(true);
      final data = await ApiService.getMyReservations();
      reservations.assignAll(data);
    } finally {
      isLoading(false);
    }
  }

  Future<void> cancelReservation(int reservationId) async {
    try {
      // Appel à l'API backend
      await ApiService.cancelReservation(reservationId);

      // Recharger la liste après annulation
      fetchReservations();

      // Message de succès
      Get.snackbar(
        'Succès',
        'Réservation annulée avec succès.',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        'Erreur',
        e.toString(),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
}
