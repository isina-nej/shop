// About Page - Complete About Us & Company Information
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/responsive_utils.dart';

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
        title: const Text('درباره ما'),
        backgroundColor: isDark ? AppColors.surfaceDark : AppColors.white,
        elevation: 0,
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: ResponsiveContainer(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppDimensions.paddingL),
              child: Column(
                children: [
                  _buildHeroSection(context),
                  const SizedBox(height: AppDimensions.paddingXL),
                  _buildMissionSection(context),
                  const SizedBox(height: AppDimensions.paddingXL),
                  _buildStatsSection(context),
                  const SizedBox(height: AppDimensions.paddingXL),
                  _buildFeaturesSection(context),
                  const SizedBox(height: AppDimensions.paddingXL),
                  _buildTeamSection(context),
                  const SizedBox(height: AppDimensions.paddingXL),
                  _buildTimelineSection(context),
                  const SizedBox(height: AppDimensions.paddingXL),
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
      padding: const EdgeInsets.all(AppDimensions.paddingXL),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.primary, AppColors.primary.withOpacity(0.8)],
        ),
        borderRadius: BorderRadius.circular(AppDimensions.radiusXL),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.3),
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
            padding: const EdgeInsets.all(AppDimensions.paddingL),
            decoration: BoxDecoration(
              color: AppColors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(50),
            ),
            child: Icon(Icons.shopping_bag, color: AppColors.white, size: 50),
          ),
          const SizedBox(height: AppDimensions.paddingXL),
          Text(
            'سینا شاپ',
            style: AppTextStyles.displayMedium.copyWith(
              color: AppColors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppDimensions.paddingM),
          Text(
            'بهترین تجربه خرید آنلاین',
            style: AppTextStyles.headlineSmall.copyWith(
              color: AppColors.white.withOpacity(0.9),
            ),
          ),
          const SizedBox(height: AppDimensions.paddingL),
          Text(
            'سینا شاپ از سال ۱۴۰۰ با هدف ارائه بهترین محصولات و خدمات به مشتریان عزیز فعالیت می‌کند. ما به دنبال ایجاد تجربه‌ای منحصربفرد و رضایت‌بخش برای همه کاربران هستیم.',
            style: AppTextStyles.bodyLarge.copyWith(
              color: AppColors.white.withOpacity(0.9),
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
      padding: const EdgeInsets.all(AppDimensions.paddingXL),
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
            'ماموریت ما',
            style: AppTextStyles.headlineMedium.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppDimensions.paddingL),

          _buildMissionItem(
            icon: Icons.visibility,
            title: 'چشم‌انداز ما',
            description:
                'پیشرو بودن در ارائه خدمات خرید آنلاین با کیفیت و اعتماد در سراسر کشور',
            color: AppColors.primary,
          ),

          const SizedBox(height: AppDimensions.paddingL),

          _buildMissionItem(
            icon: Icons.track_changes,
            title: 'هدف ما',
            description:
                'تسهیل فرآیند خرید و ایجاد رضایت حداکثری برای مشتریان با ارائه محصولات اصل و با کیفیت',
            color: AppColors.success,
          ),

          const SizedBox(height: AppDimensions.paddingL),

          _buildMissionItem(
            icon: Icons.favorite,
            title: 'ارزش‌های ما',
            description:
                'صداقت، کیفیت، نوآوری، و تعهد به رضایت مشتری اصول اساسی ما هستند',
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
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(30),
          ),
          child: Icon(icon, color: color, size: 30),
        ),
        const SizedBox(width: AppDimensions.paddingL),
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
              const SizedBox(height: AppDimensions.paddingS),
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
      padding: const EdgeInsets.all(AppDimensions.paddingXL),
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
            'آمار ما در یک نگاه',
            style: AppTextStyles.headlineSmall.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppDimensions.paddingXL),

          Row(
            children: [
              Expanded(
                child: _buildStatItem(
                  number: '۲۵۰,۰۰۰+',
                  label: 'مشتری راضی',
                  icon: Icons.people,
                  color: AppColors.primary,
                ),
              ),
              Expanded(
                child: _buildStatItem(
                  number: '۱۵,۰۰۰+',
                  label: 'محصول',
                  icon: Icons.inventory,
                  color: AppColors.success,
                ),
              ),
            ],
          ),

          const SizedBox(height: AppDimensions.paddingL),

          Row(
            children: [
              Expanded(
                child: _buildStatItem(
                  number: '۵۰۰,۰۰۰+',
                  label: 'سفارش تکمیل شده',
                  icon: Icons.shopping_cart,
                  color: AppColors.warning,
                ),
              ),
              Expanded(
                child: _buildStatItem(
                  number: '۹۸%',
                  label: 'رضایت مشتریان',
                  icon: Icons.star,
                  color: AppColors.error,
                ),
              ),
            ],
          ),

          const SizedBox(height: AppDimensions.paddingL),

          Row(
            children: [
              Expanded(
                child: _buildStatItem(
                  number: '۱۵۰+',
                  label: 'شهر تحت پوشش',
                  icon: Icons.location_city,
                  color: AppColors.info,
                ),
              ),
              Expanded(
                child: _buildStatItem(
                  number: '۲۴/۷',
                  label: 'پشتیبانی',
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
      margin: const EdgeInsets.all(AppDimensions.paddingS),
      padding: const EdgeInsets.all(AppDimensions.paddingL),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppDimensions.radiusL),
      ),
      child: Column(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(25),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(height: AppDimensions.paddingM),
          Text(
            number,
            style: AppTextStyles.headlineSmall.copyWith(
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppDimensions.paddingS),
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
      padding: const EdgeInsets.all(AppDimensions.paddingXL),
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
            'چرا سینا شاپ؟',
            style: AppTextStyles.headlineSmall.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppDimensions.paddingXL),

          _buildFeatureItem(
            icon: Icons.verified,
            title: 'ضمانت اصالت کالا',
            description: 'تمامی محصولات با ضمانت اصالت و گارانتی معتبر',
            color: AppColors.success,
          ),

          _buildFeatureItem(
            icon: Icons.local_shipping,
            title: 'ارسال سریع و رایگان',
            description: 'ارسال رایگان برای خریدهای بالای ۵۰۰ هزار تومان',
            color: AppColors.primary,
          ),

          _buildFeatureItem(
            icon: Icons.payment,
            title: 'پرداخت امن',
            description: 'درگاه‌های پرداخت معتبر و امن با رمزنگاری بانکی',
            color: AppColors.info,
          ),

          _buildFeatureItem(
            icon: Icons.support_agent,
            title: 'پشتیبانی ۲۴ ساعته',
            description: 'تیم پشتیبانی ما همیشه آماده کمک به شما هستند',
            color: AppColors.warning,
          ),

          _buildFeatureItem(
            icon: Icons.refresh,
            title: 'بازگشت کالا',
            description: 'امکان بازگشت کالا تا ۷ روز بدون هیچ شرطی',
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
      margin: const EdgeInsets.only(bottom: AppDimensions.paddingL),
      padding: const EdgeInsets.all(AppDimensions.paddingL),
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(AppDimensions.radiusM),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(25),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: AppDimensions.paddingL),
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
                const SizedBox(height: AppDimensions.paddingS),
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
      padding: const EdgeInsets.all(AppDimensions.paddingXL),
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
            'تیم مدیریت',
            style: AppTextStyles.headlineSmall.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppDimensions.paddingXL),

          Row(
            children: [
              Expanded(
                child: _buildTeamMember(
                  name: 'علی احمدی',
                  position: 'مدیر عامل',
                  description: 'بیش از ۱۰ سال تجربه در حوزه تجارت الکترونیک',
                  avatar: Icons.person,
                ),
              ),
              const SizedBox(width: AppDimensions.paddingM),
              Expanded(
                child: _buildTeamMember(
                  name: 'سارا رضایی',
                  position: 'مدیر فناوری',
                  description: 'متخصص توسعه نرم‌افزار و مهندسی کامپیوتر',
                  avatar: Icons.person,
                ),
              ),
            ],
          ),

          const SizedBox(height: AppDimensions.paddingL),

          Row(
            children: [
              Expanded(
                child: _buildTeamMember(
                  name: 'محمد حسینی',
                  position: 'مدیر فروش',
                  description: 'کارشناس بازاریابی و فروش آنلاین',
                  avatar: Icons.person,
                ),
              ),
              const SizedBox(width: AppDimensions.paddingM),
              Expanded(
                child: _buildTeamMember(
                  name: 'فاطمه کریمی',
                  position: 'مدیر پشتیبانی',
                  description: 'متخصص خدمات مشتریان و CRM',
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
      padding: const EdgeInsets.all(AppDimensions.paddingL),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.05),
        borderRadius: BorderRadius.circular(AppDimensions.radiusL),
      ),
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.2),
              borderRadius: BorderRadius.circular(30),
            ),
            child: Icon(avatar, color: AppColors.primary, size: 30),
          ),
          const SizedBox(height: AppDimensions.paddingM),
          Text(
            name,
            style: AppTextStyles.bodyLarge.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppDimensions.paddingS),
          Text(
            position,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppDimensions.paddingS),
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
      padding: const EdgeInsets.all(AppDimensions.paddingXL),
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
            'تاریخچه شرکت',
            style: AppTextStyles.headlineSmall.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppDimensions.paddingXL),

          _buildTimelineItem(
            year: '۱۴۰۰',
            title: 'تأسیس شرکت',
            description: 'آغاز فعالیت با تیم ۵ نفره و ۱۰۰ محصول',
            isFirst: true,
          ),

          _buildTimelineItem(
            year: '۱۴۰۱',
            title: 'گسترش محصولات',
            description: 'افزایش به ۵۰۰۰ محصول و ۵۰ هزار مشتری',
          ),

          _buildTimelineItem(
            year: '۱۴۰۲',
            title: 'افتتاح انبار جدید',
            description: 'راه‌اندازی انبار مرکزی و کاهش زمان ارسال',
          ),

          _buildTimelineItem(
            year: '۱۴۰۳',
            title: 'توسعه اپلیکیشن',
            description: 'عرضه اپلیکیشن موبایل و خدمات جدید',
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
                color: AppColors.primary.withOpacity(0.3),
              ),
          ],
        ),
        const SizedBox(width: AppDimensions.paddingL),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.paddingM,
                  vertical: AppDimensions.paddingS,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
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
              const SizedBox(height: AppDimensions.paddingS),
              Text(
                title,
                style: AppTextStyles.bodyLarge.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: AppDimensions.paddingS),
              Text(
                description,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.grey600,
                ),
              ),
              if (!isLast) const SizedBox(height: AppDimensions.paddingL),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildContactSection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.paddingXL),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primary.withOpacity(0.1),
            AppColors.primary.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(AppDimensions.radiusL),
        border: Border.all(color: AppColors.primary.withOpacity(0.2)),
      ),
      child: Column(
        children: [
          Text(
            'با ما در تماس باشید',
            style: AppTextStyles.headlineSmall.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppDimensions.paddingL),

          _buildContactItem(
            icon: Icons.location_on,
            title: 'آدرس',
            value: 'تهران، خیابان ولیعصر، پلاک ۱۲۳',
            onTap: () => _copyToClipboard('تهران، خیابان ولیعصر، پلاک ۱۲۳'),
          ),

          _buildContactItem(
            icon: Icons.phone,
            title: 'تلفن',
            value: '۰۲۱-۱۲۳۴۵۶۷۸',
            onTap: () => _copyToClipboard('02112345678'),
          ),

          _buildContactItem(
            icon: Icons.email,
            title: 'ایمیل',
            value: 'info@sinashop.com',
            onTap: () => _copyToClipboard('info@sinashop.com'),
          ),

          _buildContactItem(
            icon: Icons.web,
            title: 'وب‌سایت',
            value: 'www.sinashop.com',
            onTap: () => _copyToClipboard('www.sinashop.com'),
          ),

          const SizedBox(height: AppDimensions.paddingL),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildSocialButton(
                icon: Icons.telegram,
                label: 'تلگرام',
                color: AppColors.info,
                onTap: () => _copyToClipboard('@SinaShop'),
              ),
              _buildSocialButton(
                icon: Icons.phone_android,
                label: 'اینستاگرام',
                color: AppColors.purple,
                onTap: () => _copyToClipboard('@SinaShop'),
              ),
              _buildSocialButton(
                icon: Icons.facebook,
                label: 'لینکدین',
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
        padding: const EdgeInsets.all(AppDimensions.paddingM),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(icon, color: AppColors.primary, size: 20),
            ),
            const SizedBox(width: AppDimensions.paddingL),
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
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.paddingL,
          vertical: AppDimensions.paddingM,
        ),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(AppDimensions.radiusM),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: AppDimensions.paddingS),
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
        content: Text('$text کپی شد'),
        backgroundColor: AppColors.success,
      ),
    );
  }
}
