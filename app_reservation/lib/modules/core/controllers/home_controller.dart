import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/services/auth_service.dart';
import '../../../data/services/storage_service.dart';
import '../../../routes/app_routes.dart';

class HomeController extends GetxController {
  final AuthService _authService = Get.find<AuthService>();
  final StorageService _storageService = Get.find<StorageService>();

  // ==================== VARIABLES RÉACTIVES ====================
  
  // Informations utilisateur
  final userId = 0.obs;
  final telephone = ''.obs;
  final userName = 'Utilisateur'.obs;
  
  // Loading states
  final isLoadingReservations = false.obs;
  final isLoadingTerrains = false.obs;
  
  // Données
  final upcomingReservations = <Map<String, dynamic>>[].obs;
  final recommendedTerrains = <Map<String, dynamic>>[].obs;

  // ==================== LIFECYCLE ====================

  @override
  void onInit() {
    super.onInit();
    _loadUserData();
    _loadReservations();
    _loadRecommendedTerrains();
  }

  // ==================== LOAD USER DATA ====================

  Future<void> _loadUserData() async {
    try {
      // Récupérer les données depuis le storage
      final userIdValue = await _authService.getCurrentUserId();
      final telephoneValue = await _authService.getCurrentUserTelephone();
      
      userId.value = userIdValue ?? 0;
      telephone.value = telephoneValue ?? '';
      
      // Extraire le prénom du téléphone (ou utiliser firstName si disponible)
      // Pour l'instant, on utilise juste "Utilisateur" ou le premier chiffre
      userName.value = telephoneValue != null && telephoneValue.isNotEmpty
          ? 'User ${telephoneValue.substring(0, 2)}'
          : 'Utilisateur';
      
      print('✅ Données utilisateur chargées: ID=$userIdValue');
    } catch (e) {
      print('❌ Erreur chargement données utilisateur: $e');
    }
  }

  // ==================== LOAD RESERVATIONS ====================

  Future<void> _loadReservations() async {
    try {
      isLoadingReservations.value = true;
      
      // TODO: Appeler l'API pour récupérer les réservations
      // Pour l'instant, données de test
      await Future.delayed(const Duration(seconds: 1));
      
      upcomingReservations.value = [
        {
          'id': 1,
          'terrain_name': 'Stade Municipal',
          'date': '05 Jan 2025',
          'time': '14:00 - 16:00',
          'status': 'confirmed',
        },
        {
          'id': 2,
          'terrain_name': 'Terrain Ksar',
          'date': '08 Jan 2025',
          'time': '18:00 - 20:00',
          'status': 'pending',
        },
      ];
    } catch (e) {
      print('❌ Erreur chargement réservations: $e');
      upcomingReservations.value = [];
    } finally {
      isLoadingReservations.value = false;
    }
  }

  // ==================== LOAD RECOMMENDED TERRAINS ====================

  Future<void> _loadRecommendedTerrains() async {
    try {
      isLoadingTerrains.value = true;
      
      // TODO: Appeler l'API pour récupérer les terrains recommandés
      // Pour l'instant, données de test
      await Future.delayed(const Duration(seconds: 1));
      
      recommendedTerrains.value = [
        {
          'id': 1,
          'name': 'Stade Olympique',
          'location': 'Avenue Gamal Abdel Nasser, Nouakchott',
          'distance': '1.2',
          'rating': 4.8,
          'reviews': 142,
          'price': 5000,
          'image': null,
        },
        {
          'id': 2,
          'name': 'Terrain Ksar',
          'location': 'Ksar, Nouakchott',
          'distance': '3.5',
          'rating': 4.2,
          'reviews': 89,
          'price': 4500,
          'image': null,
        },
        {
          'id': 3,
          'name': 'Complexe Sportif Arafat',
          'location': 'Arafat, Nouakchott',
          'distance': '5.1',
          'rating': 4.6,
          'reviews': 156,
          'price': 6000,
          'image': null,
        },
      ];
    } catch (e) {
      print('❌ Erreur chargement terrains: $e');
      recommendedTerrains.value = [];
    } finally {
      isLoadingTerrains.value = false;
    }
  }

