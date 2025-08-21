// FAQ Page - Complete FAQ Management
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/responsive_utils.dart';

class FAQPage extends StatefulWidget {
  const FAQPage({super.key});

  @override
  State<FAQPage> createState() => _FAQPageState();
}

class _FAQPageState extends State<FAQPage> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  List<FAQCategory> _categories = [];
  List<FAQ> _allFAQs = [];
  List<FAQ> _filteredFAQs = [];
  int _selectedCategoryIndex = 0;
  final TextEditingController _searchController = TextEditingController();
  bool _isLoading = false;

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
    _loadFAQs();
    _searchController.addListener(_filterFAQs);
  }

  @override
  void dispose() {
    _animationController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _loadFAQs() {
    setState(() => _isLoading = true);

    // Mock FAQ data
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() {
          _categories = [
            FAQCategory(
              id: 'all',
              name: 'همه سوالات',
              icon: Icons.help_outline,
            ),
            FAQCategory(
              id: 'orders',
              name: 'سفارشات',
              icon: Icons.shopping_bag,
            ),
            FAQCategory(id: 'payment', name: 'پرداخت', icon: Icons.payment),
            FAQCategory(
              id: 'delivery',
              name: 'ارسال',
              icon: Icons.local_shipping,
            ),
            FAQCategory(
              id: 'returns',
              name: 'مرجوعی',
              icon: Icons.keyboard_return,
            ),
            FAQCategory(id: 'account', name: 'حساب کاربری', icon: Icons.person),
            FAQCategory(id: 'technical', name: 'مشکلات فنی', icon: Icons.build),
          ];

          _allFAQs = [
            // Orders FAQs
            FAQ(
              id: '1',
              categoryId: 'orders',
              question: 'چگونه می‌توانم سفارش خود را پیگیری کنم؟',
              answer:
                  'برای پیگیری سفارش خود، به بخش "پروفایل" > "سفارشات من" بروید. در آنجا می‌توانید وضعیت لحظه‌ای سفارش خود را مشاهده کنید. همچنین پیامک و ایمیل تأیید با کد پیگیری برای شما ارسال می‌شود.',
              isPopular: true,
              tags: ['پیگیری', 'سفارش', 'وضعیت'],
            ),
            FAQ(
              id: '2',
              categoryId: 'orders',
              question: 'آیا می‌توانم سفارش خود را تغییر دهم؟',
              answer:
                  'تا زمانی که سفارش شما آماده‌سازی نشده باشد، می‌توانید آن را تغییر دهید یا لغو کنید. برای این کار به بخش سفارشات رفته و روی "ویرایش سفارش" کلیک کنید.',
              isPopular: false,
              tags: ['تغییر سفارش', 'لغو سفارش'],
            ),
            FAQ(
              id: '3',
              categoryId: 'orders',
              question: 'حداقل مبلغ سفارش چقدر است؟',
              answer:
                  'حداقل مبلغ سفارش ۵۰,۰۰۰ تومان می‌باشد. برای سفارشات بالای ۲۰۰,۰۰۰ تومان، هزینه ارسال رایگان است.',
              isPopular: true,
              tags: ['حداقل سفارش', 'ارسال رایگان'],
            ),

            // Payment FAQs
            FAQ(
              id: '4',
              categoryId: 'payment',
              question: 'چه روش‌های پرداختی پشتیبانی می‌شود؟',
              answer:
                  'شما می‌توانید از کارت‌های بانکی (شتاب)، درگاه‌های آنلاین، کیف پول و پرداخت در محل استفاده کنید. همچنین خرید اقساطی نیز برای محصولات خاص امکان‌پذیر است.',
              isPopular: true,
              tags: ['روش پرداخت', 'کارت بانکی', 'اقساط'],
            ),
            FAQ(
              id: '5',
              categoryId: 'payment',
              question: 'آیا اطلاعات پرداخت من امن است؟',
              answer:
                  'بله، تمام اطلاعات پرداخت شما با بالاترین استانداردهای امنیتی محافظت می‌شود. ما از رمزگذاری SSL و درگاه‌های معتبر بانکی استفاده می‌کنیم.',
              isPopular: false,
              tags: ['امنیت', 'SSL', 'حریم خصوصی'],
            ),

            // Delivery FAQs
            FAQ(
              id: '6',
              categoryId: 'delivery',
              question: 'زمان ارسال محصولات چقدر است؟',
              answer:
                  'معمولاً محصولات در شهر تهران ۱-۲ روز کاری و در سایر شهرها ۲-۵ روز کاری ارسال می‌شوند. برای محصولات خاص، زمان ارسال ممکن است متفاوت باشد.',
              isPopular: true,
              tags: ['زمان ارسال', 'تهران', 'شهرستان'],
            ),
            FAQ(
              id: '7',
              categoryId: 'delivery',
              question: 'هزینه ارسال چقدر است؟',
              answer:
                  'هزینه ارسال بر اساس وزن، حجم و مقصد محاسبه می‌شود. برای سفارشات بالای ۲۰۰,۰۰۰ تومان، ارسال رایگان است. در غیر این صورت، معمولاً بین ۱۵,۰۰۰ تا ۳۰,۰۰۰ تومان است.',
              isPopular: true,
              tags: ['هزینه ارسال', 'ارسال رایگان'],
            ),

            // Returns FAQs
            FAQ(
              id: '8',
              categoryId: 'returns',
              question: 'چگونه محصول را مرجوع کنم؟',
              answer:
                  'برای مرجوعی محصول، حداکثر تا ۷ روز پس از دریافت، می‌توانید درخواست مرجوعی ثبت کنید. محصول باید در حالت اولیه و با بسته‌بندی سالم باشد.',
              isPopular: true,
              tags: ['مرجوعی', '۷ روز', 'بسته‌بندی'],
            ),
            FAQ(
              id: '9',
              categoryId: 'returns',
              question: 'چه زمانی پول من برگشت می‌خورد؟',
              answer:
                  'پس از تأیید مرجوعی و بازرسی محصول، مبلغ ظرف ۳-۵ روز کاری به حساب شما برگشت می‌خورد. در صورت پرداخت نقدی، از طریق کیف پول برگشت داده می‌شود.',
              isPopular: false,
              tags: ['برگشت وجه', 'کیف پول'],
            ),

            // Account FAQs
            FAQ(
              id: '10',
              categoryId: 'account',
              question: 'چگونه رمز عبور خود را تغییر دهم؟',
              answer:
                  'برای تغییر رمز عبور، به بخش "پروفایل" > "تنظیمات امنیتی" بروید و روی "تغییر رمز عبور" کلیک کنید. رمز عبور جدید باید حداقل ۸ کاراکتر باشد.',
              isPopular: false,
              tags: ['رمز عبور', 'امنیت', 'تغییر'],
            ),
            FAQ(
              id: '11',
              categoryId: 'account',
              question: 'چگونه اطلاعات شخصی خود را ویرایش کنم؟',
              answer:
                  'می‌توانید از بخش "پروفایل" > "ویرایش پروفایل" اطلاعات شخصی، آدرس و شماره تماس خود را بروزرسانی کنید.',
              isPopular: true,
              tags: ['ویرایش پروفایل', 'اطلاعات شخصی'],
            ),

            // Technical FAQs
            FAQ(
              id: '12',
              categoryId: 'technical',
              question: 'چرا نمی‌توانم وارد حساب کاربری شوم؟',
              answer:
                  'اگر مشکل در ورود دارید، ابتدا رمز عبور و نام کاربری خود را بررسی کنید. در صورت فراموشی، از گزینه "فراموشی رمز عبور" استفاده کنید. اگر مشکل ادامه داشت، با پشتیبانی تماس بگیرید.',
              isPopular: false,
              tags: ['ورود', 'مشکل', 'فراموشی رمز'],
            ),
          ];

          _filteredFAQs = _allFAQs;
          _isLoading = false;
        });
      }
    });
  }

  void _filterFAQs() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredFAQs = _allFAQs.where((faq) {
        final matchesCategory =
            _selectedCategoryIndex == 0 ||
            faq.categoryId == _categories[_selectedCategoryIndex].id;
        final matchesSearch =
            query.isEmpty ||
            faq.question.toLowerCase().contains(query) ||
            faq.answer.toLowerCase().contains(query) ||
            faq.tags.any((tag) => tag.toLowerCase().contains(query));
        return matchesCategory && matchesSearch;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark
          ? AppColors.backgroundDark
          : AppColors.backgroundLight,
      appBar: AppBar(
        title: const Text('سوالات متداول'),
        backgroundColor: isDark ? AppColors.surfaceDark : AppColors.white,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: _showContactSupport,
            icon: const Icon(Icons.support_agent),
            tooltip: 'تماس با پشتیبانی',
          ),
        ],
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: ResponsiveContainer(
          child: _isLoading
              ? _buildLoadingState()
              : Column(
                  children: [
                    _buildSearchBar(context),
                    _buildCategoryTabs(context),
                    Expanded(child: _buildFAQsList(context)),
                  ],
                ),
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: AppDimensions.paddingL),
          Text('در حال بارگذاری سوالات...'),
        ],
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.all(AppDimensions.paddingL),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'جستجو در سوالات متداول...',
          prefixIcon: const Icon(Icons.search),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
                  onPressed: () {
                    _searchController.clear();
                    _filterFAQs();
                  },
                  icon: const Icon(Icons.clear),
                )
              : null,
          filled: true,
          fillColor: isDark ? AppColors.surfaceDark : AppColors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppDimensions.radiusL),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryTabs(BuildContext context) {
    return Container(
      height: 60,
      margin: const EdgeInsets.only(bottom: AppDimensions.paddingL),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: AppDimensions.paddingL),
        itemCount: _categories.length,
        itemBuilder: (context, index) {
          final category = _categories[index];
          final isSelected = _selectedCategoryIndex == index;

          return Container(
            margin: const EdgeInsets.only(right: AppDimensions.paddingM),
            child: FilterChip(
              selected: isSelected,
              label: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    category.icon,
                    size: 18,
                    color: isSelected ? AppColors.white : AppColors.primary,
                  ),
                  const SizedBox(width: AppDimensions.paddingXS),
                  Text(category.name),
                ],
              ),
              onSelected: (selected) {
                setState(() {
                  _selectedCategoryIndex = index;
                });
                _filterFAQs();
              },
              backgroundColor: AppColors.white,
              selectedColor: AppColors.primary,
              labelStyle: TextStyle(
                color: isSelected ? AppColors.white : AppColors.primary,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildFAQsList(BuildContext context) {
    if (_filteredFAQs.isEmpty) {
      return _buildEmptyState(context);
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: AppDimensions.paddingL),
      itemCount: _filteredFAQs.length,
      itemBuilder: (context, index) {
        final faq = _filteredFAQs[index];
        return _buildFAQCard(faq, index);
      },
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.paddingXL),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: AppColors.grey400.withOpacity(0.1),
                borderRadius: BorderRadius.circular(60),
              ),
              child: Icon(Icons.search_off, size: 60, color: AppColors.grey400),
            ),
            const SizedBox(height: AppDimensions.paddingXL),
            Text(
              'نتیجه‌ای یافت نشد',
              style: AppTextStyles.headlineSmall.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppDimensions.paddingM),
            Text(
              'متأسفانه سوالی با این مشخصات پیدا نشد\nلطفاً کلمات کلیدی دیگری امتحان کنید',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.grey600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppDimensions.paddingXL),
            ElevatedButton.icon(
              onPressed: _showContactSupport,
              icon: const Icon(Icons.support_agent),
              label: const Text('تماس با پشتیبانی'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFAQCard(FAQ faq, int index) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.only(bottom: AppDimensions.paddingM),
      child: ExpansionTile(
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: faq.isPopular
                ? AppColors.warning.withOpacity(0.1)
                : AppColors.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Icon(
            faq.isPopular ? Icons.star : Icons.help_outline,
            color: faq.isPopular ? AppColors.warning : AppColors.primary,
            size: 20,
          ),
        ),
        title: Text(
          faq.question,
          style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.w600),
        ),
        subtitle: faq.isPopular
            ? Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.warning,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    'پرطرفدار',
                    style: AppTextStyles.labelSmall.copyWith(
                      color: AppColors.white,
                      fontSize: 10,
                    ),
                  ),
                ),
              )
            : null,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppDimensions.paddingL),
            decoration: BoxDecoration(
              color: isDark
                  ? AppColors.surfaceDark.withOpacity(0.5)
                  : AppColors.grey50,
              borderRadius: const BorderRadius.vertical(
                bottom: Radius.circular(AppDimensions.radiusM),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  faq.answer,
                  style: AppTextStyles.bodyMedium.copyWith(height: 1.6),
                ),
                if (faq.tags.isNotEmpty) ...[
                  const SizedBox(height: AppDimensions.paddingM),
                  Wrap(
                    spacing: 8,
                    runSpacing: 4,
                    children: faq.tags
                        .map(
                          (tag) => Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              tag,
                              style: AppTextStyles.bodySmall.copyWith(
                                color: AppColors.primary,
                                fontSize: 11,
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ],
                const SizedBox(height: AppDimensions.paddingM),
                Row(
                  children: [
                    TextButton.icon(
                      onPressed: () => _rateFAQ(faq, true),
                      icon: const Icon(Icons.thumb_up_outlined, size: 16),
                      label: const Text('مفید بود'),
                      style: TextButton.styleFrom(
                        foregroundColor: AppColors.success,
                        padding: EdgeInsets.zero,
                      ),
                    ),
                    TextButton.icon(
                      onPressed: () => _rateFAQ(faq, false),
                      icon: const Icon(Icons.thumb_down_outlined, size: 16),
                      label: const Text('مفید نبود'),
                      style: TextButton.styleFrom(
                        foregroundColor: AppColors.error,
                        padding: EdgeInsets.zero,
                      ),
                    ),
                    const Spacer(),
                    TextButton.icon(
                      onPressed: () => _shareFAQ(faq),
                      icon: const Icon(Icons.share, size: 16),
                      label: const Text('اشتراک'),
                      style: TextButton.styleFrom(
                        foregroundColor: AppColors.info,
                        padding: EdgeInsets.zero,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Action methods
  void _rateFAQ(FAQ faq, bool isHelpful) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          isHelpful ? 'متشکریم از نظر شما' : 'متأسفیم که پاسخ مفید نبود',
        ),
        backgroundColor: isHelpful ? AppColors.success : AppColors.warning,
      ),
    );
  }

  void _shareFAQ(FAQ faq) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('لینک سوال کپی شد')));
  }

  void _showContactSupport() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('تماس با پشتیبانی'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.phone),
              title: Text('تلفن پشتیبانی'),
              subtitle: Text('۰۲۱-۱۲۳۴۵۶۷۸'),
              contentPadding: EdgeInsets.zero,
            ),
            ListTile(
              leading: Icon(Icons.email),
              title: Text('ایمیل پشتیبانی'),
              subtitle: Text('support@sinashop.com'),
              contentPadding: EdgeInsets.zero,
            ),
            ListTile(
              leading: Icon(Icons.access_time),
              title: Text('ساعات کاری'),
              subtitle: Text('شنبه تا پنج‌شنبه: ۹ تا ۱۸'),
              contentPadding: EdgeInsets.zero,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('بستن'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // Navigate to support page
            },
            child: const Text('ارسال پیام'),
          ),
        ],
      ),
    );
  }
}

// Models
class FAQCategory {
  final String id;
  final String name;
  final IconData icon;

  FAQCategory({required this.id, required this.name, required this.icon});
}

class FAQ {
  final String id;
  final String categoryId;
  final String question;
  final String answer;
  final bool isPopular;
  final List<String> tags;

  FAQ({
    required this.id,
    required this.categoryId,
    required this.question,
    required this.answer,
    required this.isPopular,
    required this.tags,
  });
}
