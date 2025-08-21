// Profile Page - User Profile and Settings
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/theme_manager.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // Mock user data - TODO: Replace with API call
  final UserModel _user = const UserModel(
    id: '1',
    name: 'علی احمدی',
    email: 'ali.ahmadi@example.com',
    phone: '09123456789',
    profileImage: 'https://via.placeholder.com/200x200/667EEA/FFFFFF?text=User',
    joinDate: '۱۴۰۲/۰۵/۱۵',
    isVerified: true,
  );

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 768;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark
          ? AppColors.backgroundDark
          : AppColors.backgroundLight,

      // Custom App Bar
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'پروفایل کاربری',
          style: AppTextStyles.headlineMedium.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () => _showSettingsBottomSheet(context),
            icon: const Icon(Icons.settings_outlined),
          ),
        ],
      ),

      body: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.symmetric(
          horizontal: isTablet
              ? AppDimensions.paddingXL
              : AppDimensions.paddingM,
          vertical: AppDimensions.paddingM,
        ),
        child: Column(
          children: [
            // User Profile Header
            _buildProfileHeader(context),

            const SizedBox(height: AppDimensions.paddingXL),

            // Profile Menu Items
            _buildMenuSection(context, 'حساب کاربری', [
              ProfileMenuItem(
                icon: Icons.person_outline,
                title: 'ویرایش پروفایل',
                subtitle: 'تغییر اطلاعات شخصی',
                onTap: () => _navigateToEditProfile(),
              ),
              ProfileMenuItem(
                icon: Icons.location_on_outlined,
                title: 'آدرس‌های من',
                subtitle: 'مدیریت آدرس‌های ارسال',
                onTap: () => _navigateToAddresses(),
              ),
              ProfileMenuItem(
                icon: Icons.credit_card_outlined,
                title: 'کارت‌های پرداخت',
                subtitle: 'مدیریت روش‌های پرداخت',
                onTap: () => _navigateToPaymentMethods(),
              ),
            ]),

            const SizedBox(height: AppDimensions.paddingL),

            _buildMenuSection(context, 'سفارش‌ها', [
              ProfileMenuItem(
                icon: Icons.shopping_bag_outlined,
                title: 'سفارش‌های من',
                subtitle: 'مشاهده تاریخچه خرید',
                onTap: () => _navigateToOrders(),
              ),
              ProfileMenuItem(
                icon: Icons.favorite_outline,
                title: 'علاقه‌مندی‌ها',
                subtitle: 'محصولات مورد علاقه',
                onTap: () => _navigateToWishlist(),
              ),
              ProfileMenuItem(
                icon: Icons.rate_review_outlined,
                title: 'نظرات من',
                subtitle: 'نظرات ثبت شده',
                onTap: () => _navigateToReviews(),
              ),
            ]),

            const SizedBox(height: AppDimensions.paddingL),

            _buildMenuSection(context, 'تنظیمات', [
              ProfileMenuItem(
                icon: Icons.notifications_outlined,
                title: 'اعلان‌ها',
                subtitle: 'تنظیمات اطلاع‌رسانی',
                onTap: () => _navigateToNotifications(),
              ),
              ProfileMenuItem(
                icon: isDark
                    ? Icons.light_mode_outlined
                    : Icons.dark_mode_outlined,
                title: 'حالت تاریک',
                subtitle: isDark ? 'تغییر به حالت روشن' : 'تغییر به حالت تاریک',
                onTap: () => _toggleTheme(context),
                trailing: Switch(
                  value: isDark,
                  onChanged: (_) => _toggleTheme(context),
                  activeColor: AppColors.primary,
                ),
              ),
              ProfileMenuItem(
                icon: Icons.language_outlined,
                title: 'زبان',
                subtitle: 'فارسی',
                onTap: () => _showLanguageSelection(),
              ),
            ]),

            const SizedBox(height: AppDimensions.paddingL),

            _buildMenuSection(context, 'پشتیبانی', [
              ProfileMenuItem(
                icon: Icons.help_outline,
                title: 'راهنما و پشتیبانی',
                subtitle: 'سوالات متداول و تماس',
                onTap: () => _navigateToSupport(),
              ),
              ProfileMenuItem(
                icon: Icons.info_outline,
                title: 'درباره ما',
                subtitle: 'اطلاعات برنامه',
                onTap: () => _navigateToAbout(),
              ),
              ProfileMenuItem(
                icon: Icons.privacy_tip_outlined,
                title: 'حریم خصوصی',
                subtitle: 'قوانین و مقررات',
                onTap: () => _navigateToPrivacy(),
              ),
            ]),

            const SizedBox(height: AppDimensions.paddingXL),

            // Logout Button
            _buildLogoutButton(context),

            const SizedBox(height: AppDimensions.paddingXL),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(AppDimensions.paddingL),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.white,
        borderRadius: BorderRadius.circular(AppDimensions.radiusL),
        boxShadow: [
          BoxShadow(
            color: isDark ? AppColors.shadowDark : AppColors.shadowLight,
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Profile Image
          Stack(
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  border: Border.all(color: AppColors.primary, width: 3),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(47),
                  child: Image.network(
                    _user.profileImage,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: AppColors.grey200,
                        child: const Icon(
                          Icons.person,
                          color: AppColors.grey500,
                          size: 50,
                        ),
                      );
                    },
                  ),
                ),
              ),

              // Verified Badge
              if (_user.isVerified)
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isDark ? AppColors.surfaceDark : AppColors.white,
                        width: 3,
                      ),
                    ),
                    child: const Icon(
                      Icons.verified,
                      color: AppColors.white,
                      size: 18,
                    ),
                  ),
                ),
            ],
          ),

          const SizedBox(height: AppDimensions.paddingM),

          // User Name
          Text(
            _user.name,
            style: AppTextStyles.headlineMedium.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: AppDimensions.paddingS),

          // Email
          Text(
            _user.email,
            style: AppTextStyles.bodyMedium.copyWith(color: AppColors.grey600),
          ),

          const SizedBox(height: AppDimensions.paddingS),

          // Join Date
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.calendar_today_outlined,
                size: 16,
                color: AppColors.grey500,
              ),
              const SizedBox(width: AppDimensions.paddingXS),
              Text(
                'عضو از ${_user.joinDate}',
                style: AppTextStyles.labelMedium.copyWith(
                  color: AppColors.grey500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMenuSection(
    BuildContext context,
    String title,
    List<ProfileMenuItem> items,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Title
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.paddingS,
          ),
          child: Text(
            title,
            style: AppTextStyles.headlineSmall.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.grey600,
            ),
          ),
        ),

        const SizedBox(height: AppDimensions.paddingM),

        // Menu Items
        Container(
          decoration: BoxDecoration(
            color: isDark ? AppColors.surfaceDark : AppColors.white,
            borderRadius: BorderRadius.circular(AppDimensions.radiusL),
            boxShadow: [
              BoxShadow(
                color: isDark ? AppColors.shadowDark : AppColors.shadowLight,
                blurRadius: 12,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: items.asMap().entries.map((entry) {
              final index = entry.key;
              final item = entry.value;
              final isLast = index == items.length - 1;

              return _buildMenuItem(context, item, !isLast);
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildMenuItem(
    BuildContext context,
    ProfileMenuItem item,
    bool showDivider,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      children: [
        ListTile(
          onTap: item.onTap,
          leading: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(item.icon, color: AppColors.primary, size: 20),
          ),
          title: Text(
            item.title,
            style: AppTextStyles.bodyLarge.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          subtitle: item.subtitle != null
              ? Text(
                  item.subtitle!,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.grey600,
                  ),
                )
              : null,
          trailing:
              item.trailing ??
              Icon(Icons.arrow_forward_ios, size: 16, color: AppColors.grey500),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.paddingL,
            vertical: AppDimensions.paddingS,
          ),
        ),

        if (showDivider)
          Divider(
            height: 1,
            color: isDark ? AppColors.grey800 : AppColors.grey200,
            indent: AppDimensions.paddingXL + 40,
          ),
      ],
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        onPressed: () => _showLogoutDialog(context),
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.error,
          side: const BorderSide(color: AppColors.error),
          padding: const EdgeInsets.symmetric(vertical: AppDimensions.paddingM),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimensions.radiusM),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.logout, size: 20),
            const SizedBox(width: AppDimensions.paddingS),
            Text(
              'خروج از حساب کاربری',
              style: AppTextStyles.labelLarge.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Theme Toggle
  void _toggleTheme(BuildContext context) {
    // Find the ThemeManager using the context
    final themeManager = ThemeManagerProvider.of(context);
    themeManager?.toggleTheme();
  }

  // Navigation Methods
  void _navigateToEditProfile() {
    debugPrint('Navigate to edit profile');
  }

  void _navigateToAddresses() {
    debugPrint('Navigate to addresses');
  }

  void _navigateToPaymentMethods() {
    debugPrint('Navigate to payment methods');
  }

  void _navigateToOrders() {
    debugPrint('Navigate to orders');
  }

  void _navigateToWishlist() {
    debugPrint('Navigate to wishlist');
  }

  void _navigateToReviews() {
    debugPrint('Navigate to reviews');
  }

  void _navigateToNotifications() {
    debugPrint('Navigate to notifications');
  }

  void _navigateToSupport() {
    debugPrint('Navigate to support');
  }

  void _navigateToAbout() {
    debugPrint('Navigate to about');
  }

  void _navigateToPrivacy() {
    debugPrint('Navigate to privacy');
  }

  // Dialog Methods
  void _showSettingsBottomSheet(BuildContext context) {
    // TODO: Show settings bottom sheet
    debugPrint('Show settings bottom sheet');
  }

  void _showLanguageSelection() {
    // TODO: Show language selection
    debugPrint('Show language selection');
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('خروج از حساب'),
        content: const Text(
          'آیا مطمئن هستید که می‌خواهید از حساب کاربری خود خارج شوید؟',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('انصراف'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              // TODO: Implement logout
              debugPrint('User logged out');
            },
            child: const Text('خروج', style: TextStyle(color: AppColors.error)),
          ),
        ],
      ),
    );
  }
}

// User Model
class UserModel {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String profileImage;
  final String joinDate;
  final bool isVerified;

  const UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.profileImage,
    required this.joinDate,
    required this.isVerified,
  });
}

// Profile Menu Item Model
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
