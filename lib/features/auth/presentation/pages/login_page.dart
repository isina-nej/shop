// Login Page
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

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final AuthController authController = Get.put(AuthController());
  final _formKey = GlobalKey<FormState>();
  bool _obscurePassword = true;

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
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(AppDimensions.paddingL),
          child: _buildLoginForm(context),
        ),
      ),
    );
  }

  Widget _buildTabletLayout(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Center(
        child: Container(
          constraints: BoxConstraints(maxWidth: 500.w),
          padding: EdgeInsets.all(AppDimensions.paddingXL),
          child: SingleChildScrollView(child: _buildLoginForm(context)),
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
                    Icon(Icons.shopping_bag, size: 120.sp, color: Colors.white),
                    SizedBox(height: AppDimensions.paddingL),
                    Text(
                      context.tr('app_name'),
                      style: AppTextStyles.headlineLarge.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: AppDimensions.paddingM),
                    Text(
                      context.tr('welcome_back'),
                      style: AppTextStyles.bodyLarge.copyWith(
                        color: Colors.white.withOpacity(0.9),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Right side - Login form
          Expanded(
            child: Center(
              child: Container(
                constraints: BoxConstraints(maxWidth: 400.w),
                padding: EdgeInsets.all(AppDimensions.paddingXL),
                child: SingleChildScrollView(child: _buildLoginForm(context)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoginForm(BuildContext context) {
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
                Icons.shopping_bag,
                size: 80.sp,
                color: AppColors.primary,
              ),
            ),
            SizedBox(height: AppDimensions.paddingL),
          ],

          // Title
          Text(
            context.tr('login'),
            style: AppTextStyles.headlineLarge.copyWith(
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: AppDimensions.paddingM),

          // Subtitle
          Text(
            context.tr('login_subtitle'),
            style: AppTextStyles.bodyMedium.copyWith(
              color: Theme.of(context).brightness == Brightness.dark
                  ? AppColors.textSecondaryDark
                  : AppColors.textSecondaryLight,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: AppDimensions.paddingXL),

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
              return null;
            },
          ),
          SizedBox(height: AppDimensions.paddingM),

          // Forgot password
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: _showForgotPasswordDialog,
              child: Text(
                context.tr('forgot_password'),
                style: AppTextStyles.labelMedium.copyWith(
                  color: AppColors.primary,
                ),
              ),
            ),
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

          // Login button
          Obx(
            () => AuthButton(
              text: context.tr('login'),
              isLoading: authController.isLoading.value,
              onPressed: _handleLogin,
            ),
          ),
          SizedBox(height: AppDimensions.paddingXL),

          // Register link
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                context.tr('dont_have_account'),
                style: AppTextStyles.bodyMedium,
              ),
              TextButton(
                onPressed: () {
                  Get.toNamed('/register');
                },
                child: Text(
                  context.tr('register'),
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

  void _handleLogin() async {
    if (_formKey.currentState!.validate()) {
      authController.clearError();

      final success = await authController.login();
      if (success) {
        Get.offAllNamed('/home');
      }
    }
  }

  void _showForgotPasswordDialog() {
    final emailController = TextEditingController();

    Get.dialog(
      AlertDialog(
        title: Text(context.tr('forgot_password')),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(context.tr('forgot_password_description')),
            SizedBox(height: AppDimensions.paddingL),
            AuthTextField(
              controller: emailController,
              labelText: context.tr('email'),
              hintText: context.tr('enter_email'),
              keyboardType: TextInputType.emailAddress,
              prefixIcon: Icons.email_outlined,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(context.tr('cancel')),
          ),
          Obx(
            () => AuthButton(
              text: context.tr('send_reset_email'),
              isLoading: authController.isLoading.value,
              onPressed: () async {
                if (emailController.text.isNotEmpty) {
                  final success = await authController.forgotPassword(
                    emailController.text,
                  );
                  if (success) {
                    Get.back();
                    Get.snackbar(
                      context.tr('success'),
                      context.tr('reset_email_sent'),
                      backgroundColor: AppColors.success,
                      colorText: Colors.white,
                    );
                  }
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
