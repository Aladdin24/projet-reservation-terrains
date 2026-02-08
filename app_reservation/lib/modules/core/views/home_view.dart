import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      
      // ==================== BODY ====================
      body: RefreshIndicator(
        onRefresh: controller.refreshData,
        color: const Color(0xFF4CAF50),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header avec recherche et chips
              _buildHeader(),
              
              const SizedBox(height: 24),
              
              // Mes réservations
              _buildMyReservations(),
              
              const SizedBox(height: 24),
              
              // Terrains recommandés
              _buildRecommendedTerrains(),
              
              const SizedBox(height: 100), // Espace pour BottomNav + FAB
            ],
          ),
        ),
      ),
    );
  }
  
  // ==================== HEADER =====================
  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 50, 20, 24),
      decoration: const BoxDecoration(
        color: Color(0xFF4CAF50),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Salutation + Photo
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Obx(() => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Bonjour,',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        controller.userName.value,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        '👋',
                        style: TextStyle(fontSize: 24),
                      ),
                    ],
                  ),
                ],
              )),
              GestureDetector(
                onTap: controller.goToProfile,
                child: const CircleAvatar(
                  radius: 24,
                  backgroundColor: Colors.white,
                  child: Icon(
                    Icons.person,
                    color: Color(0xFF4CAF50),
                    size: 28,
                  ),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 20),
          
          // Barre de recherche
          GestureDetector(
            onTap: controller.goToSearch,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Icon(Icons.search, color: Colors.grey[400], size: 22),
                  const SizedBox(width: 12),
                  Text(
                    'Rechercher un terrain...',
                    style: TextStyle(
                      color: Colors.grey[500],
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 16),
          
          // 3 Chips: Près de moi, Dispo maintenant, Filtres
          Row(
            children: [
              _buildChip(
                icon: Icons.location_on,
                label: 'Près de moi',
                onTap: controller.filterNearby,
              ),
              const SizedBox(width: 8),
              _buildChip(
                icon: Icons.flash_on,
                label: 'Dispo maintenant',
                onTap: controller.filterAvailableNow,
              ),
              const SizedBox(width: 8),
              _buildChip(
                icon: Icons.tune,
                label: 'Filtres',
                onTap: controller.openFilters,
              ),
            ],
          ),
        ],
      ),
    );
  }
  
  Widget _buildChip({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Colors.white.withOpacity(0.3),
              width: 1,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: Colors.white, size: 16),
              const SizedBox(width: 6),
              Flexible(
                child: Text(
                  label,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  // ==================== MES RÉSERVATIONS ====================
  Widget _buildMyReservations() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Mes réservations',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              TextButton(
                onPressed: controller.seeAllReservations,
                child: const Text(
                  'Tout voir',
                  style: TextStyle(
                    color: Color(0xFF4CAF50),
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        
        Obx(() {
          if (controller.isLoadingReservations.value) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: CircularProgressIndicator(
                  color: Color(0xFF4CAF50),
                ),
              ),
            );
          }
          
          if (controller.upcomingReservations.isEmpty) {
            return _buildEmptyReservations();
          }
          
          return SizedBox(
            height: 155,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: controller.upcomingReservations.length,
              itemBuilder: (context, index) {
                final reservation = controller.upcomingReservations[index];
                return _buildReservationCard(reservation);
              },
            ),
          );
        }),
      ],
    );
  }
  
  Widget _buildReservationCard(Map<String, dynamic> reservation) {
    return Container(
      width: 160,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image avec badge
          Stack(
            children: [
              Container(
                height: 80,
                decoration: BoxDecoration(
                  color: const Color(0xFF4CAF50).withOpacity(0.1),
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(16),
                  ),
                ),
                child: const Center(
                  child: Icon(
                    Icons.sports_soccer,
                    size: 32,
                    color: Color(0xFF4CAF50),
                  ),
                ),
              ),
              Positioned(
                top: 8,
                left: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFF4CAF50),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    'À venir',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
          
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  reservation['terrain_name'] ?? 'Terrain',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.calendar_today, size: 10, color: Colors.grey[600]),
                    const SizedBox(width: 4),
                    Text(
                      reservation['date'] ?? '',
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    Icon(Icons.access_time, size: 10, color: Colors.grey[600]),
                    const SizedBox(width: 4),
                    Text(
                      reservation['time'] ?? '',
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildEmptyReservations() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(
            Icons.calendar_today_outlined,
            size: 48,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 12),
          Text(
            'Aucune réservation',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Réservez un terrain pour commencer',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: controller.goToSearch,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF4CAF50),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text('Rechercher un terrain'),
          ),
        ],
      ),
    );
  }
  
  // ==================== TERRAINS RECOMMANDÉS ====================
  Widget _buildRecommendedTerrains() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Terrains recommandés',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              TextButton(
                onPressed: controller.seeAllTerrains,
                child: const Text(
                  'Voir plus',
                  style: TextStyle(
                    color: Color(0xFF4CAF50),
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        
        Obx(() {
          if (controller.isLoadingTerrains.value) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: CircularProgressIndicator(
                  color: Color(0xFF4CAF50),
                ),
              ),
            );
          }
          
          return ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: controller.recommendedTerrains.length,
            itemBuilder: (context, index) {
              final terrain = controller.recommendedTerrains[index];
              return _buildTerrainCard(terrain);
            },
          );
        }),
      ],
    );
  }
  
  Widget _buildTerrainCard(Map<String, dynamic> terrain) {
    return GestureDetector(
      onTap: () => controller.goToTerrainDetails(terrain['id']),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Grande image avec badges
            Stack(
              children: [
                Container(
                  height: 180,
                  decoration: BoxDecoration(
                    color: const Color(0xFF4CAF50).withOpacity(0.1),
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(16),
                    ),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.sports_soccer,
                      size: 60,
                      color: Color(0xFF4CAF50),
                    ),
                  ),
                ),
                
                // Badge "Disponible"
                Positioned(
                  top: 12,
                  left: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xFF4CAF50),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      'Disponible',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                
                // Icône favori
                Positioned(
                  top: 12,
                  right: 12,
                  child: GestureDetector(
                    onTap: () => controller.toggleFavorite(terrain['id']),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.favorite_border,
                        size: 20,
                        color: Colors.black54,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            
            // Informations
            Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Nom + icône partage
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          terrain['name'] ?? 'Terrain',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.blue.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.public,
                          size: 16,
                          color: Colors.blue,
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 8),
                  
                  // Description
                  Text(
                    'Terrain de football professionnel avec pelouse synthétique de haute qualité. Idéal pour les matchs et...',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                      height: 1.4,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  
                  const SizedBox(height: 10),
                  
                  // Distance + Adresse
                  Row(
                    children: [
                      Icon(Icons.location_on, size: 14, color: Colors.grey[600]),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          '${terrain['distance'] ?? '1.2'} km • ${terrain['location'] ?? 'Avenue Gamal Abdel Nasser, Nouakchott'}',
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey[600],
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 10),
                  
                  // Note + Prix
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.star, size: 16, color: Colors.amber),
                          const SizedBox(width: 4),
                          Text(
                            '${terrain['rating'] ?? '4.8'}',
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '(${terrain['reviews'] ?? '142'} avis)',
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                      Text(
                        '${terrain['price'] ?? '5000'} MRU/h',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF4CAF50),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

























// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import '../controllers/home_controller.dart';

// class HomeView extends GetView<HomeController> {
//   const HomeView({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey[50],
      
//       // ==================== APP BAR ====================
//       appBar: AppBar(
//         elevation: 0,
//         backgroundColor: const Color(0xFF4CAF50),
//         title: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text(
//               'Terrains MR',
//               style: TextStyle(
//                 color: Colors.white,
//                 fontSize: 20,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             Obx(() => Text(
//               'Bonjour, ${controller.userName.value}',
//               style: TextStyle(
//                 color: Colors.white.withOpacity(0.9),
//                 fontSize: 12,
//                 fontWeight: FontWeight.w400,
//               ),
//             )),
//           ],
//         ),
//         actions: [
//           // Notifications
//           IconButton(
//             icon: Stack(
//               children: [
//                 const Icon(Icons.notifications_outlined, color: Colors.white),
//                 Positioned(
//                   right: 0,
//                   top: 0,
//                   child: Container(
//                     width: 8,
//                     height: 8,
//                     decoration: const BoxDecoration(
//                       color: Colors.red,
//                       shape: BoxShape.circle,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//             onPressed: controller.goToNotifications,
//           ),
          
//           // Profil
//           IconButton(
//             icon: const CircleAvatar(
//               radius: 16,
//               backgroundColor: Colors.white,
//               child: Icon(Icons.person, color: Color(0xFF4CAF50), size: 20),
//             ),
//             onPressed: controller.goToProfile,
//           ),
//           const SizedBox(width: 8),
//         ],
//       ),
      
//       // ==================== BODY ====================
//       body: RefreshIndicator(
//         onRefresh: controller.refreshData,
//         color: const Color(0xFF4CAF50),
//         child: SingleChildScrollView(
//           physics: const AlwaysScrollableScrollPhysics(),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // Header avec recherche
//               _buildSearchHeader(),
              
//               const SizedBox(height: 24),
              
//               // Actions rapides
//               _buildQuickActions(),
              
//               const SizedBox(height: 24),
              
//               // Mes réservations
//               _buildMyReservations(),
              
//               const SizedBox(height: 24),
              
//               // Terrains recommandés
//               _buildRecommendedTerrains(),
              
//               const SizedBox(height: 80), // Espace pour le FAB de MainView
//             ],
//           ),
//         ),
//       ),
//     );
//   }
  
//   // ==================== SEARCH HEADER ====================
//   Widget _buildSearchHeader() {
//     return Container(
//       padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
//       decoration: const BoxDecoration(
//         color: Color(0xFF4CAF50),
//         borderRadius: BorderRadius.only(
//           bottomLeft: Radius.circular(32),
//           bottomRight: Radius.circular(32),
//         ),
//       ),
//       child: Column(
//         children: [
//           // Barre de recherche
//           GestureDetector(
//             onTap: controller.goToSearch,
//             child: Container(
//               padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(16),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.black.withOpacity(0.1),
//                     blurRadius: 10,
//                     offset: const Offset(0, 4),
//                   ),
//                 ],
//               ),
//               child: Row(
//                 children: [
//                   const Icon(Icons.search, color: Colors.grey),
//                   const SizedBox(width: 12),
//                   Text(
//                     'Rechercher un terrain...',
//                     style: TextStyle(
//                       color: Colors.grey[600],
//                       fontSize: 15,
//                     ),
//                   ),
//                   const Spacer(),
//                   Container(
//                     padding: const EdgeInsets.all(8),
//                     decoration: BoxDecoration(
//                       color: const Color(0xFF4CAF50).withOpacity(0.1),
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//                     child: const Icon(
//                       Icons.tune,
//                       color: Color(0xFF4CAF50),
//                       size: 20,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//           const SizedBox(height: 24),
//         ],
//       ),
//     );
//   }
  
//   // ==================== QUICK ACTIONS ====================
//   Widget _buildQuickActions() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 20),
//           child: Text(
//             'Actions rapides',
//             style: TextStyle(
//               fontSize: 18,
//               fontWeight: FontWeight.bold,
//               color: Colors.grey[800],
//             ),
//           ),
//         ),
//         const SizedBox(height: 16),
        
//         SizedBox(
//           height: 120,
//           child: ListView(
//             scrollDirection: Axis.horizontal,
//             padding: const EdgeInsets.symmetric(horizontal: 20),
//             children: [
//               _buildQuickActionCard(
//                 icon: Icons.person,
//                 title: 'Individuel',
//                 color: const Color(0xFF4CAF50),
//                 onTap: controller.reserveIndividual,
//               ),
//               _buildQuickActionCard(
//                 icon: Icons.group,
//                 title: 'Groupe',
//                 color: const Color(0xFF2196F3),
//                 onTap: controller.reserveGroup,
//               ),
//               _buildQuickActionCard(
//                 icon: Icons.business,
//                 title: 'Organisation',
//                 color: const Color(0xFFFF9800),
//                 onTap: controller.reserveOrganization,
//               ),
//               _buildQuickActionCard(
//                 icon: Icons.star,
//                 title: 'Évaluer',
//                 color: const Color(0xFFFFC107),
//                 onTap: controller.evaluateTerrain,
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
  
//   Widget _buildQuickActionCard({
//     required IconData icon,
//     required String title,
//     required Color color,
//     required VoidCallback onTap,
//   }) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         width: 100,
//         margin: const EdgeInsets.only(right: 12),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(16),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withOpacity(0.05),
//               blurRadius: 10,
//               offset: const Offset(0, 4),
//             ),
//           ],
//         ),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Container(
//               width: 50,
//               height: 50,
//               decoration: BoxDecoration(
//                 color: color.withOpacity(0.1),
//                 borderRadius: BorderRadius.circular(12),
//               ),
//               child: Icon(icon, color: color, size: 26),
//             ),
//             const SizedBox(height: 8),
//             Text(
//               title,
//               style: TextStyle(
//                 fontSize: 12,
//                 fontWeight: FontWeight.w600,
//                 color: Colors.grey[800],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
  
//   // ==================== MES RÉSERVATIONS ====================
//   Widget _buildMyReservations() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 20),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text(
//                 'Mes réservations',
//                 style: TextStyle(
//                   fontSize: 18,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.grey[800],
//                 ),
//               ),
//               TextButton(
//                 onPressed: controller.seeAllReservations,
//                 child: const Text(
//                   'Voir tout',
//                   style: TextStyle(
//                     color: Color(0xFF4CAF50),
//                     fontWeight: FontWeight.w600,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//         const SizedBox(height: 12),
        
//         Obx(() {
//           if (controller.isLoadingReservations.value) {
//             return const Center(
//               child: Padding(
//                 padding: EdgeInsets.all(20),
//                 child: CircularProgressIndicator(
//                   color: Color(0xFF4CAF50),
//                 ),
//               ),
//             );
//           }
          
//           if (controller.upcomingReservations.isEmpty) {
//             return _buildEmptyReservations();
//           }
          
//           return SizedBox(
//             height: 180,
//             child: ListView.builder(
//               scrollDirection: Axis.horizontal,
//               padding: const EdgeInsets.symmetric(horizontal: 20),
//               itemCount: controller.upcomingReservations.length,
//               itemBuilder: (context, index) {
//                 final reservation = controller.upcomingReservations[index];
//                 return _buildReservationCard(reservation);
//               },
//             ),
//           );
//         }),
//       ],
//     );
//   }
  
//   Widget _buildReservationCard(Map<String, dynamic> reservation) {
//     return Container(
//       width: 280,
//       margin: const EdgeInsets.only(right: 12),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.05),
//             blurRadius: 10,
//             offset: const Offset(0, 4),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // Image du terrain
//           Container(
//             height: 100,
//             decoration: BoxDecoration(
//               color: const Color(0xFF4CAF50).withOpacity(0.1),
//               borderRadius: const BorderRadius.only(
//                 topLeft: Radius.circular(16),
//                 topRight: Radius.circular(16),
//               ),
//             ),
//             child: const Center(
//               child: Icon(
//                 Icons.sports_soccer,
//                 size: 40,
//                 color: Color(0xFF4CAF50),
//               ),
//             ),
//           ),
          
//           Padding(
//             padding: const EdgeInsets.all(12),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   reservation['terrain_name'] ?? 'Terrain',
//                   style: const TextStyle(
//                     fontSize: 14,
//                     fontWeight: FontWeight.bold,
//                   ),
//                   maxLines: 1,
//                   overflow: TextOverflow.ellipsis,
//                 ),
//                 const SizedBox(height: 4),
//                 Row(
//                   children: [
//                     Icon(Icons.calendar_today, size: 12, color: Colors.grey[600]),
//                     const SizedBox(width: 4),
//                     Text(
//                       reservation['date'] ?? '',
//                       style: TextStyle(
//                         fontSize: 12,
//                         color: Colors.grey[600],
//                       ),
//                     ),
//                     const SizedBox(width: 12),
//                     Icon(Icons.access_time, size: 12, color: Colors.grey[600]),
//                     const SizedBox(width: 4),
//                     Text(
//                       reservation['time'] ?? '',
//                       style: TextStyle(
//                         fontSize: 12,
//                         color: Colors.grey[600],
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
  
//   Widget _buildEmptyReservations() {
//     return Container(
//       margin: const EdgeInsets.symmetric(horizontal: 20),
//       padding: const EdgeInsets.all(24),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.05),
//             blurRadius: 10,
//             offset: const Offset(0, 4),
//           ),
//         ],
//       ),
//       child: Column(
//         children: [
//           Icon(
//             Icons.calendar_today_outlined,
//             size: 48,
//             color: Colors.grey[400],
//           ),
//           const SizedBox(height: 12),
//           Text(
//             'Aucune réservation',
//             style: TextStyle(
//               fontSize: 16,
//               fontWeight: FontWeight.w600,
//               color: Colors.grey[700],
//             ),
//           ),
//           const SizedBox(height: 4),
//           Text(
//             'Réservez un terrain pour commencer',
//             style: TextStyle(
//               fontSize: 14,
//               color: Colors.grey[600],
//             ),
//           ),
//           const SizedBox(height: 16),
//           ElevatedButton(
//             onPressed: controller.goToSearch,
//             style: ElevatedButton.styleFrom(
//               backgroundColor: const Color(0xFF4CAF50),
//               foregroundColor: Colors.white,
//               padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(12),
//               ),
//             ),
//             child: const Text('Rechercher un terrain'),
//           ),
//         ],
//       ),
//     );
//   }
  
//   // ==================== TERRAINS RECOMMANDÉS ====================
//   Widget _buildRecommendedTerrains() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 20),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text(
//                 'Terrains recommandés',
//                 style: TextStyle(
//                   fontSize: 18,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.grey[800],
//                 ),
//               ),
//               TextButton(
//                 onPressed: controller.seeAllTerrains,
//                 child: const Text(
//                   'Voir tout',
//                   style: TextStyle(
//                     color: Color(0xFF4CAF50),
//                     fontWeight: FontWeight.w600,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//         const SizedBox(height: 12),
        
//         Obx(() {
//           if (controller.isLoadingTerrains.value) {
//             return const Center(
//               child: Padding(
//                 padding: EdgeInsets.all(20),
//                 child: CircularProgressIndicator(
//                   color: Color(0xFF4CAF50),
//                 ),
//               ),
//             );
//           }
          
//           return ListView.builder(
//             shrinkWrap: true,
//             physics: const NeverScrollableScrollPhysics(),
//             padding: const EdgeInsets.symmetric(horizontal: 20),
//             itemCount: controller.recommendedTerrains.length,
//             itemBuilder: (context, index) {
//               final terrain = controller.recommendedTerrains[index];
//               return _buildTerrainCard(terrain);
//             },
//           );
//         }),
//       ],
//     );
//   }
  
//   Widget _buildTerrainCard(Map<String, dynamic> terrain) {
//     return GestureDetector(
//       onTap: () => controller.goToTerrainDetails(terrain['id']),
//       child: Container(
//         margin: const EdgeInsets.only(bottom: 12),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(16),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withOpacity(0.05),
//               blurRadius: 10,
//               offset: const Offset(0, 4),
//             ),
//           ],
//         ),
//         child: Row(
//           children: [
//             // Image
//             Container(
//               width: 100,
//               height: 100,
//               decoration: BoxDecoration(
//                 color: const Color(0xFF4CAF50).withOpacity(0.1),
//                 borderRadius: const BorderRadius.only(
//                   topLeft: Radius.circular(16),
//                   bottomLeft: Radius.circular(16),
//                 ),
//               ),
//               child: const Icon(
//                 Icons.sports_soccer,
//                 size: 40,
//                 color: Color(0xFF4CAF50),
//               ),
//             ),
            
//             // Info
//             Expanded(
//               child: Padding(
//                 padding: const EdgeInsets.all(12),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       terrain['name'] ?? 'Terrain',
//                       style: const TextStyle(
//                         fontSize: 15,
//                         fontWeight: FontWeight.bold,
//                       ),
//                       maxLines: 1,
//                       overflow: TextOverflow.ellipsis,
//                     ),
//                     const SizedBox(height: 4),
//                     Row(
//                       children: [
//                         Icon(Icons.location_on, size: 14, color: Colors.grey[600]),
//                         const SizedBox(width: 4),
//                         Expanded(
//                           child: Text(
//                             terrain['location'] ?? '',
//                             style: TextStyle(
//                               fontSize: 12,
//                               color: Colors.grey[600],
//                             ),
//                             maxLines: 1,
//                             overflow: TextOverflow.ellipsis,
//                           ),
//                         ),
//                       ],
//                     ),
//                     const SizedBox(height: 8),
//                     Row(
//                       children: [
//                         const Icon(Icons.star, size: 14, color: Colors.amber),
//                         const SizedBox(width: 4),
//                         Text(
//                           terrain['rating']?.toString() ?? '0.0',
//                           style: const TextStyle(
//                             fontSize: 12,
//                             fontWeight: FontWeight.w600,
//                           ),
//                         ),
//                         const SizedBox(width: 12),
//                         Text(
//                           '${terrain['price']} MRU/h',
//                           style: const TextStyle(
//                             fontSize: 14,
//                             fontWeight: FontWeight.bold,
//                             color: Color(0xFF4CAF50),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }