// Address Management Page - Complete Address Management
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/responsive_utils.dart';
import '../../../../core/localization/localization_extension.dart';

class AddressesPage extends StatefulWidget {
  const AddressesPage({super.key});

  @override
  State<AddressesPage> createState() => _AddressesPageState();
}

class _AddressesPageState extends State<AddressesPage>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  List<AddressModel> _addresses = [];

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
    _loadAddresses();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _loadAddresses() {
    // Mock addresses data
    _addresses = [
      AddressModel(
        id: '1',
        title: 'خانه',
        fullName: 'سینا احمدزاده',
        phoneNumber: '09123456789',
        city: 'تهران',
        state: 'تهران',
        address: 'خیابان ولیعصر، خیابان میرزای شیرازی، پلاک ۱۲۳',
        postalCode: '1234567890',
        isDefault: true,
        coordinates: const AddressCoordinates(lat: 35.7219, lng: 51.3347),
      ),
      AddressModel(
        id: '2',
        title: 'محل کار',
        fullName: 'سینا احمدزاده',
        phoneNumber: '02188776655',
        city: 'تهران',
        state: 'تهران',
        address: 'خیابان کریمخان، برج میلاد، طبقه ۱۵',
        postalCode: '1234567891',
        isDefault: false,
        coordinates: const AddressCoordinates(lat: 35.7447, lng: 51.3753),
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
        title: Text(context.tr('my_addresses')),
        backgroundColor: isDark ? AppColors.surfaceDark : AppColors.white,
        elevation: 0,
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: ResponsiveContainer(
          child: _addresses.isEmpty
              ? _buildEmptyState(context)
              : Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.all(AppDimensions.paddingM),
                        itemCount: _addresses.length,
                        itemBuilder: (context, index) {
                          return _buildAddressCard(
                            context,
                            _addresses[index],
                            index,
                          );
                        },
                      ),
                    ),
                    _buildAddNewAddressButton(context),
                  ],
                ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
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
            child: Icon(
              Icons.location_on_outlined,
              size: 60,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: AppDimensions.paddingL),
          Text(
            'هیچ آدرسی ثبت نشده',
            style: AppTextStyles.headlineSmall.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppDimensions.paddingS),
          Text(
            'برای راحتی خرید، آدرس خود را ثبت کنید',
            style: AppTextStyles.bodyMedium.copyWith(color: AppColors.grey600),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppDimensions.paddingXL),
          ElevatedButton.icon(
            onPressed: () => _showAddAddressDialog(context),
            icon: const Icon(Icons.add),
            label: Text(context.tr('add_new_address')),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.white,
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.paddingL,
                vertical: AppDimensions.paddingM,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddressCard(
    BuildContext context,
    AddressModel address,
    int index,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AnimatedContainer(
      duration: Duration(milliseconds: 300 + (index * 100)),
      margin: const EdgeInsets.only(bottom: AppDimensions.paddingM),
      child: Container(
        decoration: BoxDecoration(
          color: isDark ? AppColors.surfaceDark : AppColors.white,
          borderRadius: BorderRadius.circular(AppDimensions.radiusL),
          border: address.isDefault
              ? Border.all(color: AppColors.primary, width: 2)
              : null,
          boxShadow: [
            BoxShadow(
              color: isDark ? AppColors.shadowDark : AppColors.shadowLight,
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(AppDimensions.paddingL),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppDimensions.paddingS,
                      vertical: AppDimensions.paddingXS,
                    ),
                    decoration: BoxDecoration(
                      color: _getAddressTypeColor(
                        address.title,
                      ).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(
                        AppDimensions.radiusS,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          _getAddressTypeIcon(address.title),
                          size: 16,
                          color: _getAddressTypeColor(address.title),
                        ),
                        const SizedBox(width: AppDimensions.paddingXS),
                        Text(
                          address.title,
                          style: AppTextStyles.labelMedium.copyWith(
                            color: _getAddressTypeColor(address.title),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  if (address.isDefault)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppDimensions.paddingS,
                        vertical: AppDimensions.paddingXS,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.success.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(
                          AppDimensions.radiusS,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.check_circle,
                            size: 16,
                            color: AppColors.success,
                          ),
                          const SizedBox(width: AppDimensions.paddingXS),
                          Text(
                            'پیش‌فرض',
                            style: AppTextStyles.labelSmall.copyWith(
                              color: AppColors.success,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  PopupMenuButton<String>(
                    onSelected: (value) => _handleAddressAction(value, address),
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        value: 'edit',
                        child: Row(
                          children: [
                            const Icon(Icons.edit_outlined),
                            const SizedBox(width: 8),
                            Text(context.tr('edit')),
                          ],
                        ),
                      ),
                      if (!address.isDefault)
                        PopupMenuItem(
                          value: 'default',
                          child: Row(
                            children: [
                              const Icon(Icons.star_outline),
                              const SizedBox(width: 8),
                              Text(context.tr('set_as_default')),
                            ],
                          ),
                        ),
                      PopupMenuItem(
                        value: 'delete',
                        child: Row(
                          children: [
                            const Icon(Icons.delete_outline, color: Colors.red),
                            const SizedBox(width: 8),
                            Text(
                              context.tr('delete'),
                              style: const TextStyle(color: Colors.red),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: AppDimensions.paddingM),

              // Full Name & Phone
              Row(
                children: [
                  Icon(
                    Icons.person_outline,
                    size: 18,
                    color: AppColors.grey600,
                  ),
                  const SizedBox(width: AppDimensions.paddingS),
                  Expanded(
                    child: Text(
                      address.fullName,
                      style: AppTextStyles.bodyLarge.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Icon(
                    Icons.phone_outlined,
                    size: 18,
                    color: AppColors.grey600,
                  ),
                  const SizedBox(width: AppDimensions.paddingXS),
                  Text(
                    address.phoneNumber,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.grey600,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: AppDimensions.paddingS),

              // Address
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.location_on_outlined,
                    size: 18,
                    color: AppColors.grey600,
                  ),
                  const SizedBox(width: AppDimensions.paddingS),
                  Expanded(
                    child: Text(
                      '${address.city}، ${address.address}',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.grey700,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: AppDimensions.paddingS),

              // Postal Code
              Row(
                children: [
                  Icon(
                    Icons.local_post_office_outlined,
                    size: 18,
                    color: AppColors.grey600,
                  ),
                  const SizedBox(width: AppDimensions.paddingS),
                  Text(
                    'کد پستی: ${address.postalCode}',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.grey600,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: AppDimensions.paddingM),

              // Action Buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => _showOnMap(address),
                      icon: const Icon(Icons.map_outlined, size: 18),
                      label: Text(context.tr('show_on_map')),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: AppColors.info),
                        foregroundColor: AppColors.info,
                      ),
                    ),
                  ),
                  const SizedBox(width: AppDimensions.paddingS),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => _editAddress(address),
                      icon: const Icon(Icons.edit_outlined, size: 18),
                      label: Text(context.tr('edit')),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: AppColors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAddNewAddressButton(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.paddingL),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton.icon(
          onPressed: () => _showAddAddressDialog(context),
          icon: const Icon(Icons.add),
          label: Text(context.tr('add_new_address')),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: AppColors.white,
            padding: const EdgeInsets.symmetric(
              vertical: AppDimensions.paddingM,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppDimensions.radiusM),
            ),
          ),
        ),
      ),
    );
  }

  Color _getAddressTypeColor(String type) {
    switch (type.toLowerCase()) {
      case 'خانه':
        return AppColors.success;
      case 'محل کار':
        return AppColors.info;
      case 'دیگر':
        return AppColors.warning;
      default:
        return AppColors.primary;
    }
  }

  IconData _getAddressTypeIcon(String type) {
    switch (type.toLowerCase()) {
      case 'خانه':
        return Icons.home_outlined;
      case 'محل کار':
        return Icons.business_outlined;
      case 'دیگر':
        return Icons.place_outlined;
      default:
        return Icons.location_on_outlined;
    }
  }

  void _handleAddressAction(String action, AddressModel address) {
    switch (action) {
      case 'edit':
        _editAddress(address);
        break;
      case 'default':
        _setAsDefault(address);
        break;
      case 'delete':
        _deleteAddress(address);
        break;
    }
  }

  void _showAddAddressDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => AddAddressBottomSheet(
        onAddressAdded: (address) {
          setState(() {
            _addresses.add(address);
          });
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(context.tr('address_added'))));
        },
      ),
    );
  }

  void _editAddress(AddressModel address) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => AddAddressBottomSheet(
        address: address,
        onAddressAdded: (updatedAddress) {
          setState(() {
            final index = _addresses.indexWhere((a) => a.id == address.id);
            if (index != -1) {
              _addresses[index] = updatedAddress;
            }
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(context.tr('address_updated'))),
          );
        },
      ),
    );
  }

  void _setAsDefault(AddressModel address) {
    setState(() {
      for (var addr in _addresses) {
        addr.isDefault = addr.id == address.id;
      }
    });
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(context.tr('default_address_set'))));
  }

  void _deleteAddress(AddressModel address) {
    if (address.isDefault && _addresses.length > 1) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(context.tr('set_other_default_first')),
          backgroundColor: AppColors.warning,
        ),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(context.tr('delete_address')),
        content: Text(
          context
              .tr('confirm_delete_address')
              .replaceAll('{title}', address.title),
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
                _addresses.removeWhere((a) => a.id == address.id);
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(context.tr('address_deleted'))),
              );
            },
            child: Text(
              context.tr('delete'),
              style: const TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  void _showOnMap(AddressModel address) {
    // TODO: Implement map functionality
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          context
              .tr('show_address_on_map')
              .replaceAll('{title}', address.title),
        ),
      ),
    );
  }
}

