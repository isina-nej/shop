// Notifications Settings Page - Complete Notification Management
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/responsive_utils.dart';

class NotificationsSettingsPage extends StatefulWidget {
  const NotificationsSettingsPage({super.key});

  @override
  State<NotificationsSettingsPage> createState() =>
      _NotificationsSettingsPageState();
}

class _NotificationsSettingsPageState extends State<NotificationsSettingsPage>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  // Notification Settings
  bool _pushNotifications = true;
  bool _emailNotifications = true;
  bool _smsNotifications = true;

  // Order Notifications
  bool _orderConfirmation = true;
  bool _orderStatusUpdates = true;
  bool _deliveryUpdates = true;
  bool _orderReturns = true;

  // Marketing Notifications
  bool _promotionalOffers = true;
  bool _newProducts = false;
  bool _priceDrops = true;
  bool _personalizedRecommendations = true;

  // Account Notifications
  bool _securityAlerts = true;
  bool _loginAlerts = true;
  bool _accountChanges = true;
  bool _passwordChanges = true;

  // App Notifications
  bool _inAppNotifications = true;
  bool _badgeCount = true;
  bool _soundEnabled = true;
  bool _vibrationEnabled = true;

  // Timing Settings
  TimeOfDay _quietHoursStart = const TimeOfDay(hour: 22, minute: 0);
  TimeOfDay _quietHoursEnd = const TimeOfDay(hour: 8, minute: 0);
  bool _quietHoursEnabled = false;

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
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark
          ? AppColors.backgroundDark
          : AppColors.backgroundLight,
      appBar: AppBar(
        title: const Text('تنظیمات اعلان‌ها'),
        backgroundColor: isDark ? AppColors.surfaceDark : AppColors.white,
        elevation: 0,
        actions: [
          TextButton(onPressed: _saveSettings, child: const Text('ذخیره')),
        ],
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: ResponsiveContainer(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppDimensions.paddingL),
            child: Column(
              children: [
                _buildNotificationOverview(context),
                const SizedBox(height: AppDimensions.paddingL),
                _buildGeneralSettings(context),
                const SizedBox(height: AppDimensions.paddingL),
                _buildOrderNotifications(context),
                const SizedBox(height: AppDimensions.paddingL),
                _buildMarketingNotifications(context),
                const SizedBox(height: AppDimensions.paddingL),
                _buildAccountNotifications(context),
                const SizedBox(height: AppDimensions.paddingL),
                _buildAppNotifications(context),
                const SizedBox(height: AppDimensions.paddingL),
                _buildQuietHoursSettings(context),
                const SizedBox(height: AppDimensions.paddingL),
                _buildNotificationHistory(context),
                const SizedBox(height: AppDimensions.paddingXL),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNotificationOverview(BuildContext context) {
    final activeNotifications = _getActiveNotificationsCount();

    return Container(
      padding: const EdgeInsets.all(AppDimensions.paddingL),
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
                  color: AppColors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Icon(
                  Icons.notifications_active,
                  color: AppColors.white,
                  size: 30,
                ),
              ),
              const SizedBox(width: AppDimensions.paddingM),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'وضعیت اعلان‌ها',
                      style: AppTextStyles.headlineSmall.copyWith(
                        color: AppColors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: AppDimensions.paddingXS),
                    Text(
                      '$activeNotifications نوع اعلان فعال',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.white.withValues(alpha: 0.9),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.paddingL),
          Row(
            children: [
              Expanded(
                child: _buildOverviewItem(
                  icon: Icons.phone_android,
                  title: 'پوش',
                  isEnabled: _pushNotifications,
                ),
              ),
              Expanded(
                child: _buildOverviewItem(
                  icon: Icons.email,
                  title: 'ایمیل',
                  isEnabled: _emailNotifications,
                ),
              ),
              Expanded(
                child: _buildOverviewItem(
                  icon: Icons.sms,
                  title: 'پیامک',
                  isEnabled: _smsNotifications,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildOverviewItem({
    required IconData icon,
    required String title,
    required bool isEnabled,
  }) {
    return Column(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: AppColors.white.withValues(alpha: isEnabled ? 0.2 : 0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Icon(
            icon,
            color: AppColors.white.withValues(alpha: isEnabled ? 1.0 : 0.5),
            size: 20,
          ),
        ),
        const SizedBox(height: AppDimensions.paddingS),
        Text(
          title,
          style: AppTextStyles.bodySmall.copyWith(
            color: AppColors.white.withValues(alpha: isEnabled ? 1.0 : 0.7),
            fontWeight: FontWeight.w600,
          ),
        ),
        Text(
          isEnabled ? 'فعال' : 'غیرفعال',
          style: AppTextStyles.labelSmall.copyWith(
            color: AppColors.white.withValues(alpha: 0.7),
          ),
        ),
      ],
    );
  }

  Widget _buildGeneralSettings(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(AppDimensions.paddingL),
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
              Icon(Icons.settings_outlined, color: AppColors.primary),
              const SizedBox(width: AppDimensions.paddingS),
              Text(
                'تنظیمات عمومی',
                style: AppTextStyles.headlineSmall.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.paddingL),

          _buildNotificationToggle(
            icon: Icons.phone_android,
            title: 'اعلان‌های پوش',
            subtitle: 'دریافت اعلان‌ها در گوشی',
            value: _pushNotifications,
            onChanged: (value) => setState(() => _pushNotifications = value),
            iconColor: AppColors.success,
          ),

          _buildNotificationToggle(
            icon: Icons.email_outlined,
            title: 'اعلان‌های ایمیل',
            subtitle: 'دریافت ایمیل‌های اطلاع‌رسانی',
            value: _emailNotifications,
            onChanged: (value) => setState(() => _emailNotifications = value),
            iconColor: AppColors.info,
          ),

          _buildNotificationToggle(
            icon: Icons.sms_outlined,
            title: 'اعلان‌های پیامکی',
            subtitle: 'دریافت پیامک‌های مهم',
            value: _smsNotifications,
            onChanged: (value) => setState(() => _smsNotifications = value),
            iconColor: AppColors.warning,
          ),
        ],
      ),
    );
  }

  Widget _buildOrderNotifications(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(AppDimensions.paddingL),
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
              Icon(Icons.shopping_bag_outlined, color: AppColors.primary),
              const SizedBox(width: AppDimensions.paddingS),
              Text(
                'اعلان‌های سفارش',
                style: AppTextStyles.headlineSmall.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.paddingL),

          _buildNotificationToggle(
            icon: Icons.check_circle_outline,
            title: 'تأیید سفارش',
            subtitle: 'اطلاع از تأیید سفارش جدید',
            value: _orderConfirmation,
            onChanged: (value) => setState(() => _orderConfirmation = value),
            iconColor: AppColors.success,
          ),

          _buildNotificationToggle(
            icon: Icons.update,
            title: 'وضعیت سفارش',
            subtitle: 'تغییرات وضعیت آماده‌سازی و ارسال',
            value: _orderStatusUpdates,
            onChanged: (value) => setState(() => _orderStatusUpdates = value),
            iconColor: AppColors.info,
          ),

          _buildNotificationToggle(
            icon: Icons.local_shipping_outlined,
            title: 'اطلاع‌رسانی تحویل',
            subtitle: 'زمان تحویل و رسیدن سفارش',
            value: _deliveryUpdates,
            onChanged: (value) => setState(() => _deliveryUpdates = value),
            iconColor: AppColors.warning,
          ),

          _buildNotificationToggle(
            icon: Icons.keyboard_return,
            title: 'مرجوعی و بازگشت',
            subtitle: 'وضعیت درخواست‌های مرجوعی',
            value: _orderReturns,
            onChanged: (value) => setState(() => _orderReturns = value),
            iconColor: AppColors.error,
          ),
        ],
      ),
    );
  }

  Widget _buildMarketingNotifications(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(AppDimensions.paddingL),
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
              Icon(Icons.campaign_outlined, color: AppColors.primary),
              const SizedBox(width: AppDimensions.paddingS),
              Text(
                'اعلان‌های بازاریابی',
                style: AppTextStyles.headlineSmall.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.paddingL),

          _buildNotificationToggle(
            icon: Icons.local_offer,
            title: 'تخفیف‌ها و پیشنهادها',
            subtitle: 'اطلاع از تخفیف‌های ویژه',
            value: _promotionalOffers,
            onChanged: (value) => setState(() => _promotionalOffers = value),
            iconColor: AppColors.success,
          ),

          _buildNotificationToggle(
            icon: Icons.new_releases,
            title: 'محصولات جدید',
            subtitle: 'معرفی محصولات تازه وارد',
            value: _newProducts,
            onChanged: (value) => setState(() => _newProducts = value),
            iconColor: AppColors.info,
          ),

          _buildNotificationToggle(
            icon: Icons.trending_down,
            title: 'کاهش قیمت',
            subtitle: 'اطلاع از کاهش قیمت محصولات',
            value: _priceDrops,
            onChanged: (value) => setState(() => _priceDrops = value),
            iconColor: AppColors.warning,
          ),

          _buildNotificationToggle(
            icon: Icons.recommend,
            title: 'پیشنهادات شخصی',
            subtitle: 'محصولات پیشنهادی بر اساس علاقه‌مندی',
            value: _personalizedRecommendations,
            onChanged: (value) =>
                setState(() => _personalizedRecommendations = value),
            iconColor: AppColors.primary,
          ),
        ],
      ),
    );
  }

  Widget _buildAccountNotifications(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(AppDimensions.paddingL),
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
              const SizedBox(width: AppDimensions.paddingS),
              Text(
                'اعلان‌های امنیتی',
                style: AppTextStyles.headlineSmall.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.paddingL),

          _buildNotificationToggle(
            icon: Icons.warning_outlined,
            title: 'هشدارهای امنیتی',
            subtitle: 'اطلاع از فعالیت‌های مشکوک',
            value: _securityAlerts,
            onChanged: (value) => setState(() => _securityAlerts = value),
            iconColor: AppColors.error,
          ),

          _buildNotificationToggle(
            icon: Icons.login,
            title: 'ورود به حساب',
            subtitle: 'اطلاع از ورود از دستگاه جدید',
            value: _loginAlerts,
            onChanged: (value) => setState(() => _loginAlerts = value),
            iconColor: AppColors.warning,
          ),

          _buildNotificationToggle(
            icon: Icons.account_circle_outlined,
            title: 'تغییرات حساب',
            subtitle: 'اطلاع از تغییر اطلاعات شخصی',
            value: _accountChanges,
            onChanged: (value) => setState(() => _accountChanges = value),
            iconColor: AppColors.info,
          ),

          _buildNotificationToggle(
            icon: Icons.key,
            title: 'تغییر رمز عبور',
            subtitle: 'تأیید تغییر رمز عبور',
            value: _passwordChanges,
            onChanged: (value) => setState(() => _passwordChanges = value),
            iconColor: AppColors.success,
          ),
        ],
      ),
    );
  }

  Widget _buildAppNotifications(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(AppDimensions.paddingL),
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
              Icon(Icons.smartphone, color: AppColors.primary),
              const SizedBox(width: AppDimensions.paddingS),
              Text(
                'تنظیمات اپلیکیشن',
                style: AppTextStyles.headlineSmall.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.paddingL),

          _buildNotificationToggle(
            icon: Icons.notifications_active,
            title: 'اعلان‌های درون برنامه',
            subtitle: 'نمایش اعلان‌ها در برنامه',
            value: _inAppNotifications,
            onChanged: (value) => setState(() => _inAppNotifications = value),
            iconColor: AppColors.primary,
          ),

          _buildNotificationToggle(
            icon: Icons.circle_outlined,
            title: 'نشان تعداد',
            subtitle: 'نمایش تعداد اعلان‌ها روی آیکون',
            value: _badgeCount,
            onChanged: (value) => setState(() => _badgeCount = value),
            iconColor: AppColors.error,
          ),

          _buildNotificationToggle(
            icon: Icons.volume_up_outlined,
            title: 'صدای اعلان',
            subtitle: 'پخش صدا هنگام دریافت اعلان',
            value: _soundEnabled,
            onChanged: (value) => setState(() => _soundEnabled = value),
            iconColor: AppColors.warning,
          ),

          _buildNotificationToggle(
            icon: Icons.vibration,
            title: 'ارتعاش',
            subtitle: 'ارتعاش گوشی هنگام دریافت اعلان',
            value: _vibrationEnabled,
            onChanged: (value) => setState(() => _vibrationEnabled = value),
            iconColor: AppColors.info,
          ),
        ],
      ),
    );
  }

  Widget _buildQuietHoursSettings(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(AppDimensions.paddingL),
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
              Icon(Icons.bedtime_outlined, color: AppColors.primary),
              const SizedBox(width: AppDimensions.paddingS),
              Text(
                'ساعات سکوت',
                style: AppTextStyles.headlineSmall.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.paddingS),
          Text(
            'در این بازه زمانی اعلان‌ها بی‌صدا ارسال می‌شوند',
            style: AppTextStyles.bodySmall.copyWith(color: AppColors.grey600),
          ),
          const SizedBox(height: AppDimensions.paddingL),

          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            secondary: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color:
                    (_quietHoursEnabled ? AppColors.primary : AppColors.grey400)
                        .withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(
                Icons.bedtime,
                color: _quietHoursEnabled
                    ? AppColors.primary
                    : AppColors.grey400,
                size: 20,
              ),
            ),
            title: const Text('فعال‌سازی ساعات سکوت'),
            subtitle: _quietHoursEnabled
                ? Text(
                    '${_quietHoursStart.format(context)} تا ${_quietHoursEnd.format(context)}',
                  )
                : const Text('غیرفعال'),
            value: _quietHoursEnabled,
            onChanged: (value) => setState(() => _quietHoursEnabled = value),
          ),

          if (_quietHoursEnabled) ...[
            const SizedBox(height: AppDimensions.paddingM),
            Container(
              padding: const EdgeInsets.all(AppDimensions.paddingM),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                border: Border.all(
                  color: AppColors.primary.withValues(alpha: 0.3),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'شروع',
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.primary,
                          ),
                        ),
                        TextButton(
                          onPressed: () => _selectTime(true),
                          child: Text(
                            _quietHoursStart.format(context),
                            style: AppTextStyles.bodyLarge.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.arrow_forward),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'پایان',
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.primary,
                          ),
                        ),
                        TextButton(
                          onPressed: () => _selectTime(false),
                          child: Text(
                            _quietHoursEnd.format(context),
                            style: AppTextStyles.bodyLarge.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildNotificationHistory(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(AppDimensions.paddingL),
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
              Icon(Icons.history, color: AppColors.primary),
              const SizedBox(width: AppDimensions.paddingS),
              Text(
                'مدیریت اعلان‌ها',
                style: AppTextStyles.headlineSmall.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.paddingL),

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
            title: const Text('تاریخچه اعلان‌ها'),
            subtitle: const Text('مشاهده اعلان‌های دریافتی'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: _viewNotificationHistory,
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
              child: Icon(Icons.clear_all, color: AppColors.warning, size: 20),
            ),
            title: const Text('پاک کردن همه اعلان‌ها'),
            subtitle: const Text('حذف تمام اعلان‌های دریافتی'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: _clearAllNotifications,
          ),

          const Divider(),

          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.success.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(Icons.restore, color: AppColors.success, size: 20),
            ),
            title: const Text('بازنشانی تنظیمات'),
            subtitle: const Text('بازگشت به تنظیمات پیش‌فرض'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: _resetSettings,
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationToggle({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
    required Color iconColor,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppDimensions.paddingM),
      child: SwitchListTile(
        contentPadding: EdgeInsets.zero,
        secondary: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: (value ? iconColor : AppColors.grey400).withValues(
              alpha: 0.1,
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Icon(
            icon,
            color: value ? iconColor : AppColors.grey400,
            size: 20,
          ),
        ),
        title: Text(title),
        subtitle: Text(subtitle),
        value: value,
        onChanged: onChanged,
        activeColor: iconColor,
      ),
    );
  }

  // Helper methods
  int _getActiveNotificationsCount() {
    int count = 0;

    // General notifications
    if (_pushNotifications) count++;
    if (_emailNotifications) count++;
    if (_smsNotifications) count++;

    // Order notifications
    if (_orderConfirmation) count++;
    if (_orderStatusUpdates) count++;
    if (_deliveryUpdates) count++;
    if (_orderReturns) count++;

    // Marketing notifications
    if (_promotionalOffers) count++;
    if (_newProducts) count++;
    if (_priceDrops) count++;
    if (_personalizedRecommendations) count++;

    // Account notifications
    if (_securityAlerts) count++;
    if (_loginAlerts) count++;
    if (_accountChanges) count++;
    if (_passwordChanges) count++;

    // App notifications
    if (_inAppNotifications) count++;
    if (_badgeCount) count++;
    if (_soundEnabled) count++;
    if (_vibrationEnabled) count++;

    return count;
  }

  // Action methods
  void _saveSettings() {
    // Save settings to storage
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('تنظیمات با موفقیت ذخیره شد'),
        backgroundColor: AppColors.success,
      ),
    );
  }

  void _selectTime(bool isStart) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: isStart ? _quietHoursStart : _quietHoursEnd,
    );

    if (picked != null) {
      setState(() {
        if (isStart) {
          _quietHoursStart = picked;
        } else {
          _quietHoursEnd = picked;
        }
      });
    }
  }

  void _viewNotificationHistory() {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('تاریخچه اعلان‌ها')));
  }

  void _clearAllNotifications() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('پاک کردن اعلان‌ها'),
        content: const Text(
          'آیا مطمئن هستید که می‌خواهید همه اعلان‌ها را پاک کنید؟',
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
                const SnackBar(
                  content: Text('همه اعلان‌ها پاک شد'),
                  backgroundColor: AppColors.success,
                ),
              );
            },
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: const Text('پاک کن'),
          ),
        ],
      ),
    );
  }

  void _resetSettings() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('بازنشانی تنظیمات'),
        content: const Text(
          'آیا مطمئن هستید که می‌خواهید تمام تنظیمات اعلان‌ها را به حالت پیش‌فرض بازگردانید؟',
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
                // Reset all settings to default
                _pushNotifications = true;
                _emailNotifications = true;
                _smsNotifications = false;
                _orderConfirmation = true;
                _orderStatusUpdates = true;
                _deliveryUpdates = true;
                _orderReturns = true;
                _promotionalOffers = false;
                _newProducts = false;
                _priceDrops = true;
                _personalizedRecommendations = true;
                _securityAlerts = true;
                _loginAlerts = true;
                _accountChanges = true;
                _passwordChanges = true;
                _inAppNotifications = true;
                _badgeCount = true;
                _soundEnabled = true;
                _vibrationEnabled = true;
                _quietHoursEnabled = false;
              });
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('تنظیمات به حالت پیش‌فرض بازگشت'),
                  backgroundColor: AppColors.success,
                ),
              );
            },
            child: const Text('بازنشانی'),
          ),
        ],
      ),
    );
  }
}
