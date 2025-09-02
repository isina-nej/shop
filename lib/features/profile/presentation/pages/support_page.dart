// Support Page - Complete Support & Contact Management
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/responsive_utils.dart';
import '../../../../core/localization/localization_extension.dart';

class SupportPage extends StatefulWidget {
  const SupportPage({super.key});

  @override
  State<SupportPage> createState() => _SupportPageState();
}

class _SupportPageState extends State<SupportPage>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late TabController _tabController;

  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _subjectController = TextEditingController();
  final _messageController = TextEditingController();

  String _selectedDepartment = 'general';
  String _selectedPriority = 'normal';
  bool _isLoading = false;

  List<SupportTicket> _myTickets = [];

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
    _tabController = TabController(length: 3, vsync: this);
    _animationController.forward();
    _loadMyTickets();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _tabController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _subjectController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  void _loadMyTickets() {
    // Mock tickets data
    _myTickets = [
      SupportTicket(
        id: 'T001',
        subject: 'مشکل در پرداخت سفارش',
        department: 'payment',
        priority: 'high',
        status: 'open',
        createdAt: DateTime.now().subtract(const Duration(hours: 2)),
        lastReply: DateTime.now().subtract(const Duration(hours: 1)),
        messages: [
          TicketMessage(
            id: '1',
            isFromUser: true,
            message:
                'سلام، موقع پرداخت سفارش ۱۲۳۴۵، پول از حساب کم شده ولی سفارش ثبت نشده.',
            timestamp: DateTime.now().subtract(const Duration(hours: 2)),
          ),
          TicketMessage(
            id: '2',
            isFromUser: false,
            message:
                'سلام و وقت بخیر، پرونده شما بررسی شد. لطفاً ۲۴ ساعت صبر کنید تا مبلغ برگشت بخورد.',
            timestamp: DateTime.now().subtract(const Duration(hours: 1)),
            adminName: 'علی احمدی',
          ),
        ],
      ),
      SupportTicket(
        id: 'T002',
        subject: 'سوال در مورد ارسال',
        department: 'delivery',
        priority: 'normal',
        status: 'closed',
        createdAt: DateTime.now().subtract(const Duration(days: 3)),
        lastReply: DateTime.now().subtract(const Duration(days: 2)),
        messages: [
          TicketMessage(
            id: '3',
            isFromUser: true,
            message: 'چرا سفارشم هنوز ارسال نشده؟',
            timestamp: DateTime.now().subtract(const Duration(days: 3)),
          ),
          TicketMessage(
            id: '4',
            isFromUser: false,
            message: 'سفارش شما امروز ارسال شد. کد پیگیری: ۱۲۳۴۵۶۷۸۹',
            timestamp: DateTime.now().subtract(const Duration(days: 2)),
            adminName: 'مریم رضایی',
          ),
        ],
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark
          ? AppColors.backgroundDark
          : AppColors.backgroundLight,
      appBar: AppBar(
        title: Text(context.tr('support_contact')),
        backgroundColor: isDark ? AppColors.surfaceDark : AppColors.white,
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors.primary,
          unselectedLabelColor: AppColors.grey600,
          indicatorColor: AppColors.primary,
          tabs: [
            Tab(
              icon: const Icon(Icons.contact_support),
              text: context.tr('contact_us_tab'),
            ),
            Tab(
              icon: const Icon(Icons.message),
              text: context.tr('submit_ticket_tab'),
            ),
            Tab(
              icon: const Icon(Icons.history),
              text: context.tr('my_tickets_tab'),
            ),
          ],
        ),
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: ResponsiveContainer(
          child: TabBarView(
            controller: _tabController,
            children: [
              _buildContactTab(context),
              _buildTicketTab(context),
              _buildMyTicketsTab(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContactTab(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(AppDimensions.paddingL),
      child: Column(
        children: [
          _buildSupportHeader(context),
          SizedBox(height: AppDimensions.paddingL),
          _buildContactMethods(context),
          SizedBox(height: AppDimensions.paddingL),
          _buildWorkingHours(context),
          SizedBox(height: AppDimensions.paddingL),
          _buildQuickActions(context),
        ],
      ),
    );
  }

  Widget _buildSupportHeader(BuildContext context) {
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
            blurRadius: 12,
            offset: const Offset(0, 4),
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
            child: Icon(Icons.support_agent, color: AppColors.white, size: 40),
          ),
          SizedBox(height: AppDimensions.paddingL),
          Text(
            context.tr('sina_shop_support'),
            style: AppTextStyles.headlineMedium.copyWith(
              color: AppColors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: AppDimensions.paddingS),
          Text(
            context.tr('support_message'),
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.white.withValues(alpha: 0.9),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildContactMethods(BuildContext context) {
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
          Text(
            context.tr('contact_methods'),
            style: AppTextStyles.headlineSmall.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: AppDimensions.paddingL),

          _buildContactMethod(
            icon: Icons.phone,
            title: context.tr('support_phone'),
            subtitle: '۰۲۱-۱۲۳۴۵۶۷۸',
            action: context.tr('call'),
            onTap: () => _callSupport('02112345678'),
            color: AppColors.success,
          ),

          _buildContactMethod(
            icon: Icons.email,
            title: context.tr('support_email'),
            subtitle: 'support@sinashop.com',
            action: context.tr('send_email'),
            onTap: () => _emailSupport('support@sinashop.com'),
            color: AppColors.info,
          ),

          _buildContactMethod(
            icon: Icons.chat,
            title: 'چت آنلاین',
            subtitle: 'پاسخ فوری به سوالات شما',
            action: 'شروع چت',
            onTap: () => _startLiveChat(),
            color: AppColors.primary,
          ),

          _buildContactMethod(
            icon: Icons.telegram,
            title: context.tr('support_telegram'),
            subtitle: '@SinaShopSupport',
            action: context.tr('send_message'),
            onTap: () => _openTelegram('@SinaShopSupport'),
            color: AppColors.warning,
          ),
        ],
      ),
    );
  }

  Widget _buildContactMethod({
    required IconData icon,
    required String title,
    required String subtitle,
    required String action,
    required VoidCallback onTap,
    required Color color,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: AppDimensions.paddingM),
      child: ListTile(
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(25),
          ),
          child: Icon(icon, color: color, size: 24),
        ),
        title: Text(
          title,
          style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.w600),
        ),
        subtitle: Text(subtitle),
        trailing: OutlinedButton(
          onPressed: onTap,
          style: OutlinedButton.styleFrom(
            foregroundColor: color,
            side: BorderSide(color: color),
          ),
          child: Text(action),
        ),
        contentPadding: EdgeInsets.zero,
      ),
    );
  }

  Widget _buildWorkingHours(BuildContext context) {
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
              Icon(Icons.access_time, color: AppColors.primary),
              SizedBox(width: AppDimensions.paddingS),
              Text(
                context.tr('support_working_hours'),
                style: AppTextStyles.headlineSmall.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: AppDimensions.paddingL),

          _buildWorkingDay('شنبه تا چهارشنبه', '۹:۰۰ - ۱۸:۰۰', true),
          _buildWorkingDay('پنج‌شنبه', '۹:۰۰ - ۱۴:۰۰', true),
          _buildWorkingDay('جمعه', 'تعطیل', false),

          SizedBox(height: AppDimensions.paddingM),
          Container(
            padding: EdgeInsets.all(AppDimensions.paddingM),
            decoration: BoxDecoration(
              color: AppColors.info.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AppDimensions.radiusM),
            ),
            child: Row(
              children: [
                Icon(Icons.info_outline, color: AppColors.info, size: 20),
                SizedBox(width: AppDimensions.paddingS),
                Expanded(
                  child: Text(
                    context.tr('online_support_active'),
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.info,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWorkingDay(String day, String hours, bool isWorking) {
    return Padding(
      padding: EdgeInsets.only(bottom: AppDimensions.paddingS),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: isWorking ? AppColors.success : AppColors.error,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          SizedBox(width: AppDimensions.paddingM),
          Expanded(
            child: Text(
              day,
              style: AppTextStyles.bodyMedium.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Text(
            hours,
            style: AppTextStyles.bodyMedium.copyWith(
              color: isWorking ? AppColors.success : AppColors.error,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
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
          Text(
            context.tr('quick_actions'),
            style: AppTextStyles.headlineSmall.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: AppDimensions.paddingL),

          Row(
            children: [
              Expanded(
                child: _buildQuickActionButton(
                  icon: Icons.help_outline,
                  title: 'سوالات متداول',
                  subtitle: 'پاسخ سریع',
                  onTap: () => Navigator.pushNamed(context, '/faq'),
                  color: AppColors.info,
                ),
              ),
              SizedBox(width: AppDimensions.paddingM),
              Expanded(
                child: _buildQuickActionButton(
                  icon: Icons.bug_report,
                  title: 'گزارش باگ',
                  subtitle: 'مشکل فنی',
                  onTap: () => _reportBug(),
                  color: AppColors.error,
                ),
              ),
            ],
          ),

          SizedBox(height: AppDimensions.paddingM),

          Row(
            children: [
              Expanded(
                child: _buildQuickActionButton(
                  icon: Icons.feedback,
                  title: 'نظرات و پیشنهادات',
                  subtitle: 'بهبود سرویس',
                  onTap: () => _giveFeedback(),
                  color: AppColors.success,
                ),
              ),
              SizedBox(width: AppDimensions.paddingM),
              Expanded(
                child: _buildQuickActionButton(
                  icon: Icons.school,
                  title: 'آموزش استفاده',
                  subtitle: 'راهنمای کاربری',
                  onTap: () => _showTutorials(),
                  color: AppColors.warning,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionButton({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    required Color color,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppDimensions.radiusM),
      child: Container(
        padding: EdgeInsets.all(AppDimensions.paddingM),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(AppDimensions.radiusM),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 32),
            SizedBox(height: AppDimensions.paddingS),
            Text(
              title,
              style: AppTextStyles.bodySmall.copyWith(
                color: color,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            Text(
              subtitle,
              style: AppTextStyles.labelSmall.copyWith(
                color: color.withValues(alpha: 0.8),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTicketTab(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(AppDimensions.paddingL),
      child: Form(
        key: _formKey,
        child: Column(children: [_buildTicketForm(context)]),
      ),
    );
  }

  Widget _buildTicketForm(BuildContext context) {
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
          Text(
            context.tr('submit_support_ticket'),
            style: AppTextStyles.headlineSmall.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: AppDimensions.paddingL),

          TextFormField(
            controller: _nameController,
            decoration: const InputDecoration(
              labelText: 'نام و نام خانوادگی',
              prefixIcon: Icon(Icons.person),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'نام خود را وارد کنید';
              }
              return null;
            },
          ),

          SizedBox(height: AppDimensions.paddingM),

          TextFormField(
            controller: _emailController,
            decoration: const InputDecoration(
              labelText: 'ایمیل',
              prefixIcon: Icon(Icons.email),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'ایمیل خود را وارد کنید';
              }
              return null;
            },
          ),

          SizedBox(height: AppDimensions.paddingM),

          DropdownButtonFormField<String>(
            initialValue: _selectedDepartment,
            decoration: const InputDecoration(
              labelText: 'بخش مربوطه',
              prefixIcon: Icon(Icons.category),
            ),
            items: [
              DropdownMenuItem(
                value: 'general',
                child: Text(context.tr('general')),
              ),
              DropdownMenuItem(
                value: 'orders',
                child: Text(context.tr('orders')),
              ),
              DropdownMenuItem(
                value: 'payment',
                child: Text(context.tr('payment')),
              ),
              DropdownMenuItem(
                value: 'delivery',
                child: Text(context.tr('delivery')),
              ),
              DropdownMenuItem(
                value: 'technical',
                child: Text(context.tr('technical_issues')),
              ),
              DropdownMenuItem(
                value: 'account',
                child: Text(context.tr('user_account')),
              ),
            ],
            onChanged: (value) {
              setState(() {
                _selectedDepartment = value!;
              });
            },
          ),

          SizedBox(height: AppDimensions.paddingM),

          DropdownButtonFormField<String>(
            initialValue: _selectedPriority,
            decoration: const InputDecoration(
              labelText: 'اولویت',
              prefixIcon: Icon(Icons.priority_high),
            ),
            items: [
              DropdownMenuItem(value: 'low', child: Text(context.tr('low'))),
              DropdownMenuItem(
                value: 'normal',
                child: Text(context.tr('normal')),
              ),
              DropdownMenuItem(value: 'high', child: Text(context.tr('high'))),
              DropdownMenuItem(
                value: 'urgent',
                child: Text(context.tr('urgent')),
              ),
            ],
            onChanged: (value) {
              setState(() {
                _selectedPriority = value!;
              });
            },
          ),

          SizedBox(height: AppDimensions.paddingM),

          TextFormField(
            controller: _subjectController,
            decoration: const InputDecoration(
              labelText: 'موضوع',
              prefixIcon: Icon(Icons.subject),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'موضوع را وارد کنید';
              }
              return null;
            },
          ),

          SizedBox(height: AppDimensions.paddingM),

          TextFormField(
            controller: _messageController,
            decoration: const InputDecoration(
              labelText: 'توضیحات',
              prefixIcon: Icon(Icons.message),
              alignLabelWithHint: true,
            ),
            maxLines: 5,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'توضیحات را وارد کنید';
              }
              return null;
            },
          ),

          SizedBox(height: AppDimensions.paddingXL),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _isLoading ? null : _submitTicket,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.white,
                padding: EdgeInsets.symmetric(vertical: AppDimensions.paddingL),
              ),
              child: _isLoading
                  ? const CircularProgressIndicator(color: AppColors.white)
                  : Text(context.tr('submit_ticket')),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMyTicketsTab(BuildContext context) {
    if (_myTickets.isEmpty) {
      return _buildEmptyTicketsState(context);
    }

    return ListView.builder(
      padding: EdgeInsets.all(AppDimensions.paddingL),
      itemCount: _myTickets.length,
      itemBuilder: (context, index) {
        final ticket = _myTickets[index];
        return _buildTicketCard(ticket);
      },
    );
  }

  Widget _buildEmptyTicketsState(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(AppDimensions.paddingXL),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: AppColors.grey400.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(60),
              ),
              child: Icon(
                Icons.support_agent,
                size: 60,
                color: AppColors.grey400,
              ),
            ),
            SizedBox(height: AppDimensions.paddingXL),
            Text(
              context.tr('no_tickets'),
              style: AppTextStyles.headlineSmall.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: AppDimensions.paddingM),
            Text(
              context.tr('no_tickets_message'),
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.grey600,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: AppDimensions.paddingXL),
            ElevatedButton(
              onPressed: () => _tabController.index = 1,
              child: Text(context.tr('new_ticket')),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTicketCard(SupportTicket ticket) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: EdgeInsets.only(bottom: AppDimensions.paddingL),
      padding: EdgeInsets.all(AppDimensions.paddingL),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.white,
        borderRadius: BorderRadius.circular(AppDimensions.radiusL),
        border: Border.all(
          color: _getStatusColor(ticket.status).withValues(alpha: 0.3),
        ),
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
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: _getStatusColor(ticket.status).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  _getStatusText(ticket.status),
                  style: AppTextStyles.labelSmall.copyWith(
                    color: _getStatusColor(ticket.status),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(width: AppDimensions.paddingS),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: _getPriorityColor(
                    ticket.priority,
                  ).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  _getPriorityText(ticket.priority),
                  style: AppTextStyles.labelSmall.copyWith(
                    color: _getPriorityColor(ticket.priority),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const Spacer(),
              Text(
                context.tr('ticket_code').replaceAll('{id}', ticket.id),
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.grey600,
                ),
              ),
            ],
          ),

          SizedBox(height: AppDimensions.paddingM),

          Text(
            ticket.subject,
            style: AppTextStyles.bodyLarge.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),

          SizedBox(height: AppDimensions.paddingS),

          Text(
            context
                .tr('department')
                .replaceAll(
                  '{department}',
                  _getDepartmentText(ticket.department),
                ),
            style: AppTextStyles.bodySmall.copyWith(color: AppColors.grey600),
          ),

          SizedBox(height: AppDimensions.paddingS),

          Row(
            children: [
              Icon(Icons.access_time, size: 16, color: AppColors.grey600),
              SizedBox(width: AppDimensions.paddingXS),
              Text(
                context
                    .tr('created_at')
                    .replaceAll('{date}', _formatDate(ticket.createdAt)),
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.grey600,
                ),
              ),
              SizedBox(width: AppDimensions.paddingM),
              Icon(Icons.reply, size: 16, color: AppColors.grey600),
              SizedBox(width: AppDimensions.paddingXS),
              Text(
                context
                    .tr('last_reply')
                    .replaceAll('{date}', _formatDate(ticket.lastReply)),
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.grey600,
                ),
              ),
            ],
          ),

          SizedBox(height: AppDimensions.paddingM),

          Row(
            children: [
              OutlinedButton.icon(
                onPressed: () => _viewTicket(ticket),
                icon: const Icon(Icons.visibility, size: 16),
                label: Text(context.tr('view')),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.primary,
                ),
              ),
              if (ticket.status == 'open') ...[
                SizedBox(width: AppDimensions.paddingS),
                OutlinedButton.icon(
                  onPressed: () => _replyTicket(ticket),
                  icon: const Icon(Icons.reply, size: 16),
                  label: Text(context.tr('reply')),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.success,
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  // Helper methods
  Color _getStatusColor(String status) {
    switch (status) {
      case 'open':
        return AppColors.warning;
      case 'closed':
        return AppColors.success;
      case 'pending':
        return AppColors.info;
      default:
        return AppColors.grey600;
    }
  }

  String _getStatusText(String status) {
    switch (status) {
      case 'open':
        return 'باز';
      case 'closed':
        return 'بسته';
      case 'pending':
        return 'در انتظار';
      default:
        return 'نامشخص';
    }
  }

  Color _getPriorityColor(String priority) {
    switch (priority) {
      case 'low':
        return AppColors.success;
      case 'normal':
        return AppColors.info;
      case 'high':
        return AppColors.warning;
      case 'urgent':
        return AppColors.error;
      default:
        return AppColors.grey600;
    }
  }

  String _getPriorityText(String priority) {
    switch (priority) {
      case 'low':
        return 'کم';
      case 'normal':
        return 'معمولی';
      case 'high':
        return 'بالا';
      case 'urgent':
        return 'فوری';
      default:
        return 'نامشخص';
    }
  }

  String _getDepartmentText(String department) {
    switch (department) {
      case 'general':
        return 'عمومی';
      case 'orders':
        return 'سفارشات';
      case 'payment':
        return 'پرداخت';
      case 'delivery':
        return 'ارسال';
      case 'technical':
        return 'مشکلات فنی';
      case 'account':
        return 'حساب کاربری';
      default:
        return 'نامشخص';
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes} دقیقه پیش';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} ساعت پیش';
    } else {
      return '${difference.inDays} روز پیش';
    }
  }

  // Action methods
  void _callSupport(String phoneNumber) {
    Clipboard.setData(ClipboardData(text: phoneNumber));
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(context.tr('phone_copied'))));
  }

  void _emailSupport(String email) {
    Clipboard.setData(ClipboardData(text: email));
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(context.tr('email_copied'))));
  }

  void _startLiveChat() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(context.tr('online_chat_coming_soon'))),
    );
  }

  void _openTelegram(String username) {
    Clipboard.setData(ClipboardData(text: username));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(context.tr('telegram_username_copied'))),
    );
  }

  void _reportBug() {
    _tabController.index = 1;
    setState(() {
      _selectedDepartment = 'technical';
      _subjectController.text = 'گزارش باگ: ';
    });
  }

  void _giveFeedback() {
    _tabController.index = 1;
    setState(() {
      _selectedDepartment = 'general';
      _subjectController.text = 'نظرات و پیشنهادات';
    });
  }

  void _showTutorials() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(context.tr('tutorials_coming_soon'))),
    );
  }

  void _submitTicket() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

    setState(() => _isLoading = false);

    // Clear form
    _nameController.clear();
    _emailController.clear();
    _subjectController.clear();
    _messageController.clear();

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(context.tr('ticket_submitted_successfully')),
          backgroundColor: AppColors.success,
        ),
      );

      // Switch to my tickets tab
      _tabController.index = 2;
    }
  }

  void _viewTicket(SupportTicket ticket) {
    showDialog(
      context: context,
      builder: (context) => TicketDetailsDialog(ticket: ticket),
    );
  }

  void _replyTicket(SupportTicket ticket) {
    showDialog(
      context: context,
      builder: (context) => ReplyTicketDialog(
        ticket: ticket,
        onReply: (message) {
          // Add reply to ticket
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(context.tr('your_reply_sent'))),
          );
        },
      ),
    );
  }
}

