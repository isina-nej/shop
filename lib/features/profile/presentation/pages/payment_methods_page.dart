// Payment Methods Page - Complete Payment Management
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/responsive_utils.dart';
import '../../../../core/localization/localization_extension.dart';

class PaymentMethodsPage extends StatefulWidget {
  const PaymentMethodsPage({super.key});

  @override
  State<PaymentMethodsPage> createState() => _PaymentMethodsPageState();
}

class _PaymentMethodsPageState extends State<PaymentMethodsPage>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  List<PaymentMethod> _paymentMethods = [];
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
    _loadPaymentMethods();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _loadPaymentMethods() {
    setState(() => _isLoading = true);

    // Mock payment methods data
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() {
          _paymentMethods = [
            PaymentMethod(
              id: '1',
              type: PaymentMethodType.card,
              title: 'کارت ملی ایران',
              subtitle: '**** **** **** 1234',
              isDefault: true,
              expiryDate: '12/25',
              holderName: 'علی احمدی',
              bankName: 'بانک ملی ایران',
              cardImage: 'assets/images/cards/melli.png',
            ),
            PaymentMethod(
              id: '2',
              type: PaymentMethodType.card,
              title: 'کارت پارسیان',
              subtitle: '**** **** **** 5678',
              isDefault: false,
              expiryDate: '08/26',
              holderName: 'علی احمدی',
              bankName: 'بانک پارسیان',
              cardImage: 'assets/images/cards/parsian.png',
            ),
            PaymentMethod(
              id: '3',
              type: PaymentMethodType.wallet,
              title: 'کیف پول',
              subtitle: 'موجودی: ۲۵۰,۰۰۰ تومان',
              isDefault: false,
              balance: 250000,
            ),
            PaymentMethod(
              id: '4',
              type: PaymentMethodType.installment,
              title: 'خرید اقساطی',
              subtitle: 'تا ۳۶ ماه اقساط بدون بهره',
              isDefault: false,
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
        title: Text(context.tr('payment_methods')),
        backgroundColor: isDark ? AppColors.surfaceDark : AppColors.white,
        elevation: 0,
        actions: [
          IconButton(onPressed: _addPaymentMethod, icon: const Icon(Icons.add)),
        ],
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: ResponsiveContainer(
          child: _isLoading
              ? _buildLoadingState()
              : _paymentMethods.isEmpty
              ? _buildEmptyState(context)
              : _buildPaymentMethodsList(context),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _addPaymentMethod,
        icon: const Icon(Icons.add),
        label: Text(context.tr('add_payment_method')),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.white,
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
          Text(context.tr('loading')),
        ],
      ),
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
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(60),
              ),
              child: Icon(Icons.payment, size: 60, color: AppColors.primary),
            ),
            const SizedBox(height: AppDimensions.paddingXL),
            Text(
              'هیچ روش پرداختی اضافه نشده',
              style: AppTextStyles.headlineSmall.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppDimensions.paddingM),
            Text(
              'برای پرداخت راحت‌تر در خریدهای آتی، کارت بانکی یا کیف پول خود را اضافه کنید',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.grey600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppDimensions.paddingXL),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _addPaymentMethod,
                icon: const Icon(Icons.add),
                label: Text(context.tr('add_payment_method')),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.white,
                  padding: const EdgeInsets.symmetric(
                    vertical: AppDimensions.paddingL,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentMethodsList(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppDimensions.paddingL),
      child: Column(
        children: [
          _buildQuickActions(context),
          const SizedBox(height: AppDimensions.paddingL),
          _buildDefaultPaymentSection(context),
          const SizedBox(height: AppDimensions.paddingL),
          _buildPaymentMethodsSection(context),
          const SizedBox(height: AppDimensions.paddingXL + 60), // For FAB
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
            'عملیات سریع',
            style: AppTextStyles.headlineSmall.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppDimensions.paddingL),
          Row(
            children: [
              Expanded(
                child: _buildQuickActionButton(
                  icon: Icons.account_balance_wallet_outlined,
                  title: 'شارژ کیف پول',
                  color: AppColors.success,
                  onTap: _chargeWallet,
                ),
              ),
              const SizedBox(width: AppDimensions.paddingM),
              Expanded(
                child: _buildQuickActionButton(
                  icon: Icons.credit_card_outlined,
                  title: 'افزودن کارت',
                  color: AppColors.primary,
                  onTap: _addCard,
                ),
              ),
              const SizedBox(width: AppDimensions.paddingM),
              Expanded(
                child: _buildQuickActionButton(
                  icon: Icons.history,
                  title: 'تراکنش‌ها',
                  color: AppColors.info,
                  onTap: _viewTransactions,
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
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppDimensions.radiusM),
      child: Container(
        padding: const EdgeInsets.all(AppDimensions.paddingM),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(AppDimensions.radiusM),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: AppDimensions.paddingS),
            Text(
              title,
              style: AppTextStyles.bodySmall.copyWith(
                color: color,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDefaultPaymentSection(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final defaultMethod = _paymentMethods.firstWhere(
      (method) => method.isDefault,
      orElse: () => _paymentMethods.first,
    );

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
              Icon(Icons.star, color: AppColors.warning),
              const SizedBox(width: AppDimensions.paddingS),
              Text(
                'روش پرداخت پیش‌فرض',
                style: AppTextStyles.headlineSmall.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.paddingL),
          _buildPaymentMethodCard(defaultMethod, isDefault: true),
        ],
      ),
    );
  }

  Widget _buildPaymentMethodsSection(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final otherMethods = _paymentMethods
        .where((method) => !method.isDefault)
        .toList();

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
            'سایر روش‌های پرداخت',
            style: AppTextStyles.headlineSmall.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppDimensions.paddingL),
          if (otherMethods.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(AppDimensions.paddingL),
                child: Text(
                  'هیچ روش پرداخت دیگری اضافه نشده',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.grey600,
                  ),
                ),
              ),
            )
          else
            ...otherMethods.map(
              (method) => Padding(
                padding: const EdgeInsets.only(bottom: AppDimensions.paddingM),
                child: _buildPaymentMethodCard(method),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildPaymentMethodCard(
    PaymentMethod method, {
    bool isDefault = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        gradient: _getPaymentMethodGradient(method.type),
        borderRadius: BorderRadius.circular(AppDimensions.radiusL),
        boxShadow: [
          BoxShadow(
            color: _getPaymentMethodColor(method.type).withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _showPaymentMethodDetails(method),
          borderRadius: BorderRadius.circular(AppDimensions.radiusL),
          child: Padding(
            padding: const EdgeInsets.all(AppDimensions.paddingL),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: AppColors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: Icon(
                        _getPaymentMethodIcon(method.type),
                        color: AppColors.white,
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: AppDimensions.paddingM),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  method.title,
                                  style: AppTextStyles.headlineSmall.copyWith(
                                    color: AppColors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              if (isDefault)
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.white.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    'پیش‌فرض',
                                    style: AppTextStyles.labelSmall.copyWith(
                                      color: AppColors.white,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(height: AppDimensions.paddingXS),
                          Text(
                            method.subtitle,
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: AppColors.white.withOpacity(0.8),
                            ),
                          ),
                          if (method.type == PaymentMethodType.card &&
                              method.expiryDate != null)
                            Text(
                              'انقضا: ${method.expiryDate}',
                              style: AppTextStyles.bodySmall.copyWith(
                                color: AppColors.white.withOpacity(0.7),
                              ),
                            ),
                        ],
                      ),
                    ),
                    PopupMenuButton<String>(
                      icon: Icon(Icons.more_vert, color: AppColors.white),
                      onSelected: (value) =>
                          _handlePaymentMethodAction(method, value),
                      itemBuilder: (context) => [
                        if (!method.isDefault)
                          const PopupMenuItem(
                            value: 'set_default',
                            child: ListTile(
                              leading: Icon(Icons.star_border),
                              title: Text(context.tr('set_as_default')),
                              contentPadding: EdgeInsets.zero,
                            ),
                          ),
                        const PopupMenuItem(
                          value: 'edit',
                          child: ListTile(
                            leading: Icon(Icons.edit),
                            title: Text(context.tr('edit')),
                            contentPadding: EdgeInsets.zero,
                          ),
                        ),
                        PopupMenuItem(
                          value: 'delete',
                          child: ListTile(
                            leading: Icon(Icons.delete, color: AppColors.error),
                            title: Text(
                              'حذف',
                              style: TextStyle(color: AppColors.error),
                            ),
                            contentPadding: EdgeInsets.zero,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                if (method.type == PaymentMethodType.card) ...[
                  const SizedBox(height: AppDimensions.paddingL),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          method.holderName ?? '',
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.white.withOpacity(0.8),
                          ),
                        ),
                      ),
                      if (method.bankName != null)
                        Text(
                          method.bankName!,
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.white.withOpacity(0.7),
                          ),
                        ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Helper methods
  IconData _getPaymentMethodIcon(PaymentMethodType type) {
    switch (type) {
      case PaymentMethodType.card:
        return Icons.credit_card;
      case PaymentMethodType.wallet:
        return Icons.account_balance_wallet;
      case PaymentMethodType.installment:
        return Icons.payment;
      case PaymentMethodType.bank:
        return Icons.account_balance;
    }
  }

  Color _getPaymentMethodColor(PaymentMethodType type) {
    switch (type) {
      case PaymentMethodType.card:
        return AppColors.primary;
      case PaymentMethodType.wallet:
        return AppColors.success;
      case PaymentMethodType.installment:
        return AppColors.warning;
      case PaymentMethodType.bank:
        return AppColors.info;
    }
  }

  LinearGradient _getPaymentMethodGradient(PaymentMethodType type) {
    final color = _getPaymentMethodColor(type);
    return LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [color, color.withOpacity(0.8)],
    );
  }

  // Action methods
  void _addPaymentMethod() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => AddPaymentMethodSheet(
        onMethodAdded: (method) {
          setState(() {
            _paymentMethods.add(method);
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                '${context.tr('payment_method_added')} ${method.title}',
              ),
              backgroundColor: AppColors.success,
            ),
          );
        },
      ),
    );
  }

  void _addCard() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => AddCardSheet(
        onCardAdded: (card) {
          setState(() {
            _paymentMethods.add(card);
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('${context.tr('card_added')} ${card.title}'),
              backgroundColor: AppColors.success,
            ),
          );
        },
      ),
    );
  }

  void _chargeWallet() {
    showDialog(
      context: context,
      builder: (context) => ChargeWalletDialog(
        onCharged: (amount) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                '${context.tr('wallet_charged_with')} $amount ${context.tr('toman')}',
              ),
              backgroundColor: AppColors.success,
            ),
          );
        },
      ),
    );
  }

  void _viewTransactions() {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(context.tr('transaction_history'))));
  }

  void _showPaymentMethodDetails(PaymentMethod method) {
    showDialog(
      context: context,
      builder: (context) => PaymentMethodDetailsDialog(method: method),
    );
  }

  void _handlePaymentMethodAction(PaymentMethod method, String action) {
    switch (action) {
      case 'set_default':
        _setDefaultPaymentMethod(method);
        break;
      case 'edit':
        _editPaymentMethod(method);
        break;
      case 'delete':
        _deletePaymentMethod(method);
        break;
    }
  }

  void _setDefaultPaymentMethod(PaymentMethod method) {
    setState(() {
      for (var m in _paymentMethods) {
        m.isDefault = m.id == method.id;
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${method.title} به عنوان روش پرداخت پیش‌فرض تنظیم شد'),
        backgroundColor: AppColors.success,
      ),
    );
  }

  void _editPaymentMethod(PaymentMethod method) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${context.tr('edit')} ${method.title}')),
    );
  }

  void _deletePaymentMethod(PaymentMethod method) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(context.tr('delete_payment_method')),
        content: Text(
          'آیا مطمئن هستید که می‌خواهید "${method.title}" را حذف کنید؟',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(context.tr('cancel')),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _paymentMethods.removeWhere((m) => m.id == method.id);
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('${method.title} حذف شد'),
                  backgroundColor: AppColors.error,
                ),
              );
            },
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: Text(context.tr('delete')),
          ),
        ],
      ),
    );
  }
}

