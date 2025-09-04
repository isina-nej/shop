// Authentication Controller using GetX
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../../core/storage/storage_service.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/network/network_service.dart';

class AuthController extends GetxController {
  static AuthController get instance => Get.find();

  // Observable state
  final RxBool isLoading = false.obs;
  final RxBool isAuthenticated = false.obs;
  final Rx<User?> currentUser = Rx<User?>(null);
  final RxString errorMessage = ''.obs;

  // Form controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final phoneController = TextEditingController();

  // Form validation
  final RxBool emailValid = false.obs;
  final RxBool passwordValid = false.obs;
  final RxBool confirmPasswordValid = false.obs;

  @override
  void onInit() {
    super.onInit();
    _checkAuthStatus();
    _setupValidation();
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    firstNameController.dispose();
    lastNameController.dispose();
    phoneController.dispose();
    super.onClose();
  }

  void _setupValidation() {
    emailController.addListener(() {
      emailValid.value = _isValidEmail(emailController.text);
    });

    passwordController.addListener(() {
      passwordValid.value = _isValidPassword(passwordController.text);
      if (confirmPasswordController.text.isNotEmpty) {
        confirmPasswordValid.value =
            passwordController.text == confirmPasswordController.text;
      }
    });

    confirmPasswordController.addListener(() {
      confirmPasswordValid.value =
          passwordController.text == confirmPasswordController.text;
    });
  }

  Future<void> _checkAuthStatus() async {
    final token = await AppStorage.getString(AppConstants.userTokenKey);
    if (token != null && token.isNotEmpty) {
      try {
        // Verify token with backend
        final userData = await AppStorage.getString(AppConstants.userDataKey);
        if (userData != null) {
          currentUser.value = User.fromJson(userData);
          isAuthenticated.value = true;
        }
      } catch (e) {
        // Token invalid, clear storage
        await logout();
      }
    }
  }

  Future<bool> login() async {
    if (!_validateLoginForm()) return false;

    try {
      isLoading.value = true;
      errorMessage.value = '';

      final response = await NetworkService.post('/auth/login', {
        'email': emailController.text.trim(),
        'password': passwordController.text,
      });

      if (response.statusCode == 200) {
        final data = response.data;

        // Store user data and token
        await AppStorage.setString(
          AppConstants.userTokenKey,
          data['tokens']['access'],
        );
        await AppStorage.setString(
          AppConstants.userDataKey,
          data['user'].toString(),
        );

        currentUser.value = User.fromMap(data['user']);
        isAuthenticated.value = true;

        _clearForm();
        return true;
      } else {
        errorMessage.value = response.data['message'] ?? 'خطا در ورود';
        return false;
      }
    } catch (e) {
      errorMessage.value = 'خطا در ارتباط با سرور';
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> register() async {
    if (!_validateRegisterForm()) return false;

    try {
      isLoading.value = true;
      errorMessage.value = '';

      final response = await NetworkService.post('/auth/register', {
        'email': emailController.text.trim(),
        'password': passwordController.text,
        'first_name': firstNameController.text.trim(),
        'last_name': lastNameController.text.trim(),
        'phone_number': phoneController.text.trim(),
      });

      if (response.statusCode == 201) {
        final data = response.data;

        // Store user data and token
        await AppStorage.setString(
          AppConstants.userTokenKey,
          data['tokens']['access'],
        );
        await AppStorage.setString(
          AppConstants.userDataKey,
          data['user'].toString(),
        );

        currentUser.value = User.fromMap(data['user']);
        isAuthenticated.value = true;

        _clearForm();
        return true;
      } else {
        errorMessage.value = response.data['message'] ?? 'خطا در ثبت نام';
        return false;
      }
    } catch (e) {
      errorMessage.value = 'خطا در ارتباط با سرور';
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logout() async {
    try {
      await AppStorage.remove(AppConstants.userTokenKey);
      await AppStorage.remove(AppConstants.userDataKey);

      currentUser.value = null;
      isAuthenticated.value = false;
      _clearForm();

      Get.offAllNamed('/login');
    } catch (e) {
      debugPrint('خطا در خروج: $e');
    }
  }

  Future<bool> forgotPassword(String email) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final response = await NetworkService.post('/auth/forgot-password', {
        'email': email.trim(),
      });

      if (response.statusCode == 200) {
        return true;
      } else {
        errorMessage.value = response.data['message'] ?? 'خطا در ارسال ایمیل';
        return false;
      }
    } catch (e) {
      errorMessage.value = 'خطا در ارتباط با سرور';
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  bool _validateLoginForm() {
    if (emailController.text.trim().isEmpty) {
      errorMessage.value = 'ایمیل را وارد کنید';
      return false;
    }
    if (!_isValidEmail(emailController.text.trim())) {
      errorMessage.value = 'ایمیل معتبر وارد کنید';
      return false;
    }
    if (passwordController.text.isEmpty) {
      errorMessage.value = 'رمز عبور را وارد کنید';
      return false;
    }
    return true;
  }

  bool _validateRegisterForm() {
    if (firstNameController.text.trim().isEmpty) {
      errorMessage.value = 'نام را وارد کنید';
      return false;
    }
    if (lastNameController.text.trim().isEmpty) {
      errorMessage.value = 'نام خانوادگی را وارد کنید';
      return false;
    }
    if (emailController.text.trim().isEmpty) {
      errorMessage.value = 'ایمیل را وارد کنید';
      return false;
    }
    if (!_isValidEmail(emailController.text.trim())) {
      errorMessage.value = 'ایمیل معتبر وارد کنید';
      return false;
    }
    if (passwordController.text.isEmpty) {
      errorMessage.value = 'رمز عبور را وارد کنید';
      return false;
    }
    if (!_isValidPassword(passwordController.text)) {
      errorMessage.value = 'رمز عبور حداقل ۸ کاراکتر باشد';
      return false;
    }
    if (passwordController.text != confirmPasswordController.text) {
      errorMessage.value = 'رمز عبور و تکرار آن مطابقت ندارند';
      return false;
    }
    return true;
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  bool _isValidPassword(String password) {
    return password.length >= AppConstants.minPasswordLength;
  }

  void _clearForm() {
    emailController.clear();
    passwordController.clear();
    confirmPasswordController.clear();
    firstNameController.clear();
    lastNameController.clear();
    phoneController.clear();
    errorMessage.value = '';
  }

  void clearError() {
    errorMessage.value = '';
  }
}

// User Model
class User {
  final String id;
  final String email;
  final String firstName;
  final String lastName;
  final String? phoneNumber;
  final String? avatar;
  final DateTime createdAt;

  User({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    this.phoneNumber,
    this.avatar,
    required this.createdAt,
  });

  String get fullName => '$firstName $lastName';

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'].toString(),
      email: map['email'] ?? '',
      firstName: map['first_name'] ?? '',
      lastName: map['last_name'] ?? '',
      phoneNumber: map['phone_number'],
      avatar: map['avatar'],
      createdAt: DateTime.parse(
        map['created_at'] ?? DateTime.now().toIso8601String(),
      ),
    );
  }

  factory User.fromJson(String jsonString) {
    // Implementation depends on your JSON structure
    // This is a placeholder
    return User(
      id: '1',
      email: 'user@example.com',
      firstName: 'کاربر',
      lastName: 'نمونه',
      createdAt: DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'first_name': firstName,
      'last_name': lastName,
      'phone_number': phoneNumber,
      'avatar': avatar,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
