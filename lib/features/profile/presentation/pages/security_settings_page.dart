// Security Settings Page - Complete Security Management
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/responsive_utils.dart';
import '../../../../core/localization/localization_extension.dart';

class SecuritySettingsPage extends StatefulWidget {
  const SecuritySettingsPage({super.key});

  @override
  State<SecuritySettingsPage> createState() => _SecuritySettingsPageState();
}

class _SecuritySettingsPageState extends State<SecuritySettingsPage>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  // Security settings state
  bool _twoFactorEnabled = false;
  bool _biometricEnabled = true;
  bool _loginNotifications = true;
  bool _suspiciousActivityAlerts = true;
  final String _lastPasswordChange = '۳ ماه پیش';
  List<LoginSession> _activeSessions = [];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );
    _animationController.forward();
    _loadSecurityData();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _loadSecurityData() {
    // Mock active sessions data
    _activeSessions = [
      LoginSession(
        id: '1',
        device: 'Chrome در Windows',
        location: 'تهران، ایران',
        ipAddress: '192.168.1.1',
        lastActive: 'اکنون',
        isCurrent: true,
      ),
      LoginSession(
        id: '2',
        device: 'موبایل اندروید',
        location: 'تهران، ایران',
        ipAddress: '192.168.1.2',
        lastActive: '۲ ساعت پیش',
        isCurrent: false,
      ),
      LoginSession(
        id: '3',
        device: 'Safari در iPhone',
        location: 'اصفهان، ایران',
        ipAddress: '192.168.1.3',
        lastActive: '۱ روز پیش',
        isCurrent: false,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark
          ? AppColors.backgroundDark
          : AppColors.backgroundLight,
      appBar: AppBar(
        title: Text(context.tr('security_settings')),
        backgroundColor: isDark ? AppColors.surfaceDark : AppColors.white,
        elevation: 0,
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: ResponsiveContainer(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(AppDimensions.paddingL),
            child: Column(
              children: [
                _buildSecurityOverview(context),
                SizedBox(height: AppDimensions.paddingL),
                _buildPasswordSection(context),
                SizedBox(height: AppDimensions.paddingL),
                _buildTwoFactorSection(context),
                SizedBox(height: AppDimensions.paddingL),
                _buildBiometricSection(context),
                SizedBox(height: AppDimensions.paddingL),
                _buildNotificationSettings(context),
                SizedBox(height: AppDimensions.paddingL),
                _buildActiveSessionsSection(context),
                SizedBox(height: AppDimensions.paddingL),
                _buildPrivacyActions(context),
                SizedBox(height: AppDimensions.paddingXL),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSecurityOverview(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final securityLevel = _calculateSecurityLevel();

    return Container(
      padding: EdgeInsets.all(AppDimensions.paddingL),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.white,
        borderRadius: BorderRadius.circular(AppDimensions.radiusL),
        boxShadow: [
          BoxShadow(
            color: isDark ? AppColors.shadowDark : AppColors.shadowLight,
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: _getSecurityLevelColor(
                    securityLevel,
                  ).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Icon(
                  _getSecurityLevelIcon(securityLevel),
                  color: _getSecurityLevelColor(securityLevel),
                  size: 30,
                ),
              ),
              SizedBox(width: AppDimensions.paddingM),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'سطح امنیت حساب',
                      style: AppTextStyles.headlineSmall.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: AppDimensions.paddingXS),
                    Text(
                      _getSecurityLevelText(securityLevel),
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: _getSecurityLevelColor(securityLevel),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: AppDimensions.paddingL),
          LinearProgressIndicator(
            value: securityLevel / 100,
            backgroundColor: AppColors.grey200,
            valueColor: AlwaysStoppedAnimation(
              _getSecurityLevelColor(securityLevel),
            ),
          ),
          SizedBox(height: AppDimensions.paddingS),
          Text(
            '$securityLevel% امن',
            style: AppTextStyles.bodySmall.copyWith(color: AppColors.grey600),
          ),
        ],
      ),
    );
  }

  Widget _buildPasswordSection(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: EdgeInsets.all(AppDimensions.paddingL),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.white,
        borderRadius: BorderRadius.circular(AppDimensions.radiusL),
        boxShadow: [
          BoxShadow(
            color: isDark ? AppColors.shadowDark : AppColors.shadowLight,
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.lock_outline, color: AppColors.primary),
              SizedBox(width: AppDimensions.paddingS),
              Text(
                'رمز عبور',
                style: AppTextStyles.headlineSmall.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: AppDimensions.paddingL),

          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.warning.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(
                Icons.key_outlined,
                color: AppColors.warning,
                size: 20,
              ),
            ),
            title: Text(context.tr('change_password')),
            subtitle: Text(
              '${context.tr('last_change')}: $_lastPasswordChange',
            ),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: _changePassword,
          ),

          const Divider(),

          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.info.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(Icons.history, color: AppColors.info, size: 20),
            ),
            title: Text(context.tr('password_history')),
            subtitle: Text(context.tr('view_recent_changes')),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: _showPasswordHistory,
          ),
        ],
      ),
    );
  }

  Widget _buildTwoFactorSection(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: EdgeInsets.all(AppDimensions.paddingL),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.white,
        borderRadius: BorderRadius.circular(AppDimensions.radiusL),
        boxShadow: [
          BoxShadow(
            color: isDark ? AppColors.shadowDark : AppColors.shadowLight,
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.security_outlined, color: AppColors.primary),
              SizedBox(width: AppDimensions.paddingS),
              Text(
                'تأیید دو مرحله‌ای',
                style: AppTextStyles.headlineSmall.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: AppDimensions.paddingS),
          Text(
            'امنیت بیشتر با کد تأیید پیامکی یا برنامه‌های احراز هویت',
            style: AppTextStyles.bodySmall.copyWith(color: AppColors.grey600),
          ),
          SizedBox(height: AppDimensions.paddingL),

          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            secondary: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color:
                    (_twoFactorEnabled ? AppColors.success : AppColors.grey400)
                        .withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(
                _twoFactorEnabled ? Icons.verified_user : Icons.security,
                color: _twoFactorEnabled
                    ? AppColors.success
                    : AppColors.grey400,
                size: 20,
              ),
            ),
            title: Text(context.tr('enable_two_factor')),
            subtitle: Text(
              _twoFactorEnabled
                  ? 'حساب شما با تأیید دو مرحله‌ای محافظت می‌شود'
                  : 'برای امنیت بیشتر فعال کنید',
            ),
            value: _twoFactorEnabled,
            onChanged: _toggleTwoFactor,
          ),

          if (_twoFactorEnabled) ...[
            SizedBox(height: AppDimensions.paddingM),
            Container(
              padding: EdgeInsets.all(AppDimensions.paddingM),
              decoration: BoxDecoration(
                color: AppColors.success.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                border: Border.all(
                  color: AppColors.success.withValues(alpha: 0.3),
                ),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.check_circle,
                        color: AppColors.success,
                        size: 20,
                      ),
                      SizedBox(width: AppDimensions.paddingS),
                      Expanded(
                        child: Text(
                          'تأیید دو مرحله‌ای فعال است',
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.success,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: AppDimensions.paddingS),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: _manageTwoFactorMethods,
                          icon: const Icon(Icons.settings, size: 18),
                          label: Text(context.tr('manage_methods')),
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(color: AppColors.success),
                            foregroundColor: AppColors.success,
                          ),
                        ),
                      ),
                      SizedBox(width: AppDimensions.paddingS),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: _showBackupCodes,
                          icon: const Icon(Icons.code, size: 18),
                          label: Text(context.tr('recovery_codes')),
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(color: AppColors.success),
                            foregroundColor: AppColors.success,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildBiometricSection(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: EdgeInsets.all(AppDimensions.paddingL),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.white,
        borderRadius: BorderRadius.circular(AppDimensions.radiusL),
        boxShadow: [
          BoxShadow(
            color: isDark ? AppColors.shadowDark : AppColors.shadowLight,
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.fingerprint_outlined, color: AppColors.primary),
              SizedBox(width: AppDimensions.paddingS),
              Text(
                'احراز هویت بیومتریک',
                style: AppTextStyles.headlineSmall.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: AppDimensions.paddingL),

          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            secondary: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: (_biometricEnabled ? AppColors.info : AppColors.grey400)
                    .withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(
                _biometricEnabled
                    ? Icons.fingerprint
                    : Icons.fingerprint_outlined,
                color: _biometricEnabled ? AppColors.info : AppColors.grey400,
                size: 20,
              ),
            ),
            title: Text(context.tr('fingerprint_login')),
            subtitle: Text(context.tr('fingerprint_description')),
            value: _biometricEnabled,
            onChanged: (value) {
              setState(() {
                _biometricEnabled = value;
              });
              _showSecurityMessage(
                _biometricEnabled
                    ? 'احراز هویت بیومتریک فعال شد'
                    : 'احراز هویت بیومتریک غیرفعال شد',
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationSettings(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: EdgeInsets.all(AppDimensions.paddingL),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.white,
        borderRadius: BorderRadius.circular(AppDimensions.radiusL),
        boxShadow: [
          BoxShadow(
            color: isDark ? AppColors.shadowDark : AppColors.shadowLight,
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.notifications_outlined, color: AppColors.primary),
              SizedBox(width: AppDimensions.paddingS),
              Text(
                'هشدارهای امنیتی',
                style: AppTextStyles.headlineSmall.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: AppDimensions.paddingL),

          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            secondary: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color:
                    (_loginNotifications
                            ? AppColors.warning
                            : AppColors.grey400)
                        .withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(
                Icons.login,
                color: _loginNotifications
                    ? AppColors.warning
                    : AppColors.grey400,
                size: 20,
              ),
            ),
            title: Text(context.tr('login_notifications')),
            subtitle: Text(context.tr('login_notifications_description')),
            value: _loginNotifications,
            onChanged: (value) {
              setState(() {
                _loginNotifications = value;
              });
            },
          ),

          SizedBox(height: AppDimensions.paddingM),

          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            secondary: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color:
                    (_suspiciousActivityAlerts
                            ? AppColors.error
                            : AppColors.grey400)
                        .withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(
                Icons.warning_outlined,
                color: _suspiciousActivityAlerts
                    ? AppColors.error
                    : AppColors.grey400,
                size: 20,
              ),
            ),
            title: Text(context.tr('suspicious_activity')),
            subtitle: Text(context.tr('suspicious_activity_description')),
            value: _suspiciousActivityAlerts,
            onChanged: (value) {
              setState(() {
                _suspiciousActivityAlerts = value;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildActiveSessionsSection(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: EdgeInsets.all(AppDimensions.paddingL),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.white,
        borderRadius: BorderRadius.circular(AppDimensions.radiusL),
        boxShadow: [
          BoxShadow(
            color: isDark ? AppColors.shadowDark : AppColors.shadowLight,
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.devices_outlined, color: AppColors.primary),
              SizedBox(width: AppDimensions.paddingS),
              Expanded(
                child: Text(
                  'دستگاه‌های فعال',
                  style: AppTextStyles.headlineSmall.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              TextButton(
                onPressed: _terminateAllSessions,
                style: TextButton.styleFrom(foregroundColor: AppColors.error),
                child: Text(context.tr('logout_all')),
              ),
            ],
          ),
          SizedBox(height: AppDimensions.paddingL),

          ..._activeSessions.map((session) => _buildSessionItem(session)),
        ],
      ),
    );
  }

  Widget _buildSessionItem(LoginSession session) {
    return Container(
      margin: EdgeInsets.only(bottom: AppDimensions.paddingM),
      padding: EdgeInsets.all(AppDimensions.paddingM),
      decoration: BoxDecoration(
        color: session.isCurrent
            ? AppColors.primary.withValues(alpha: 0.1)
            : AppColors.grey100,
        borderRadius: BorderRadius.circular(AppDimensions.radiusM),
        border: session.isCurrent
            ? Border.all(color: AppColors.primary.withValues(alpha: 0.3))
            : null,
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(
                _getDeviceIcon(session.device),
                color: session.isCurrent
                    ? AppColors.primary
                    : AppColors.grey600,
                size: 20,
              ),
              SizedBox(width: AppDimensions.paddingS),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          session.device,
                          style: AppTextStyles.bodyMedium.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        if (session.isCurrent) ...[
                          SizedBox(width: AppDimensions.paddingS),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.success,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              'فعلی',
                              style: AppTextStyles.labelSmall.copyWith(
                                color: AppColors.white,
                                fontSize: 10.0.sp,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    SizedBox(height: AppDimensions.paddingXS),
                    Text(
                      '${session.location} • ${session.lastActive}',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.grey600,
                      ),
                    ),
                  ],
                ),
              ),
              if (!session.isCurrent)
                IconButton(
                  onPressed: () => _terminateSession(session),
                  icon: Icon(Icons.logout, color: AppColors.error, size: 20),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPrivacyActions(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: EdgeInsets.all(AppDimensions.paddingL),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.white,
        borderRadius: BorderRadius.circular(AppDimensions.radiusL),
        boxShadow: [
          BoxShadow(
            color: isDark ? AppColors.shadowDark : AppColors.shadowLight,
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.privacy_tip_outlined, color: AppColors.primary),
              SizedBox(width: AppDimensions.paddingS),
              Text(
                'حریم خصوصی و داده‌ها',
                style: AppTextStyles.headlineSmall.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: AppDimensions.paddingL),

          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.info.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(
                Icons.download_outlined,
                color: AppColors.info,
                size: 20,
              ),
            ),
            title: Text(context.tr('download_personal_data')),
            subtitle: Text(context.tr('download_personal_data_description')),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: _downloadPersonalData,
          ),

          const Divider(),

          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.warning.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(
                Icons.delete_forever_outlined,
                color: AppColors.warning,
                size: 20,
              ),
            ),
            title: Text(context.tr('delete_account')),
            subtitle: Text(context.tr('delete_account_description')),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: _deleteAccount,
          ),
        ],
      ),
    );
  }

  // Helper methods
  int _calculateSecurityLevel() {
    int level = 30; // Base level
    if (_twoFactorEnabled) level += 30;
    if (_biometricEnabled) level += 20;
    if (_loginNotifications) level += 10;
    if (_suspiciousActivityAlerts) level += 10;
    return level.clamp(0, 100);
  }

  Color _getSecurityLevelColor(int level) {
    if (level >= 80) return AppColors.success;
    if (level >= 60) return AppColors.warning;
    return AppColors.error;
  }

  IconData _getSecurityLevelIcon(int level) {
    if (level >= 80) return Icons.shield;
    if (level >= 60) return Icons.shield_outlined;
    return Icons.warning_outlined;
  }

  String _getSecurityLevelText(int level) {
    if (level >= 80) return 'عالی';
    if (level >= 60) return 'متوسط';
    return 'ضعیف';
  }

  IconData _getDeviceIcon(String device) {
    if (device.contains('Chrome') || device.contains('Safari')) {
      return Icons.computer;
    } else if (device.contains('موبایل') || device.contains('iPhone')) {
      return Icons.phone_android;
    }
    return Icons.device_unknown;
  }

  void _showSecurityMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: AppColors.success),
    );
  }

  // Action methods
  void _changePassword() {
    showDialog(context: context, builder: (context) => ChangePasswordDialog());
  }

  void _showPasswordHistory() {
    // TODO: Show password history
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(context.tr('password_history_view'))),
    );
  }

  void _toggleTwoFactor(bool? value) {
    if (value == true) {
      _showTwoFactorSetupDialog();
    } else {
      _showTwoFactorDisableDialog();
    }
  }

  void _showTwoFactorSetupDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(context.tr('enable_two_factor_title')),
        content: const Text(
          'برای فعال‌سازی تأیید دو مرحله‌ای، شماره موبایل خود را تأیید کنید.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('انصراف'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _twoFactorEnabled = true;
              });
              _showSecurityMessage('تأیید دو مرحله‌ای فعال شد');
            },
            child: Text(context.tr('confirm')),
          ),
        ],
      ),
    );
  }

  void _showTwoFactorDisableDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(context.tr('disable_two_factor')),
        content: const Text(
          'آیا مطمئن هستید که می‌خواهید تأیید دو مرحله‌ای را غیرفعال کنید؟ این کار امنیت حساب شما را کاهش می‌دهد.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('انصراف'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _twoFactorEnabled = false;
              });
              _showSecurityMessage('تأیید دو مرحله‌ای غیرفعال شد');
            },
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: Text(context.tr('disable')),
          ),
        ],
      ),
    );
  }

  void _manageTwoFactorMethods() {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(context.tr('two_factor_methods'))));
  }

  void _showBackupCodes() {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(context.tr('show_recovery_codes'))));
  }

  void _terminateSession(LoginSession session) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(context.tr('logout_device')),
        content: Text(
          'آیا مطمئن هستید که می‌خواهید از "${session.device}" خارج شوید؟',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('انصراف'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _activeSessions.removeWhere((s) => s.id == session.id);
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    '${context.tr('logged_out_from_device')}: ${session.device}',
                  ),
                ),
              );
            },
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: Text(context.tr('logout')),
          ),
        ],
      ),
    );
  }

  void _terminateAllSessions() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(context.tr('logout_all_devices')),
        content: const Text(
          'آیا مطمئن هستید که می‌خواهید از تمام دستگاه‌ها به جز دستگاه فعلی خارج شوید؟',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('انصراف'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _activeSessions.removeWhere((s) => !s.isCurrent);
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(context.tr('logged_out_all_devices'))),
              );
            },
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: const Text('خروج از همه'),
          ),
        ],
      ),
    );
  }

  void _downloadPersonalData() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(context.tr('download_request_sent'))),
    );
  }

  void _deleteAccount() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.warning, color: AppColors.error),
            SizedBox(width: 8.0.w),
            Text(context.tr('delete_account_title')),
          ],
        ),
        content: const Text(
          'هشدار: این عمل غیرقابل بازگشت است و تمام اطلاعات شما حذف خواهد شد.\n\nآیا مطمئن هستید؟',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('انصراف'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(context.tr('delete_account_request_sent')),
                  backgroundColor: AppColors.error,
                ),
              );
            },
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: const Text('حذف حساب'),
          ),
        ],
      ),
    );
  }
}