// Add Payment Method Bottom Sheet
class AddPaymentMethodSheet extends StatelessWidget {
  final Function(PaymentMethod) onMethodAdded;

  const AddPaymentMethodSheet({super.key, required this.onMethodAdded});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: const EdgeInsets.all(AppDimensions.paddingL),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.grey400,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: AppDimensions.paddingL),
            Text(
              'افزودن روش پرداخت',
              style: AppTextStyles.headlineSmall.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppDimensions.paddingL),

            ListTile(
              leading: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Icon(Icons.credit_card, color: AppColors.primary),
              ),
              title: Text(context.tr('bank_card')),
              subtitle: Text(context.tr('add_bank_card_description')),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                Navigator.pop(context);
                // Open add card sheet
              },
            ),

            ListTile(
              leading: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: AppColors.success.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Icon(
                  Icons.account_balance_wallet,
                  color: AppColors.success,
                ),
              ),
              title: Text(context.tr('wallet')),
              subtitle: Text(context.tr('create_wallet_description')),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                Navigator.pop(context);
                final walletMethod = PaymentMethod(
                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                  type: PaymentMethodType.wallet,
                  title: 'کیف پول',
                  subtitle: 'موجودی: ۰ تومان',
                  isDefault: false,
                  balance: 0,
                );
                onMethodAdded(walletMethod);
              },
            ),

            ListTile(
              leading: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: AppColors.warning.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Icon(Icons.payment, color: AppColors.warning),
              ),
              title: Text(context.tr('installment_purchase')),
              subtitle: Text(context.tr('installment_description')),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                Navigator.pop(context);
                final installmentMethod = PaymentMethod(
                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                  type: PaymentMethodType.installment,
                  title: 'خرید اقساطی',
                  subtitle: 'تا ۳۶ ماه اقساط بدون بهره',
                  isDefault: false,
                );
                onMethodAdded(installmentMethod);
              },
            ),
          ],
        ),
      ),
    );
  }
}

