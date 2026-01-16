import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'data/services/storage_service.dart';
import 'initial_bindings.dart';
import 'routes/app_pages.dart';
import 'routes/app_routes.dart';
import 'app_themes.dart';

void main() async {
  // Assurer que les bindings Flutter sont initialisés
  WidgetsFlutterBinding.ensureInitialized();

  // ==================== INITIALISATION DU STORAGE SERVICE ====================
  
  // Initialiser StorageService de manière asynchrone AVANT l'app
  // CRITIQUE: StorageService doit être initialisé avant le reste
  await Get.putAsync(() => StorageService().init(), permanent: true);
  
  print('✅ StorageService initialisé');
  
  // ==================== CONFIGURATION SYSTÈME ====================
  
  // Forcer l'orientation portrait uniquement
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  
  // Configuration de la barre de statut
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
    ),
  );

  print('✅ Configuration système appliquée');

  // Lancer l'application
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      // ==================== CONFIGURATION GÉNÉRALE ====================
      
      title: 'Réservation Terrains',
      debugShowCheckedModeBanner: false,
      
      // ==================== THÈME ====================
      
      theme: AppThemes.lightTheme,
      darkTheme: AppThemes.darkTheme,
      themeMode: ThemeMode.system, // Suit le thème système
      
      // ==================== BINDINGS ====================
      
      // Initialiser tous les services globaux au démarrage
      initialBinding: InitialBindings(),
      
      // ==================== ROUTING ====================
      
      // ✅ Route initiale: SPLASH
      // Le SplashController vérifie si l'utilisateur est connecté
      // et redirige vers HOME ou LOGIN automatiquement
      initialRoute: AppRoutes.SPLASH,
      getPages: AppPages.pages,
      
      // ==================== LOCALISATION ====================
      
      locale: const Locale('fr', 'FR'), // Français
      fallbackLocale: const Locale('fr', 'FR'),
      
      // ==================== CONFIGURATION GLOBALE ====================
      
      // Transitions par défaut
      defaultTransition: Transition.cupertino,
      transitionDuration: const Duration(milliseconds: 300),
      
      // Builder pour gérer les erreurs globales
      builder: (context, child) {
        // Désactiver le changement de taille de police système
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
          child: child!,
        );
      },
    );
  }
}



// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:get/get.dart';
// import 'data/services/storage_service.dart';
// import 'initial_bindings.dart';
// import 'routes/app_pages.dart';
// import 'routes/app_routes.dart';
// import 'app_themes.dart';

// void main() async {
//   // Assurer que les bindings Flutter sont initialisés
//   WidgetsFlutterBinding.ensureInitialized();

//   // ==================== INITIALISATION DU STORAGE SERVICE ====================
  
//   // Initialiser StorageService de manière asynchrone AVANT l'app
//   // Utilisation de putAsync pour gérer l'initialisation asynchrone
//   await Get.putAsync(() => StorageService().init(), permanent: true);
  
//   // ==================== CONFIGURATION SYSTÈME ====================
  
//   // Forcer l'orientation portrait uniquement
//   await SystemChrome.setPreferredOrientations([
//     DeviceOrientation.portraitUp,
//     DeviceOrientation.portraitDown,
//   ]);
  
//   // Configuration de la barre de statut
//   SystemChrome.setSystemUIOverlayStyle(
//     const SystemUiOverlayStyle(
//       statusBarColor: Colors.transparent,
//       statusBarIconBrightness: Brightness.dark,
//       statusBarBrightness: Brightness.light,
//     ),
//   );

//   // Lancer l'application
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return GetMaterialApp(
//       // ==================== CONFIGURATION GÉNÉRALE ====================
      
//       title: 'Réservation Terrains',
//       debugShowCheckedModeBanner: false,
      
//       // ==================== THÈME ====================
      
//       theme: AppThemes.lightTheme,
//       darkTheme: AppThemes.darkTheme,
//       themeMode: ThemeMode.system, // Suit le thème système
      
//       // ==================== BINDINGS ====================
      
//       // Initialiser tous les services globaux au démarrage
//       initialBinding: InitialBindings(),
      
//       // ==================== ROUTING ====================
      
//       // Route initiale - Sera déterminée par AuthMiddleware
//       initialRoute: AppRoutes.LOGIN,
//       getPages: AppPages.pages,
      
//       // ==================== LOCALISATION ====================
      
//       locale: const Locale('fr', 'FR'), // Français
//       fallbackLocale: const Locale('fr', 'FR'),
      
//       // ==================== CONFIGURATION GLOBALE ====================
      
//       // Transitions par défaut
//       defaultTransition: Transition.cupertino,
//       transitionDuration: const Duration(milliseconds: 300),
      
//       // Builder pour gérer les erreurs globales
//       builder: (context, child) {
//         // Désactiver le changement de taille de police système
//         return MediaQuery(
//           data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
//           child: child!,
//         );
//       },
//     );
//   }
// }