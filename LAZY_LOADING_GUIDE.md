# راهنمای پیاده‌سازی Lazy Loading در Flutter Web

## مشکل فعلی
پروژه شما در حال حاضر تمام صفحات را در ابتدای اجرا لود می‌کند که باعث کند شدن بارگیری اولیه سایت می‌شود.

## راه‌حل‌های پیاده‌سازی شده

### 1. Deferred Loading با Dart
فایل `lib/core/routing/deferred_page_loader.dart` پیاده‌سازی واقعی Deferred Loading را با استفاده از `deferred imports` ارائه می‌دهد:

```dart
import '../../features/home/presentation/pages/home_page.dart' deferred as home_page;

static Future<Widget> loadHomePage() async {
  await _loadLibrary('home', () => home_page.loadLibrary());
  return home_page.HomePage();
}
```

### 2. Enhanced App Router
فایل `lib/core/routing/enhanced_app_router.dart` روتر پیشرفته با Lazy Loading:

```dart
case home:
  return MaterialPageRoute(
    builder: (_) => DeferredPageWrapper(
      pageLoader: () => DeferredPageLoader.loadHomePage(),
      pageName: 'خانه',
    ),
  );
```

### 3. Enhanced Main Layout  
فایل `lib/shared/widgets/layouts/enhanced_main_layout.dart` برای Bottom Navigation با Lazy Loading.

## مزایای این پیاده‌سازی:

### ✅ بهبود سرعت بارگیری اولیه
- صفحات فقط هنگام نیاز لود می‌شوند
- حجم اولیه JavaScript کاهش می‌یابد
- زمان Time to First Contentful Paint بهبود می‌یابد

### ✅ مدیریت حافظه بهتر
- صفحات در cache نگهداری می‌شوند
- حافظه فقط برای صفحات استفاده شده مصرف می‌شود

### ✅ تجربه کاربری بهتر
- Loading indicator در حین بارگیری
- Error handling با قابلیت retry
- Preloading برای صفحات مهم

### ✅ نمایشگرهای وضعیت
- نقطه آبی: در حال بارگیری
- نقطه سبز: بارگیری شده
- Progress bar برای پیشرفت کلی

## نحوه اعمال تغییرات:

### مرحله 1: تغییر main.dart
```dart
// از این:
import 'core/routing/app_router.dart';
import 'shared/widgets/layouts/main_layout.dart';

// به این:
import 'core/routing/enhanced_app_router.dart';
import 'shared/widgets/layouts/enhanced_main_layout.dart';

// در MaterialApp:
onGenerateRoute: EnhancedAppRouter.generateRoute,
home: const EnhancedMainLayout(),
```

### مرحله 2: Preload صفحات مهم
```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // سایر تنظیمات...
  
  // Preload صفحات مهم
  await EnhancedAppRouter.preloadCriticalPages();
  
  runApp(MyApp());
}
```

### مرحله 3: استفاده از Navigation
```dart
// به جای:
Navigator.of(context).push(MaterialPageRoute(builder: (_) => ProductsPage()));

// از این استفاده کنید:
Navigator.of(context).pushNamed('/products');
```

## تنظیمات اضافی برای بهینه‌سازی Web:

### 1. فایل pubspec.yaml
```yaml
flutter:
  web:
    # فعال‌سازی code splitting
    generate_pubspec_files: true
```

### 2. Build commands برای تولید بهینه:
```bash
# Build معمولی
flutter build web

# Build با tree shaking بهتر
flutter build web --tree-shake-icons --dart-define=flutter.web.canvaskit.runtime=true

# Build با تنظیمات بهینه‌سازی
flutter build web --release --tree-shake-icons --dart-define=flutter.web.canvaskit.runtime=true --web-renderer=canvaskit
```

## مزایای اضافی:

### 1. SEO بهتر
صفحات سریعتر لود می‌شوند که برای SEO مفید است.

### 2. کاهش استفاده از bandwidth
کاربران فقط صفحاتی که استفاده می‌کنند را دانلود می‌کنند.

### 3. بهبود Core Web Vitals
- First Contentful Paint (FCP)
- Largest Contentful Paint (LCP)  
- Cumulative Layout Shift (CLS)

## نکات مهم:

1. **Preloading**: صفحات مهم مثل Home و Profile از قبل لود می‌شوند
2. **Caching**: صفحات لود شده در حافظه نگهداری می‌شوند
3. **Error Handling**: مدیریت خطا با امکان تلاش مجدد
4. **Loading States**: نمایشگرهای مختلف برای وضعیت بارگیری

## اندازه‌گیری بهبود:

برای اندازه‌گیری بهبود عملکرد:

1. **Chrome DevTools** → Network tab
2. **Lighthouse** برای Core Web Vitals
3. **Flutter Inspector** برای memory usage

این پیاده‌سازی باعث کاهش قابل توجه در زمان بارگیری اولیه و بهبود تجربه کاربری خواهد شد.
