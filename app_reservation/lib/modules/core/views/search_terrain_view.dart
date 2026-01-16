// TODO: Implement search_terrain_view.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/search_terrain_controller.dart';

class SearchTerrainView extends GetView<SearchTerrainController> {
  const SearchTerrainView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('Rechercher un terrain'),
        backgroundColor: const Color(0xFF4CAF50),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: const Center(
        child: Text(
          'Page de recherche\nEn développement',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey,
          ),
        ),
      ),
    );
  }
}