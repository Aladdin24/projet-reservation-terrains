// lib/views/auth/login_view.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/services.dart';
import '../../controllers/auth_controller.dart';

class LoginView extends GetView<AuthController> {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AuthController());

    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
        ),
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF2E7D32), // Vert foncé
                Color(0xFF388E3C), // Vert moyen
                Color(0xFF4CAF50), // Vert principal
                Color(0xFF66BB6A), // Vert clair
              ],
              stops: [0.0, 0.3, 0.7, 1.0],
            ),
          ),
          child: SafeArea(
            child: Center(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildWelcomeSection(),
                    const SizedBox(height: 40),
                    _buildLoginForm(controller),
                    const SizedBox(height: 30),
                    _buildFooterLinks(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildWelcomeSection() {
    return Column(
      children: [
        // Logo avec effet terrain de sport
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.green.shade100.withOpacity(0.2),
                Colors.green.shade300.withOpacity(0.1),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white.withOpacity(0.3), width: 2),
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Cercle d'herbe
              Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    colors: [Colors.black, Colors.black],
                    center: Alignment.center,
                    radius: 0.8,
                  ),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.8),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
              ),
              // Icone de ballon
              const Icon(
                Icons.sports_soccer,
                size: 60,
                color: Colors.white,
                shadows: [Shadow(blurRadius: 8, color: Colors.black38)],
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),

        // Titres
        AnimatedOpacity(
          duration: const Duration(milliseconds: 500),
          opacity: 1,
          child: Column(
            children: [
              Text(
                'BIENVENUE',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white.withOpacity(0.9),
                  fontWeight: FontWeight.w600,
                  letterSpacing: 2.0,
                ),
              ),
              const SizedBox(height: 05),
              const Text(
                'Terrains MR',
                style: TextStyle(
                  fontSize: 40,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.0,
                  shadows: [Shadow(blurRadius: 4, color: Colors.black26)],
                ),
              ),
              const SizedBox(height: 05),
              Container(
                width: 100,
                height: 3,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.white.withOpacity(0.8),
                      Colors.white.withOpacity(0.3),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 05),
              Text(
                'Réservez votre terrain de sport\nen quelques clics',
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.white.withOpacity(0.9),
                  height: 1.4,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLoginForm(AuthController controller) {
    return Container(
      padding: const EdgeInsets.all(30),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.green.shade900.withOpacity(0.2),
            blurRadius: 25,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // En-tête du formulaire
          _buildFormHeader(),
          const SizedBox(height: 30),

          // Champ téléphone
          _buildPhoneField(controller),
          const SizedBox(height: 20),

          // Champ mot de passe
          _buildPasswordField(controller),
          const SizedBox(height: 10),

          // Lien mot de passe oublié
          _buildForgotPasswordLink(),
          const SizedBox(height: 30),

          // Bouton de connexion
          _buildLoginButton(controller),
          const SizedBox(height: 25),

          // Séparateur
          _buildDivider(),
          const SizedBox(height: 25),

          // Bouton d'inscription
          _buildRegisterButton(),
        ],
      ),
    );
  }

  Widget _buildFormHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 4,
              height: 24,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.green.shade600, Colors.green.shade400],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: 12),
            Text(
              'CONNEXION',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.green.shade800,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.only(left: 16),
          child: Text(
            'Accédez à votre espace personnel',
            style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
          ),
        ),
      ],
    );
  }

  Widget _buildPhoneField(AuthController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Numéro de téléphone',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: Colors.green.shade800,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller.phoneController,
          keyboardType: TextInputType.phone,
          style: const TextStyle(fontSize: 16, color: Colors.grey),
          decoration: InputDecoration(
            hintText: '06 12 34 56 78',
            hintStyle: TextStyle(color: Colors.grey.shade400),
            prefixIcon: Container(
              margin: const EdgeInsets.only(right: 12),
              decoration: BoxDecoration(
                border: Border(
                  right: BorderSide(color: Colors.green.shade200, width: 1.5),
                ),
              ),
              child: Icon(
                Icons.phone_android_outlined,
                color: Colors.green.shade600,
              ),
            ),
            prefixIconConstraints: const BoxConstraints(minWidth: 56),
            filled: true,
            fillColor: Colors.green.shade50,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 18,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(color: Colors.green.shade100, width: 1.5),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(color: Colors.green.shade500, width: 2),
            ),
            floatingLabelBehavior: FloatingLabelBehavior.never,
          ),
        ),
      ],
    );
  }

  Widget _buildPasswordField(AuthController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Mot de passe',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: Colors.green.shade800,
          ),
        ),
        const SizedBox(height: 8),
        Obx(
          () => TextField(
            controller: controller.passwordController,
            obscureText: !controller.isPasswordVisible.value,
            style: const TextStyle(fontSize: 16, color: Colors.grey),
            decoration: InputDecoration(
              hintText: 'Entrez votre mot de passe',
              hintStyle: TextStyle(color: Colors.grey.shade400),
              prefixIcon: Container(
                margin: const EdgeInsets.only(right: 12),
                decoration: BoxDecoration(
                  border: Border(
                    right: BorderSide(color: Colors.green.shade200, width: 1.5),
                  ),
                ),
                child: Icon(Icons.lock_outline, color: Colors.green.shade600),
              ),
              suffixIcon: IconButton(
                onPressed: controller.togglePasswordVisibility,
                icon: Icon(
                  controller.isPasswordVisible.value
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  color: Colors.green.shade600,
                ),
              ),
              prefixIconConstraints: const BoxConstraints(minWidth: 56),
              filled: true,
              fillColor: Colors.green.shade50,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 18,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide(
                  color: Colors.green.shade100,
                  width: 1.5,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide(color: Colors.green.shade500, width: 2),
              ),
              floatingLabelBehavior: FloatingLabelBehavior.never,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildForgotPasswordLink() {
    return Align(
      alignment: Alignment.centerRight,
      child: TextButton.icon(
        onPressed: _showForgotPasswordDialog,
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        ),
        icon: Icon(Icons.help_outline, size: 16, color: Colors.green.shade600),
        label: Text(
          'Mot de passe oublié ?',
          style: TextStyle(
            color: Colors.green.shade700,
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildLoginButton(AuthController controller) {
    return Obx(
      () => AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        height: 56,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: controller.isLoading.value
              ? []
              : [
                  BoxShadow(
                    color: Colors.green.shade600.withOpacity(0.4),
                    blurRadius: 15,
                    offset: const Offset(0, 8),
                  ),
                ],
        ),
        child: ElevatedButton(
          onPressed: controller.isLoading.value ? null : controller.login,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green.shade600,
            foregroundColor: Colors.white,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            padding: const EdgeInsets.symmetric(vertical: 16),
            shadowColor: Colors.transparent,
          ),
          child: controller.isLoading.value
              ? SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Colors.white.withOpacity(0.9),
                    ),
                  ),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Se connecter',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.3,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Icon(
                      Icons.arrow_forward_rounded,
                      size: 22,
                      color: Colors.white.withOpacity(0.9),
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Row(
      children: [
        Expanded(
          child: Divider(color: Colors.green.shade200, thickness: 1, height: 1),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'NOUVEAU ICI ?',
            style: TextStyle(
              color: Colors.green.shade600,
              fontSize: 12,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
            ),
          ),
        ),
        Expanded(
          child: Divider(color: Colors.green.shade200, thickness: 1, height: 1),
        ),
      ],
    );
  }

  Widget _buildRegisterButton() {
    return OutlinedButton.icon(
      onPressed: () => Get.toNamed('/register'),
      style: OutlinedButton.styleFrom(
        foregroundColor: Colors.green.shade600,
        side: BorderSide(color: Colors.green.shade400, width: 1.5),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        padding: const EdgeInsets.symmetric(vertical: 16),
        backgroundColor: Colors.green.shade50,
      ),
      icon: const Icon(Icons.person_add_outlined, size: 20),
      label: const Text(
        'Créer un nouveau compte',
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      ),
    );
  }

  Widget _buildFooterLinks() {
    return Column(
      children: [
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
              onPressed: () => _showTermsDialog(),
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
              ),
              child: Text(
                'Conditions',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.9),
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Container(
              width: 1,
              height: 12,
              color: Colors.white.withOpacity(0.3),
            ),
            TextButton(
              onPressed: () => _showPrivacyDialog(),
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
              ),
              child: Text(
                'Confidentialité',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.9),
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Container(
              width: 1,
              height: 12,
              color: Colors.white.withOpacity(0.3),
            ),
            TextButton(
              onPressed: () => _showContactDialog(),
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
              ),
              child: Text(
                'Contact',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.9),
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Text(
          '© 2024 Terrains MR - Votre terrain, votre passion',
          style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 12),
        ),
      ],
    );
  }

  void _showForgotPasswordDialog() {
    Get.dialog(
      Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Icône
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.green.shade100,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.lock_reset_outlined,
                  size: 40,
                  color: Colors.green.shade700,
                ),
              ),
              const SizedBox(height: 20),

              // Titre
              Text(
                'Mot de passe oublié',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.green.shade800,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),

              // Description
              Text(
                'Entrez votre numéro de téléphone pour recevoir un code de réinitialisation',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade600,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),

              // Champ de saisie
              TextField(
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  labelText: 'Numéro de téléphone',
                  prefixIcon: Icon(
                    Icons.phone_android_outlined,
                    color: Colors.green.shade600,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.green.shade200),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: Colors.green.shade500,
                      width: 2,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),

              // Boutons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: Get.back,
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: Colors.green.shade400),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: Text(
                        'Annuler',
                        style: TextStyle(
                          color: Colors.green.shade700,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Get.back();
                        Get.snackbar(
                          'Code envoyé',
                          'Un SMS avec le code de réinitialisation vous a été envoyé',
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: Colors.green.shade600,
                          colorText: Colors.white,
                          borderRadius: 12,
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green.shade600,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: const Text(
                        'Envoyer',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showTermsDialog() {
    Get.defaultDialog(
      title: 'Conditions d\'utilisation',
      titleStyle: TextStyle(
        color: Colors.green.shade800,
        fontWeight: FontWeight.bold,
        fontSize: 20,
      ),
      content: SingleChildScrollView(
        child: Column(
          children: [
            Icon(Icons.gavel_outlined, size: 40, color: Colors.green.shade600),
            const SizedBox(height: 16),
            Text(
              'En utilisant Terrains MR, vous acceptez nos conditions générales d\'utilisation.',
              style: TextStyle(color: Colors.grey.shade700),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
      confirm: ElevatedButton(
        onPressed: Get.back,
        style: ElevatedButton.styleFrom(backgroundColor: Colors.green.shade600),
        child: const Text('J\'accepte'),
      ),
    );
  }

  void _showPrivacyDialog() {
    Get.defaultDialog(
      title: 'Confidentialité',
      titleStyle: TextStyle(
        color: Colors.green.shade800,
        fontWeight: FontWeight.bold,
        fontSize: 20,
      ),
      content: SingleChildScrollView(
        child: Column(
          children: [
            Icon(
              Icons.security_outlined,
              size: 40,
              color: Colors.green.shade600,
            ),
            const SizedBox(height: 16),
            Text(
              'Nous protégeons vos données personnelles. Vos informations sont sécurisées.',
              style: TextStyle(color: Colors.grey.shade700),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
      confirm: ElevatedButton(
        onPressed: Get.back,
        style: ElevatedButton.styleFrom(backgroundColor: Colors.green.shade600),
        child: const Text('Compris'),
      ),
    );
  }

  void _showContactDialog() {
    Get.defaultDialog(
      title: 'Contact',
      titleStyle: TextStyle(
        color: Colors.green.shade800,
        fontWeight: FontWeight.bold,
        fontSize: 20,
      ),
      content: SingleChildScrollView(
        child: Column(
          children: [
            Icon(
              Icons.contact_support_outlined,
              size: 40,
              color: Colors.green.shade600,
            ),
            const SizedBox(height: 16),
            Text(
              'Contactez-nous : contact@terrains-mr.com\nTél: 0800 123 456',
              style: TextStyle(color: Colors.grey.shade700),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
      confirm: ElevatedButton(
        onPressed: Get.back,
        style: ElevatedButton.styleFrom(backgroundColor: Colors.green.shade600),
        child: const Text('Fermer'),
      ),
    );
  }
}