// Add Card Bottom Sheet
class AddCardSheet extends StatefulWidget {
  final Function(PaymentMethod) onCardAdded;

  const AddCardSheet({super.key, required this.onCardAdded});

  @override
  State<AddCardSheet> createState() => _AddCardSheetState();
}

class _AddCardSheetState extends State<AddCardSheet> {
  final _formKey = GlobalKey<FormState>();
  final _cardNumberController = TextEditingController();
  final _expiryController = TextEditingController();
  final _holderNameController = TextEditingController();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: const EdgeInsets.all(AppDimensions.paddingL),
      child: SafeArea(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.grey400,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: AppDimensions.paddingL),
              Text(
                'افزودن کارت بانکی',
                style: AppTextStyles.headlineSmall.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: AppDimensions.paddingL),

              TextFormField(
                controller: _cardNumberController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'شماره کارت',
                  prefixIcon: Icon(Icons.credit_card),
                  hintText: '1234 5678 9012 3456',
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(16),
                ],
                validator: (value) {
                  if (value == null || value.length != 16) {
                    return 'شماره کارت باید ۱۶ رقم باشد';
                  }
                  return null;
                },
              ),
              const SizedBox(height: AppDimensions.paddingM),

              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _expiryController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'تاریخ انقضا',
                        prefixIcon: Icon(Icons.calendar_month),
                        hintText: 'MM/YY',
                      ),
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(4),
                        TextInputFormatter.withFunction((oldValue, newValue) {
                          final text = newValue.text;
                          if (text.length >= 2) {
                            return TextEditingValue(
                              text:
                                  '${text.substring(0, 2)}/${text.substring(2)}',
                              selection: TextSelection.collapsed(
                                offset: text.length + 1,
                              ),
                            );
                          }
                          return newValue;
                        }),
                      ],
                      validator: (value) {
                        if (value == null || value.length != 5) {
                          return 'تاریخ انقضا نامعتبر';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppDimensions.paddingM),

              TextFormField(
                controller: _holderNameController,
                decoration: const InputDecoration(
                  labelText: 'نام دارنده کارت',
                  prefixIcon: Icon(Icons.person),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'نام دارنده کارت را وارد کنید';
                  }
                  return null;
                },
              ),
              const SizedBox(height: AppDimensions.paddingXL),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _addCard,
                  child: _isLoading
                      ? const CircularProgressIndicator()
                      : Text(context.tr('add_card')),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _addCard() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 2));

    final cardMethod = PaymentMethod(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      type: PaymentMethodType.card,
      title: 'کارت بانکی',
      subtitle: '**** **** **** ${_cardNumberController.text.substring(12)}',
      isDefault: false,
      expiryDate: _expiryController.text,
      holderName: _holderNameController.text,
      bankName: 'بانک مرکزی',
    );

    setState(() => _isLoading = false);
    Navigator.pop(context);
    widget.onCardAdded(cardMethod);
  }
}

