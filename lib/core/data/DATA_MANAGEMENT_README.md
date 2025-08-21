# Data Management System - راهنمای استفاده

این سیستم مدیریت داده شبیه‌سازی API کامل برای فروشگاه آنلاین فراهم می‌کند و تمام داده‌های سایت را از یک منبع واحد ارائه می‌دهد.

## 📁 ساختار فایل‌ها

```
lib/core/data/
├── models/
│   ├── product_model.dart      # مدل کامل محصول
│   └── user_model.dart         # مدل کامل کاربر
├── test_data/
│   ├── product_test_data.dart  # داده‌های تست محصولات
│   └── user_test_data.dart     # داده‌های تست کاربران
├── services/
│   ├── product_api_service.dart # سرویس API محصولات
│   └── user_api_service.dart    # سرویس API کاربران
├── data_manager.dart           # مدیر کل داده‌ها (واسط اصلی)
└── examples/
    └── data_manager_usage_example.dart # نمونه‌های استفاده
```

## 🚀 شروع سریع

### 1. دسترسی به DataManager

```dart
import '../core/data/data_manager.dart';

final dataManager = DataManager.instance;
```

### 2. دریافت محصولات

```dart
// دریافت همه محصولات با صفحه‌بندی
final response = await dataManager.getProducts(
  page: 1,
  limit: 10,
);

if (response.success) {
  final products = response.data;
  print('محصولات یافت شده: ${products.length}');
}
```

### 3. جستجوی محصولات

```dart
// جستجوی محصولات
final searchResponse = await dataManager.searchProducts(
  'آیفون',
  page: 1,
  limit: 5,
);

// جستجو با فیلتر دسته‌بندی
final categoryResponse = await dataManager.getProducts(
  categoryId: 'electronics',
  limit: 10,
);

// جستجو با فیلتر قیمت
final priceFilterResponse = await dataManager.getProducts(
  minPrice: 500000,
  maxPrice: 2000000,
);
```

### 4. دریافت اطلاعات کاربر

```dart
// دریافت کاربر خاص
final userResponse = await dataManager.getUser('user_1');

if (userResponse.success && userResponse.data != null) {
  final user = userResponse.data!;
  print('کاربر: ${user.profile.firstName} ${user.profile.lastName}');
}
```

## 📊 ویژگی‌های کلیدی

### مدل محصول (ProductModel)
- 🖼️ **تصاویر**: چندین تصویر با URL و متادیتا
- 🎨 **رنگ‌ها**: رنگ‌های موجود با کد هگز و نام
- 📏 **سایزها**: سایزهای مختلف با موجودی
- ⭐ **امتیازات**: امتیاز متوسط و نظرات کاربران
- 🔧 **مشخصات**: مشخصات فنی کامل
- 📦 **موجودی**: وضعیت موجودی و انبار
- 🚚 **حمل‌ونقل**: اطلاعات ارسال و هزینه
- 💰 **فروش**: آمار فروش و محبوبیت
- 🔍 **SEO**: متاتگ‌ها و بهینه‌سازی
- 🛡️ **گارانتی**: اطلاعات گارانتی
- 🔄 **متغیرها**: انواع مختلف محصول

### مدل کاربر (UserModel)
- 👤 **پروفایل**: اطلاعات شخصی کامل
- 📱 **شبکه‌های اجتماعی**: لینک‌ها و پروفایل‌ها
- 🔐 **حساب**: اطلاعات حساب کاربری
- ⚙️ **تنظیمات**: ترجیحات کاربر
- 📈 **فعالیت**: تاریخچه و آمار (lastLoginAt, totalOrders, totalSpent)
- 🎯 **وفاداری**: امتیاز و سطح (currentPoints, tier, totalEarned)
- 🔒 **امنیت**: تنظیمات امنیتی
- 🔔 **اعلانات**: تنظیمات اطلاع‌رسانی
- 🚚 **آدرس‌ها**: آدرس‌های ارسال
- 💳 **پرداخت**: روش‌های پرداخت
- ❤️ **علاقه‌مندی**: محصولات مورد علاقه

## 🔍 عملیات جستجو و فیلتر

### جستجوی پیشرفته محصولات

```dart
// جستجو با چندین فیلتر
final advancedSearch = await dataManager.getProducts(
  query: 'گوشی',
  categoryId: 'electronics',
  brandId: 'apple',
  minPrice: 1000000,
  maxPrice: 5000000,
  minRating: 4.0,
  sortBy: 'price',
  sortOrder: 'asc',
  page: 1,
  limit: 20,
);
```

### محصولات ویژه

```dart
// محصولات ویژه
final featured = await dataManager.getFeaturedProducts(limit: 10);

// پرفروش‌ترین محصولات
final bestSellers = await dataManager.getBestSellers(limit: 5);

// جدیدترین محصولات
final newArrivals = await dataManager.getNewArrivals(limit: 8);

// محصولات حراجی
final onSale = await dataManager.getProductsOnSale(limit: 12);

// محصولات مرتبط
final related = await dataManager.getRelatedProducts('product_id', limit: 6);
```

