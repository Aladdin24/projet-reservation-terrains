import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/splash_controller.dart';

class SplashView extends GetView<SplashController> {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    // ✅ IMPORTANT: Forcer la création du controller
    print('📱 SplashView: build() appelé');
    print('📱 Récupération du controller...');
    final ctrl = controller;  // ✅ Accès au controller pour le créer
    print('📱 Controller récupéré: ${ctrl.runtimeType}');
    
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              const Color(0xFF66BB6A), // Vert clair
              const Color(0xFF4CAF50), // Vert principal
              const Color(0xFF388E3C), // Vert foncé
            ],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo animé
              TweenAnimationBuilder(
                duration: const Duration(milliseconds: 800),
                tween: Tween<double>(begin: 0.0, end: 1.0),
                builder: (context, double value, child) {
                  return Transform.scale(
                    scale: value,
                    child: Opacity(
                      opacity: value,
                      child: Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 30,
                              offset: const Offset(0, 15),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.sports_soccer,
                          size: 60,
                          color: Color(0xFF4CAF50),
                        ),
                      ),
                    ),
                  );
                },
              ),

              const SizedBox(height: 24),

              // Titre
              const Text(
                'Terrains MR',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                ),
              ),

              const SizedBox(height: 8),

              // Sous-titre
              Text(
                'Réservez votre terrain',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.9),
                  fontSize: 16,
                ),
              ),

              const SizedBox(height: 48),

              // Loading indicator
              const SizedBox(
                width: 50,
                height: 50,
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  strokeWidth: 3,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}