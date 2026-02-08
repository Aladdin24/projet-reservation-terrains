// lib/main.dart
import 'package:app_reservation/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'app/routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ApiService.init(); // ← Ajoutez cette ligne
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Réservation Terrains',
      debugShowCheckedModeBanner: false,
      initialRoute: '/login',
      getPages: AppRoutes.routes,
      theme: ThemeData(
        primarySwatch: Colors.green,
        useMaterial3: true,
      ),
    );
  }
}