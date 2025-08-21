// Edit Profile Page - Complete Profile Editing
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/responsive_utils.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  late AnimationController _animationController;
  late Animation<double> _slideAnimation;

  // Form controllers
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _birthdateController = TextEditingController();
  final _nationalIdController = TextEditingController();
  final _addressController = TextEditingController();

  // Form state
  String _selectedGender = 'مرد';
  String _selectedCity = 'تهران';
  bool _isLoading = false;
  bool _hasProfileImage = true;

  // Mock current user data
  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _slideAnimation = Tween<double>(begin: -50, end: 0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );
    _animationController.forward();

    // Initialize with current user data
    _nameController.text = 'سینا احمدزاده';
    _emailController.text = 'sina.ahmadzadeh@sinashop.com';
    _phoneController.text = '09123456789';
    _birthdateController.text = '۱۳۷۰/۰۵/۱۵';
    _nationalIdController.text = '0123456789';
    _addressController.text = 'تهران، خیابان ولیعصر، پلاک ۱۲۳';
  }

  @override
  void dispose() {
    _animationController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _birthdateController.dispose();
    _nationalIdController.dispose();
    _addressController.dispose();
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
        title: const Text('ویرایش پروفایل'),
        backgroundColor: isDark ? AppColors.surfaceDark : AppColors.white,
        elevation: 0,
        actions: [
          TextButton(
            onPressed: _isLoading ? null : _saveProfile,
            child: _isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('ذخیره'),
          ),
        ],
      ),
      body: AnimatedBuilder(
        animation: _slideAnimation,
        builder: (context, child) {
          return Transform.translate(
            offset: Offset(0, _slideAnimation.value),
            child: ResponsiveContainer(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppDimensions.paddingL),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      _buildProfileImageSection(context),
                      const SizedBox(height: AppDimensions.paddingXL),
                      _buildPersonalInfoSection(context),
                      const SizedBox(height: AppDimensions.paddingL),
                      _buildContactInfoSection(context),
                      const SizedBox(height: AppDimensions.paddingL),
                      _buildAddressSection(context),
                      const SizedBox(height: AppDimensions.paddingXL),
                      _buildActionButtons(context),
                      const SizedBox(height: AppDimensions.paddingXL),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildProfileImageSection(BuildContext context) {
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
        children: [
          Text(
            'تصویر پروفایل',
            style: AppTextStyles.headlineSmall.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppDimensions.paddingL),
          Stack(
            children: [
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(60),
                  border: Border.all(color: AppColors.primary, width: 3),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(57),
                  child: _hasProfileImage
                      ? Image.asset(
                          'assets/images/placeholders/user_avatar.png',
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    AppColors.primary,
                                    AppColors.secondary,
                                  ],
                                ),
                              ),
                              child: const Icon(
                                Icons.person,
                                color: AppColors.white,
                                size: 60,
                              ),
                            );
                          },
                        )
                      : Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [AppColors.primary, AppColors.secondary],
                            ),
                          ),
                          child: const Icon(
                            Icons.person,
                            color: AppColors.white,
                            size: 60,
                          ),
                        ),
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: GestureDetector(
                  onTap: _showImageSourceDialog,
                  child: Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: AppColors.white, width: 2),
                    ),
                    child: const Icon(
                      Icons.camera_alt,
                      color: AppColors.white,
                      size: 18,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.paddingM),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextButton.icon(
                onPressed: _changeProfileImage,
                icon: const Icon(Icons.photo_camera),
                label: const Text('تغییر تصویر'),
              ),
              TextButton.icon(
                onPressed: _removeProfileImage,
                icon: const Icon(Icons.delete_outline),
                label: const Text('حذف تصویر'),
                style: TextButton.styleFrom(foregroundColor: AppColors.error),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPersonalInfoSection(BuildContext context) {
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
          Row(
            children: [
              Icon(Icons.person_outline, color: AppColors.primary),
              const SizedBox(width: AppDimensions.paddingS),
              Text(
                'اطلاعات شخصی',
                style: AppTextStyles.headlineSmall.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.paddingL),

          // Name Field
          _buildTextFormField(
            controller: _nameController,
            label: 'نام و نام خانوادگی',
            icon: Icons.person,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'لطفاً نام خود را وارد کنید';
              }
              if (value.length < 2) {
                return 'نام باید حداقل ۲ کاراکتر باشد';
              }
              return null;
            },
          ),

          const SizedBox(height: AppDimensions.paddingM),

          // National ID Field
          _buildTextFormField(
            controller: _nationalIdController,
            label: 'کد ملی',
            icon: Icons.credit_card,
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(10),
            ],
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'لطفاً کد ملی خود را وارد کنید';
              }
              if (value.length != 10) {
                return 'کد ملی باید ۱۰ رقم باشد';
              }
              return null;
            },
          ),

          const SizedBox(height: AppDimensions.paddingM),

          // Birthdate Field
          _buildTextFormField(
            controller: _birthdateController,
            label: 'تاریخ تولد',
            icon: Icons.calendar_today,
            readOnly: true,
            onTap: _selectBirthDate,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'لطفاً تاریخ تولد خود را انتخاب کنید';
              }
              return null;
            },
          ),

          const SizedBox(height: AppDimensions.paddingM),

          // Gender Selection
          _buildGenderSelection(),
        ],
      ),
    );
  }

  Widget _buildContactInfoSection(BuildContext context) {
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
          Row(
            children: [
              Icon(Icons.contact_phone_outlined, color: AppColors.primary),
              const SizedBox(width: AppDimensions.paddingS),
              Text(
                'اطلاعات تماس',
                style: AppTextStyles.headlineSmall.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.paddingL),

          // Email Field
          _buildTextFormField(
            controller: _emailController,
            label: 'ایمیل',
            icon: Icons.email_outlined,
            keyboardType: TextInputType.emailAddress,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'لطفاً ایمیل خود را وارد کنید';
              }
              if (!RegExp(
                r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
              ).hasMatch(value)) {
                return 'لطفاً ایمیل معتبر وارد کنید';
              }
              return null;
            },
          ),

          const SizedBox(height: AppDimensions.paddingM),

          // Phone Field
          _buildTextFormField(
            controller: _phoneController,
            label: 'شماره موبایل',
            icon: Icons.phone_android,
            keyboardType: TextInputType.phone,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(11),
            ],
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'لطفاً شماره موبایل خود را وارد کنید';
              }
              if (!RegExp(r'^09[0-9]{9}$').hasMatch(value)) {
                return 'شماره موبایل معتبر نیست';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }

  Widget _buildAddressSection(BuildContext context) {
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
          Row(
            children: [
              Icon(Icons.location_on_outlined, color: AppColors.primary),
              const SizedBox(width: AppDimensions.paddingS),
              Text(
                'آدرس',
                style: AppTextStyles.headlineSmall.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.paddingL),

          // City Selection
          _buildCitySelection(),

          const SizedBox(height: AppDimensions.paddingM),

          // Address Field
          _buildTextFormField(
            controller: _addressController,
            label: 'آدرس کامل',
            icon: Icons.home_outlined,
            maxLines: 3,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'لطفاً آدرس خود را وارد کنید';
              }
              if (value.length < 10) {
                return 'آدرس باید حداقل ۱۰ کاراکتر باشد';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTextFormField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    List<TextInputFormatter>? inputFormatters,
    String? Function(String?)? validator,
    bool readOnly = false,
    VoidCallback? onTap,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      validator: validator,
      readOnly: readOnly,
      onTap: onTap,
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
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusM),
          borderSide: BorderSide(color: AppColors.error),
        ),
        filled: true,
        fillColor: Theme.of(context).brightness == Brightness.dark
            ? AppColors.grey800.withOpacity(0.3)
            : AppColors.grey50,
      ),
    );
  }

  Widget _buildGenderSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'جنسیت',
          style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: AppDimensions.paddingS),
        Row(
          children: [
            Expanded(
              child: RadioListTile<String>(
                title: const Text('مرد'),
                value: 'مرد',
                groupValue: _selectedGender,
                onChanged: (value) {
                  setState(() {
                    _selectedGender = value!;
                  });
                },
                contentPadding: EdgeInsets.zero,
              ),
            ),
            Expanded(
              child: RadioListTile<String>(
                title: const Text('زن'),
                value: 'زن',
                groupValue: _selectedGender,
                onChanged: (value) {
                  setState(() {
                    _selectedGender = value!;
                  });
                },
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCitySelection() {
    final cities = [
      'تهران',
      'مشهد',
      'اصفهان',
      'شیراز',
      'تبریز',
      'کرج',
      'اهواز',
      'قم',
      'رشت',
      'کرمان',
      'همدان',
      'یزد',
      'اردبیل',
      'بندرعباس',
      'اراک',
    ];

    return DropdownButtonFormField<String>(
      value: _selectedCity,
      decoration: InputDecoration(
        labelText: 'شهر',
        prefixIcon: const Icon(Icons.location_city),
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
        filled: true,
        fillColor: Theme.of(context).brightness == Brightness.dark
            ? AppColors.grey800.withOpacity(0.3)
            : AppColors.grey50,
      ),
      items: cities.map((city) {
        return DropdownMenuItem<String>(value: city, child: Text(city));
      }).toList(),
      onChanged: (value) {
        setState(() {
          _selectedCity = value!;
        });
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'لطفاً شهر خود را انتخاب کنید';
        }
        return null;
      },
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _isLoading ? null : _saveProfile,
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
            child: _isLoading
                ? const CircularProgressIndicator(color: AppColors.white)
                : const Text('ذخیره تغییرات'),
          ),
        ),
        const SizedBox(height: AppDimensions.paddingM),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            onPressed: _resetForm,
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: AppColors.grey400),
              padding: const EdgeInsets.symmetric(
                vertical: AppDimensions.paddingM,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppDimensions.radiusM),
              ),
            ),
            child: const Text('بازیابی اطلاعات'),
          ),
        ),
      ],
    );
  }

  // Methods
  void _showImageSourceDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('انتخاب منبع تصویر'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('دوربین'),
              onTap: () {
                Navigator.pop(context);
                _takePhotoFromCamera();
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('گالری'),
              onTap: () {
                Navigator.pop(context);
                _selectPhotoFromGallery();
              },
            ),
          ],
        ),
      ),
    );
  }

  void _takePhotoFromCamera() {
    // TODO: Implement camera functionality
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('عکس‌گیری از دوربین')));
  }

  void _selectPhotoFromGallery() {
    // TODO: Implement gallery selection
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('انتخاب از گالری')));
  }

  void _changeProfileImage() {
    _showImageSourceDialog();
  }

  void _removeProfileImage() {
    setState(() {
      _hasProfileImage = false;
    });
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('تصویر پروفایل حذف شد')));
  }

  void _selectBirthDate() async {
    // TODO: Implement Persian date picker
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('انتخاب تاریخ تولد')));
  }

  void _saveProfile() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isLoading = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('اطلاعات با موفقیت ذخیره شد'),
        backgroundColor: AppColors.success,
      ),
    );

    Navigator.pop(context);
  }

  void _resetForm() {
    _nameController.text = 'سینا احمدزاده';
    _emailController.text = 'sina.ahmadzadeh@sinashop.com';
    _phoneController.text = '09123456789';
    _birthdateController.text = '۱۳۷۰/۰۵/۱۵';
    _nationalIdController.text = '0123456789';
    _addressController.text = 'تهران، خیابان ولیعصر، پلاک ۱۲۳';
    setState(() {
      _selectedGender = 'مرد';
      _selectedCity = 'تهران';
      _hasProfileImage = true;
    });
  }
}
