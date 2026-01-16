import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../controllers/login_controller.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
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
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // ==================== LOGO ====================
                  _buildLogo(),

                  const SizedBox(height: 48),

                  // ==================== CARD LOGIN ====================
                  _buildLoginCard(context),

                  const SizedBox(height: 24),

                  // ==================== REGISTER LINK ====================
                  _buildRegisterLink(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ==================== LOGO ====================

  Widget _buildLogo() {
    return Column(
      children: [
        // Icône terrain de football
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: const Icon(
            Icons.sports_soccer,
            size: 50,
            color: Color(0xFF4CAF50),
          ),
        ),

        const SizedBox(height: 16),

        // Titre
        const Text(
          'Terrains MR',
          style: TextStyle(
            color: Colors.white,
            fontSize: 32,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),

        const SizedBox(height: 8),

        // Sous-titre
        Text(
          'Réservez votre terrain en un clic',
          style: TextStyle(
            color: Colors.white.withOpacity(0.9),
            fontSize: 16,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }

  // ==================== LOGIN CARD ====================

  Widget _buildLoginCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Titre
          const Text(
            'Connexion',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF4CAF50),
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 8),

          Text(
            'Connectez-vous pour réserver',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 32),

          // Champ téléphone
          _buildPhoneField(),

          const SizedBox(height: 16),

          // Champ mot de passe
          _buildPasswordField(),

          const SizedBox(height: 12),

          // Ligne: Se souvenir + Mot de passe oublié
          _buildRememberAndForgot(),

          const SizedBox(height: 24),

          // Bouton connexion
          _buildLoginButton(),
        ],
      ),
    );
  }

  // ==================== PHONE FIELD ====================

  Widget _buildPhoneField() {
    return Obx(() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: controller.telephoneController,
            keyboardType: TextInputType.phone,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(8), // 8 chiffres maximum
            ],
            style: const TextStyle(
              color: Colors.black87, // ✅ Couleur du texte saisi
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
            decoration: InputDecoration(
              labelText: 'Numéro de téléphone',
              hintText: '22345678', // Format mauritanien : 8 chiffres
              prefixIcon: const Icon(
                Icons.phone,
                color: Color(0xFF4CAF50),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                  color: Color(0xFF4CAF50),
                  width: 2,
                ),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.red),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.red, width: 2),
              ),
              filled: true,
              fillColor: Colors.grey[50],
            ),
          ),
          if (controller.telephoneError.value != null)
            Padding(
              padding: const EdgeInsets.only(top: 8, left: 12),
              child: Text(
                controller.telephoneError.value!,
                style: const TextStyle(
                  color: Colors.red,
                  fontSize: 12,
                ),
              ),
            ),
        ],
      );
    });
  }

  // ==================== PASSWORD FIELD ====================

  Widget _buildPasswordField() {
    return Obx(() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: controller.passwordController,
            obscureText: !controller.isPasswordVisible.value,
            style: const TextStyle(
              color: Colors.black87, // ✅ Couleur du texte saisi
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
            decoration: InputDecoration(
              labelText: 'Mot de passe',
              hintText: 'Entrez votre mot de passe',
              prefixIcon: const Icon(
                Icons.lock,
                color: Color(0xFF4CAF50),
              ),
              suffixIcon: IconButton(
                icon: Icon(
                  controller.isPasswordVisible.value
                      ? Icons.visibility
                      : Icons.visibility_off,
                  color: Colors.grey[600],
                ),
                onPressed: controller.togglePasswordVisibility,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                  color: Color(0xFF4CAF50),
                  width: 2,
                ),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.red),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.red, width: 2),
              ),
              filled: true,
              fillColor: Colors.grey[50],
            ),
          ),
          if (controller.passwordError.value != null)
            Padding(
              padding: const EdgeInsets.only(top: 8, left: 12),
              child: Text(
                controller.passwordError.value!,
                style: const TextStyle(
                  color: Colors.red,
                  fontSize: 12,
                ),
              ),
            ),
        ],
      );
    });
  }

  // ==================== REMEMBER & FORGOT ====================

  Widget _buildRememberAndForgot() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Se souvenir de moi
        Obx(() {
          return Row(
            children: [
              SizedBox(
                width: 24,
                height: 24,
                child: Checkbox(
                  value: controller.rememberMe.value,
                  onChanged: controller.toggleRememberMe,
                  activeColor: const Color(0xFF4CAF50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'Se souvenir',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[700],
                ),
              ),
            ],
          );
        }),

        // Mot de passe oublié
        TextButton(
          onPressed: controller.forgotPassword,
          child: const Text(
            'Mot de passe oublié?',
            style: TextStyle(
              fontSize: 12,
              color: Color(0xFF4CAF50),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  // ==================== LOGIN BUTTON ====================

  Widget _buildLoginButton() {
    return Obx(() {
      return ElevatedButton(
        onPressed: controller.isLoading.value ? null : controller.login,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF4CAF50),
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 2,
        ),
        child: controller.isLoading.value
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : const Text(
                'Se connecter',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
                ),
              ),
      );
    });
  }

  // ==================== REGISTER LINK ====================

  Widget _buildRegisterLink() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Pas encore de compte? ',
          style: TextStyle(
            color: Colors.white.withOpacity(0.9),
            fontSize: 14,
          ),
        ),
        TextButton(
          onPressed: controller.goToRegister,
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 8),
          ),
          child: const Text(
            'S\'inscrire',
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.bold,
              decoration: TextDecoration.underline,
            ),
          ),
        ),
      ],
    );
  }
}



// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:get/get.dart';
// import '../controllers/login_controller.dart';

// class LoginView extends GetView<LoginController> {
//   const LoginView({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             begin: Alignment.topCenter,
//             end: Alignment.bottomCenter,
//             colors: [
//               const Color(0xFF66BB6A), // Vert clair
//               const Color(0xFF4CAF50), // Vert principal
//               const Color(0xFF388E3C), // Vert foncé
//             ],
//           ),
//         ),
//         child: SafeArea(
//           child: Center(
//             child: SingleChildScrollView(
//               padding: const EdgeInsets.symmetric(horizontal: 24),
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   // ==================== LOGO ====================
//                   _buildLogo(),

//                   const SizedBox(height: 48),

//                   // ==================== CARD LOGIN ====================
//                   _buildLoginCard(context),

//                   const SizedBox(height: 24),

//                   // ==================== REGISTER LINK ====================
//                   _buildRegisterLink(),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   // ==================== LOGO ====================

//   Widget _buildLogo() {
//     return Column(
//       children: [
//         // Icône terrain de football
//         Container(
//           width: 100,
//           height: 100,
//           decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.circular(20),
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.black.withOpacity(0.2),
//                 blurRadius: 20,
//                 offset: const Offset(0, 10),
//               ),
//             ],
//           ),
//           child: const Icon(
//             Icons.sports_soccer,
//             size: 50,
//             color: Color(0xFF4CAF50),
//           ),
//         ),

//         const SizedBox(height: 16),

//         // Titre
//         const Text(
//           'Terrains MR',
//           style: TextStyle(
//             color: Colors.white,
//             fontSize: 32,
//             fontWeight: FontWeight.bold,
//             letterSpacing: 1.2,
//           ),
//         ),

//         const SizedBox(height: 8),

//         // Sous-titre
//         Text(
//           'Réservez votre terrain en un clic',
//           style: TextStyle(
//             color: Colors.white.withOpacity(0.9),
//             fontSize: 16,
//             fontWeight: FontWeight.w400,
//           ),
//         ),
//       ],
//     );
//   }

//   // ==================== LOGIN CARD ====================

//   Widget _buildLoginCard(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.all(24),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(20),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.1),
//             blurRadius: 20,
//             offset: const Offset(0, 10),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.stretch,
//         children: [
//           // Titre
//           const Text(
//             'Connexion',
//             style: TextStyle(
//               fontSize: 24,
//               fontWeight: FontWeight.bold,
//               color: Color(0xFF4CAF50),
//             ),
//             textAlign: TextAlign.center,
//           ),

//           const SizedBox(height: 8),

//           Text(
//             'Connectez-vous pour réserver',
//             style: TextStyle(
//               fontSize: 14,
//               color: Colors.grey[600],
//             ),
//             textAlign: TextAlign.center,
//           ),

//           const SizedBox(height: 32),

//           // Champ téléphone
//           _buildPhoneField(),

//           const SizedBox(height: 16),

//           // Champ mot de passe
//           _buildPasswordField(),

//           const SizedBox(height: 12),

//           // Ligne: Se souvenir + Mot de passe oublié
//           _buildRememberAndForgot(),

//           const SizedBox(height: 24),

//           // Bouton connexion
//           _buildLoginButton(),
//         ],
//       ),
//     );
//   }

//   // ==================== PHONE FIELD ====================

//   Widget _buildPhoneField() {
//     return Obx(() {
//       return Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           TextField(
//             controller: controller.telephoneController,
//             keyboardType: TextInputType.phone,
//             inputFormatters: [
//               FilteringTextInputFormatter.digitsOnly,
//               LengthLimitingTextInputFormatter(8), // 8 chiffres maximum
//             ],
//             decoration: InputDecoration(
//               labelText: 'Numéro de téléphone',
//               hintText: '22345678', // Format mauritanien : 8 chiffres
//               prefixIcon: const Icon(
//                 Icons.phone,
//                 color: Color(0xFF4CAF50),
//               ),
//               border: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(12),
//                 borderSide: BorderSide(color: Colors.grey[300]!),
//               ),
//               enabledBorder: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(12),
//                 borderSide: BorderSide(color: Colors.grey[300]!),
//               ),
//               focusedBorder: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(12),
//                 borderSide: const BorderSide(
//                   color: Color(0xFF4CAF50),
//                   width: 2,
//                 ),
//               ),
//               errorBorder: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(12),
//                 borderSide: const BorderSide(color: Colors.red),
//               ),
//               focusedErrorBorder: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(12),
//                 borderSide: const BorderSide(color: Colors.red, width: 2),
//               ),
//               filled: true,
//               fillColor: Colors.grey[50],
//             ),
//           ),
//           if (controller.telephoneError.value != null)
//             Padding(
//               padding: const EdgeInsets.only(top: 8, left: 12),
//               child: Text(
//                 controller.telephoneError.value!,
//                 style: const TextStyle(
//                   color: Colors.red,
//                   fontSize: 12,
//                 ),
//               ),
//             ),
//         ],
//       );
//     });
//   }