// Change Password Dialog
class ChangePasswordDialog extends StatefulWidget {
  const ChangePasswordDialog({super.key});

  @override
  State<ChangePasswordDialog> createState() => _ChangePasswordDialogState();
}

class _ChangePasswordDialogState extends State<ChangePasswordDialog> {
  final _formKey = GlobalKey<FormState>();
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _obscureCurrentPassword = true;
  bool _obscureNewPassword = true;
  bool _obscureConfirmPassword = true;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(context.tr('change_password')),
      content: SizedBox(
        width: double.maxFinite,
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _currentPasswordController,
                obscureText: _obscureCurrentPassword,
                decoration: InputDecoration(
                  labelText: 'رمز عبور فعلی',
                  prefixIcon: const Icon(Icons.lock_outlined),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureCurrentPassword
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                    onPressed: () => setState(
                      () => _obscureCurrentPassword = !_obscureCurrentPassword,
                    ),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'رمز عبور فعلی را وارد کنید';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0.h),
              TextFormField(
                controller: _newPasswordController,
                obscureText: _obscureNewPassword,
                decoration: InputDecoration(
                  labelText: 'رمز عبور جدید',
                  prefixIcon: const Icon(Icons.lock),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureNewPassword
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                    onPressed: () => setState(
                      () => _obscureNewPassword = !_obscureNewPassword,
                    ),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'رمز عبور جدید را وارد کنید';
                  }
                  if (value.length < 8) {
                    return 'رمز عبور باید حداقل ۸ کاراکتر باشد';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0.h),
              TextFormField(
                controller: _confirmPasswordController,
                obscureText: _obscureConfirmPassword,
                decoration: InputDecoration(
                  labelText: 'تکرار رمز عبور جدید',
                  prefixIcon: const Icon(Icons.lock_reset),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureConfirmPassword
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                    onPressed: () => setState(
                      () => _obscureConfirmPassword = !_obscureConfirmPassword,
                    ),
                  ),
                ),
                validator: (value) {
                  if (value != _newPasswordController.text) {
                    return 'رمز عبور تطابق ندارد';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('انصراف'),
        ),
        ElevatedButton(
          onPressed: _isLoading ? null : _changePassword,
          child: _isLoading
              ? const CircularProgressIndicator()
              : Text(context.tr('change_password')),
        ),
      ],
    );
  }

  void _changePassword() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 2));
    setState(() => _isLoading = false);

    if (!mounted) return;

    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(context.tr('password_changed_successfully')),
        backgroundColor: AppColors.success,
      ),
    );
  }
}

// Login Session Model
class LoginSession {
  final String id;
  final String device;
  final String location;
  final String ipAddress;
  final String lastActive;
  final bool isCurrent;

  LoginSession({
    required this.id,
    required this.device,
    required this.location,
    required this.ipAddress,
    required this.lastActive,
    required this.isCurrent,
  });
}