// Charge Wallet Dialog
class ChargeWalletDialog extends StatefulWidget {
  final Function(String) onCharged;

  const ChargeWalletDialog({super.key, required this.onCharged});

  @override
  State<ChargeWalletDialog> createState() => _ChargeWalletDialogState();
}

class _ChargeWalletDialogState extends State<ChargeWalletDialog> {
  final _amountController = TextEditingController();
  final _predefinedAmounts = ['50,000', '100,000', '200,000', '500,000'];
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(context.tr('charge_wallet')),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextFormField(
            controller: _amountController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'مبلغ (تومان)',
              prefixIcon: Icon(Icons.money),
            ),
          ),
          const SizedBox(height: AppDimensions.paddingM),
          Text(context.tr('suggested_amounts')),
          const SizedBox(height: AppDimensions.paddingS),
          Wrap(
            spacing: 8,
            children: _predefinedAmounts
                .map(
                  (amount) => InkWell(
                    onTap: () => _amountController.text = amount,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        '$amount تومان',
                        style: TextStyle(color: AppColors.primary),
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('انصراف'),
        ),
        ElevatedButton(
          onPressed: _isLoading ? null : _chargeWallet,
          child: _isLoading
              ? const CircularProgressIndicator()
              : Text(context.tr('charge')),
        ),
      ],
    );
  }

  void _chargeWallet() async {
    if (_amountController.text.isEmpty) return;

    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 2));
    setState(() => _isLoading = false);

    Navigator.pop(context);
    widget.onCharged(_amountController.text);
  }
}