//   // ==================== PASSWORD FIELD ====================

//   Widget _buildPasswordField() {
//     return Obx(() {
//       return Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           TextField(
          
//             controller: controller.passwordController,
//             obscureText: !controller.isPasswordVisible.value,
//             decoration: InputDecoration(
//               labelText: 'Mot de passe',
//               hintText: 'Entrez votre mot de passe',
//               prefixIcon: const Icon(
//                 Icons.lock,
//                 color: Color(0xFF4CAF50),
//               ),
//               suffixIcon: IconButton(
//                 icon: Icon(
//                   controller.isPasswordVisible.value
//                       ? Icons.visibility
//                       : Icons.visibility_off,
//                   color: Colors.grey[600],
//                 ),
//                 onPressed: controller.togglePasswordVisibility,
//               ),
//               border: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(12),
//                 borderSide: BorderSide(color: Colors.grey[300]!),
//               ),
//               enabledBorder: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(12),
//                 borderSide: BorderSide(color: Colors.grey[300]!),
//               ),
//               focusedBorder: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(12),
//                 borderSide: const BorderSide(
//                   color: Color(0xFF4CAF50),
//                   width: 2,
//                 ),
//               ),
//               errorBorder: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(12),
//                 borderSide: const BorderSide(color: Colors.red),
//               ),
//               focusedErrorBorder: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(12),
//                 borderSide: const BorderSide(color: Colors.red, width: 2),
//               ),
//               filled: true,
//               fillColor: Colors.grey[50],
//             ),
//           ),
//           if (controller.passwordError.value != null)
//             Padding(
//               padding: const EdgeInsets.only(top: 8, left: 12),
//               child: Text(
//                 controller.passwordError.value!,
//                 style: const TextStyle(
//                   color: Colors.red,
//                   fontSize: 12,
//                 ),
//               ),
//             ),
//         ],
//       );
//     });
//   }

//   // ==================== REMEMBER & FORGOT ====================

//   Widget _buildRememberAndForgot() {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         // Se souvenir de moi
//         Obx(() {
//           return Row(
//             children: [
//               SizedBox(
//                 width: 24,
//                 height: 24,
//                 child: Checkbox(
//                   value: controller.rememberMe.value,
//                   onChanged: controller.toggleRememberMe,
//                   activeColor: const Color(0xFF4CAF50),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(4),
//                   ),
//                 ),
//               ),
//               const SizedBox(width: 8),
//               Text(
//                 'Se souvenir',
//                 style: TextStyle(
//                   fontSize: 12,
//                   color: Colors.grey[700],
//                 ),
//               ),
//             ],
//           );
//         }),

//         // Mot de passe oublié
//         TextButton(
//           onPressed: controller.forgotPassword,
//           child: const Text(
//             'Mot de passe oublié?',
//             style: TextStyle(
//               fontSize: 12,
//               color: Color(0xFF4CAF50),
//               fontWeight: FontWeight.w600,
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   // ==================== LOGIN BUTTON ====================

//   Widget _buildLoginButton() {
//     return Obx(() {
//       return ElevatedButton(
//         onPressed: controller.isLoading.value ? null : controller.login,
//         style: ElevatedButton.styleFrom(
//           backgroundColor: const Color(0xFF4CAF50),
//           foregroundColor: Colors.white,
//           padding: const EdgeInsets.symmetric(vertical: 16),
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(12),
//           ),
//           elevation: 2,
//         ),
//         child: controller.isLoading.value
//             ? const SizedBox(
//                 height: 20,
//                 width: 20,
//                 child: CircularProgressIndicator(
//                   strokeWidth: 2,
//                   valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
//                 ),
//               )
//             : const Text(
//                 'Se connecter',
//                 style: TextStyle(
//                   fontSize: 16,
//                   fontWeight: FontWeight.w600,
//                   letterSpacing: 0.5,
//                 ),
//               ),
//       );
//     });
//   }

//   // ==================== REGISTER LINK ====================

//   Widget _buildRegisterLink() {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         Text(
//           'Pas encore de compte? ',
//           style: TextStyle(
//             color: Colors.white.withOpacity(0.9),
//             fontSize: 14,
//           ),
//         ),
//         TextButton(
//           onPressed: controller.goToRegister,
//           style: TextButton.styleFrom(
//             padding: const EdgeInsets.symmetric(horizontal: 8),
//           ),
//           child: const Text(
//             'S\'inscrire',
//             style: TextStyle(
//               color: Colors.white,
//               fontSize: 14,
//               fontWeight: FontWeight.bold,
//               decoration: TextDecoration.underline,
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }
