import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MainController extends GetxController {
  // ==================== VARIABLES RÉACTIVES ====================
  
  final currentIndex = 0.obs;

  // ==================== NAVIGATION ====================
  
  void changeIndex(int index) {
    currentIndex.value = index;
  }

  // ==================== ACTIONS RAPIDES ====================
  
  void quickReservation() {
    // Afficher bottom sheet avec options
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Type de réservation',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
            _buildQuickOption(
              icon: Icons.person,
              title: 'Réservation individuelle',
              color: const Color(0xFF4CAF50),
              onTap: () {
                Get.back();
                _reserveIndividual();
              },
            ),
            const SizedBox(height: 12),
            _buildQuickOption(
              icon: Icons.group,
              title: 'Réservation pour groupe',
              color: const Color(0xFF2196F3),
              onTap: () {
                Get.back();
                _reserveGroup();
              },
            ),
            const SizedBox(height: 12),
            _buildQuickOption(
              icon: Icons.business,
              title: 'Réservation organisation',
              color: const Color(0xFFFF9800),
              onTap: () {
                Get.back();
                _reserveOrganization();
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickOption({
    required IconData icon,
    required String title,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: Colors.white, size: 24),
            ),
            const SizedBox(width: 16),
            Text(
              title,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _reserveIndividual() {
    // TODO: Navigation vers réservation individuelle
    Get.snackbar(
      'Réservation individuelle',
      'Fonctionnalité en développement',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void _reserveGroup() {
    // TODO: Navigation vers réservation groupe
    Get.snackbar(
      'Réservation groupe',
      'Fonctionnalité en développement',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void _reserveOrganization() {
    // TODO: Navigation vers réservation organisation
    Get.snackbar(
      'Réservation organisation',
      'Fonctionnalité en développement',
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}