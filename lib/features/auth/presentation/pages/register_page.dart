// Register Page
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/localization/localization_extension.dart';
import '../../../../core/utils/responsive_utils.dart';
import '../auth_controller.dart';
import '../widgets/auth_text_field.dart';
import '../widgets/auth_button.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final AuthController authController = Get.find<AuthController>();
  final _formKey = GlobalKey<FormState>();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _agreeToTerms = false;

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      mobile: _buildMobileLayout(context),
      tablet: _buildTabletLayout(context),
      desktop: _buildDesktopLayout(context),
    );
  }

  Widget _buildMobileLayout(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(AppDimensions.paddingL),
          child: _buildRegisterForm(context),
        ),
      ),
    );
  }

  Widget _buildTabletLayout(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
      ),
      body: Center(
        child: Container(
          constraints: BoxConstraints(maxWidth: 500.w),
          padding: EdgeInsets.all(AppDimensions.paddingXL),
          child: SingleChildScrollView(child: _buildRegisterForm(context)),
        ),
      ),
    );
  }

  Widget _buildDesktopLayout(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Row(
        children: [
          // Left side - Branding
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColors.primary,
                    AppColors.primary.withOpacity(0.8),
                  ],
                ),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.person_add, size: 120.sp, color: Colors.white),
                    SizedBox(height: AppDimensions.paddingL),
                    Text(
                      context.tr('join_us'),
                      style: AppTextStyles.headlineLarge.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: AppDimensions.paddingM),
                    Text(
                      context.tr('create_account_subtitle'),
                      style: AppTextStyles.bodyLarge.copyWith(
                        color: Colors.white.withOpacity(0.9),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Right side - Register form
          Expanded(
            child: Stack(
              children: [
                // Back button
                Positioned(
                  top: 24.h,
                  left: 24.w,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () => Get.back(),
                  ),
                ),
                // Form
                Center(
                  child: Container(
                    constraints: BoxConstraints(maxWidth: 400.w),
                    padding: EdgeInsets.all(AppDimensions.paddingXL),
                    child: SingleChildScrollView(
                      child: _buildRegisterForm(context),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRegisterForm(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Logo for mobile/tablet
          if (AppBreakpoints.isMobile(MediaQuery.of(context).size.width) ||
              AppBreakpoints.isTablet(MediaQuery.of(context).size.width)) ...[
            Center(
              child: Icon(
                Icons.person_add,
                size: 80.sp,
                color: AppColors.primary,
              ),
            ),
            SizedBox(height: AppDimensions.paddingL),
          ],

          // Title
          Text(
            context.tr('register'),
            style: AppTextStyles.headlineLarge.copyWith(
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: AppDimensions.paddingM),

          // Subtitle
          Text(
            context.tr('create_account_subtitle'),
            style: AppTextStyles.bodyMedium.copyWith(
              color: Theme.of(context).brightness == Brightness.dark
                  ? AppColors.textSecondaryDark
                  : AppColors.textSecondaryLight,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: AppDimensions.paddingXL),

          // First Name field
          AuthTextField(
            controller: authController.firstNameController,
            labelText: context.tr('first_name'),
            hintText: context.tr('enter_first_name'),
            prefixIcon: Icons.person_outline,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return context.tr('first_name_required');
              }
              return null;
            },
          ),
          SizedBox(height: AppDimensions.paddingL),

          // Last Name field
          AuthTextField(
            controller: authController.lastNameController,
            labelText: context.tr('last_name'),
            hintText: context.tr('enter_last_name'),
            prefixIcon: Icons.person_outline,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return context.tr('last_name_required');
              }
              return null;
            },
          ),
          SizedBox(height: AppDimensions.paddingL),

          // Email field
          AuthTextField(
            controller: authController.emailController,
            labelText: context.tr('email'),
            hintText: context.tr('enter_email'),
            keyboardType: TextInputType.emailAddress,
            prefixIcon: Icons.email_outlined,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return context.tr('email_required');
              }
              if (!GetUtils.isEmail(value)) {
                return context.tr('email_invalid');
              }
              return null;
            },
          ),
          SizedBox(height: AppDimensions.paddingL),

          // Phone field (optional)
          AuthTextField(
            controller: authController.phoneController,
            labelText: context.tr('phone_number'),
            hintText: context.tr('enter_phone_optional'),
            keyboardType: TextInputType.phone,
            prefixIcon: Icons.phone_outlined,
            validator: (value) {
              if (value != null &&
                  value.isNotEmpty &&
                  !GetUtils.isPhoneNumber(value)) {
                return context.tr('phone_invalid');
              }
              return null;
            },
          ),
          SizedBox(height: AppDimensions.paddingL),

          // Password field
          AuthTextField(
            controller: authController.passwordController,
            labelText: context.tr('password'),
            hintText: context.tr('enter_password'),
            obscureText: _obscurePassword,
            prefixIcon: Icons.lock_outlined,
            suffixIcon: IconButton(
              icon: Icon(
                _obscurePassword
                    ? Icons.visibility_outlined
                    : Icons.visibility_off_outlined,
              ),
              onPressed: () {
                setState(() {
                  _obscurePassword = !_obscurePassword;
                });
              },
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return context.tr('password_required');
              }
              if (value.length < 8) {
                return context.tr('password_min_length');
              }
              return null;
            },
          ),
          SizedBox(height: AppDimensions.paddingL),

          // Confirm Password field
          AuthTextField(
            controller: authController.confirmPasswordController,
            labelText: context.tr('confirm_password'),
            hintText: context.tr('enter_confirm_password'),
            obscureText: _obscureConfirmPassword,
            prefixIcon: Icons.lock_outlined,
            suffixIcon: IconButton(
              icon: Icon(
                _obscureConfirmPassword
                    ? Icons.visibility_outlined
                    : Icons.visibility_off_outlined,
              ),
              onPressed: () {
                setState(() {
                  _obscureConfirmPassword = !_obscureConfirmPassword;
                });
              },
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return context.tr('confirm_password_required');
              }
              if (value != authController.passwordController.text) {
                return context.tr('passwords_not_match');
              }
              return null;
            },
          ),
          SizedBox(height: AppDimensions.paddingL),

          // Terms and conditions
          Row(
            children: [
              Checkbox(
                value: _agreeToTerms,
                onChanged: (value) {
                  setState(() {
                    _agreeToTerms = value ?? false;
                  });
                },
                activeColor: AppColors.primary,
              ),
              Expanded(
                child: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: context.tr('agree_to'),
                        style: AppTextStyles.bodySmall.copyWith(
                          color: Theme.of(context).brightness == Brightness.dark
                              ? AppColors.textPrimaryDark
                              : AppColors.textPrimaryLight,
                        ),
                      ),
                      TextSpan(
                        text: ' ${context.tr('terms_and_conditions')}',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.primary,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: AppDimensions.paddingL),

          // Error message
          Obx(() {
            if (authController.errorMessage.value.isNotEmpty) {
              return Container(
                padding: EdgeInsets.all(AppDimensions.paddingM),
                margin: EdgeInsets.only(bottom: AppDimensions.paddingL),
                decoration: BoxDecoration(
                  color: AppColors.error.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                  border: Border.all(color: AppColors.error.withOpacity(0.3)),
                ),
                child: Row(
                  children: [
                    Icon(Icons.error_outline, color: AppColors.error, size: 20),
                    SizedBox(width: AppDimensions.paddingS),
                    Expanded(
                      child: Text(
                        authController.errorMessage.value,
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.error,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }
            return const SizedBox.shrink();
          }),

          // Register button
          Obx(
            () => AuthButton(
              text: context.tr('register'),
              isLoading: authController.isLoading.value,
              isEnabled: _agreeToTerms,
              onPressed: _handleRegister,
            ),
          ),
          SizedBox(height: AppDimensions.paddingXL),

          // Login link
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                context.tr('already_have_account'),
                style: AppTextStyles.bodyMedium,
              ),
              TextButton(
                onPressed: () {
                  Get.back();
                },
                child: Text(
                  context.tr('login'),
                  style: AppTextStyles.labelMedium.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _handleRegister() async {
    if (_formKey.currentState!.validate()) {
      if (!_agreeToTerms) {
        Get.snackbar(
          context.tr('error'),
          context.tr('must_agree_terms'),
          backgroundColor: AppColors.error,
          colorText: Colors.white,
        );
        return;
      }

      authController.clearError();

      final success = await authController.register();
      if (success) {
        Get.offAllNamed('/home');
      }
    }
  }
}
