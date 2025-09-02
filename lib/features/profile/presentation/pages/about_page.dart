// About Page - Complete About Us & Company Information
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/responsive_utils.dart';
import '../../../../core/localization/localization_extension.dart';

class AboutPage extends StatefulWidget {
  const AboutPage({super.key});

  @override
  State<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );
    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
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
        title: Text(context.tr('about_us')),
        backgroundColor: isDark ? AppColors.surfaceDark : AppColors.white,
        elevation: 0,
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: ResponsiveContainer(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(AppDimensions.paddingL),
              child: Column(
                children: [
                  _buildHeroSection(context),
                  SizedBox(height: AppDimensions.paddingXL),
                  _buildMissionSection(context),
                  SizedBox(height: AppDimensions.paddingXL),
                  _buildStatsSection(context),
                  SizedBox(height: AppDimensions.paddingXL),
                  _buildFeaturesSection(context),
                  SizedBox(height: AppDimensions.paddingXL),
                  _buildTeamSection(context),
                  SizedBox(height: AppDimensions.paddingXL),
                  _buildTimelineSection(context),
                  SizedBox(height: AppDimensions.paddingXL),
                  _buildContactSection(context),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeroSection(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppDimensions.paddingXL),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.primary, AppColors.primary.withValues(alpha: 0.8)],
        ),
        borderRadius: BorderRadius.circular(AppDimensions.radiusXL),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 100,
            height: 100,
            padding: EdgeInsets.all(AppDimensions.paddingL),
            decoration: BoxDecoration(
              color: AppColors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(50),
            ),
            child: Icon(Icons.shopping_bag, color: AppColors.white, size: 50),
          ),
          SizedBox(height: AppDimensions.paddingXL),
          Text(
            context.tr('sina_shop'),
            style: AppTextStyles.displayMedium.copyWith(
              color: AppColors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: AppDimensions.paddingM),
          Text(
            context.tr('best_online_shopping_experience'),
            style: AppTextStyles.headlineSmall.copyWith(
              color: AppColors.white.withValues(alpha: 0.9),
            ),
          ),
          SizedBox(height: AppDimensions.paddingL),
          Text(
            context.tr('sina_shop_description'),
            style: AppTextStyles.bodyLarge.copyWith(
              color: AppColors.white.withValues(alpha: 0.9),
              height: 1.6,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildMissionSection(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: EdgeInsets.all(AppDimensions.paddingXL),
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
          Text(
            context.tr('our_mission'),
            style: AppTextStyles.headlineMedium.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: AppDimensions.paddingL),

          _buildMissionItem(
            icon: Icons.visibility,
            title: context.tr('our_vision'),
            description: context.tr('our_vision_description'),
            color: AppColors.primary,
          ),

          SizedBox(height: AppDimensions.paddingL),

          _buildMissionItem(
            icon: Icons.track_changes,
            title: context.tr('our_goal'),
            description: context.tr('our_goal_description'),
            color: AppColors.success,
          ),

          SizedBox(height: AppDimensions.paddingL),

          _buildMissionItem(
            icon: Icons.favorite,
            title: context.tr('our_values'),
            description: context.tr('our_values_description'),
            color: AppColors.error,
          ),
        ],
      ),
    );
  }

  Widget _buildMissionItem({
    required IconData icon,
    required String title,
    required String description,
    required Color color,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(30),
          ),
          child: Icon(icon, color: color, size: 30),
        ),
        SizedBox(width: AppDimensions.paddingL),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTextStyles.bodyLarge.copyWith(
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
              SizedBox(height: AppDimensions.paddingS),
              Text(
                description,
                style: AppTextStyles.bodyMedium.copyWith(height: 1.5),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatsSection(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: EdgeInsets.all(AppDimensions.paddingXL),
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
          Text(
            context.tr('our_stats_at_glance'),
            style: AppTextStyles.headlineSmall.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: AppDimensions.paddingXL),

          Row(
            children: [
              Expanded(
                child: _buildStatItem(
                  number: '۲۵۰,۰۰۰+',
                  label: context.tr('satisfied_customers'),
                  icon: Icons.people,
                  color: AppColors.primary,
                ),
              ),
              Expanded(
                child: _buildStatItem(
                  number: '۱۵,۰۰۰+',
                  label: context.tr('products_count'),
                  icon: Icons.inventory,
                  color: AppColors.success,
                ),
              ),
            ],
          ),

          SizedBox(height: AppDimensions.paddingL),

          Row(
            children: [
              Expanded(
                child: _buildStatItem(
                  number: '۵۰۰,۰۰۰+',
                  label: context.tr('completed_orders'),
                  icon: Icons.shopping_cart,
                  color: AppColors.warning,
                ),
              ),
              Expanded(
                child: _buildStatItem(
                  number: '۹۸%',
                  label: context.tr('customer_satisfaction'),
                  icon: Icons.star,
                  color: AppColors.error,
                ),
              ),
            ],
          ),

          SizedBox(height: AppDimensions.paddingL),

          Row(
            children: [
              Expanded(
                child: _buildStatItem(
                  number: '۱۵۰+',
                  label: context.tr('cities_covered'),
                  icon: Icons.location_city,
                  color: AppColors.info,
                ),
              ),
              Expanded(
                child: _buildStatItem(
                  number: '۲۴/۷',
                  label: context.tr('support_247'),
                  icon: Icons.support_agent,
                  color: AppColors.purple,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem({
    required String number,
    required String label,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      margin: EdgeInsets.all(AppDimensions.paddingS),
      padding: EdgeInsets.all(AppDimensions.paddingL),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppDimensions.radiusL),
      ),
      child: Column(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(25),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          SizedBox(height: AppDimensions.paddingM),
          Text(
            number,
            style: AppTextStyles.headlineSmall.copyWith(
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: AppDimensions.paddingS),
          Text(
            label,
            style: AppTextStyles.bodySmall.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildFeaturesSection(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: EdgeInsets.all(AppDimensions.paddingXL),
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
          Text(
            context.tr('why_sina_shop'),
            style: AppTextStyles.headlineSmall.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: AppDimensions.paddingXL),

          _buildFeatureItem(
            icon: Icons.verified,
            title: context.tr('genuine_product_guarantee'),
            description: context.tr('genuine_product_description'),
            color: AppColors.success,
          ),

          _buildFeatureItem(
            icon: Icons.local_shipping,
            title: context.tr('fast_free_shipping'),
            description: context.tr('fast_free_shipping_description'),
            color: AppColors.primary,
          ),

          _buildFeatureItem(
            icon: Icons.payment,
            title: context.tr('secure_payment'),
            description: context.tr('secure_payment_description'),
            color: AppColors.info,
          ),

          _buildFeatureItem(
            icon: Icons.support_agent,
            title: context.tr('24_7_support'),
            description: context.tr('24_7_support_description'),
            color: AppColors.warning,
          ),

          _buildFeatureItem(
            icon: Icons.refresh,
            title: context.tr('product_return'),
            description: context.tr('product_return_description'),
            color: AppColors.error,
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureItem({
    required IconData icon,
    required String title,
    required String description,
    required Color color,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: AppDimensions.paddingL),
      padding: EdgeInsets.all(AppDimensions.paddingL),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(AppDimensions.radiusM),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Row(
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
          SizedBox(width: AppDimensions.paddingL),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.bodyLarge.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: AppDimensions.paddingS),
                Text(
                  description,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.grey600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTeamSection(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: EdgeInsets.all(AppDimensions.paddingXL),
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
          Text(
            context.tr('management_team'),
            style: AppTextStyles.headlineSmall.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: AppDimensions.paddingXL),

          Row(
            children: [
              Expanded(
                child: _buildTeamMember(
                  name: context.tr('ali_ahmadi'),
                  position: context.tr('ceo'),
                  description: context.tr('ceo_description'),
                  avatar: Icons.person,
                ),
              ),
              SizedBox(width: AppDimensions.paddingM),
              Expanded(
                child: _buildTeamMember(
                  name: context.tr('sara_rezaei'),
                  position: context.tr('cto'),
                  description: context.tr('cto_description'),
                  avatar: Icons.person,
                ),
              ),
            ],
          ),

          SizedBox(height: AppDimensions.paddingL),

          Row(
            children: [
              Expanded(
                child: _buildTeamMember(
                  name: context.tr('mohammad_hosseini'),
                  position: context.tr('sales_manager'),
                  description: context.tr('sales_manager_description'),
                  avatar: Icons.person,
                ),
              ),
              SizedBox(width: AppDimensions.paddingM),
              Expanded(
                child: _buildTeamMember(
                  name: context.tr('fateme_karimi'),
                  position: context.tr('support_manager'),
                  description: context.tr('support_manager_description'),
                  avatar: Icons.person,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTeamMember({
    required String name,
    required String position,
    required String description,
    required IconData avatar,
  }) {
    return Container(
      padding: EdgeInsets.all(AppDimensions.paddingL),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(AppDimensions.radiusL),
      ),
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(30),
            ),
            child: Icon(avatar, color: AppColors.primary, size: 30),
          ),
          SizedBox(height: AppDimensions.paddingM),
          Text(
            name,
            style: AppTextStyles.bodyLarge.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: AppDimensions.paddingS),
          Text(
            position,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: AppDimensions.paddingS),
          Text(
            description,
            style: AppTextStyles.bodySmall.copyWith(color: AppColors.grey600),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineSection(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: EdgeInsets.all(AppDimensions.paddingXL),
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
          Text(
            context.tr('company_history'),
            style: AppTextStyles.headlineSmall.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: AppDimensions.paddingXL),

          _buildTimelineItem(
            year: '۱۴۰۰',
            title: context.tr('company_founded'),
            description: context.tr('company_founded_description'),
            isFirst: true,
          ),

          _buildTimelineItem(
            year: '۱۴۰۱',
            title: context.tr('product_expansion'),
            description: context.tr('product_expansion_description'),
          ),

          _buildTimelineItem(
            year: '۱۴۰۲',
            title: context.tr('new_warehouse'),
            description: context.tr('new_warehouse_description'),
          ),

          _buildTimelineItem(
            year: '۱۴۰۳',
            title: context.tr('app_development'),
            description: context.tr('app_development_description'),
            isLast: true,
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineItem({
    required String year,
    required String title,
    required String description,
    bool isFirst = false,
    bool isLast = false,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            if (!isLast)
              Container(
                width: 2,
                height: 60,
                color: AppColors.primary.withValues(alpha: 0.3),
              ),
          ],
        ),
        SizedBox(width: AppDimensions.paddingL),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: AppDimensions.paddingM,
                  vertical: AppDimensions.paddingS,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                ),
                child: Text(
                  year,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: AppDimensions.paddingS),
              Text(
                title,
                style: AppTextStyles.bodyLarge.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: AppDimensions.paddingS),
              Text(
                description,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.grey600,
                ),
              ),
              if (!isLast) SizedBox(height: AppDimensions.paddingL),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildContactSection(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppDimensions.paddingXL),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primary.withValues(alpha: 0.1),
            AppColors.primary.withValues(alpha: 0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(AppDimensions.radiusL),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
      ),
      child: Column(
        children: [
          Text(
            context.tr('contact_us'),
            style: AppTextStyles.headlineSmall.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: AppDimensions.paddingL),

          _buildContactItem(
            icon: Icons.location_on,
            title: context.tr('address'),
            value: 'تهران، خیابان ولیعصر، پلاک ۱۲۳',
            onTap: () => _copyToClipboard('تهران، خیابان ولیعصر، پلاک ۱۲۳'),
          ),

          _buildContactItem(
            icon: Icons.phone,
            title: context.tr('phone'),
            value: '۰۲۱-۱۲۳۴۵۶۷۸',
            onTap: () => _copyToClipboard('02112345678'),
          ),

          _buildContactItem(
            icon: Icons.email,
            title: context.tr('email'),
            value: 'info@sinashop.com',
            onTap: () => _copyToClipboard('info@sinashop.com'),
          ),

          _buildContactItem(
            icon: Icons.web,
            title: context.tr('website'),
            value: 'www.sinashop.com',
            onTap: () => _copyToClipboard('www.sinashop.com'),
          ),

          SizedBox(height: AppDimensions.paddingL),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildSocialButton(
                icon: Icons.telegram,
                label: context.tr('telegram'),
                color: AppColors.info,
                onTap: () => _copyToClipboard('@SinaShop'),
              ),
              _buildSocialButton(
                icon: Icons.phone_android,
                label: context.tr('instagram'),
                color: AppColors.purple,
                onTap: () => _copyToClipboard('@SinaShop'),
              ),
              _buildSocialButton(
                icon: Icons.facebook,
                label: context.tr('linkedin'),
                color: AppColors.primary,
                onTap: () => _copyToClipboard('SinaShop'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildContactItem({
    required IconData icon,
    required String title,
    required String value,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppDimensions.radiusM),
      child: Padding(
        padding: EdgeInsets.all(AppDimensions.paddingM),
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
            SizedBox(width: AppDimensions.paddingL),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.grey600,
                    ),
                  ),
                  Text(
                    value,
                    style: AppTextStyles.bodyMedium.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.copy, color: AppColors.grey400, size: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildSocialButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppDimensions.radiusM),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: AppDimensions.paddingL,
          vertical: AppDimensions.paddingM,
        ),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(AppDimensions.radiusM),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 24),
            SizedBox(height: AppDimensions.paddingS),
            Text(
              label,
              style: AppTextStyles.bodySmall.copyWith(
                color: color,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$text ${context.tr('copied_to_clipboard')}'),
        backgroundColor: AppColors.success,
      ),
    );
  }
}