### عملیات کاربری

```dart
// جستجوی کاربران
final users = await dataManager.searchUsers('علی');

// کاربران ویژه
final premiumUsers = await dataManager.getPremiumUsers();

// کاربران جدید
final newUsers = await dataManager.getNewUsers();
```

## 📈 آمار و داشبورد

### آمار کلی

```dart
// آمار محصولات
final productStats = await dataManager.getProductStats();
// شامل: تعداد محصولات، دسته‌بندی‌ها، برندها، آمار موجودی

// آمار سیستم (در صورت وجود)
final systemHealth = await dataManager.getSystemHealth();
// شامل: وضعیت API، دیتابیس، حافظه، تعداد درخواست‌ها
```

### پیشنهادات جستجو

```dart
// پیشنهادات جستجو
final suggestions = await dataManager.getSearchSuggestions('موب');
// برمی‌گرداند: ['موبایل', 'موبایل سامسونگ', 'موبایل آیفون']
```

## 🛠️ ابزارهای توسعه

### بررسی سلامت سیستم

```dart
// بررسی وضعیت سیستم
final health = await dataManager.getSystemHealth();
// شامل: وضعیت API، دیتابیس، حافظه، تعداد درخواست‌ها
```

### فیلترهای موجود

```dart
// دریافت فیلترهای موجود
final filters = await dataManager.getAvailableFilters();
// شامل: دسته‌بندی‌ها، برندها، رنگ‌ها، سایزها، بازه قیمت
```

## 💡 نمونه‌های کاربردی

### 1. صفحه لیست محصولات

```dart
class ProductListScreen extends StatefulWidget {
  @override
  _ProductListScreenState createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  final DataManager _dataManager = DataManager.instance;
  List<ProductModel> _products = [];

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    final response = await _dataManager.getProducts(limit: 20);
    if (response.success) {
      setState(() {
        _products = response.data;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: _products.length,
      itemBuilder: (context, index) {
        final product = _products[index];
        return ListTile(
          title: Text(product.name),
          subtitle: Text(product.formattedPrice),
          trailing: Text('⭐ ${product.rating.average}'),
        );
      },
    );
  }
}
```

### 2. صفحه جستجو

```dart
class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final DataManager _dataManager = DataManager.instance;
  final TextEditingController _searchController = TextEditingController();
  List<ProductModel> _searchResults = [];

  Future<void> _search(String query) async {
    final response = await _dataManager.searchProducts(query);
    if (response.success) {
      setState(() {
        _searchResults = response.data;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: 'جستجو...',
            suffixIcon: IconButton(
              icon: Icon(Icons.search),
              onPressed: () => _search(_searchController.text),
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: _searchResults.length,
            itemBuilder: (context, index) {
              final product = _searchResults[index];
              return Card(
                child: ListTile(
                  title: Text(product.name),
                  subtitle: Text(product.formattedPrice),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
```

## 🔄 Response Format

همه متدها یک Response object برمی‌گردانند:

```dart
class ApiResponse<T> {
  final bool success;         // موفقیت عملیات
  final String message;       // پیام
  final T data;              // داده‌ها
  final Map<String, dynamic>? metadata; // متادیتا (صفحه‌بندی، فیلترها و...)
}
```

## 🎯 ویژگی‌های پیشرفته

- **صفحه‌بندی**: پشتیبانی کامل از pagination
- **مرتب‌سازی**: مرتب‌سازی بر اساس نام، قیمت، امتیاز، محبوبیت
- **فیلترینگ**: فیلتر پیشرفته بر اساس دسته‌بندی، برند، قیمت، امتیاز
- **جستجوی هوشمند**: جستجو در نام، توضیحات، برند
- **کش داخلی**: بهینه‌سازی عملکرد با کش کردن داده‌ها
- **شبیه‌سازی تأخیر**: شبیه‌سازی واقعی API calls
- **مدیریت خطا**: مدیریت کامل خطاها و exception ها

## 📚 مثال‌های بیشتر

فایل‌های `data_manager_usage_example.dart` و `data_manager_usage_example_fixed.dart` را برای مثال‌های کاربردی بیشتر مشاهده کنید.

**نکته**: `data_manager_usage_example_fixed.dart` نسخه اصلاح شده است که تمام خطاها رفع شده و با API واقعی سازگار است.

## ⚠️ نکات مهم

1. **Singleton Pattern**: DataManager از الگوی Singleton استفاده می‌کند
2. **Async/Await**: همه عملیات async هستند
3. **Error Handling**: همیشه response.success را چک کنید
4. **Memory Management**: داده‌ها در حافظه نگهداری می‌شوند
5. **Test Data**: داده‌های تست واقع‌گرایانه و کامل

---

✨ **این سیستم آماده استفاده است و تمام داده‌های فروشگاه را مدیریت می‌کند!**
