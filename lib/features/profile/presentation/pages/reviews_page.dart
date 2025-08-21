// Reviews Page - Complete Reviews Management
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/responsive_utils.dart';

class ReviewsPage extends StatefulWidget {
  const ReviewsPage({super.key});

  @override
  State<ReviewsPage> createState() => _ReviewsPageState();
}

class _ReviewsPageState extends State<ReviewsPage>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late TabController _tabController;

  List<Review> _myReviews = [];
  List<Review> _pendingReviews = [];
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
    _tabController = TabController(length: 2, vsync: this);
    _animationController.forward();
    _loadReviews();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  void _loadReviews() {
    setState(() => _isLoading = true);

    // Mock reviews data
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() {
          _myReviews = [
            Review(
              id: '1',
              productId: 'p1',
              productName: 'گوشی موبایل سامسونگ Galaxy S23',
              productImage: 'assets/images/products/samsung_s23.jpg',
              rating: 5,
              comment:
                  'محصول فوق‌العاده‌ای است. کیفیت عکس‌برداری بی‌نظیر و عملکرد بسیار خوب.',
              date: DateTime.now().subtract(const Duration(days: 5)),
              isVerified: true,
              likes: 12,
              dislikes: 1,
              shopResponse:
                  'متشکریم از نظر مثبت شما. امیدواریم همیشه راضی باشید.',
              images: [
                'assets/images/reviews/review1_1.jpg',
                'assets/images/reviews/review1_2.jpg',
              ],
            ),
            Review(
              id: '2',
              productId: 'p2',
              productName: 'لپ‌تاپ لنوو ThinkPad',
              productImage: 'assets/images/products/lenovo_thinkpad.jpg',
              rating: 4,
              comment: 'لپ‌تاپ خوبی است اما قیمت کمی بالا. کیفیت ساخت عالی.',
              date: DateTime.now().subtract(const Duration(days: 15)),
              isVerified: true,
              likes: 8,
              dislikes: 3,
            ),
            Review(
              id: '3',
              productId: 'p3',
              productName: 'هدفون بی‌سیم Apple AirPods',
              productImage: 'assets/images/products/airpods.jpg',
              rating: 3,
              comment: 'صدا خوب است اما باتری زودتر از انتظار تمام می‌شود.',
              date: DateTime.now().subtract(const Duration(days: 30)),
              isVerified: true,
              likes: 5,
              dislikes: 7,
            ),
          ];

          _pendingReviews = [
            Review(
              id: '4',
              productId: 'p4',
              productName: 'ساعت هوشمند شیائومی Mi Watch',
              productImage: 'assets/images/products/mi_watch.jpg',
              rating: 0,
              comment: '',
              date: DateTime.now().subtract(const Duration(days: 2)),
              isVerified: false,
              likes: 0,
              dislikes: 0,
              isPending: true,
            ),
            Review(
              id: '5',
              productId: 'p5',
              productName: 'تبلت iPad Air',
              productImage: 'assets/images/products/ipad_air.jpg',
              rating: 0,
              comment: '',
              date: DateTime.now().subtract(const Duration(days: 1)),
              isVerified: false,
              likes: 0,
              dislikes: 0,
              isPending: true,
            ),
          ];
          _isLoading = false;
        });
      }
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
        title: const Text('نظرات و امتیازات'),
        backgroundColor: isDark ? AppColors.surfaceDark : AppColors.white,
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors.primary,
          unselectedLabelColor: AppColors.grey600,
          indicatorColor: AppColors.primary,
          tabs: [
            Tab(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.rate_review_outlined),
                  const SizedBox(width: 8),
                  Text('نظرات من (${_myReviews.length})'),
                ],
              ),
            ),
            Tab(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.pending_outlined),
                  const SizedBox(width: 8),
                  Text('در انتظار نظر (${_pendingReviews.length})'),
                ],
              ),
            ),
          ],
        ),
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: ResponsiveContainer(
          child: _isLoading
              ? _buildLoadingState()
              : TabBarView(
                  controller: _tabController,
                  children: [
                    _buildMyReviewsTab(context),
                    _buildPendingReviewsTab(context),
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
          Text('در حال بارگذاری نظرات...'),
        ],
      ),
    );
  }

  Widget _buildMyReviewsTab(BuildContext context) {
    if (_myReviews.isEmpty) {
      return _buildEmptyState(
        icon: Icons.rate_review_outlined,
        title: 'هیچ نظری ثبت نشده',
        subtitle: 'شما هنوز برای هیچ محصولی نظر ثبت نکرده‌اید',
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppDimensions.paddingL),
      child: Column(
        children: [
          _buildReviewsStats(context),
          const SizedBox(height: AppDimensions.paddingL),
          ..._myReviews.map((review) => _buildReviewCard(review)),
        ],
      ),
    );
  }

  Widget _buildPendingReviewsTab(BuildContext context) {
    if (_pendingReviews.isEmpty) {
      return _buildEmptyState(
        icon: Icons.done_all,
        title: 'همه محصولات بررسی شده',
        subtitle: 'شما برای تمام محصولات خریداری شده نظر ثبت کرده‌اید',
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppDimensions.paddingL),
      child: Column(
        children: [
          _buildPendingHeader(context),
          const SizedBox(height: AppDimensions.paddingL),
          ..._pendingReviews.map((review) => _buildPendingReviewCard(review)),
        ],
      ),
    );
  }

  Widget _buildEmptyState({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
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
              child: Icon(icon, size: 60, color: AppColors.grey400),
            ),
            const SizedBox(height: AppDimensions.paddingXL),
            Text(
              title,
              style: AppTextStyles.headlineSmall.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppDimensions.paddingM),
            Text(
              subtitle,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.grey600,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReviewsStats(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final averageRating = _myReviews.isEmpty
        ? 0.0
        : _myReviews.map((r) => r.rating).reduce((a, b) => a + b) /
              _myReviews.length;
    final totalLikes = _myReviews.fold<int>(
      0,
      (sum, review) => sum + review.likes,
    );
    final verifiedReviews = _myReviews.where((r) => r.isVerified).length;

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
          Text(
            'آمار نظرات شما',
            style: AppTextStyles.headlineSmall.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppDimensions.paddingL),
          Row(
            children: [
              Expanded(
                child: _buildStatItem(
                  icon: Icons.star,
                  value: averageRating.toStringAsFixed(1),
                  label: 'میانگین امتیاز',
                  color: AppColors.warning,
                ),
              ),
              Expanded(
                child: _buildStatItem(
                  icon: Icons.thumb_up_outlined,
                  value: totalLikes.toString(),
                  label: 'لایک دریافتی',
                  color: AppColors.success,
                ),
              ),
              Expanded(
                child: _buildStatItem(
                  icon: Icons.verified,
                  value: verifiedReviews.toString(),
                  label: 'نظر تأیید شده',
                  color: AppColors.info,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String value,
    required String label,
    required Color color,
  }) {
    return Column(
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
        const SizedBox(height: AppDimensions.paddingS),
        Text(
          value,
          style: AppTextStyles.headlineSmall.copyWith(
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: AppTextStyles.bodySmall.copyWith(color: AppColors.grey600),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildPendingHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.paddingL),
      decoration: BoxDecoration(
        color: AppColors.info.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppDimensions.radiusL),
        border: Border.all(color: AppColors.info.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(Icons.info_outline, color: AppColors.info),
          const SizedBox(width: AppDimensions.paddingM),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'نظر شما مهم است',
                  style: AppTextStyles.bodyLarge.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.info,
                  ),
                ),
                const SizedBox(height: AppDimensions.paddingXS),
                Text(
                  'با ثبت نظر، به سایر خریداران کمک کنید و امتیاز کسب کنید',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.info,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewCard(Review review) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.only(bottom: AppDimensions.paddingL),
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
          // Product Info
          Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: AppColors.grey200,
                  borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                ),
                child: Icon(Icons.image, color: AppColors.grey400, size: 30),
              ),
              const SizedBox(width: AppDimensions.paddingM),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      review.productName,
                      style: AppTextStyles.bodyLarge.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: AppDimensions.paddingXS),
                    Text(
                      _formatDate(review.date),
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.grey600,
                      ),
                    ),
                  ],
                ),
              ),
              PopupMenuButton<String>(
                onSelected: (value) => _handleReviewAction(review, value),
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'edit',
                    child: ListTile(
                      leading: Icon(Icons.edit),
                      title: Text('ویرایش نظر'),
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'share',
                    child: ListTile(
                      leading: Icon(Icons.share),
                      title: Text('اشتراک‌گذاری'),
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                  PopupMenuItem(
                    value: 'delete',
                    child: ListTile(
                      leading: Icon(Icons.delete, color: AppColors.error),
                      title: Text(
                        'حذف نظر',
                        style: TextStyle(color: AppColors.error),
                      ),
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: AppDimensions.paddingL),

          // Rating
          Row(
            children: [
              Row(
                children: List.generate(
                  5,
                  (index) => Icon(
                    index < review.rating ? Icons.star : Icons.star_border,
                    color: AppColors.warning,
                    size: 20,
                  ),
                ),
              ),
              const SizedBox(width: AppDimensions.paddingS),
              if (review.isVerified)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.success,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    'تأیید شده',
                    style: AppTextStyles.labelSmall.copyWith(
                      color: AppColors.white,
                      fontSize: 10,
                    ),
                  ),
                ),
            ],
          ),

          if (review.comment.isNotEmpty) ...[
            const SizedBox(height: AppDimensions.paddingM),
            Text(review.comment, style: AppTextStyles.bodyMedium),
          ],

          // Review Images
          if (review.images != null && review.images!.isNotEmpty) ...[
            const SizedBox(height: AppDimensions.paddingM),
            SizedBox(
              height: 80,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: review.images!.length,
                itemBuilder: (context, index) => Container(
                  width: 80,
                  height: 80,
                  margin: const EdgeInsets.only(right: AppDimensions.paddingS),
                  decoration: BoxDecoration(
                    color: AppColors.grey200,
                    borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                  ),
                  child: Icon(Icons.image, color: AppColors.grey400),
                ),
              ),
            ),
          ],

          const SizedBox(height: AppDimensions.paddingL),

          // Actions
          Row(
            children: [
              _buildActionButton(
                icon: Icons.thumb_up_outlined,
                label: review.likes.toString(),
                onTap: () => _likeReview(review),
              ),
              const SizedBox(width: AppDimensions.paddingM),
              _buildActionButton(
                icon: Icons.thumb_down_outlined,
                label: review.dislikes.toString(),
                onTap: () => _dislikeReview(review),
              ),
              const Spacer(),
              if (review.shopResponse != null)
                TextButton(
                  onPressed: () => _showShopResponse(review),
                  child: const Text('پاسخ فروشگاه'),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPendingReviewCard(Review review) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.only(bottom: AppDimensions.paddingL),
      padding: const EdgeInsets.all(AppDimensions.paddingL),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.white,
        borderRadius: BorderRadius.circular(AppDimensions.radiusL),
        border: Border.all(color: AppColors.warning.withOpacity(0.3)),
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
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: AppColors.grey200,
                  borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                ),
                child: Icon(Icons.image, color: AppColors.grey400, size: 30),
              ),
              const SizedBox(width: AppDimensions.paddingM),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      review.productName,
                      style: AppTextStyles.bodyLarge.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: AppDimensions.paddingXS),
                    Row(
                      children: [
                        Icon(
                          Icons.schedule,
                          color: AppColors.warning,
                          size: 16,
                        ),
                        const SizedBox(width: AppDimensions.paddingXS),
                        Text(
                          'خریداری شده ${_formatDate(review.date)}',
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.warning,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: AppDimensions.paddingL),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => _writeReview(review),
              icon: const Icon(Icons.rate_review),
              label: const Text('نوشتن نظر'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.white,
                padding: const EdgeInsets.symmetric(
                  vertical: AppDimensions.paddingM,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppDimensions.radiusS),
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.paddingS),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 18, color: AppColors.grey600),
            const SizedBox(width: AppDimensions.paddingXS),
            Text(
              label,
              style: AppTextStyles.bodySmall.copyWith(color: AppColors.grey600),
            ),
          ],
        ),
      ),
    );
  }

  // Helper methods
  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date).inDays;

    if (difference == 0) return 'امروز';
    if (difference == 1) return 'دیروز';
    if (difference < 30) return '$difference روز پیش';
    if (difference < 365) return '${(difference / 30).floor()} ماه پیش';
    return '${(difference / 365).floor()} سال پیش';
  }

  // Action methods
  void _handleReviewAction(Review review, String action) {
    switch (action) {
      case 'edit':
        _editReview(review);
        break;
      case 'share':
        _shareReview(review);
        break;
      case 'delete':
        _deleteReview(review);
        break;
    }
  }

  void _editReview(Review review) {
    showDialog(
      context: context,
      builder: (context) => WriteReviewDialog(
        review: review,
        isEdit: true,
        onReviewSubmitted: (updatedReview) {
          setState(() {
            final index = _myReviews.indexWhere(
              (r) => r.id == updatedReview.id,
            );
            if (index != -1) {
              _myReviews[index] = updatedReview;
            }
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('نظر شما با موفقیت ویرایش شد'),
              backgroundColor: AppColors.success,
            ),
          );
        },
      ),
    );
  }

  void _shareReview(Review review) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('اشتراک‌گذاری نظر')));
  }

  void _deleteReview(Review review) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('حذف نظر'),
        content: const Text(
          'آیا مطمئن هستید که می‌خواهید این نظر را حذف کنید؟',
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
                _myReviews.removeWhere((r) => r.id == review.id);
              });
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('نظر حذف شد'),
                  backgroundColor: AppColors.error,
                ),
              );
            },
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: const Text('حذف'),
          ),
        ],
      ),
    );
  }

  void _writeReview(Review review) {
    showDialog(
      context: context,
      builder: (context) => WriteReviewDialog(
        review: review,
        isEdit: false,
        onReviewSubmitted: (newReview) {
          setState(() {
            _pendingReviews.removeWhere((r) => r.id == review.id);
            _myReviews.insert(0, newReview);
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('نظر شما با موفقیت ثبت شد'),
              backgroundColor: AppColors.success,
            ),
          );
        },
      ),
    );
  }

  void _likeReview(Review review) {
    setState(() {
      review.likes++;
    });
  }

  void _dislikeReview(Review review) {
    setState(() {
      review.dislikes++;
    });
  }

  void _showShopResponse(Review review) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('پاسخ فروشگاه'),
        content: Text(review.shopResponse ?? ''),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('بستن'),
          ),
        ],
      ),
    );
  }
}

// Write Review Dialog
class WriteReviewDialog extends StatefulWidget {
  final Review review;
  final bool isEdit;
  final Function(Review) onReviewSubmitted;

  const WriteReviewDialog({
    super.key,
    required this.review,
    required this.isEdit,
    required this.onReviewSubmitted,
  });

  @override
  State<WriteReviewDialog> createState() => _WriteReviewDialogState();
}

class _WriteReviewDialogState extends State<WriteReviewDialog> {
  final _commentController = TextEditingController();
  int _rating = 0;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.isEdit) {
      _rating = widget.review.rating;
      _commentController.text = widget.review.comment;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.isEdit ? 'ویرایش نظر' : 'نوشتن نظر'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product info
            Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: AppColors.grey200,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(Icons.image, color: AppColors.grey400),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    widget.review.productName,
                    style: AppTextStyles.bodyMedium.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Rating
            const Text(
              'امتیاز شما:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Row(
              children: List.generate(
                5,
                (index) => GestureDetector(
                  onTap: () => setState(() => _rating = index + 1),
                  child: Icon(
                    index < _rating ? Icons.star : Icons.star_border,
                    color: AppColors.warning,
                    size: 32,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Comment
            const Text(
              'نظر شما:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _commentController,
              maxLines: 4,
              decoration: const InputDecoration(
                hintText: 'نظر خود را در مورد این محصول بنویسید...',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('انصراف'),
        ),
        ElevatedButton(
          onPressed: _rating > 0 && !_isLoading ? _submitReview : null,
          child: _isLoading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Text(widget.isEdit ? 'ویرایش' : 'ثبت نظر'),
        ),
      ],
    );
  }

  void _submitReview() async {
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 1));

    final updatedReview = Review(
      id: widget.review.id,
      productId: widget.review.productId,
      productName: widget.review.productName,
      productImage: widget.review.productImage,
      rating: _rating,
      comment: _commentController.text,
      date: widget.isEdit ? widget.review.date : DateTime.now(),
      isVerified: false, // New reviews need verification
      likes: widget.review.likes,
      dislikes: widget.review.dislikes,
      isPending: false,
    );

    Navigator.pop(context);
    widget.onReviewSubmitted(updatedReview);
  }
}

// Review Model
class Review {
  final String id;
  final String productId;
  final String productName;
  final String productImage;
  int rating;
  String comment;
  final DateTime date;
  bool isVerified;
  int likes;
  int dislikes;
  final String? shopResponse;
  final List<String>? images;
  final bool isPending;

  Review({
    required this.id,
    required this.productId,
    required this.productName,
    required this.productImage,
    required this.rating,
    required this.comment,
    required this.date,
    required this.isVerified,
    required this.likes,
    required this.dislikes,
    this.shopResponse,
    this.images,
    this.isPending = false,
  });
}