// Add Address Bottom Sheet
class AddAddressBottomSheet extends StatefulWidget {
  final AddressModel? address;
  final Function(AddressModel) onAddressAdded;

  const AddAddressBottomSheet({
    super.key,
    this.address,
    required this.onAddressAdded,
  });

  @override
  State<AddAddressBottomSheet> createState() => _AddAddressBottomSheetState();
}

class _AddAddressBottomSheetState extends State<AddAddressBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _fullNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _postalCodeController = TextEditingController();

  String _selectedCity = 'تهران';
  String _selectedState = 'تهران';
  bool _isDefault = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.address != null) {
      _titleController.text = widget.address!.title;
      _fullNameController.text = widget.address!.fullName;
      _phoneController.text = widget.address!.phoneNumber;
      _addressController.text = widget.address!.address;
      _postalCodeController.text = widget.address!.postalCode;
      _selectedCity = widget.address!.city;
      _selectedState = widget.address!.state;
      _isDefault = widget.address!.isDefault;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _fullNameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _postalCodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      height: MediaQuery.of(context).size.height * 0.9,
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.white,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(AppDimensions.radiusL),
        ),
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(AppDimensions.paddingL),
            child: Column(
              children: [
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.grey300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: AppDimensions.paddingM),
                Text(
                  widget.address != null ? 'ویرایش آدرس' : 'افزودن آدرس جدید',
                  style: AppTextStyles.headlineSmall.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          const Divider(),

          // Form
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppDimensions.paddingL),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildAddressTypeSelection(),
                    const SizedBox(height: AppDimensions.paddingL),
                    _buildTextFormField(
                      controller: _fullNameController,
                      label: 'نام و نام خانوادگی',
                      icon: Icons.person_outline,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'لطفاً نام و نام خانوادگی را وارد کنید';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: AppDimensions.paddingM),
                    _buildTextFormField(
                      controller: _phoneController,
                      label: 'شماره تلفن',
                      icon: Icons.phone_outlined,
                      keyboardType: TextInputType.phone,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'لطفاً شماره تلفن را وارد کنید';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: AppDimensions.paddingM),
                    _buildLocationSelection(),
                    const SizedBox(height: AppDimensions.paddingM),
                    _buildTextFormField(
                      controller: _addressController,
                      label: 'آدرس کامل',
                      icon: Icons.location_on_outlined,
                      maxLines: 3,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'لطفاً آدرس کامل را وارد کنید';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: AppDimensions.paddingM),
                    _buildTextFormField(
                      controller: _postalCodeController,
                      label: 'کد پستی',
                      icon: Icons.local_post_office_outlined,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(10),
                      ],
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'لطفاً کد پستی را وارد کنید';
                        }
                        if (value.length != 10) {
                          return 'کد پستی باید ۱۰ رقم باشد';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: AppDimensions.paddingL),
                    CheckboxListTile(
                      title: Text(context.tr('set_as_default')),
                      value: _isDefault,
                      onChanged: (value) {
                        setState(() {
                          _isDefault = value ?? false;
                        });
                      },
                      contentPadding: EdgeInsets.zero,
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Action Buttons
          Container(
            padding: const EdgeInsets.all(AppDimensions.paddingL),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(context.tr('cancel')),
                  ),
                ),
                const SizedBox(width: AppDimensions.paddingM),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _saveAddress,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: AppColors.white,
                    ),
                    child: _isLoading
                        ? const CircularProgressIndicator(
                            color: AppColors.white,
                          )
                        : Text(widget.address != null ? 'ویرایش' : 'ذخیره'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddressTypeSelection() {
    final types = ['خانه', 'محل کار', 'دیگر'];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'نوع آدرس',
          style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: AppDimensions.paddingS),
        Row(
          children: types.map((type) {
            final isSelected = _titleController.text == type;
            return Expanded(
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _titleController.text = type;
                  });
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: AppDimensions.paddingXS,
                  ),
                  padding: const EdgeInsets.symmetric(
                    vertical: AppDimensions.paddingM,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.primary
                        : AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                    border: Border.all(
                      color: isSelected ? AppColors.primary : AppColors.grey300,
                    ),
                  ),
                  child: Text(
                    type,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: isSelected ? AppColors.white : AppColors.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildLocationSelection() {
    final states = ['تهران', 'اصفهان', 'شیراز', 'مشهد', 'تبریز'];
    final cities = {
      'تهران': ['تهران', 'کرج', 'ورامین'],
      'اصفهان': ['اصفهان', 'کاشان', 'نجف‌آباد'],
      'شیراز': ['شیراز', 'کازرون', 'فسا'],
      'مشهد': ['مشهد', 'نیشابور', 'سبزوار'],
      'تبریز': ['تبریز', 'مراغه', 'میانه'],
    };

    return Column(
      children: [
        DropdownButtonFormField<String>(
          value: _selectedState,
          decoration: InputDecoration(
            labelText: 'استان',
            prefixIcon: const Icon(Icons.map_outlined),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppDimensions.radiusM),
            ),
          ),
          items: states.map((state) {
            return DropdownMenuItem(value: state, child: Text(state));
          }).toList(),
          onChanged: (value) {
            setState(() {
              _selectedState = value!;
              _selectedCity = cities[value]!.first;
            });
          },
        ),
        const SizedBox(height: AppDimensions.paddingM),
        DropdownButtonFormField<String>(
          value: _selectedCity,
          decoration: InputDecoration(
            labelText: 'شهر',
            prefixIcon: const Icon(Icons.location_city_outlined),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppDimensions.radiusM),
            ),
          ),
          items: cities[_selectedState]!.map((city) {
            return DropdownMenuItem(value: city, child: Text(city));
          }).toList(),
          onChanged: (value) {
            setState(() {
              _selectedCity = value!;
            });
          },
        ),
      ],
    );
  }

  Widget _buildTextFormField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    List<TextInputFormatter>? inputFormatters,
    String? Function(String?)? validator,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      validator: validator,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusM),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusM),
          borderSide: BorderSide(color: AppColors.grey300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusM),
          borderSide: BorderSide(color: AppColors.primary),
        ),
      ),
    );
  }

  void _saveAddress() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    await Future.delayed(const Duration(seconds: 1));

    final address = AddressModel(
      id:
          widget.address?.id ??
          DateTime.now().millisecondsSinceEpoch.toString(),
      title: _titleController.text,
      fullName: _fullNameController.text,
      phoneNumber: _phoneController.text,
      city: _selectedCity,
      state: _selectedState,
      address: _addressController.text,
      postalCode: _postalCodeController.text,
      isDefault: _isDefault,
      coordinates: const AddressCoordinates(lat: 35.7219, lng: 51.3347),
    );

    widget.onAddressAdded(address);
    Navigator.pop(context);
  }
}

// Address Model
class AddressModel {
  final String id;
  final String title;
  final String fullName;
  final String phoneNumber;
  final String city;
  final String state;
  final String address;
  final String postalCode;
  bool isDefault;
  final AddressCoordinates coordinates;

  AddressModel({
    required this.id,
    required this.title,
    required this.fullName,
    required this.phoneNumber,
    required this.city,
    required this.state,
    required this.address,
    required this.postalCode,
    required this.isDefault,
    required this.coordinates,
  });
}

class AddressCoordinates {
  final double lat;
  final double lng;

  const AddressCoordinates({required this.lat, required this.lng});
}
