// Privacy Policy Page - Complete Privacy & Data Protection Information
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/responsive_utils.dart';

class PrivacyPolicyPage extends StatefulWidget {
  const PrivacyPolicyPage({super.key});

  @override
  State<PrivacyPolicyPage> createState() => _PrivacyPolicyPageState();
}

class _PrivacyPolicyPageState extends State<PrivacyPolicyPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  final List<PrivacySection> _privacySections = [
    PrivacySection(
      title: 'جمع‌آوری اطلاعات',
      icon: Icons.info_outline,
      color: AppColors.primary,
      content: '''ما اطلاعات شما را از طریق روش‌های زیر جمع‌آوری می‌کنیم:

• اطلاعات شخصی که هنگام ثبت‌نام ارائه می‌دهید (نام، ایمیل، شماره تلفن)
• اطلاعات خرید و تراکنش‌های مالی
• اطلاعات استفاده از سایت (کوکی‌ها، لاگ‌ها)
• اطلاعات دستگاه (IP، نوع مرورگر، سیستم‌عامل)
• اطلاعات مکانی (با اجازه شما)''',
    ),
    PrivacySection(
      title: 'استفاده از اطلاعات',
      icon: Icons.settings,
      color: AppColors.success,
      content: '''اطلاعات جمع‌آوری شده برای اهداف زیر استفاده می‌شود:

• پردازش و تکمیل سفارشات شما
• ارائه خدمات پشتیبانی و خدمات مشتریان
• بهبود عملکرد وب‌سایت و تجربه کاربری
• ارسال اطلاعیه‌های مهم و به‌روزرسانی‌ها
• بازاریابی و تبلیغات شخصی‌سازی شده (با رضایت شما)
• تحلیل و گزارش‌گیری داخلی''',
    ),
    PrivacySection(
      title: 'محافظت از اطلاعات',
      icon: Icons.security,
      color: AppColors.info,
      content:
          '''ما از روش‌های مختلفی برای محافظت از اطلاعات شما استفاده می‌کنیم:

• رمزگذاری SSL/TLS برای انتقال داده‌ها
• سیستم‌های امنیتی پیشرفته و فایروال
• دسترسی محدود کارکنان به اطلاعات شخصی
• پشتیبان‌گیری منظم و ایمن از داده‌ها
• نظارت مداوم بر سیستم‌های امنیتی
• آپدیت منظم سیستم‌ها و نرم‌افزارها''',
    ),
    PrivacySection(
      title: 'اشتراک‌گذاری اطلاعات',
      icon: Icons.share,
      color: AppColors.warning,
      content:
          '''اطلاعات شما تنها در موارد زیر با اشخاص ثالث به اشتراک گذاشته می‌شود:

• شرکای ارسال و حمل‌ونقل (برای تکمیل سفارش)
• ارائه‌دهندگان خدمات پرداخت (برای پردازش تراکنش)
• مقامات قانونی (در صورت درخواست قانونی)
• تجمیع و تحلیل آمار بدون شناسایی هویت
• در صورت ادغام یا فروش شرکت (با اطلاع قبلی)

ما هرگز اطلاعات شخصی شما را به اهداف تجاری به فروش نمی‌رسانیم.''',
    ),
    PrivacySection(
      title: 'کوکی‌ها',
      icon: Icons.web,
      color: AppColors.warning,
      content: '''ما از کوکی‌ها برای بهبود تجربه کاربری استفاده می‌کنیم:

• کوکی‌های ضروری: برای عملکرد اساسی سایت
• کوکی‌های عملکردی: برای به خاطر سپردن تنظیمات
• کوکی‌های تحلیلی: برای درک نحوه استفاده از سایت
• کوکی‌های تبلیغاتی: برای نمایش تبلیغات مرتبط

شما می‌توانید کوکی‌ها را از طریق تنظیمات مرورگر خود کنترل کنید.''',
    ),
    PrivacySection(
      title: 'حقوق شما',
      icon: Icons.account_balance,
      color: AppColors.error,
      content: '''بر اساس قوانین حفاظت از داده‌ها، شما دارای حقوق زیر هستید:

• دسترسی به اطلاعات شخصی خود
• تصحیح اطلاعات نادرست
• حذف اطلاعات شخصی (حق فراموشی)
• محدود کردن پردازش اطلاعات
• قابلیت انتقال داده‌ها
• مخالفت با پردازش اطلاعات برای بازاریابی
• شکایت به مراجع نظارتی''',
    ),
  ];

  bool _isAccepted = false;

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
        title: const Text('حریم خصوصی'),
        backgroundColor: isDark ? AppColors.surfaceDark : AppColors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: _sharePrivacyPolicy,
          ),
        ],
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: ResponsiveContainer(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _buildHeader(context),
                  _buildLastUpdated(context),
                  _buildQuickNavigation(context),
                  _buildPrivacySections(context),
                  _buildContactSupport(context),
                  _buildAcceptanceSection(context),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(AppDimensions.paddingL),
      padding: const EdgeInsets.all(AppDimensions.paddingXL),
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
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: AppColors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(40),
            ),
            child: Icon(Icons.privacy_tip, color: AppColors.white, size: 40),
          ),
          const SizedBox(height: AppDimensions.paddingL),
          Text(
            'سیاست حریم خصوصی',
            style: AppTextStyles.displaySmall.copyWith(
              color: AppColors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppDimensions.paddingM),
          Text(
            'ما به حفاظت از حریم خصوصی و اطلاعات شخصی شما متعهد هستیم',
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

  Widget _buildLastUpdated(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppDimensions.paddingL),
      padding: const EdgeInsets.all(AppDimensions.paddingL),
      decoration: BoxDecoration(
        color: AppColors.info.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppDimensions.radiusM),
        border: Border.all(color: AppColors.info.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Icon(Icons.update, color: AppColors.info, size: 20),
          const SizedBox(width: AppDimensions.paddingM),
          Expanded(
            child: Text(
              'آخرین به‌روزرسانی: ۱۵ آذر ۱۴۰۳',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.info,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Text(
            'نسخه ۲.۱',
            style: AppTextStyles.bodySmall.copyWith(color: AppColors.info),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickNavigation(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.all(AppDimensions.paddingL),
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
            ),
          ),
          const SizedBox(height: AppDimensions.paddingL),
          Wrap(
            spacing: AppDimensions.paddingS,
            runSpacing: AppDimensions.paddingS,
            children: _privacySections
                .map((section) => _buildQuickNavChip(section))
                .toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickNavChip(PrivacySection section) {
    return GestureDetector(
      onTap: () => _scrollToSection(section.title),
      child: Chip(
        label: Text(
          section.title,
          style: AppTextStyles.bodySmall.copyWith(
            color: section.color,
            fontWeight: FontWeight.w600,
          ),
        ),
        avatar: Icon(section.icon, color: section.color, size: 18),
        backgroundColor: section.color.withValues(alpha: 0.1),
        side: BorderSide(color: section.color.withValues(alpha: 0.3)),
      ),
    );
  }

  Widget _buildPrivacySections(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppDimensions.paddingL),
      child: Column(
        children: _privacySections
            .map((section) => _buildPrivacySection(section))
            .toList(),
      ),
    );
  }

  Widget _buildPrivacySection(PrivacySection section) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      key: ValueKey(section.title),
      margin: const EdgeInsets.only(bottom: AppDimensions.paddingL),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.white,
        borderRadius: BorderRadius.circular(AppDimensions.radiusL),
        border: Border.all(color: section.color.withValues(alpha: 0.3)),
        boxShadow: [
          BoxShadow(
            color: isDark ? AppColors.shadowDark : AppColors.shadowLight,
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          leading: Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: section.color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(25),
            ),
            child: Icon(section.icon, color: section.color, size: 24),
          ),
          title: Text(
            section.title,
            style: AppTextStyles.bodyLarge.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          children: [
            Padding(
              padding: const EdgeInsets.all(AppDimensions.paddingL),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    section.content,
                    style: AppTextStyles.bodyMedium.copyWith(height: 1.6),
                  ),
                  const SizedBox(height: AppDimensions.paddingL),
                  Row(
                    children: [
                      OutlinedButton.icon(
                        onPressed: () => _copyToClipboard(section.content),
                        icon: const Icon(Icons.copy, size: 16),
                        label: const Text('کپی متن'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: section.color,
                          side: BorderSide(color: section.color),
                        ),
                      ),
                      const SizedBox(width: AppDimensions.paddingM),
                      TextButton.icon(
                        onPressed: () => _shareSection(section),
                        icon: const Icon(Icons.share, size: 16),
                        label: const Text('اشتراک‌گذاری'),
                        style: TextButton.styleFrom(
                          foregroundColor: section.color,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactSupport(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(AppDimensions.paddingL),
      padding: const EdgeInsets.all(AppDimensions.paddingXL),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.success.withValues(alpha: 0.1),
            AppColors.success.withValues(alpha: 0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(AppDimensions.radiusL),
        border: Border.all(color: AppColors.success.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: AppColors.success.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(30),
            ),
            child: Icon(
              Icons.support_agent,
              color: AppColors.success,
              size: 30,
            ),
          ),
          const SizedBox(height: AppDimensions.paddingL),
          Text(
            'سوالی درباره حریم خصوصی دارید؟',
            style: AppTextStyles.headlineSmall.copyWith(
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppDimensions.paddingM),
          Text(
            'تیم پشتیبانی ما آماده پاسخگویی به سوالات شما درباره حریم خصوصی و امنیت داده‌ها است.',
            style: AppTextStyles.bodyMedium.copyWith(color: AppColors.grey600),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppDimensions.paddingL),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => Navigator.pushNamed(context, '/support'),
                  icon: const Icon(Icons.chat, size: 18),
                  label: const Text('چت با پشتیبانی'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.success,
                    side: BorderSide(color: AppColors.success),
                  ),
                ),
              ),
              const SizedBox(width: AppDimensions.paddingM),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: _callPrivacySupport,
                  icon: const Icon(Icons.phone, size: 18),
                  label: const Text('تماس مستقیم'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.success,
                    foregroundColor: AppColors.white,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAcceptanceSection(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.all(AppDimensions.paddingL),
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
            'پذیرش شرایط',
            style: AppTextStyles.headlineSmall.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppDimensions.paddingL),

          Container(
            padding: const EdgeInsets.all(AppDimensions.paddingL),
            decoration: BoxDecoration(
              color: AppColors.warning.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AppDimensions.radiusM),
              border: Border.all(
                color: AppColors.warning.withValues(alpha: 0.3),
              ),
            ),
            child: Row(
              children: [
                Icon(Icons.info_outline, color: AppColors.warning, size: 20),
                const SizedBox(width: AppDimensions.paddingM),
                Expanded(
                  child: Text(
                    'با استفاده از خدمات ما، شما با این سیاست حریم خصوصی موافقت می‌کنید.',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.warning,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: AppDimensions.paddingL),

          CheckboxListTile(
            value: _isAccepted,
            onChanged: (value) {
              setState(() {
                _isAccepted = value ?? false;
              });
            },
            title: RichText(
              text: TextSpan(
                style: AppTextStyles.bodyMedium.copyWith(
                  color: isDark ? AppColors.white : AppColors.black,
                ),
                children: [
                  const TextSpan(text: 'من '),
                  TextSpan(
                    text: 'سیاست حریم خصوصی',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const TextSpan(text: ' را مطالعه کرده و با آن موافقم.'),
                ],
              ),
            ),
            activeColor: AppColors.primary,
            controlAffinity: ListTileControlAffinity.leading,
            contentPadding: EdgeInsets.zero,
          ),

          const SizedBox(height: AppDimensions.paddingL),

          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => _downloadPrivacyPolicy(),
                  child: const Text('دانلود PDF'),
                ),
              ),
              const SizedBox(width: AppDimensions.paddingM),
              Expanded(
                child: ElevatedButton(
                  onPressed: _isAccepted ? _confirmAcceptance : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.white,
                  ),
                  child: const Text('تایید و ادامه'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _scrollToSection(String sectionTitle) {
    // In a real implementation, you would scroll to the specific section
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('رفتن به بخش: $sectionTitle')));
  }

  void _sharePrivacyPolicy() {
    Clipboard.setData(
      const ClipboardData(
        text: 'سیاست حریم خصوصی سینا شاپ - www.sinashop.com/privacy',
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('لینک سیاست حریم خصوصی کپی شد'),
        backgroundColor: AppColors.success,
      ),
    );
  }

  void _copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('متن کپی شد'),
        backgroundColor: AppColors.success,
      ),
    );
  }

  void _shareSection(PrivacySection section) {
    Clipboard.setData(
      ClipboardData(text: '${section.title}\n\n${section.content}'),
    );
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('بخش "${section.title}" کپی شد'),
        backgroundColor: AppColors.success,
      ),
    );
  }

  void _callPrivacySupport() {
    Clipboard.setData(const ClipboardData(text: '02112345678'));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('شماره تماس کپی شد: ۰۲۱-۱۲۳۴۵۶۷۸'),
        backgroundColor: AppColors.info,
      ),
    );
  }

  void _downloadPrivacyPolicy() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('دانلود PDF به زودی فعال می‌شود'),
        backgroundColor: AppColors.info,
      ),
    );
  }

  void _confirmAcceptance() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('تایید پذیرش'),
        content: const Text(
          'شما با سیاست حریم خصوصی ما موافقت کردید. این تنظیم در پروفایل شما ذخیره شد.',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text('تایید'),
          ),
        ],
      ),
    );
  }
}

class PrivacySection {
  final String title;
  final IconData icon;
  final Color color;
  final String content;

  PrivacySection({
    required this.title,
    required this.icon,
    required this.color,
    required this.content,
  });
}
