import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../controllers/register_controller.dart';

class RegisterView extends GetView<RegisterController> {
  const RegisterView({super.key});

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
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // ==================== LOGO ====================
                  _buildLogo(),

                  const SizedBox(height: 32),

                  // ==================== CARD REGISTER ====================
                  _buildRegisterCard(context),

                  const SizedBox(height: 24),

                  // ==================== LOGIN LINK ====================
                  _buildLoginLink(),
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
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
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
            size: 40,
            color: Color(0xFF4CAF50),
          ),
        ),

        const SizedBox(height: 12),

        // Titre
        const Text(
          'Terrains MR',
          style: TextStyle(
            color: Colors.white,
            fontSize: 28,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
      ],
    );
  }

  // ==================== REGISTER CARD ====================

  Widget _buildRegisterCard(BuildContext context) {
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
            'Inscription',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF4CAF50),
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 8),

          Text(
            'Créez votre compte pour réserver',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 24),

          // Champ prénom
          _buildFirstNameField(),

          const SizedBox(height: 16),

          // Champ nom
          _buildLastNameField(),

          const SizedBox(height: 16),

          // Champ téléphone
          _buildPhoneField(),

          const SizedBox(height: 16),

          // Champ mot de passe
          _buildPasswordField(),

          const SizedBox(height: 16),

          // Champ confirmation mot de passe
          _buildConfirmPasswordField(),

          const SizedBox(height: 24),

          // Bouton inscription
          _buildRegisterButton(),
        ],
      ),
    );
  }

  // ==================== FIRST NAME FIELD ====================

  Widget _buildFirstNameField() {
    return Obx(() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: controller.firstNameController,
            textCapitalization: TextCapitalization.words,
            style: const TextStyle(
              color: Colors.black87, // ✅ Couleur du texte saisi
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
            decoration: InputDecoration(
              labelText: 'Prénom',
              hintText: 'Votre prénom',
              prefixIcon: const Icon(
                Icons.person,
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
          if (controller.firstNameError.value != null)
            Padding(
              padding: const EdgeInsets.only(top: 8, left: 12),
              child: Text(
                controller.firstNameError.value!,
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

  // ==================== LAST NAME FIELD ====================

  Widget _buildLastNameField() {
    return Obx(() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: controller.lastNameController,
            textCapitalization: TextCapitalization.words,
            style: const TextStyle(
              color: Colors.black87, // ✅ Couleur du texte saisi
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
            decoration: InputDecoration(
              labelText: 'Nom',
              hintText: 'Votre nom',
              prefixIcon: const Icon(
                Icons.person_outline,
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
          if (controller.lastNameError.value != null)
            Padding(
              padding: const EdgeInsets.only(top: 8, left: 12),
              child: Text(
                controller.lastNameError.value!,
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
              hintText: '22345678',
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
              hintText: 'Minimum 6 caractères',
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

  // ==================== CONFIRM PASSWORD FIELD ====================

  Widget _buildConfirmPasswordField() {
    return Obx(() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: controller.confirmPasswordController,
            obscureText: !controller.isConfirmPasswordVisible.value,
            style: const TextStyle(
              color: Colors.black87, // ✅ Couleur du texte saisi
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
            decoration: InputDecoration(
              labelText: 'Confirmer le mot de passe',
              hintText: 'Ressaisir le mot de passe',
              prefixIcon: const Icon(
                Icons.lock_outline,
                color: Color(0xFF4CAF50),
              ),
              suffixIcon: IconButton(
                icon: Icon(
                  controller.isConfirmPasswordVisible.value
                      ? Icons.visibility
                      : Icons.visibility_off,
                  color: Colors.grey[600],
                ),
                onPressed: controller.toggleConfirmPasswordVisibility,
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
          if (controller.confirmPasswordError.value != null)
            Padding(
              padding: const EdgeInsets.only(top: 8, left: 12),
              child: Text(
                controller.confirmPasswordError.value!,
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

  // ==================== REGISTER BUTTON ====================

  Widget _buildRegisterButton() {
    return Obx(() {
      return ElevatedButton(
        onPressed: controller.isLoading.value ? null : controller.register,
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
                'S\'inscrire',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
                ),
              ),
      );
    });
  }

  // ==================== LOGIN LINK ====================

  Widget _buildLoginLink() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Déjà un compte? ',
          style: TextStyle(
            color: Colors.white.withOpacity(0.9),
            fontSize: 14,
          ),
        ),
        TextButton(
          onPressed: controller.goToLogin,
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 8),
          ),
          child: const Text(
            'Se connecter',
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
// import '../controllers/register_controller.dart';

// class RegisterView extends GetView<RegisterController> {
//   const RegisterView({super.key});

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
//               padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   // ==================== LOGO ====================
//                   _buildLogo(),

//                   const SizedBox(height: 32),

//                   // ==================== CARD REGISTER ====================
//                   _buildRegisterCard(context),

//                   const SizedBox(height: 24),

//                   // ==================== LOGIN LINK ====================
//                   _buildLoginLink(),
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
//           width: 80,
//           height: 80,
//           decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.circular(16),
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
//             size: 40,
//             color: Color(0xFF4CAF50),
//           ),
//         ),

//         const SizedBox(height: 12),

//         // Titre
//         const Text(
//           'Terrains MR',
//           style: TextStyle(
//             color: Colors.white,
//             fontSize: 28,
//             fontWeight: FontWeight.bold,
//             letterSpacing: 1.2,
//           ),
//         ),
//       ],
//     );
//   }

//   // ==================== REGISTER CARD ====================

//   Widget _buildRegisterCard(BuildContext context) {
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
//             'Inscription',
//             style: TextStyle(
//               fontSize: 24,
//               fontWeight: FontWeight.bold,
//               color: Color(0xFF4CAF50),
//             ),
//             textAlign: TextAlign.center,
//           ),

//           const SizedBox(height: 8),

//           Text(
//             'Créez votre compte pour réserver',
//             style: TextStyle(
//               fontSize: 14,
//               color: Colors.grey[600],
//             ),
//             textAlign: TextAlign.center,
//           ),

//           const SizedBox(height: 24),

//           // Champ prénom
//           _buildFirstNameField(),

//           const SizedBox(height: 16),

//           // Champ nom
//           _buildLastNameField(),

//           const SizedBox(height: 16),

//           // Champ téléphone
//           _buildPhoneField(),

//           const SizedBox(height: 16),

//           // Champ mot de passe
//           _buildPasswordField(),

//           const SizedBox(height: 16),

//           // Champ confirmation mot de passe
//           _buildConfirmPasswordField(),

//           const SizedBox(height: 24),

//           // Bouton inscription
//           _buildRegisterButton(),
//         ],
//       ),
//     );
//   }

//   // ==================== FIRST NAME FIELD ====================

//   Widget _buildFirstNameField() {
//     return Obx(() {
//       return Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           TextField(
//             controller: controller.firstNameController,
//             textCapitalization: TextCapitalization.words,
//             decoration: InputDecoration(
//               labelText: 'Prénom',
//               hintText: 'Votre prénom',
//               prefixIcon: const Icon(
//                 Icons.person,
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
//           if (controller.firstNameError.value != null)
//             Padding(
//               padding: const EdgeInsets.only(top: 8, left: 12),
//               child: Text(
//                 controller.firstNameError.value!,
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

//   // ==================== LAST NAME FIELD ====================

//   Widget _buildLastNameField() {
//     return Obx(() {
//       return Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           TextField(
//             controller: controller.lastNameController,
//             textCapitalization: TextCapitalization.words,
//             decoration: InputDecoration(
//               labelText: 'Nom',
//               hintText: 'Votre nom',
//               prefixIcon: const Icon(
//                 Icons.person_outline,
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
//           if (controller.lastNameError.value != null)
//             Padding(
//               padding: const EdgeInsets.only(top: 8, left: 12),
//               child: Text(
//                 controller.lastNameError.value!,
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
//               hintText: '22345678',
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
//               hintText: 'Minimum 6 caractères',
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

//   // ==================== CONFIRM PASSWORD FIELD ====================

//   Widget _buildConfirmPasswordField() {
//     return Obx(() {
//       return Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           TextField(
//             controller: controller.confirmPasswordController,
//             obscureText: !controller.isConfirmPasswordVisible.value,
//             decoration: InputDecoration(
//               labelText: 'Confirmer le mot de passe',
//               hintText: 'Ressaisir le mot de passe',
//               prefixIcon: const Icon(
//                 Icons.lock_outline,
//                 color: Color(0xFF4CAF50),
//               ),
//               suffixIcon: IconButton(
//                 icon: Icon(
//                   controller.isConfirmPasswordVisible.value
//                       ? Icons.visibility
//                       : Icons.visibility_off,
//                   color: Colors.grey[600],
//                 ),
//                 onPressed: controller.toggleConfirmPasswordVisibility,
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
//           if (controller.confirmPasswordError.value != null)
//             Padding(
//               padding: const EdgeInsets.only(top: 8, left: 12),
//               child: Text(
//                 controller.confirmPasswordError.value!,
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

//   // ==================== REGISTER BUTTON ====================

//   Widget _buildRegisterButton() {
//     return Obx(() {
//       return ElevatedButton(
//         onPressed: controller.isLoading.value ? null : controller.register,
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
//                 'S\'inscrire',
//                 style: TextStyle(
//                   fontSize: 16,
//                   fontWeight: FontWeight.w600,
//                   letterSpacing: 0.5,
//                 ),
//               ),
//       );
//     });
//   }

//   // ==================== LOGIN LINK ====================

//   Widget _buildLoginLink() {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         Text(
//           'Déjà un compte? ',
//           style: TextStyle(
//             color: Colors.white.withOpacity(0.9),
//             fontSize: 14,
//           ),
//         ),
//         TextButton(
//           onPressed: controller.goToLogin,
//           style: TextButton.styleFrom(
//             padding: const EdgeInsets.symmetric(horizontal: 8),
//           ),
//           child: const Text(
//             'Se connecter',
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