// Ticket Details Dialog
class TicketDetailsDialog extends StatelessWidget {
  final SupportTicket ticket;

  const TicketDetailsDialog({super.key, required this.ticket});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: double.maxFinite,
        padding: EdgeInsets.all(AppDimensions.paddingL),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              context.tr('ticket_details').replaceAll('{id}', ticket.id),
              style: AppTextStyles.headlineSmall.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: AppDimensions.paddingL),

            Text(
              context.tr('subject').replaceAll('{subject}', ticket.subject),
              style: AppTextStyles.bodyLarge.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),

            SizedBox(height: AppDimensions.paddingM),

            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: ticket.messages.length,
                itemBuilder: (context, index) {
                  final message = ticket.messages[index];
                  return Container(
                    margin: EdgeInsets.only(bottom: AppDimensions.paddingM),
                    padding: EdgeInsets.all(AppDimensions.paddingM),
                    decoration: BoxDecoration(
                      color: message.isFromUser
                          ? AppColors.primary.withValues(alpha: 0.1)
                          : AppColors.grey100,
                      borderRadius: BorderRadius.circular(
                        AppDimensions.radiusM,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          message.isFromUser
                              ? context.tr('you')
                              : message.adminName ?? context.tr('support_team'),
                          style: AppTextStyles.bodySmall.copyWith(
                            fontWeight: FontWeight.bold,
                            color: message.isFromUser
                                ? AppColors.primary
                                : AppColors.success,
                          ),
                        ),
                        SizedBox(height: AppDimensions.paddingXS),
                        Text(message.message, style: AppTextStyles.bodyMedium),
                        SizedBox(height: AppDimensions.paddingXS),
                        Text(
                          _formatMessageDate(message.timestamp),
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.grey600,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            SizedBox(height: AppDimensions.paddingL),

            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(context.tr('close')),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatMessageDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} - ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }
}

// Reply Ticket Dialog
class ReplyTicketDialog extends StatefulWidget {
  final SupportTicket ticket;
  final Function(String) onReply;

  const ReplyTicketDialog({
    super.key,
    required this.ticket,
    required this.onReply,
  });

  @override
  State<ReplyTicketDialog> createState() => _ReplyTicketDialogState();
}

class _ReplyTicketDialogState extends State<ReplyTicketDialog> {
  final _replyController = TextEditingController();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('${context.tr('reply_to_ticket')} ${widget.ticket.id}'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _replyController,
            decoration: InputDecoration(
              hintText: context.tr('reply_hint'),
              border: const OutlineInputBorder(),
            ),
            maxLines: 4,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(context.tr('cancel')),
        ),
        ElevatedButton(
          onPressed: _isLoading ? null : _sendReply,
          child: _isLoading
              ? const CircularProgressIndicator()
              : Text(context.tr('send')),
        ),
      ],
    );
  }

  void _sendReply() async {
    if (_replyController.text.trim().isEmpty) return;

    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 1));

    if (mounted) {
      Navigator.pop(context);
    }
    widget.onReply(_replyController.text);
  }
}

// Models
class SupportTicket {
  final String id;
  final String subject;
  final String department;
  final String priority;
  final String status;
  final DateTime createdAt;
  final DateTime lastReply;
  final List<TicketMessage> messages;

  SupportTicket({
    required this.id,
    required this.subject,
    required this.department,
    required this.priority,
    required this.status,
    required this.createdAt,
    required this.lastReply,
    required this.messages,
  });
}

class TicketMessage {
  final String id;
  final bool isFromUser;
  final String message;
  final DateTime timestamp;
  final String? adminName;

  TicketMessage({
    required this.id,
    required this.isFromUser,
    required this.message,
    required this.timestamp,
    this.adminName,
  });
}