// Payment Method Details Dialog
class PaymentMethodDetailsDialog extends StatelessWidget {
  final PaymentMethod method;

  const PaymentMethodDetailsDialog({super.key, required this.method});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(method.title),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDetailRow('نوع:', _getTypeText(method.type)),
          if (method.subtitle.isNotEmpty)
            _buildDetailRow('شماره:', method.subtitle),
          if (method.expiryDate != null)
            _buildDetailRow('انقضا:', method.expiryDate!),
          if (method.holderName != null)
            _buildDetailRow('دارنده:', method.holderName!),
          if (method.bankName != null)
            _buildDetailRow('بانک:', method.bankName!),
          if (method.balance != null)
            _buildDetailRow('موجودی:', '${method.balance!.toString()} تومان'),
          _buildDetailRow('پیش‌فرض:', method.isDefault ? 'بله' : 'خیر'),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(context.tr('close')),
        ),
      ],
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  String _getTypeText(PaymentMethodType type) {
    switch (type) {
      case PaymentMethodType.card:
        return 'کارت بانکی';
      case PaymentMethodType.wallet:
        return 'کیف پول';
      case PaymentMethodType.installment:
        return 'خرید اقساطی';
      case PaymentMethodType.bank:
        return 'حساب بانکی';
    }
  }
}

// Models
enum PaymentMethodType { card, wallet, installment, bank }

class PaymentMethod {
  final String id;
  final PaymentMethodType type;
  final String title;
  final String subtitle;
  bool isDefault;
  final String? expiryDate;
  final String? holderName;
  final String? bankName;
  final String? cardImage;
  final int? balance;

  PaymentMethod({
    required this.id,
    required this.type,
    required this.title,
    required this.subtitle,
    required this.isDefault,
    this.expiryDate,
    this.holderName,
    this.bankName,
    this.cardImage,
    this.balance,
  });
}
