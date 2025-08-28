// Modern Profile Page - Redesigned for Better UX
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/advanced_theme_manager.dart';
import '../../../../core/localization/language_manager.dart';
import '../../../../core/localization/localization_extension.dart';
import '../../../../core/utils/responsive_utils.dart';
import '../../../../core/routing/app_router.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  // Mock user data
  final UserModel _user = const UserModel(
    id: '1',
    name: 'سینا احمدزاده',
    email: 'sina.ahmadzadeh@sinashop.com',
    phone: '09123456789',
    profileImage: 'assets/images/placeholders/user_avatar.png',
    joinDate: '۱۴۰۳/۰۵/۲۱',
    isVerified: true,
    totalOrders: 24,
    totalSpent: 12450000,
  );

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
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
    return Scaffold(
      backgroundColor: Theme.of(context).brightness == Brightness.dark
          ? AppColors.backgroundDark
          : AppColors.backgroundLight,
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: CustomScrollView(
          slivers: [
            _buildSliverAppBar(context),
            SliverToBoxAdapter(
              child: ResponsiveContainer(
                child: Column(
                  children: [
                    const SizedBox(height: AppDimensions.paddingL),
                    _buildStatsCards(context),
                    const SizedBox(height: AppDimensions.paddingXL),
                    _buildQuickActions(context),
                    const SizedBox(height: AppDimensions.paddingXL),
                    _buildMenuSections(context),
                    const SizedBox(height: AppDimensions.paddingXL),
                    _buildLogoutSection(context),
                    const SizedBox(height: AppDimensions.paddingXL),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSliverAppBar(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SliverAppBar(
      expandedHeight: 280.0,
      floating: false,
      pinned: true,
      backgroundColor: isDark ? AppColors.surfaceDark : AppColors.white,
      elevation: 0,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                AppColors.primary,
                AppColors.primary.withValues(alpha: 0.8),
              ],
            ),
          ),
          child: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 40),
                _buildProfileAvatar(context),
                const SizedBox(height: AppDimensions.paddingM),
                _buildUserInfo(context),
              ],
            ),
          ),
        ),
      ),
      actions: [
        IconButton(
          onPressed: () => _showSettingsBottomSheet(context),
          icon: const Icon(Icons.more_vert, color: AppColors.white),
        ),
      ],
    );
  }

  Widget _buildProfileAvatar(BuildContext context) {
    return Hero(
      tag: 'profile_avatar',
      child: Stack(
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(60),
              border: Border.all(color: AppColors.white, width: 4),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.2),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(56),
              child: Image.asset(
                _user.profileImage,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [AppColors.secondary, AppColors.accent],
                      ),
                    ),
                    child: const Icon(
                      Icons.person,
                      color: AppColors.white,
                      size: 60,
                    ),
                  );
                },
              ),
            ),
          ),

          // Verification Badge
          if (_user.isVerified)
            Positioned(
              bottom: 8,
              right: 8,
              child: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: AppColors.success,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: AppColors.white, width: 3),
                ),
                child: const Icon(
                  Icons.verified,
                  color: AppColors.white,
                  size: 18,
                ),
              ),
            ),

          // Edit Button
          Positioned(
            bottom: 8,
            left: 8,
            child: GestureDetector(
              onTap: () => _navigateToEditProfile(),
              child: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.camera_alt,
                  color: AppColors.primary,
                  size: 18,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserInfo(BuildContext context) {
    return Column(
      children: [
        Text(
          _user.name,
          style: AppTextStyles.headlineMedium.copyWith(
            color: AppColors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: AppDimensions.paddingXS),
        Text(
          _user.email,
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.white.withValues(alpha: 0.9),
          ),
        ),
        const SizedBox(height: AppDimensions.paddingS),
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.paddingM,
            vertical: AppDimensions.paddingXS,
          ),
          decoration: BoxDecoration(
            color: AppColors.white.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(AppDimensions.radiusS),
          ),
          child: Text(
            'عضو از ${_user.joinDate}',
            style: AppTextStyles.labelSmall.copyWith(
              color: AppColors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatsCards(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            context,
            title: 'تعداد سفارشات',
            value: '${_user.totalOrders}',
            icon: Icons.shopping_bag,
            color: AppColors.info,
            isDark: isDark,
          ),
        ),
        const SizedBox(width: AppDimensions.paddingM),
        Expanded(
          child: _buildStatCard(
            context,
            title: 'مجموع خرید',
            value: '${(_user.totalSpent / 1000).toStringAsFixed(0)}K تومان',
            icon: Icons.account_balance_wallet,
            color: AppColors.success,
            isDark: isDark,
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(
    BuildContext context, {
    required String title,
    required String value,
    required IconData icon,
    required Color color,
    required bool isDark,
  }) {
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
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(25),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(height: AppDimensions.paddingM),
          Text(
            value,
            style: AppTextStyles.headlineSmall.copyWith(
              fontWeight: FontWeight.bold,
              color: isDark
                  ? AppColors.textPrimaryDark
                  : AppColors.textPrimaryLight,
            ),
          ),
          const SizedBox(height: AppDimensions.paddingXS),
          Text(
            title,
            style: AppTextStyles.labelMedium.copyWith(color: AppColors.grey600),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
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
          Text(
            'دسترسی سریع',
            style: AppTextStyles.headlineSmall.copyWith(
              fontWeight: FontWeight.bold,
              color: isDark
                  ? AppColors.textPrimaryDark
                  : AppColors.textPrimaryLight,
            ),
          ),
          const SizedBox(height: AppDimensions.paddingL),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildQuickActionItem(
                context,
                icon: Icons.shopping_bag_outlined,
                title: 'سفارشات من',
                color: AppColors.primary,
                onTap: () => _navigateToOrders(),
              ),
              _buildQuickActionItem(
                context,
                icon: Icons.favorite_outline,
                title: 'علاقه‌مندی‌ها',
                color: AppColors.error,
                onTap: () => _navigateToWishlist(),
              ),
              _buildQuickActionItem(
                context,
                icon: Icons.location_on_outlined,
                title: 'آدرس‌ها',
                color: AppColors.info,
                onTap: () => _navigateToAddresses(),
              ),
              _buildQuickActionItem(
                context,
                icon: Icons.support_agent_outlined,
                title: 'پشتیبانی',
                color: AppColors.warning,
                onTap: () => _navigateToSupport(),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(28),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(height: AppDimensions.paddingS),
          Text(
            title,
            style: AppTextStyles.labelSmall.copyWith(
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildMenuSections(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      children: [
        // Account Settings
        _buildModernMenuSection(
          context,
          title: 'تنظیمات حساب کاربری',
          icon: Icons.person_outline,
          items: [
            ModernMenuItem(
              icon: Icons.edit_outlined,
              title: 'ویرایش اطلاعات شخصی',
              subtitle: 'نام، ایمیل، شماره تلفن',
              onTap: () => _navigateToEditProfile(),
            ),
            ModernMenuItem(
              icon: Icons.security_outlined,
              title: 'تنظیمات امنیتی',
              subtitle: 'تغییر رمز عبور، تأیید دو مرحله‌ای',
              onTap: () => _navigateToSecurity(),
            ),
            ModernMenuItem(
              icon: Icons.notifications_outlined,
              title: 'اعلان‌ها',
              subtitle: 'مدیریت اعلان‌های دریافتی',
              onTap: () => _navigateToNotifications(),
            ),
          ],
        ),

        const SizedBox(height: AppDimensions.paddingL),

        // Shopping
        _buildModernMenuSection(
          context,
          title: 'خرید و فروش',
          icon: Icons.shopping_cart_outlined,
          items: [
            ModernMenuItem(
              icon: Icons.receipt_long_outlined,
              title: 'تاریخچه سفارشات',
              subtitle: 'مشاهده سفارشات قبلی',
              onTap: () => _navigateToOrders(),
            ),
            ModernMenuItem(
              icon: Icons.rate_review_outlined,
              title: 'نظرات و امتیازها',
              subtitle: 'نظرات ثبت شده توسط شما',
              onTap: () => _navigateToReviews(),
            ),
            ModernMenuItem(
              icon: Icons.credit_card_outlined,
              title: 'کارت‌های بانکی',
              subtitle: 'مدیریت روش‌های پرداخت',
              onTap: () => _navigateToPaymentMethods(),
            ),
          ],
        ),

        const SizedBox(height: AppDimensions.paddingL),

        // App Settings
        _buildModernMenuSection(
          context,
          title: 'تنظیمات برنامه',
          icon: Icons.settings_outlined,
          items: [
            ModernMenuItem(
              icon: isDark
                  ? Icons.light_mode_outlined
                  : Icons.dark_mode_outlined,
              title: 'حالت تیره/روشن',
              subtitle: isDark ? 'تغییر به حالت روشن' : 'تغییر به حالت تیره',
              onTap: () => _toggleTheme(context),
              trailing: Switch(
                value: isDark,
                onChanged: (_) => _toggleTheme(context),
                activeColor: AppColors.primary,
              ),
            ),
            ModernMenuItem(
              icon: Icons.language_outlined,
              title: 'زبان برنامه',
              subtitle: context.languageManager.languageName,
              onTap: () => _showLanguageSelection(),
            ),
          ],
        ),

        const SizedBox(height: AppDimensions.paddingL),

        // Help & Support
        _buildModernMenuSection(
          context,
          title: 'راهنما و پشتیبانی',
          icon: Icons.help_outline,
          items: [
            ModernMenuItem(
              icon: Icons.quiz_outlined,
              title: 'سوالات متداول',
              subtitle: 'پاسخ سوالات رایج',
              onTap: () => _navigateToFAQ(),
            ),
            ModernMenuItem(
              icon: Icons.chat_bubble_outline,
              title: 'تماس با پشتیبانی',
              subtitle: 'درخواست کمک از تیم پشتیبانی',
              onTap: () => _navigateToSupport(),
            ),
            ModernMenuItem(
              icon: Icons.info_outline,
              title: 'درباره سینا شاپ',
              subtitle: 'اطلاعات برنامه و نسخه',
              onTap: () => _navigateToAbout(),
            ),
            ModernMenuItem(
              icon: Icons.policy_outlined,
              title: 'حریم خصوصی و قوانین',
              subtitle: 'شرایط استفاده و حریم خصوصی',
              onTap: () => _navigateToPrivacy(),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildModernMenuSection(
    BuildContext context, {
    required String title,
    required IconData icon,
    required List<ModernMenuItem> items,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
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
          // Section Header
          Container(
            padding: const EdgeInsets.all(AppDimensions.paddingL),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Icon(icon, color: AppColors.primary, size: 20),
                ),
                const SizedBox(width: AppDimensions.paddingM),
                Text(
                  title,
                  style: AppTextStyles.headlineSmall.copyWith(
                    fontWeight: FontWeight.bold,
                    color: isDark
                        ? AppColors.textPrimaryDark
                        : AppColors.textPrimaryLight,
                  ),
                ),
              ],
            ),
          ),

          // Menu Items
          ...items.asMap().entries.map((entry) {
            final index = entry.key;
            final item = entry.value;

            return Column(
              children: [
                if (index > 0)
                  Divider(
                    height: 1,
                    color: isDark ? AppColors.grey800 : AppColors.grey200,
                    indent: AppDimensions.paddingL,
                    endIndent: AppDimensions.paddingL,
                  ),
                _buildModernMenuItem(context, item),
              ],
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildModernMenuItem(BuildContext context, ModernMenuItem item) {
    return ListTile(
      onTap: item.onTap,
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: AppColors.grey100,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Icon(item.icon, color: AppColors.grey700, size: 20),
      ),
      title: Text(
        item.title,
        style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.w600),
      ),
      subtitle: item.subtitle != null
          ? Text(
              item.subtitle!,
              style: AppTextStyles.bodySmall.copyWith(color: AppColors.grey600),
            )
          : null,
      trailing:
          item.trailing ??
          Icon(Icons.arrow_forward_ios, size: 16, color: AppColors.grey500),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.paddingL,
        vertical: AppDimensions.paddingXS,
      ),
    );
  }

  Widget _buildLogoutSection(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
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
      child: ListTile(
        onTap: () => _showLogoutDialog(context),
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: AppColors.error.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Icon(Icons.logout, color: AppColors.error, size: 20),
        ),
        title: Text(
          'خروج از حساب کاربری',
          style: AppTextStyles.bodyLarge.copyWith(
            fontWeight: FontWeight.w600,
            color: AppColors.error,
          ),
        ),
        subtitle: Text(
          'خروج امن از حساب کاربری',
          style: AppTextStyles.bodySmall.copyWith(color: AppColors.grey600),
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          size: 16,
          color: AppColors.error,
        ),
        contentPadding: const EdgeInsets.all(AppDimensions.paddingL),
      ),
    );
  }

  // Theme Toggle
  void _toggleTheme(BuildContext context) {
    final themeManager = Provider.of<AdvancedThemeManager>(
      context,
      listen: false,
    );
    themeManager.toggleTheme();
  }

  // Navigation Methods with proper routing
  void _navigateToEditProfile() {
    Navigator.pushNamed(context, '/edit-profile');
  }

  void _navigateToSecurity() {
    Navigator.pushNamed(context, '/security-settings');
  }

  void _navigateToAddresses() {
    Navigator.pushNamed(context, '/addresses');
  }

  void _navigateToPaymentMethods() {
    Navigator.pushNamed(context, '/payment-methods');
  }

  void _navigateToOrders() {
    Navigator.pushNamed(context, AppRouter.orders);
  }

  void _navigateToWishlist() {
    Navigator.pushNamed(context, AppRouter.wishlist);
  }

  void _navigateToReviews() {
    Navigator.pushNamed(context, '/reviews');
  }

  void _navigateToNotifications() {
    Navigator.pushNamed(context, '/notifications');
  }

  void _navigateToFAQ() {
    Navigator.pushNamed(context, '/faq');
  }

  void _navigateToSupport() {
    Navigator.pushNamed(context, '/support');
  }

  void _navigateToAbout() {
    Navigator.pushNamed(context, '/about');
  }

  void _navigateToPrivacy() {
    Navigator.pushNamed(context, '/privacy');
  }

  // Dialog Methods
  void _showSettingsBottomSheet(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: isDark ? AppColors.surfaceDark : AppColors.white,
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(AppDimensions.radiusL),
          ),
        ),
        padding: const EdgeInsets.all(AppDimensions.paddingL),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.grey300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: AppDimensions.paddingL),
            Text(
              'تنظیمات بیشتر',
              style: AppTextStyles.headlineSmall.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppDimensions.paddingL),
            ListTile(
              leading: const Icon(Icons.share_outlined),
              title: Text(context.tr('share_profile')),
              onTap: () {
                Navigator.pop(context);
                // TODO: Implement profile sharing
              },
            ),
            ListTile(
              leading: const Icon(Icons.qr_code_outlined),
              title: Text(context.tr('show_qr_code')),
              onTap: () {
                Navigator.pop(context);
                // TODO: Show QR code
              },
            ),
            ListTile(
              leading: const Icon(Icons.backup_outlined),
              title: Text(context.tr('backup_data')),
              onTap: () {
                Navigator.pop(context);
                // TODO: Implement data backup
              },
            ),
            const SizedBox(height: AppDimensions.paddingL),
          ],
        ),
      ),
    );
  }

  void _showLanguageSelection() {
    final languageManager = Provider.of<LanguageManager>(
      context,
      listen: false,
    );
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: isDark ? AppColors.surfaceDark : AppColors.white,
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(AppDimensions.radiusL),
          ),
        ),
        padding: const EdgeInsets.all(AppDimensions.paddingL),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.grey300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: AppDimensions.paddingL),
              Text(
                'انتخاب زبان',
                style: AppTextStyles.headlineSmall.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: AppDimensions.paddingL),
              ...LanguageManager.supportedLocales.map((locale) {
                final languageData = _getLanguageData(locale.languageCode);

                return Container(
                  margin: const EdgeInsets.only(bottom: AppDimensions.paddingS),
                  decoration: BoxDecoration(
                    color:
                        languageManager.locale.languageCode ==
                            locale.languageCode
                        ? AppColors.primary.withValues(alpha: 0.1)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                    border:
                        languageManager.locale.languageCode ==
                            locale.languageCode
                        ? Border.all(color: AppColors.primary)
                        : null,
                  ),
                  child: ListTile(
                    leading: Text(
                      languageData['flag']!,
                      style: const TextStyle(fontSize: 28),
                    ),
                    title: Text(
                      languageData['name']!,
                      style: AppTextStyles.bodyLarge.copyWith(
                        fontWeight:
                            languageManager.locale.languageCode ==
                                locale.languageCode
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    ),
                    subtitle: Text(languageData['nativeName']!),
                    trailing:
                        languageManager.locale.languageCode ==
                            locale.languageCode
                        ? Icon(Icons.check_circle, color: AppColors.primary)
                        : null,
                    onTap: () async {
                      switch (locale.languageCode) {
                        case 'fa':
                          await languageManager.setFarsi();
                          break;
                        case 'en':
                          await languageManager.setEnglish();
                          break;
                        case 'ar':
                          await languageManager.setArabic();
                          break;
                        case 'ru':
                          await languageManager.setRussian();
                          break;
                        case 'zh':
                          await languageManager.setChinese();
                          break;
                      }
                      Navigator.of(context).pop();
                    },
                  ),
                );
              }).toList(),
              const SizedBox(height: AppDimensions.paddingL),
            ],
          ),
        ),
      ),
    );
  }

  Map<String, String> _getLanguageData(String languageCode) {
    switch (languageCode) {
      case 'fa':
        return {'flag': '🇮🇷', 'name': 'فارسی', 'nativeName': 'Persian'};
      case 'en':
        return {'flag': '🇺🇸', 'name': 'English', 'nativeName': 'English'};
      case 'ar':
        return {'flag': '🇸🇦', 'name': 'العربية', 'nativeName': 'Arabic'};
      case 'ru':
        return {'flag': '🇷🇺', 'name': 'Русский', 'nativeName': 'Russian'};
      case 'zh':
        return {'flag': '🇨🇳', 'name': '中文', 'nativeName': 'Chinese'};
      default:
        return {
          'flag': '🌐',
          'name': languageCode.toUpperCase(),
          'nativeName': 'Unknown',
        };
    }
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusM),
        ),
        icon: Icon(Icons.logout, color: AppColors.error, size: 48),
        title: Text(
          'خروج از حساب کاربری',
          style: AppTextStyles.headlineSmall.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          'آیا مطمئن هستید که می‌خواهید از حساب کاربری خود خارج شوید؟\n\nشما می‌توانید دوباره با اطلاعات خود وارد شوید.',
          style: AppTextStyles.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('انصراف', style: TextStyle(color: AppColors.grey600)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              _performLogout();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              foregroundColor: AppColors.white,
            ),
            child: Text(context.tr('logout')),
          ),
        ],
      ),
    );
  }

  void _performLogout() {
    // TODO: Implement actual logout logic
    debugPrint('User logged out');

    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(context.tr('logout_successful')),
        backgroundColor: AppColors.success,
        behavior: SnackBarBehavior.floating,
      ),
    );

    // Navigate to login page (for now just print)
    // Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
  }
}

// Updated User Model with additional fields
class UserModel {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String profileImage;
  final String joinDate;
  final bool isVerified;
  final int totalOrders;
  final double totalSpent;

  const UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.profileImage,
    required this.joinDate,
    required this.isVerified,
    required this.totalOrders,
    required this.totalSpent,
  });
}

// Modern Menu Item Model
class ModernMenuItem {
  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback onTap;
  final Widget? trailing;

  const ModernMenuItem({
    required this.icon,
    required this.title,
    this.subtitle,
    required this.onTap,
    this.trailing,
  });
}

// Profile Menu Item Model (legacy support)
class ProfileMenuItem {
  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback onTap;
  final Widget? trailing;

  const ProfileMenuItem({
    required this.icon,
    required this.title,
    this.subtitle,
    required this.onTap,
    this.trailing,
  });
}
