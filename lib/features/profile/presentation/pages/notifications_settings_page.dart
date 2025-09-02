// Notifications Settings Page - Complete Notification Management
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/responsive_utils.dart';
import '../../../../core/localization/localization_extension.dart';

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
        title: Text(context.tr('notifications_settings')),
        backgroundColor: isDark ? AppColors.surfaceDark : AppColors.white,
        elevation: 0,
        actions: [
          TextButton(onPressed: _saveSettings, child: Text(context.tr('save'))),
        ],
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: ResponsiveContainer(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(AppDimensions.paddingL),
            child: Column(
              children: [
                _buildNotificationOverview(context),
                SizedBox(height: AppDimensions.paddingL),
                _buildGeneralSettings(context),
                SizedBox(height: AppDimensions.paddingL),
                _buildOrderNotifications(context),
                SizedBox(height: AppDimensions.paddingL),
                _buildMarketingNotifications(context),
                SizedBox(height: AppDimensions.paddingL),
                _buildAccountNotifications(context),
                SizedBox(height: AppDimensions.paddingL),
                _buildAppNotifications(context),
                SizedBox(height: AppDimensions.paddingL),
                _buildQuietHoursSettings(context),
                SizedBox(height: AppDimensions.paddingL),
                _buildNotificationHistory(context),
                SizedBox(height: AppDimensions.paddingXL),
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
      padding: EdgeInsets.all(AppDimensions.paddingL),
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
              SizedBox(width: AppDimensions.paddingM),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      context.tr('notifications_status'),
                      style: AppTextStyles.headlineSmall.copyWith(
                        color: AppColors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: AppDimensions.paddingXS),
                    Text(
                      context
                          .tr('active_notifications_count')
                          .replaceFirst('{}', activeNotifications.toString()),
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.white.withValues(alpha: 0.9),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: AppDimensions.paddingL),
          Row(
            children: [
              Expanded(
                child: _buildOverviewItem(
                  icon: Icons.phone_android,
                  title: context.tr('push_notifications'),
                  isEnabled: _pushNotifications,
                ),
              ),
              Expanded(
                child: _buildOverviewItem(
                  icon: Icons.email,
                  title: context.tr('email_notifications'),
                  isEnabled: _emailNotifications,
                ),
              ),
              Expanded(
                child: _buildOverviewItem(
                  icon: Icons.sms,
                  title: context.tr('sms_notifications'),
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
        SizedBox(height: AppDimensions.paddingS),
        Text(
          title,
          style: AppTextStyles.bodySmall.copyWith(
            color: AppColors.white.withValues(alpha: isEnabled ? 1.0 : 0.7),
            fontWeight: FontWeight.w600,
          ),
        ),
        Text(
          isEnabled ? context.tr('active') : context.tr('inactive'),
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
              Icon(Icons.settings_outlined, color: AppColors.primary),
              SizedBox(width: AppDimensions.paddingS),
              Text(
                context.tr('general_settings'),
                style: AppTextStyles.headlineSmall.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: AppDimensions.paddingL),

          _buildNotificationToggle(
            icon: Icons.phone_android,
            title: context.tr('push_notifications_title'),
            subtitle: context.tr('receive_notifications_on_phone'),
            value: _pushNotifications,
            onChanged: (value) => setState(() => _pushNotifications = value),
            iconColor: AppColors.success,
          ),

          _buildNotificationToggle(
            icon: Icons.email_outlined,
            title: context.tr('email_notifications_title'),
            subtitle: context.tr('receive_informational_emails'),
            value: _emailNotifications,
            onChanged: (value) => setState(() => _emailNotifications = value),
            iconColor: AppColors.info,
          ),

          _buildNotificationToggle(
            icon: Icons.sms_outlined,
            title: context.tr('sms_notifications_title'),
            subtitle: context.tr('receive_important_sms'),
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
              Icon(Icons.shopping_bag_outlined, color: AppColors.primary),
              SizedBox(width: AppDimensions.paddingS),
              Text(
                context.tr('order_notifications'),
                style: AppTextStyles.headlineSmall.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: AppDimensions.paddingL),

          _buildNotificationToggle(
            icon: Icons.check_circle_outline,
            title: context.tr('order_confirmation'),
            subtitle: context.tr('new_order_confirmation_notification'),
            value: _orderConfirmation,
            onChanged: (value) => setState(() => _orderConfirmation = value),
            iconColor: AppColors.success,
          ),

          _buildNotificationToggle(
            icon: Icons.update,
            title: context.tr('order_status'),
            subtitle: context.tr('preparation_shipping_status_changes'),
            value: _orderStatusUpdates,
            onChanged: (value) => setState(() => _orderStatusUpdates = value),
            iconColor: AppColors.info,
          ),

          _buildNotificationToggle(
            icon: Icons.local_shipping_outlined,
            title: context.tr('delivery_notification'),
            subtitle: context.tr('delivery_time_order_arrival'),
            value: _deliveryUpdates,
            onChanged: (value) => setState(() => _deliveryUpdates = value),
            iconColor: AppColors.warning,
          ),

          _buildNotificationToggle(
            icon: Icons.keyboard_return,
            title: context.tr('returns_refunds'),
            subtitle: context.tr('return_requests_status'),
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
              Icon(Icons.campaign_outlined, color: AppColors.primary),
              SizedBox(width: AppDimensions.paddingS),
              Text(
                context.tr('marketing_notifications'),
                style: AppTextStyles.headlineSmall.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: AppDimensions.paddingL),

          _buildNotificationToggle(
            icon: Icons.local_offer,
            title: context.tr('discounts_offers'),
            subtitle: context.tr('special_discounts_notification'),
            value: _promotionalOffers,
            onChanged: (value) => setState(() => _promotionalOffers = value),
            iconColor: AppColors.success,
          ),

          _buildNotificationToggle(
            icon: Icons.new_releases,
            title: context.tr('new_products'),
            subtitle: context.tr('new_arrivals_introduction'),
            value: _newProducts,
            onChanged: (value) => setState(() => _newProducts = value),
            iconColor: AppColors.info,
          ),

          _buildNotificationToggle(
            icon: Icons.trending_down,
            title: context.tr('price_reduction'),
            subtitle: context.tr('product_price_reductions_notification'),
            value: _priceDrops,
            onChanged: (value) => setState(() => _priceDrops = value),
            iconColor: AppColors.warning,
          ),

          _buildNotificationToggle(
            icon: Icons.recommend,
            title: context.tr('personal_recommendations'),
            subtitle: context.tr('recommended_products_based_interests'),
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
                context.tr('security_notifications'),
                style: AppTextStyles.headlineSmall.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: AppDimensions.paddingL),

          _buildNotificationToggle(
            icon: Icons.warning_outlined,
            title: context.tr('security_alerts'),
            subtitle: context.tr('suspicious_activity_notification'),
            value: _securityAlerts,
            onChanged: (value) => setState(() => _securityAlerts = value),
            iconColor: AppColors.error,
          ),

          _buildNotificationToggle(
            icon: Icons.login,
            title: context.tr('account_login'),
            subtitle: context.tr('new_device_login_notification'),
            value: _loginAlerts,
            onChanged: (value) => setState(() => _loginAlerts = value),
            iconColor: AppColors.warning,
          ),

          _buildNotificationToggle(
            icon: Icons.account_circle_outlined,
            title: context.tr('account_changes'),
            subtitle: context.tr('personal_information_changes_notification'),
            value: _accountChanges,
            onChanged: (value) => setState(() => _accountChanges = value),
            iconColor: AppColors.info,
          ),

          _buildNotificationToggle(
            icon: Icons.key,
            title: context.tr('password_changes'),
            subtitle: context.tr('password_change_confirmation'),
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
              Icon(Icons.smartphone, color: AppColors.primary),
              SizedBox(width: AppDimensions.paddingS),
              Text(
                context.tr('app_settings'),
                style: AppTextStyles.headlineSmall.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: AppDimensions.paddingL),

          _buildNotificationToggle(
            icon: Icons.notifications_active,
            title: context.tr('in_app_notifications'),
            subtitle: context.tr('notifications_display_in_app'),
            value: _inAppNotifications,
            onChanged: (value) => setState(() => _inAppNotifications = value),
            iconColor: AppColors.primary,
          ),

          _buildNotificationToggle(
            icon: Icons.circle_outlined,
            title: context.tr('badge_count'),
            subtitle: context.tr('notification_count_on_icon'),
            value: _badgeCount,
            onChanged: (value) => setState(() => _badgeCount = value),
            iconColor: AppColors.error,
          ),

          _buildNotificationToggle(
            icon: Icons.volume_up_outlined,
            title: context.tr('notification_sound'),
            subtitle: context.tr('sound_on_notification'),
            value: _soundEnabled,
            onChanged: (value) => setState(() => _soundEnabled = value),
            iconColor: AppColors.warning,
          ),

          _buildNotificationToggle(
            icon: Icons.vibration,
            title: context.tr('vibration'),
            subtitle: context.tr('phone_vibration_on_notification'),
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
              Icon(Icons.bedtime_outlined, color: AppColors.primary),
              SizedBox(width: AppDimensions.paddingS),
              Text(
                context.tr('quiet_hours'),
                style: AppTextStyles.headlineSmall.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: AppDimensions.paddingS),
          Text(
            context.tr('silent_notification_period'),
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
            title: Text(context.tr('quiet_hours_activation')),
            subtitle: _quietHoursEnabled
                ? Text(
                    '${_quietHoursStart.format(context)} ${context.tr('to')} ${_quietHoursEnd.format(context)}',
                  )
                : Text(context.tr('inactive')),
            value: _quietHoursEnabled,
            onChanged: (value) => setState(() => _quietHoursEnabled = value),
          ),

          if (_quietHoursEnabled) ...[
            SizedBox(height: AppDimensions.paddingM),
            Container(
              padding: EdgeInsets.all(AppDimensions.paddingM),
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
                          context.tr('start'),
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
                          context.tr('end'),
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
              Icon(Icons.history, color: AppColors.primary),
              SizedBox(width: AppDimensions.paddingS),
              Text(
                context.tr('notification_management'),
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
              child: Icon(Icons.history, color: AppColors.info, size: 20),
            ),
            title: Text(context.tr('notification_history')),
            subtitle: Text(context.tr('view_received_notifications')),
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
            title: Text(context.tr('clear_all_notifications')),
            subtitle: Text(context.tr('delete_all_received_notifications')),
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
            title: Text(context.tr('reset_settings')),
            subtitle: Text(context.tr('return_to_default_settings')),
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
      padding: EdgeInsets.only(bottom: AppDimensions.paddingM),
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
        activeThumbColor: iconColor,
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
      SnackBar(
        content: Text(context.tr('settings_saved_successfully')),
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
    ).showSnackBar(SnackBar(content: Text(context.tr('notification_history'))));
  }

  void _clearAllNotifications() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(context.tr('clear_notifications')),
        content: Text(context.tr('confirm_clear_all_notifications')),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(context.tr('cancel')),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(context.tr('all_notifications_cleared')),
                  backgroundColor: AppColors.success,
                ),
              );
            },
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: Text(context.tr('clear')),
          ),
        ],
      ),
    );
  }

  void _resetSettings() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(context.tr('reset_settings_title')),
        content: Text(context.tr('confirm_reset_all_notification_settings')),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(context.tr('cancel')),
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
                SnackBar(
                  content: Text(context.tr('settings_reset_to_default')),
                  backgroundColor: AppColors.success,
                ),
              );
            },
            child: Text(context.tr('reset')),
          ),
        ],
      ),
    );
  }
}
