// lib/controllers/auth_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../services/api_service.dart';

class AuthController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final phoneController = TextEditingController();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();

  var isLoading = false.obs;

  void login() async {
    isLoading(true);
    try {
      await ApiService.login(phoneController.text, passwordController.text);
      Get.offAllNamed('/home');
    } finally {
      isLoading(false);
    }
  }

  void register() async {
    isLoading(true);
    try {
      await ApiService.register(
        phone: phoneController.text,
        firstName: firstNameController.text,
        lastName: lastNameController.text,
        password: passwordController.text,
      );
      Get.offAllNamed('/home');
    } finally {
      isLoading(false);
    }
  }

  // Dans AuthController
  RxBool isPasswordVisible = false.obs;

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }
}