  // ==================== REFRESH DATA ====================

  Future<void> refreshData() async {
    await Future.wait([
      _loadUserData(),
      _loadReservations(),
      _loadRecommendedTerrains(),
    ]);
  }

  // ==================== FILTRES RAPIDES ====================

  void filterNearby() {
    print('📍 Filtrer par proximité');
    // TODO: Implémenter filtrage par proximité
    Get.toNamed(AppRoutes.SEARCH_TERRAIN, arguments: {'filter': 'nearby'});
  }

  void filterAvailableNow() {
    print('⚡ Filtrer disponibles maintenant');
    // TODO: Implémenter filtrage disponibilité
    Get.toNamed(AppRoutes.SEARCH_TERRAIN, arguments: {'filter': 'available'});
  }

  void openFilters() {
    print('🎯 Ouvrir filtres avancés');
    // TODO: Ouvrir modal de filtres
    Get.snackbar(
      'Filtres',
      'Filtres avancés en développement',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void toggleFavorite(int terrainId) {
    print('❤️ Toggle favori: $terrainId');
    // TODO: Ajouter/retirer des favoris
    Get.snackbar(
      'Favoris',
      'Fonctionnalité en développement',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  // ==================== ACTIONS RAPIDES ====================

  void reserveIndividual() {
    print('📝 Réservation individuelle');
    // TODO: Navigation vers page réservation individuelle
    Get.toNamed(AppRoutes.RESERVATION, arguments: {'type': 'individual'});
  }

  void reserveGroup() {
    print('📝 Réservation groupe');
    // TODO: Navigation vers page réservation groupe
    Get.toNamed(AppRoutes.RESERVATION, arguments: {'type': 'group'});
  }

  void reserveOrganization() {
    print('📝 Réservation organisation');
    // TODO: Navigation vers page réservation organisation
    Get.toNamed(AppRoutes.RESERVATION, arguments: {'type': 'organization'});
  }

  void evaluateTerrain() {
    print('⭐ Évaluer terrain');
    // TODO: Navigation vers page évaluation
    Get.toNamed(AppRoutes.EVALUATION);
  }

  // ==================== NAVIGATION VERS AUTRES PAGES ====================

  void goToSearch() {
    print('🔍 Navigation vers Recherche');
    Get.toNamed(AppRoutes.SEARCH_TERRAIN);
  }

  void goToNotifications() {
    print('🔔 Navigation vers Notifications');
    Get.toNamed(AppRoutes.NOTIFICATIONS);
  }

  void goToProfile() {
    print('👤 Navigation vers Profil');
    Get.toNamed(AppRoutes.PROFILE);
  }

  void seeAllReservations() {
    print('📅 Voir toutes les réservations');
    Get.toNamed(AppRoutes.MES_RESERVATIONS);
  }

  void seeAllTerrains() {
    print('🏟️ Voir tous les terrains');
    goToSearch();
  }

  void goToTerrainDetails(int terrainId) {
    print('🏟️ Détails terrain: $terrainId');
    Get.toNamed(
      AppRoutes.TERRAIN_DETAILS,
      arguments: {'terrain_id': terrainId},
    );
  }

  // ==================== LOGOUT ====================

  Future<void> logout() async {
    try {
      // Confirmer la déconnexion
      final confirm = await Get.dialog<bool>(
        AlertDialog(
          title: const Text('Déconnexion'),
          content: const Text('Voulez-vous vraiment vous déconnecter ?'),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          actions: [
            TextButton(
              onPressed: () => Get.back(result: false),
              child: const Text('Annuler'),
            ),
            ElevatedButton(
              onPressed: () => Get.back(result: true),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Déconnexion'),
            ),
          ],
        ),
      );

      if (confirm != true) return;

      // Déconnexion
      await _authService.logout();

      // Redirection vers LOGIN
      Get.offAllNamed(AppRoutes.LOGIN);

      // Message
      Get.snackbar(
        'Déconnexion',
        'Vous avez été déconnecté avec succès',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFF4CAF50),
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );
    } catch (e) {
      print('❌ Erreur déconnexion: $e');
      
      Get.snackbar(
        'Erreur',
        'Une erreur est survenue lors de la déconnexion',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
}











// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import '../../../data/services/auth_service.dart';
// import '../../../data/services/storage_service.dart';
// import '../../../routes/app_routes.dart';

// class HomeController extends GetxController {
//   final AuthService _authService = Get.find<AuthService>();
//   final StorageService _storageService = Get.find<StorageService>();

//   // ==================== VARIABLES RÉACTIVES ====================
  
//   // Informations utilisateur
//   final userId = 0.obs;
//   final telephone = ''.obs;
//   final userName = 'Utilisateur'.obs;
  
//   // Loading states
//   final isLoadingReservations = false.obs;
//   final isLoadingTerrains = false.obs;
  
//   // Données
//   final upcomingReservations = <Map<String, dynamic>>[].obs;
//   final recommendedTerrains = <Map<String, dynamic>>[].obs;

//   // ==================== LIFECYCLE ====================

//   @override
//   void onInit() {
//     super.onInit();
//     _loadUserData();
//     _loadReservations();
//     _loadRecommendedTerrains();
//   }

//   // ==================== LOAD USER DATA ====================

//   Future<void> _loadUserData() async {
//     try {
//       // Récupérer les données depuis le storage
//       final userIdValue = await _authService.getCurrentUserId();
//       final telephoneValue = await _authService.getCurrentUserTelephone();
      
//       userId.value = userIdValue ?? 0;
//       telephone.value = telephoneValue ?? '';
      
//       // Extraire le prénom du téléphone (ou utiliser firstName si disponible)
//       // Pour l'instant, on utilise juste "Utilisateur" ou le premier chiffre
//       userName.value = telephoneValue != null && telephoneValue.isNotEmpty
//           ? 'User ${telephoneValue.substring(0, 2)}'
//           : 'Utilisateur';
      
//       print('✅ Données utilisateur chargées: ID=$userIdValue');
//     } catch (e) {
//       print('❌ Erreur chargement données utilisateur: $e');
//     }
//   }

//   // ==================== LOAD RESERVATIONS ====================

//   Future<void> _loadReservations() async {
//     try {
//       isLoadingReservations.value = true;
      
//       // TODO: Appeler l'API pour récupérer les réservations
//       // Pour l'instant, données de test
//       await Future.delayed(const Duration(seconds: 1));
      
//       upcomingReservations.value = [
//         {
//           'id': 1,
//           'terrain_name': 'Stade Municipal',
//           'date': '05 Jan 2025',
//           'time': '14:00 - 16:00',
//           'status': 'confirmed',
//         },
//         {
//           'id': 2,
//           'terrain_name': 'Terrain Ksar',
//           'date': '08 Jan 2025',
//           'time': '18:00 - 20:00',
//           'status': 'pending',
//         },
//       ];
//     } catch (e) {
//       print('❌ Erreur chargement réservations: $e');
//       upcomingReservations.value = [];
//     } finally {
//       isLoadingReservations.value = false;
//     }
//   }

//   // ==================== LOAD RECOMMENDED TERRAINS ====================

//   Future<void> _loadRecommendedTerrains() async {
//     try {
//       isLoadingTerrains.value = true;
      
//       // TODO: Appeler l'API pour récupérer les terrains recommandés
//       // Pour l'instant, données de test
//       await Future.delayed(const Duration(seconds: 1));
      
//       recommendedTerrains.value = [
//         {
//           'id': 1,
//           'name': 'Stade Municipal',
//           'location': 'Tevragh Zeina, Nouakchott',
//           'rating': 4.5,
//           'price': 5000,
//           'image': null,
//         },
//         {
//           'id': 2,
//           'name': 'Terrain Ksar',
//           'location': 'Ksar, Nouakchott',
//           'rating': 4.2,
//           'price': 4500,
//           'image': null,
//         },
//         {
//           'id': 3,
//           'name': 'Complexe Sportif',
//           'location': 'Arafat, Nouakchott',
//           'rating': 4.8,
//           'price': 6000,
//           'image': null,
//         },
//       ];
//     } catch (e) {
//       print('❌ Erreur chargement terrains: $e');
//       recommendedTerrains.value = [];
//     } finally {
//       isLoadingTerrains.value = false;
//     }
//   }

//   // ==================== REFRESH DATA ====================

//   Future<void> refreshData() async {
//     await Future.wait([
//       _loadUserData(),
//       _loadReservations(),
//       _loadRecommendedTerrains(),
//     ]);
//   }

//   // ==================== ACTIONS RAPIDES ====================

//   void reserveIndividual() {
//     print('📝 Réservation individuelle');
//     // TODO: Navigation vers page réservation individuelle
//     Get.toNamed(AppRoutes.RESERVATION, arguments: {'type': 'individual'});
//   }

//   void reserveGroup() {
//     print('📝 Réservation groupe');
//     // TODO: Navigation vers page réservation groupe
//     Get.toNamed(AppRoutes.RESERVATION, arguments: {'type': 'group'});
//   }

//   void reserveOrganization() {
//     print('📝 Réservation organisation');
//     // TODO: Navigation vers page réservation organisation
//     Get.toNamed(AppRoutes.RESERVATION, arguments: {'type': 'organization'});
//   }

//   void evaluateTerrain() {
//     print('⭐ Évaluer terrain');
//     // TODO: Navigation vers page évaluation
//     Get.toNamed(AppRoutes.EVALUATION);
//   }

//   // ==================== NAVIGATION VERS AUTRES PAGES ====================

//   void goToSearch() {
//     print('🔍 Navigation vers Recherche');
//     Get.toNamed(AppRoutes.SEARCH_TERRAIN);
//   }

//   void goToNotifications() {
//     print('🔔 Navigation vers Notifications');
//     Get.toNamed(AppRoutes.NOTIFICATIONS);
//   }

//   void goToProfile() {
//     print('👤 Navigation vers Profil');
//     Get.toNamed(AppRoutes.PROFILE);
//   }

//   void seeAllReservations() {
//     print('📅 Voir toutes les réservations');
//     Get.toNamed(AppRoutes.MES_RESERVATIONS);
//   }

//   void seeAllTerrains() {
//     print('🏟️ Voir tous les terrains');
//     goToSearch();
//   }

//   void goToTerrainDetails(int terrainId) {
//     print('🏟️ Détails terrain: $terrainId');
//     Get.toNamed(
//       AppRoutes.TERRAIN_DETAILS,
//       arguments: {'terrain_id': terrainId},
//     );
//   }

//   // ==================== LOGOUT ====================

//   Future<void> logout() async {
//     try {
//       // Confirmer la déconnexion
//       final confirm = await Get.dialog<bool>(
//         AlertDialog(
//           title: const Text('Déconnexion'),
//           content: const Text('Voulez-vous vraiment vous déconnecter ?'),
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(16),
//           ),
//           actions: [
//             TextButton(
//               onPressed: () => Get.back(result: false),
//               child: const Text('Annuler'),
//             ),
//             ElevatedButton(
//               onPressed: () => Get.back(result: true),
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.red,
//                 foregroundColor: Colors.white,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//               ),
//               child: const Text('Déconnexion'),
//             ),
//           ],
//         ),
//       );

//       if (confirm != true) return;

//       // Déconnexion
//       await _authService.logout();

//       // Redirection vers LOGIN
//       Get.offAllNamed(AppRoutes.LOGIN);

//       // Message
//       Get.snackbar(
//         'Déconnexion',
//         'Vous avez été déconnecté avec succès',
//         snackPosition: SnackPosition.BOTTOM,
//         backgroundColor: const Color(0xFF4CAF50),
//         colorText: Colors.white,
//         duration: const Duration(seconds: 2),
//       );
//     } catch (e) {
//       print('❌ Erreur déconnexion: $e');
      
//       Get.snackbar(
//         'Erreur',
//         'Une erreur est survenue lors de la déconnexion',
//         snackPosition: SnackPosition.BOTTOM,
//         backgroundColor: Colors.red,
//         colorText: Colors.white,
//       );
//     }
//   }
// }