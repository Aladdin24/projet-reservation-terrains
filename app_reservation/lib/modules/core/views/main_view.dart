import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/main_controller.dart';
import 'home_view.dart';
import 'search_terrain_view.dart';
import 'mes_reservations_view.dart';
import 'profile_view.dart';

class MainView extends GetView<MainController> {
  const MainView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
      body: IndexedStack(
        index: controller.currentIndex.value,
        children: const [
          HomeView(),
          SearchTerrainView(),
          MesReservationsView(),
          ProfileView(),
        ],
      ),
      
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: controller.currentIndex.value,
        onTap: controller.changeIndex,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFF4CAF50),
        unselectedItemColor: Colors.grey,
        selectedFontSize: 12,
        unselectedFontSize: 12,
        elevation: 8,
        backgroundColor: Colors.white,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Accueil',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search_outlined),
            activeIcon: Icon(Icons.search),
            label: 'Rechercher',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today_outlined),
            activeIcon: Icon(Icons.calendar_today),
            label: 'Réservations',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
      ),
      
      floatingActionButton: Obx(() => controller.currentIndex.value == 0
          ? FloatingActionButton(
              onPressed: controller.quickReservation,
              backgroundColor: const Color(0xFF4CAF50),
              child: const Icon(Icons.add, color: Colors.white, size: 28),
            )
          : const SizedBox.shrink()),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    ));
  }
}










// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import '../controllers/main_controller.dart';
// import 'home_view.dart';
// import 'search_terrain_view.dart';
// import 'mes_reservations_view.dart';
// import 'profile_view.dart';

// class MainView extends GetView<MainController> {
//   const MainView({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Obx(() => Scaffold(
//       body: IndexedStack(
//         index: controller.currentIndex.value,
//         children: const [
//           HomeView(),
//           SearchTerrainView(),
//           MesReservationsView(),
//           ProfileView(),
//         ],
//       ),
      
//       bottomNavigationBar: BottomNavigationBar(
//         currentIndex: controller.currentIndex.value,
//         onTap: controller.changeIndex,
//         type: BottomNavigationBarType.fixed,
//         selectedItemColor: const Color(0xFF4CAF50),
//         unselectedItemColor: Colors.grey,
//         selectedFontSize: 12,
//         unselectedFontSize: 12,
//         elevation: 8,
//         backgroundColor: Colors.white,
//         items: const [
//           BottomNavigationBarItem(
//             icon: Icon(Icons.home_outlined),
//             activeIcon: Icon(Icons.home),
//             label: 'Accueil',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.search_outlined),
//             activeIcon: Icon(Icons.search),
//             label: 'Rechercher',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.calendar_today_outlined),
//             activeIcon: Icon(Icons.calendar_today),
//             label: 'Réservations',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.person_outline),
//             activeIcon: Icon(Icons.person),
//             label: 'Profil',
//           ),
//         ],
//       ),
      
//       floatingActionButton: Obx(() => controller.currentIndex.value == 0
//           ? FloatingActionButton.extended(
//               onPressed: controller.quickReservation,
//               backgroundColor: const Color(0xFF4CAF50),
//               icon: const Icon(Icons.add, color: Colors.white),
//               label: const Text(
//                 'Réserver',
//                 style: TextStyle(
//                   color: Colors.white,
//                   fontWeight: FontWeight.w600,
//                 ),
//               ),
//             )
//           : const SizedBox.shrink()),
//       floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
//     ));
//   }
// }