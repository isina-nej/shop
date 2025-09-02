// Settings Page - Complete App Settings & User Preferences
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/responsive_utils.dart';
import '../../../../core/localization/localization_extension.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  // App Settings
  bool _isDarkMode = false;
  bool _isPushNotificationsEnabled = true;
  bool _isEmailNotificationsEnabled = true;
  bool _isSmsNotificationsEnabled = false;
  bool _isLocationEnabled = true;
  bool _isAnalyticsEnabled = true;
  bool _isAutoUpdateEnabled = true;
  bool _isBiometricEnabled = false;
  bool _isOfflineModeEnabled = false;

  String _selectedLanguage = 'fa';
  String _selectedTheme = 'system';
  String _selectedCurrency = 'IRR';
  String _selectedDateFormat = 'persian';

  double _cacheSize = 45.2; // MB

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
    _loadSettings();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _loadSettings() {
    // Load settings from storage
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark
          ? AppColors.backgroundDark
          : AppColors.backgroundLight,
      appBar: AppBar(
        title: Text(context.tr('settings')),
        backgroundColor: isDark ? AppColors.surfaceDark : AppColors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: _showSearchSettings,
          ),
          IconButton(
            icon: const Icon(Icons.restore),
            onPressed: _showResetDialog,
          ),
        ],
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: ResponsiveContainer(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(AppDimensions.paddingL),
            child: Column(
              children: [
                _buildUserProfileCard(context),
                SizedBox(height: AppDimensions.paddingL),
                _buildAppearanceSettings(context),
                SizedBox(height: AppDimensions.paddingL),
                _buildNotificationSettings(context),
                SizedBox(height: AppDimensions.paddingL),
                _buildPrivacySecuritySettings(context),
                SizedBox(height: AppDimensions.paddingL),
                _buildLanguageRegionSettings(context),
                SizedBox(height: AppDimensions.paddingL),
                _buildDataStorageSettings(context),
                SizedBox(height: AppDimensions.paddingL),
                _buildAdvancedSettings(context),
                SizedBox(height: AppDimensions.paddingL),
                _buildHelpAboutSettings(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildUserProfileCard(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppDimensions.paddingXL),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.primary, AppColors.primary.withValues(alpha: 0.8)],
        ),
        borderRadius: BorderRadius.circular(AppDimensions.radiusL),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.3),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: AppColors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(40),
            ),
            child: Icon(Icons.person, color: AppColors.white, size: 40),
          ),
          SizedBox(width: AppDimensions.paddingL),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'علی احمدی',
                  style: AppTextStyles.headlineSmall.copyWith(
                    color: AppColors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: AppDimensions.paddingS),
                Text(
                  'ali.ahmadi@email.com',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.white.withValues(alpha: 0.9),
                  ),
                ),
                SizedBox(height: AppDimensions.paddingS),
                Text(
                  'عضو از: آذر ۱۴۰۲',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.white.withValues(alpha: 0.8),
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () => Navigator.pushNamed(context, '/profile/edit'),
            icon: Icon(Icons.edit, color: AppColors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildAppearanceSettings(BuildContext context) {
    return _buildSettingsSection(
      title: 'ظاهر و نمایش',
      icon: Icons.palette,
      color: AppColors.primary,
      children: [
        _buildSwitchSetting(
          title: 'حالت تاریک',
          subtitle: 'استفاده از تم تاریک اپلیکیشن',
          icon: Icons.dark_mode,
          value: _isDarkMode,
          onChanged: (value) {
            setState(() => _isDarkMode = value);
            _showThemeChangeDialog();
          },
        ),

        _buildDropdownSetting(
          title: 'تم',
          subtitle: 'انتخاب تم اپلیکیشن',
          icon: Icons.color_lens,
          value: _selectedTheme,
          items: [
            DropdownMenuItem(
              value: 'system',
              child: Text(context.tr('system')),
            ),
            DropdownMenuItem(
              value: 'light',
              child: Text(context.tr('light_mode')),
            ),
            DropdownMenuItem(
              value: 'dark',
              child: Text(context.tr('dark_mode')),
            ),
          ],
          onChanged: (value) {
            setState(() => _selectedTheme = value!);
          },
        ),

        _buildActionSetting(
          title: 'اندازه فونت',
          subtitle: 'تغییر اندازه نوشته‌ها',
          icon: Icons.text_fields,
          onTap: _showFontSizeDialog,
        ),
      ],
    );
  }

  Widget _buildNotificationSettings(BuildContext context) {
    return _buildSettingsSection(
      title: 'اطلاعیه‌ها',
      icon: Icons.notifications,
      color: AppColors.warning,
      children: [
        _buildSwitchSetting(
          title: 'اطلاعیه‌های پوش',
          subtitle: 'دریافت اطلاعیه‌ها در دستگاه',
          icon: Icons.notifications_active,
          value: _isPushNotificationsEnabled,
          onChanged: (value) {
            setState(() => _isPushNotificationsEnabled = value);
          },
        ),

        _buildSwitchSetting(
          title: 'اطلاعیه‌های ایمیل',
          subtitle: 'دریافت ایمیل برای تغییرات مهم',
          icon: Icons.email,
          value: _isEmailNotificationsEnabled,
          onChanged: (value) {
            setState(() => _isEmailNotificationsEnabled = value);
          },
        ),

        _buildSwitchSetting(
          title: 'اطلاعیه‌های پیامک',
          subtitle: 'دریافت پیامک برای سفارشات',
          icon: Icons.sms,
          value: _isSmsNotificationsEnabled,
          onChanged: (value) {
            setState(() => _isSmsNotificationsEnabled = value);
          },
        ),

        _buildActionSetting(
          title: 'مدیریت اطلاعیه‌ها',
          subtitle: 'تنظیمات پیشرفته اطلاعیه‌ها',
          icon: Icons.tune,
          onTap: _showNotificationManagement,
        ),
      ],
    );
  }

  Widget _buildPrivacySecuritySettings(BuildContext context) {
    return _buildSettingsSection(
      title: 'حریم خصوصی و امنیت',
      icon: Icons.security,
      color: AppColors.error,
      children: [
        _buildSwitchSetting(
          title: 'احراز هویت زیستی',
          subtitle: 'ورود با اثر انگشت یا تشخیص چهره',
          icon: Icons.fingerprint,
          value: _isBiometricEnabled,
          onChanged: (value) {
            setState(() => _isBiometricEnabled = value);
            if (value) _enableBiometricAuth();
          },
        ),

        _buildSwitchSetting(
          title: 'خدمات مکان‌یابی',
          subtitle: 'استفاده از موقعیت مکانی شما',
          icon: Icons.location_on,
          value: _isLocationEnabled,
          onChanged: (value) {
            setState(() => _isLocationEnabled = value);
          },
        ),

        _buildSwitchSetting(
          title: 'تجزیه و تحلیل',
          subtitle: 'کمک به بهبود اپلیکیشن',
          icon: Icons.analytics,
          value: _isAnalyticsEnabled,
          onChanged: (value) {
            setState(() => _isAnalyticsEnabled = value);
          },
        ),

        _buildActionSetting(
          title: 'تغییر رمز عبور',
          subtitle: 'تغییر رمز عبور حساب کاربری',
          icon: Icons.lock,
          onTap: () => Navigator.pushNamed(context, '/profile/security'),
        ),

        _buildActionSetting(
          title: 'تنظیمات حریم خصوصی',
          subtitle: 'مدیریت اطلاعات شخصی',
          icon: Icons.privacy_tip,
          onTap: () => Navigator.pushNamed(context, '/privacy'),
        ),
      ],
    );
  }

  Widget _buildLanguageRegionSettings(BuildContext context) {
    return _buildSettingsSection(
      title: 'زبان و منطقه',
      icon: Icons.language,
      color: AppColors.info,
      children: [
        _buildDropdownSetting(
          title: 'زبان اپلیکیشن',
          subtitle: 'انتخاب زبان رابط کاربری',
          icon: Icons.translate,
          value: _selectedLanguage,
          items: [
            DropdownMenuItem(value: 'fa', child: Text(context.tr('persian'))),
            DropdownMenuItem(value: 'en', child: Text(context.tr('english'))),
            DropdownMenuItem(value: 'ar', child: Text(context.tr('arabic'))),
          ],
          onChanged: (value) {
            setState(() => _selectedLanguage = value!);
            _showLanguageChangeDialog();
          },
        ),

        _buildDropdownSetting(
          title: 'واحد پول',
          subtitle: 'انتخاب واحد نمایش قیمت‌ها',
          icon: Icons.monetization_on,
          value: _selectedCurrency,
          items: [
            DropdownMenuItem(
              value: 'IRR',
              child: Text(context.tr('iranian_rial')),
            ),
            DropdownMenuItem(
              value: 'USD',
              child: Text(context.tr('us_dollar')),
            ),
            DropdownMenuItem(value: 'EUR', child: Text(context.tr('euro'))),
          ],
          onChanged: (value) {
            setState(() => _selectedCurrency = value!);
          },
        ),

        _buildDropdownSetting(
          title: 'فرمت تاریخ',
          subtitle: 'نحوه نمایش تاریخ و زمان',
          icon: Icons.calendar_today,
          value: _selectedDateFormat,
          items: [
            DropdownMenuItem(
              value: 'persian',
              child: Text(context.tr('shamsi')),
            ),
            DropdownMenuItem(
              value: 'gregorian',
              child: Text(context.tr('gregorian')),
            ),
          ],
          onChanged: (value) {
            setState(() => _selectedDateFormat = value!);
          },
        ),
      ],
    );
  }

  Widget _buildDataStorageSettings(BuildContext context) {
    return _buildSettingsSection(
      title: 'ذخیره‌سازی و داده‌ها',
      icon: Icons.storage,
      color: AppColors.success,
      children: [
        _buildSwitchSetting(
          title: 'حالت آفلاین',
          subtitle: 'ذخیره محصولات برای استفاده آفلاین',
          icon: Icons.offline_pin,
          value: _isOfflineModeEnabled,
          onChanged: (value) {
            setState(() => _isOfflineModeEnabled = value);
          },
        ),

        _buildSwitchSetting(
          title: 'بروزرسانی خودکار',
          subtitle: 'دانلود خودکار بروزرسانی‌ها',
          icon: Icons.system_update,
          value: _isAutoUpdateEnabled,
          onChanged: (value) {
            setState(() => _isAutoUpdateEnabled = value);
          },
        ),

        _buildInfoSetting(
          title: 'حجم کش',
          subtitle: 'فضای اشغال شده: ${_cacheSize.toStringAsFixed(1)} مگابایت',
          icon: Icons.folder,
          trailing: TextButton(
            onPressed: _clearCache,
            child: Text(context.tr('clear')),
          ),
        ),

        _buildActionSetting(
          title: 'مدیریت دانلودها',
          subtitle: 'مشاهده و مدیریت فایل‌های دانلود شده',
          icon: Icons.download,
          onTap: _showDownloadManager,
        ),

        _buildActionSetting(
          title: 'پشتیبان‌گیری داده‌ها',
          subtitle: 'ذخیره تنظیمات در فضای ابری',
          icon: Icons.backup,
          onTap: _showBackupOptions,
        ),
      ],
    );
  }

  Widget _buildAdvancedSettings(BuildContext context) {
    return _buildSettingsSection(
      title: 'تنظیمات پیشرفته',
      icon: Icons.settings_applications,
      color: AppColors.grey600,
      children: [
        _buildActionSetting(
          title: 'گزارش‌های خرابی',
          subtitle: 'ارسال خودکار گزارش خرابی‌ها',
          icon: Icons.bug_report,
          onTap: _showCrashReportSettings,
        ),

        _buildActionSetting(
          title: 'حالت توسعه‌دهنده',
          subtitle: 'ابزارهای پیشرفته برای توسعه‌دهندگان',
          icon: Icons.developer_mode,
          onTap: _showDeveloperMode,
        ),

        _buildActionSetting(
          title: 'تنظیمات شبکه',
          subtitle: 'پروکسی، DNS و تنظیمات اتصال',
          icon: Icons.network_check,
          onTap: _showNetworkSettings,
        ),

        _buildActionSetting(
          title: 'صادرات تنظیمات',
          subtitle: 'ذخیره تنظیمات در فایل',
          icon: Icons.file_download,
          onTap: _exportSettings,
        ),
      ],
    );
  }

  Widget _buildHelpAboutSettings(BuildContext context) {
    return _buildSettingsSection(
      title: 'راهنما و درباره',
      icon: Icons.help,
      color: AppColors.primary,
      children: [
        _buildActionSetting(
          title: 'راهنمای استفاده',
          subtitle: 'آموزش نحوه استفاده از اپلیکیشن',
          icon: Icons.help_center,
          onTap: _showUserGuide,
        ),

        _buildActionSetting(
          title: 'سوالات متداول',
          subtitle: 'پاسخ سوالات رایج کاربران',
          icon: Icons.quiz,
          onTap: () => Navigator.pushNamed(context, '/faq'),
        ),

        _buildActionSetting(
          title: context.tr('contact_support'),
          subtitle: 'ارتباط با تیم پشتیبانی',
          icon: Icons.support_agent,
          onTap: () => Navigator.pushNamed(context, '/support'),
        ),

        _buildActionSetting(
          title: context.tr('about_app'),
          subtitle: context.tr('app_version_info'),
          icon: Icons.info,
          onTap: () => Navigator.pushNamed(context, '/about'),
        ),

        _buildInfoSetting(
          title: 'نسخه اپلیکیشن',
          subtitle: '۱.۲.۳ (Build ۱۰۰)',
          icon: Icons.verified,
          trailing: const Icon(Icons.check_circle, color: AppColors.success),
        ),
      ],
    );
  }

  Widget _buildSettingsSection({
    required String title,
    required IconData icon,
    required Color color,
    required List<Widget> children,
  }) {
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
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Icon(icon, color: color, size: 20),
              ),
              SizedBox(width: AppDimensions.paddingM),
              Text(
                title,
                style: AppTextStyles.headlineSmall.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: AppDimensions.paddingL),
          ...children,
        ],
      ),
    );
  }

  Widget _buildSwitchSetting({
    required String title,
    required String subtitle,
    required IconData icon,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return ListTile(
      leading: Icon(icon, color: AppColors.grey600),
      title: Text(
        title,
        style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.w600),
      ),
      subtitle: Text(subtitle),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeThumbColor: AppColors.primary,
      ),
      contentPadding: EdgeInsets.zero,
    );
  }

  Widget _buildDropdownSetting<T>({
    required String title,
    required String subtitle,
    required IconData icon,
    required T value,
    required List<DropdownMenuItem<T>> items,
    required ValueChanged<T?> onChanged,
  }) {
    return ListTile(
      leading: Icon(icon, color: AppColors.grey600),
      title: Text(
        title,
        style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.w600),
      ),
      subtitle: Text(subtitle),
      trailing: DropdownButton<T>(
        value: value,
        items: items,
        onChanged: onChanged,
        underline: SizedBox(),
      ),
      contentPadding: EdgeInsets.zero,
    );
  }

  Widget _buildActionSetting({
    required String title,
    required String subtitle,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: AppColors.grey600),
      title: Text(
        title,
        style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.w600),
      ),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
      contentPadding: EdgeInsets.zero,
    );
  }

  Widget _buildInfoSetting({
    required String title,
    required String subtitle,
    required IconData icon,
    Widget? trailing,
  }) {
    return ListTile(
      leading: Icon(icon, color: AppColors.grey600),
      title: Text(
        title,
        style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.w600),
      ),
      subtitle: Text(subtitle),
      trailing: trailing,
      contentPadding: EdgeInsets.zero,
    );
  }

  // Action Methods
  void _showSearchSettings() {
    showSearch(context: context, delegate: SettingsSearchDelegate());
  }

  void _showResetDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(context.tr('reset_settings')),
        content: const Text(
          'آیا مطمئن هستید که می‌خواهید تمام تنظیمات را به حالت پیش‌فرض بازگردانید؟',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(context.tr('cancel')),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _resetAllSettings();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              foregroundColor: AppColors.white,
            ),
            child: Text(context.tr('reset')),
          ),
        ],
      ),
    );
  }

  void _showThemeChangeDialog() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text(
          'تم تغییر کرد. لطفاً اپلیکیشن را مجدداً راه‌اندازی کنید.',
        ),
        action: SnackBarAction(
          label: 'راه‌اندازی مجدد',
          onPressed: () {
            // Restart app functionality
          },
        ),
      ),
    );
  }

  void _showFontSizeDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(context.tr('font_size')),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: Text(context.tr('small')),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              title: Text(context.tr('medium')),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              title: Text(context.tr('large')),
              onTap: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }

  void _showLanguageChangeDialog() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(context.tr('language_changed_restart')),
        duration: Duration(seconds: 3),
      ),
    );
  }

  void _enableBiometricAuth() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(context.tr('biometric_enabled')),
        backgroundColor: AppColors.success,
      ),
    );
  }

  void _showNotificationManagement() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(context.tr('notification_management_coming_soon')),
      ),
    );
  }

  void _clearCache() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(context.tr('clear_cache')),
        content: Text(
          '${_cacheSize.toStringAsFixed(1)} مگابایت کش پاک می‌شود.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('انصراف'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() => _cacheSize = 0.0);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(context.tr('cache_cleared')),
                  backgroundColor: AppColors.success,
                ),
              );
            },
            child: Text(context.tr('clear')),
          ),
        ],
      ),
    );
  }

  void _showDownloadManager() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(context.tr('download_management_coming_soon'))),
    );
  }

  void _showBackupOptions() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(context.tr('backup')),
        content: Text(context.tr('backup_google_drive_description')),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('انصراف'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(context.tr('backup_completed')),
                  backgroundColor: AppColors.success,
                ),
              );
            },
            child: Text(context.tr('save')),
          ),
        ],
      ),
    );
  }

  void _showCrashReportSettings() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(context.tr('crash_report_coming_soon'))),
    );
  }

  void _showDeveloperMode() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(context.tr('developer_mode_coming_soon'))),
    );
  }

  void _showNetworkSettings() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(context.tr('network_settings_coming_soon'))),
    );
  }

  void _exportSettings() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(context.tr('settings_exported')),
        backgroundColor: AppColors.success,
      ),
    );
  }

  void _showUserGuide() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(context.tr('user_guide_coming_soon'))),
    );
  }

  void _resetAllSettings() {
    setState(() {
      _isDarkMode = false;
      _isPushNotificationsEnabled = true;
      _isEmailNotificationsEnabled = true;
      _isSmsNotificationsEnabled = false;
      _isLocationEnabled = true;
      _isAnalyticsEnabled = true;
      _isAutoUpdateEnabled = true;
      _isBiometricEnabled = false;
      _isOfflineModeEnabled = false;
      _selectedLanguage = 'fa';
      _selectedTheme = 'system';
      _selectedCurrency = 'IRR';
      _selectedDateFormat = 'persian';
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(context.tr('all_settings_reset')),
        backgroundColor: AppColors.success,
      ),
    );
  }
}

// Settings Search Delegate
class SettingsSearchDelegate extends SearchDelegate<String> {
  final List<String> _searchData = [
    'تم تاریک',
    'اطلاعیه‌ها',
    'حریم خصوصی',
    'زبان',
    'کش',
    'پشتیبان‌گیری',
    'امنیت',
    'اثر انگشت',
    'رمز عبور',
  ];

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, '');
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return _buildSearchResults();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return _buildSearchResults();
  }

  Widget _buildSearchResults() {
    final results = _searchData
        .where((item) => item.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(results[index]),
          onTap: () {
            close(context, results[index]);
          },
        );
      },
    );
  }
}
