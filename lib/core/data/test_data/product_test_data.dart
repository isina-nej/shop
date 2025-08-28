import '../models/product_model.dart';

class ProductTestData {
  static final List<ProductModel> products = [
    // Electronics - Smartphone
    ProductModel(
      id: 'sm001',
      name: 'آیفون ۱۴ پرو مکس',
      brand: 'Apple',
      model: 'iPhone 14 Pro Max',
      description:
          'جدیدترین گوشی هوشمند اپل با پردازنده A16 Bionic و سیستم دوربین پیشرفته',
      shortDescriptions: [
        'پردازنده A16 Bionic قدرتمند',
        'دوربین ۴۸ مگاپیکسلی اصلی',
        'نمایشگر Super Retina XDR',
        'مقاوم در برابر آب IP68',
      ],
      price: 52900000,
      originalPrice: 55900000,
      currency: 'تومان',
      images: [
        ProductImage(
          id: 'img1',
          url:
              'https://images.unsplash.com/photo-1592750475338-74b7b21085ab?w=500',
          altText: 'آیفون ۱۴ پرو مکس - نمای جلو',
          isPrimary: true,
          colorVariant: 'deep-purple',
          order: 1,
        ),
        ProductImage(
          id: 'img2',
          url:
              'https://images.unsplash.com/photo-1511707171634-5f897ff02aa9?w=500',
          altText: 'آیفون ۱۴ پرو مکس - نمای پشت',
          isPrimary: false,
          colorVariant: 'deep-purple',
          order: 2,
        ),
      ],
      availableColors: [
        ProductColor(
          id: 'deep-purple',
          name: 'بنفش تیره',
          hexCode: '#5f4b8b',
          imageUrl:
              'https://images.unsplash.com/photo-1592750475338-74b7b21085ab?w=100',
          isAvailable: true,
        ),
        ProductColor(
          id: 'gold',
          name: 'طلایی',
          hexCode: '#ffd700',
          imageUrl:
              'https://images.unsplash.com/photo-1511707171634-5f897ff02aa9?w=100',
          isAvailable: true,
        ),
        ProductColor(
          id: 'silver',
          name: 'نقره‌ای',
          hexCode: '#c0c0c0',
          imageUrl:
              'https://images.unsplash.com/photo-1574944985070-8f3ebc6b79d2?w=100',
          isAvailable: false,
        ),
      ],
      availableSizes: [
        ProductSize(
          id: '128gb',
          name: '۱۲۸ گیگابایت',
          value: '128',
          unit: 'GB',
          isAvailable: true,
          stockCount: 15,
        ),
        ProductSize(
          id: '256gb',
          name: '۲۵۶ گیگابایت',
          value: '256',
          unit: 'GB',
          isAvailable: true,
          stockCount: 8,
        ),
        ProductSize(
          id: '512gb',
          name: '۵۱۲ گیگابایت',
          value: '512',
          unit: 'GB',
          isAvailable: true,
          stockCount: 3,
        ),
      ],
      categoryId: 'electronics',
      categoryName: 'الکترونیک',
      subCategories: ['موبایل', 'گوشی هوشمند', 'اپل'],
      rating: ProductRating(
        average: 4.7,
        totalReviews: 1847,
        starDistribution: {5: 1200, 4: 450, 3: 150, 2: 35, 1: 12},
        qualityRating: 4.8,
        valueRating: 4.2,
        shippingRating: 4.9,
      ),
      reviews: ProductReviews(
        totalCount: 1847,
        latestReviews: [
          ProductReview(
            id: 'rev1',
            userId: 'user123',
            userName: 'علی احمدی',
            userAvatar: 'https://i.pravatar.cc/150?img=1',
            rating: 5,
            title: 'عالی و بی‌نقص',
            comment:
                'کیفیت دوربین فوق‌العاده است. باتری هم خیلی خوب دوام می‌آورد.',
            images: [
              'https://images.unsplash.com/photo-1592750475338-74b7b21085ab?w=200',
            ],
            isVerifiedPurchase: true,
            isRecommended: true,
            helpfulVotes: 23,
            createdAt: DateTime.now().subtract(Duration(days: 5)),
            pros: ['کیفیت دوربین', 'عمر باتری', 'سرعت پردازنده'],
            cons: ['قیمت بالا'],
          ),
        ],
        verifiedPurchases: 1456,
        recommendationCount: 1623,
      ),
      specifications: ProductSpecifications(
        general: {
          'برند': 'Apple',
          'مدل': 'iPhone 14 Pro Max',
          'سال تولید': '2022',
          'گارانتی': '۱۸ ماه گارانتی رسمی',
        },
        technical: {
          'پردازنده': 'A16 Bionic chip',
          'رم': '6 GB',
          'حافظه داخلی': '128/256/512/1024 GB',
          'سیستم عامل': 'iOS 16',
          'دوربین اصلی': '48MP + 12MP + 12MP',
          'دوربین جلو': '12MP TrueDepth',
        },
        physical: {
          'ابعاد': '160.7 × 77.6 × 7.85 mm',
          'وزن': '240 گرم',
          'جنس بدنه': 'استیل ضد زنگ و شیشه',
          'مقاومت': 'IP68',
        },
        additional: {
          'نوع شارژ': 'Lightning / MagSafe / Qi',
          'شبکه': '5G',
          'بلوتوث': '5.3',
          'NFC': 'دارد',
        },
      ),
      inventory: ProductInventory(
        totalStock: 50,
        availableStock: 26,
        reservedStock: 8,
        soldCount: 324,
        stockStatus: 'in_stock',
        lowStockThreshold: 10,
        variantStock: {
          'deep-purple-128gb': 15,
          'deep-purple-256gb': 8,
          'gold-128gb': 3,
        },
      ),
      shipping: ProductShipping(
        weight: 0.24,
        dimensions: ProductDimensions(
          length: 16.07,
          width: 7.76,
          height: 0.785,
          unit: 'cm',
        ),
        freeShipping: true,
        shippingCost: 0,
        estimatedDeliveryDays: 2,
        shippingMethods: ['پیک موتوری', 'پست پیشتاز', 'تیپاکس'],
        availableRegions: ['تهران', 'کرج', 'اصفهان', 'مشهد', 'شیراز'],
      ),
      salesInfo: ProductSales(
        totalSold: 324,
        monthlySales: 89,
        weeklySales: 23,
        revenue: 17139600000,
        viewCount: 12847,
        wishlistCount: 892,
        cartAddCount: 567,
        conversionRate: 4.4,
      ),
      tags: ['پرفروش', 'جدید', 'اپل', 'گوشی', '5G', 'دوربین حرفه‌ای'],
      seo: ProductSEO(
        metaTitle: 'خرید آیفون ۱۴ پرو مکس | بهترین قیمت | فروشگاه سینا',
        metaDescription:
            'آیفون ۱۴ پرو مکس با پردازنده A16 Bionic و دوربین ۴۸ مگاپیکسلی. گارانتی رسمی و ارسال رایگان.',
        keywords: ['آیفون', 'iPhone 14 Pro Max', 'اپل', 'گوشی هوشمند'],
        slug: 'iphone-14-pro-max',
        canonicalUrl: 'https://shop.example.com/products/iphone-14-pro-max',
        openGraph: {
          'title': 'آیفون ۱۴ پرو مکس - فروشگاه سینا',
          'description': 'آیفون ۱۴ پرو مکس با بهترین قیمت',
          'image':
              'https://images.unsplash.com/photo-1592750475338-74b7b21085ab?w=1200',
        },
      ),
      createdAt: DateTime.now().subtract(Duration(days: 30)),
      updatedAt: DateTime.now().subtract(Duration(hours: 2)),
      isActive: true,
      isFeatured: true,
      isNewArrival: true,
      isBestSeller: true,
      warranty: ProductWarranty(
        hasWarranty: true,
        durationMonths: 18,
        type: 'گارانتی رسمی',
        description: 'گارانتی ۱۸ ماهه رسمی وارد کننده',
        provider: 'شرکت رسمی وارد کننده اپل',
      ),
      relatedProductIds: ['sm002', 'sm003', 'acc001'],
      variants: [
        ProductVariant(
          id: 'var1',
          colorId: 'deep-purple',
          sizeId: '128gb',
          sku: 'IP14PM-DP-128',
          price: 52900000,
          stock: 15,
          images: [
            'https://images.unsplash.com/photo-1592750475338-74b7b21085ab?w=500',
          ],
        ),
      ],
    ),

    // Fashion - T-Shirt
    ProductModel(
      id: 'fs001',
      name: 'تی‌شرت مردانه کلاسیک',
      brand: 'Zara',
      model: 'Classic Fit Tee',
      description: 'تی‌شرت راحت و شیک از جنس پنبه ۱۰۰٪ برای استفاده روزمره',
      shortDescriptions: [
        'جنس پنبه ۱۰۰٪ طبیعی',
        'برش راحت و استاندارد',
        'مناسب فصول گرم',
        'قابل شستشو در ماشین',
      ],
      price: 390000,
      originalPrice: 490000,
      currency: 'تومان',
      images: [
        ProductImage(
          id: 'img1',
          url:
              'https://images.unsplash.com/photo-1521572163474-6864f9cf17ab?w=500',
          altText: 'تی‌شرت مردانه کلاسیک - آبی',
          isPrimary: true,
          colorVariant: 'navy',
          order: 1,
        ),
        ProductImage(
          id: 'img2',
          url:
              'https://images.unsplash.com/photo-1583743814966-8936f37f4678?w=500',
          altText: 'تی‌شرت مردانه کلاسیک - سفید',
          isPrimary: false,
          colorVariant: 'white',
          order: 2,
        ),
      ],
      availableColors: [
        ProductColor(
          id: 'navy',
          name: 'سرمه‌ای',
          hexCode: '#000080',
          imageUrl:
              'https://images.unsplash.com/photo-1521572163474-6864f9cf17ab?w=100',
          isAvailable: true,
        ),
        ProductColor(
          id: 'white',
          name: 'سفید',
          hexCode: '#ffffff',
          imageUrl:
              'https://images.unsplash.com/photo-1583743814966-8936f37f4678?w=100',
          isAvailable: true,
        ),
        ProductColor(
          id: 'black',
          name: 'مشکی',
          hexCode: '#000000',
          imageUrl:
              'https://images.unsplash.com/photo-1574180566232-aaad1b5b8450?w=100',
          isAvailable: true,
        ),
      ],
      availableSizes: [
        ProductSize(
          id: 's',
          name: 'کوچک',
          value: 'S',
          unit: '',
          isAvailable: true,
          stockCount: 25,
        ),
        ProductSize(
          id: 'm',
          name: 'متوسط',
          value: 'M',
          unit: '',
          isAvailable: true,
          stockCount: 30,
        ),
        ProductSize(
          id: 'l',
          name: 'بزرگ',
          value: 'L',
          unit: '',
          isAvailable: true,
          stockCount: 20,
        ),
        ProductSize(
          id: 'xl',
          name: 'خیلی بزرگ',
          value: 'XL',
          unit: '',
          isAvailable: false,
          stockCount: 0,
        ),
      ],
      categoryId: 'fashion',
      categoryName: 'پوشاک',
      subCategories: ['مردانه', 'تی‌شرت', 'پنبه‌ای'],
      rating: ProductRating(
        average: 4.3,
        totalReviews: 456,
        starDistribution: {5: 200, 4: 150, 3: 80, 2: 20, 1: 6},
        qualityRating: 4.5,
        valueRating: 4.7,
        shippingRating: 4.2,
      ),
      reviews: ProductReviews(
        totalCount: 456,
        latestReviews: [
          ProductReview(
            id: 'rev2',
            userId: 'user456',
            userName: 'محمد رضایی',
            userAvatar: 'https://i.pravatar.cc/150?img=2',
            rating: 4,
            title: 'کیفیت خوب و راحت',
            comment: 'جنس خوبی داره و راحته. سایزش هم درسته.',
            images: [],
            isVerifiedPurchase: true,
            isRecommended: true,
            helpfulVotes: 12,
            createdAt: DateTime.now().subtract(Duration(days: 3)),
            pros: ['راحت', 'کیفیت خوب', 'قیمت مناسب'],
            cons: ['رنگ کمی کم رنگ شده'],
          ),
        ],
        verifiedPurchases: 389,
        recommendationCount: 412,
      ),
      specifications: ProductSpecifications(
        general: {
          'برند': 'Zara',
          'جنس': 'پنبه ۱۰۰٪',
          'کشور سازنده': 'ترکیه',
          'نوع': 'تی‌شرت',
        },
        technical: {'وزن': '150 گرم', 'ضخامت': '180 GSM', 'نوع بافت': 'جرسی'},
        physical: {'طول آستین': 'کوتاه', 'یقه': 'گرد', 'برش': 'راحت'},
        additional: {
          'شستشو': 'ماشینی ۳۰ درجه',
          'اتو': 'دمای متوسط',
          'خشک‌کن': 'مجاز',
        },
      ),
      inventory: ProductInventory(
        totalStock: 150,
        availableStock: 75,
        reservedStock: 15,
        soldCount: 892,
        stockStatus: 'in_stock',
        lowStockThreshold: 20,
        variantStock: {'navy-m': 30, 'white-m': 25, 'black-l': 20},
      ),
      shipping: ProductShipping(
        weight: 0.15,
        dimensions: ProductDimensions(
          length: 25,
          width: 20,
          height: 2,
          unit: 'cm',
        ),
        freeShipping: false,
        shippingCost: 25000,
        estimatedDeliveryDays: 3,
        shippingMethods: ['پست معمولی', 'پیک'],
        availableRegions: ['تهران', 'کرج', 'اصفهان'],
      ),
      salesInfo: ProductSales(
        totalSold: 892,
        monthlySales: 156,
        weeklySales: 45,
        revenue: 347880000,
        viewCount: 5647,
        wishlistCount: 234,
        cartAddCount: 445,
        conversionRate: 15.8,
      ),
      tags: ['پنبه', 'مردانه', 'راحت', 'کلاسیک', 'روزمره'],
      seo: ProductSEO(
        metaTitle: 'تی‌شرت مردانه کلاسیک | پنبه ۱۰۰٪ | فروشگاه سینا',
        metaDescription:
            'تی‌شرت مردانه کلاسیک از جنس پنبه ۱۰۰٪. راحت و با کیفیت. سایزهای متنوع.',
        keywords: ['تی‌شرت', 'مردانه', 'پنبه', 'کلاسیک'],
        slug: 'classic-mens-tshirt',
        canonicalUrl: 'https://shop.example.com/products/classic-mens-tshirt',
        openGraph: {
          'title': 'تی‌شرت مردانه کلاسیک',
          'description': 'تی‌شرت راحت و با کیفیت',
          'image':
              'https://images.unsplash.com/photo-1521572163474-6864f9cf17ab?w=1200',
        },
      ),
      createdAt: DateTime.now().subtract(Duration(days: 60)),
      updatedAt: DateTime.now().subtract(Duration(days: 1)),
      isActive: true,
      isFeatured: false,
      isNewArrival: false,
      isBestSeller: true,
      warranty: ProductWarranty(
        hasWarranty: false,
        durationMonths: 0,
        type: '',
        description: 'بدون گارانتی - ضمانت بازگشت ۷ روزه',
        provider: '',
      ),
      relatedProductIds: ['fs002', 'fs003', 'fs004'],
      variants: [
        ProductVariant(
          id: 'var2',
          colorId: 'navy',
          sizeId: 'm',
          sku: 'ZR-TSH-NV-M',
          price: 390000,
          stock: 30,
          images: [
            'https://images.unsplash.com/photo-1521572163474-6864f9cf17ab?w=500',
          ],
        ),
      ],
    ),

    // Home & Garden - Coffee Maker
    ProductModel(
      id: 'hg001',
      name: 'قهوه‌ساز اسپرسو دلونگی',
      brand: 'DeLonghi',
      model: 'Magnifica S ECAM22.110',
      description:
          'قهوه‌ساز اتوماتیک حرفه‌ای برای تهیه انواع قهوه با کیفیت کافه‌ای در منزل',
      shortDescriptions: [
        'آسیاب داخلی قابل تنظیم',
        'سیستم فشار ۱۵ بار',
        'ظرفیت مخزن آب ۱.۸ لیتر',
        'تنظیمات قابل برنامه‌ریزی',
      ],
      price: 18500000,
      originalPrice: 21000000,
      currency: 'تومان',
      images: [
        ProductImage(
          id: 'img1',
          url:
              'https://images.unsplash.com/photo-1495474472287-4d71bcdd2085?w=500',
          altText: 'قهوه‌ساز دلونگی - نمای جلو',
          isPrimary: true,
          colorVariant: 'black-silver',
          order: 1,
        ),
      ],
      availableColors: [
        ProductColor(
          id: 'black-silver',
          name: 'مشکی-نقره‌ای',
          hexCode: '#2c2c2c',
          imageUrl:
              'https://images.unsplash.com/photo-1495474472287-4d71bcdd2085?w=100',
          isAvailable: true,
        ),
      ],
      availableSizes: [
        ProductSize(
          id: 'standard',
          name: 'استاندارد',
          value: '۱.۸ لیتر',
          unit: 'لیتر',
          isAvailable: true,
          stockCount: 12,
        ),
      ],
      categoryId: 'home-appliances',
      categoryName: 'لوازم خانگی',
      subCategories: ['آشپزخانه', 'قهوه‌ساز', 'اسپرسو'],
      rating: ProductRating(
        average: 4.6,
        totalReviews: 234,
        starDistribution: {5: 156, 4: 58, 3: 15, 2: 3, 1: 2},
        qualityRating: 4.8,
        valueRating: 4.2,
        shippingRating: 4.7,
      ),
      reviews: ProductReviews(
        totalCount: 234,
        latestReviews: [
          ProductReview(
            id: 'rev3',
            userId: 'user789',
            userName: 'سارا کریمی',
            userAvatar: 'https://i.pravatar.cc/150?img=3',
            rating: 5,
            title: 'قهوه‌ای عالی می‌سازد',
            comment:
                'طعم قهوه‌هاش واقعاً مثل کافه‌ست. آسیاب داخلیش هم خیلی خوبه.',
            images: [
              'https://images.unsplash.com/photo-1495474472287-4d71bcdd2085?w=200',
            ],
            isVerifiedPurchase: true,
            isRecommended: true,
            helpfulVotes: 18,
            createdAt: DateTime.now().subtract(Duration(days: 7)),
            pros: ['کیفیت قهوه', 'آسیاب داخلی', 'آسان در استفاده'],
            cons: ['قیمت بالا', 'صدای زیاد آسیاب'],
          ),
        ],
        verifiedPurchases: 198,
        recommendationCount: 214,
      ),
      specifications: ProductSpecifications(
        general: {
          'برند': 'DeLonghi',
          'مدل': 'Magnifica S ECAM22.110',
          'کشور سازنده': 'ایتالیا',
          'نوع': 'قهوه‌ساز اسپرسو اتوماتیک',
        },
        technical: {
          'توان': '1450 وات',
          'فشار': '15 بار',
          'ولتاژ': '220-240 ولت',
          'آسیاب': 'استیل ضد زنگ',
          'بویلر': 'ترموبلوک',
        },
        physical: {
          'ابعاد': '238 × 430 × 350 mm',
          'وزن': '9 کیلوگرم',
          'ظرفیت مخزن آب': '1.8 لیتر',
          'ظرفیت دان قهوه': '250 گرم',
        },
        additional: {
          'تمیزکاری': 'برنامه اتوماتیک',
          'صفحه کنترل': 'دیجیتال',
          'قابلیت‌ها': 'اسپرسو، کافه لونگو، کاپوچینو',
        },
      ),
      inventory: ProductInventory(
        totalStock: 25,
        availableStock: 12,
        reservedStock: 3,
        soldCount: 89,
        stockStatus: 'in_stock',
        lowStockThreshold: 5,
        variantStock: {'black-silver-standard': 12},
      ),
      shipping: ProductShipping(
        weight: 10.5,
        dimensions: ProductDimensions(
          length: 43,
          width: 35,
          height: 23.8,
          unit: 'cm',
        ),
        freeShipping: true,
        shippingCost: 0,
        estimatedDeliveryDays: 3,
        shippingMethods: ['باربری', 'تیپاکس'],
        availableRegions: ['تهران', 'کرج', 'اصفهان', 'مشهد'],
      ),
      salesInfo: ProductSales(
        totalSold: 89,
        monthlySales: 23,
        weeklySales: 6,
        revenue: 1646500000,
        viewCount: 3456,
        wishlistCount: 167,
        cartAddCount: 234,
        conversionRate: 2.6,
      ),
      tags: ['قهوه‌ساز', 'اسپرسو', 'دلونگی', 'اتوماتیک', 'آشپزخانه'],
      seo: ProductSEO(
        metaTitle: 'قهوه‌ساز اسپرسو دلونگی | مدل Magnifica S | فروشگاه سینا',
        metaDescription:
            'قهوه‌ساز اسپرسو اتوماتیک دلونگی با آسیاب داخلی و فشار ۱۵ بار. گارانتی رسمی.',
        keywords: ['قهوه‌ساز', 'اسپرسو', 'دلونگی', 'اتوماتیک'],
        slug: 'delonghi-magnifica-espresso-maker',
        canonicalUrl:
            'https://shop.example.com/products/delonghi-magnifica-espresso-maker',
        openGraph: {
          'title': 'قهوه‌ساز اسپرسو دلونگی',
          'description': 'قهوه‌ساز حرفه‌ای برای خانه',
          'image':
              'https://images.unsplash.com/photo-1495474472287-4d71bcdd2085?w=1200',
        },
      ),
      createdAt: DateTime.now().subtract(Duration(days: 45)),
      updatedAt: DateTime.now().subtract(Duration(hours: 6)),
      isActive: true,
      isFeatured: true,
      isNewArrival: false,
      isBestSeller: false,
      warranty: ProductWarranty(
        hasWarranty: true,
        durationMonths: 24,
        type: 'گارانتی رسمی',
        description: 'گارانتی ۲۴ ماهه نمایندگی رسمی دلونگی',
        provider: 'نمایندگی رسمی دلونگی ایران',
      ),
      relatedProductIds: ['hg002', 'hg003', 'acc002'],
      variants: [
        ProductVariant(
          id: 'var3',
          colorId: 'black-silver',
          sizeId: 'standard',
          sku: 'DL-ECAM22110-BS',
          price: 18500000,
          stock: 12,
          images: [
            'https://images.unsplash.com/photo-1495474472287-4d71bcdd2085?w=500',
          ],
        ),
      ],
    ),

    // Beauty & Health - Skincare
    ProductModel(
      id: 'bh001',
      name: 'کرم ضد آفتاب لاروش پوزه',
      brand: 'La Roche-Posay',
      model: 'Anthelios Ultra Light SPF 60',
      description:
          'کرم ضد آفتاب پیشرفته با فاکتور حفاظتی ۶۰ مناسب برای پوست‌های حساس',
      shortDescriptions: [
        'فاکتور حفاظتی SPF 60',
        'مقاوم در برابر آب و عرق',
        'مناسب پوست‌های حساس',
        'بافت سبک و غیرچرب',
      ],
      price: 850000,
      originalPrice: 950000,
      currency: 'تومان',
      images: [
        ProductImage(
          id: 'img1',
          url:
              'https://images.unsplash.com/photo-1556228453-efd6c1ff04f6?w=500',
          altText: 'کرم ضد آفتاب لاروش پوزه',
          isPrimary: true,
          colorVariant: 'default',
          order: 1,
        ),
      ],
      availableColors: [
        ProductColor(
          id: 'default',
          name: 'بی‌رنگ',
          hexCode: '#ffffff',
          imageUrl:
              'https://images.unsplash.com/photo-1556228453-efd6c1ff04f6?w=100',
          isAvailable: true,
        ),
      ],
      availableSizes: [
        ProductSize(
          id: '60ml',
          name: '۶۰ میلی‌لیتر',
          value: '60',
          unit: 'ml',
          isAvailable: true,
          stockCount: 45,
        ),
      ],
      categoryId: 'beauty-health',
      categoryName: 'زیبایی و سلامت',
      subCategories: ['مراقبت از پوست', 'ضد آفتاب', 'لاروش پوزه'],
      rating: ProductRating(
        average: 4.8,
        totalReviews: 678,
        starDistribution: {5: 543, 4: 98, 3: 25, 2: 8, 1: 4},
        qualityRating: 4.9,
        valueRating: 4.5,
        shippingRating: 4.8,
      ),
      reviews: ProductReviews(
        totalCount: 678,
        latestReviews: [
          ProductReview(
            id: 'rev4',
            userId: 'user101',
            userName: 'مریم حسینی',
            userAvatar: 'https://i.pravatar.cc/150?img=4',
            rating: 5,
            title: 'بهترین ضد آفتاب تا حالا',
            comment:
                'واقعاً عالیه! پوستم رو کاملاً محافظت می‌کنه و اصلاً چرب نمی‌شه.',
            images: [],
            isVerifiedPurchase: true,
            isRecommended: true,
            helpfulVotes: 34,
            createdAt: DateTime.now().subtract(Duration(days: 2)),
            pros: ['محافظت عالی', 'بافت سبک', 'ماندگار'],
            cons: ['قیمت کمی بالا'],
          ),
        ],
        verifiedPurchases: 589,
        recommendationCount: 641,
      ),
      specifications: ProductSpecifications(
        general: {
          'برند': 'La Roche-Posay',
          'مدل': 'Anthelios Ultra Light',
          'کشور سازنده': 'فرانسه',
          'نوع': 'کرم ضد آفتاب',
        },
        technical: {
          'فاکتور حفاظتی': 'SPF 60',
          'محافظت UVA': 'بله',
          'محافظت UVB': 'بله',
          'مقاوم در برابر آب': '80 دقیقه',
        },
        physical: {
          'حجم': '60 میلی‌لیتر',
          'بافت': 'کرمی سبک',
          'رنگ': 'بی‌رنگ',
          'رایحه': 'بدون رایحه',
        },
        additional: {
          'مناسب برای': 'پوست صورت و بدن',
          'نوع پوست': 'تمام انواع پوست',
          'ترکیبات فعال': 'Mexoryl SX/XL',
          'پاربن': 'بدون پاربن',
        },
      ),
      inventory: ProductInventory(
        totalStock: 80,
        availableStock: 45,
        reservedStock: 12,
        soldCount: 456,
        stockStatus: 'in_stock',
        lowStockThreshold: 15,
        variantStock: {'default-60ml': 45},
      ),
      shipping: ProductShipping(
        weight: 0.08,
        dimensions: ProductDimensions(
          length: 12,
          width: 4,
          height: 3,
          unit: 'cm',
        ),
        freeShipping: false,
        shippingCost: 20000,
        estimatedDeliveryDays: 2,
        shippingMethods: ['پیک', 'پست پیشتاز'],
        availableRegions: ['تهران', 'کرج', 'اصفهان', 'مشهد', 'شیراز'],
      ),
      salesInfo: ProductSales(
        totalSold: 456,
        monthlySales: 123,
        weeklySales: 34,
        revenue: 387600000,
        viewCount: 8934,
        wishlistCount: 445,
        cartAddCount: 667,
        conversionRate: 5.1,
      ),
      tags: ['ضد آفتاب', 'لاروش پوزه', 'SPF 60', 'پوست حساس', 'ضروری'],
      seo: ProductSEO(
        metaTitle: 'کرم ضد آفتاب لاروش پوزه SPF 60 | فروشگاه سینا',
        metaDescription:
            'کرم ضد آفتاب لاروش پوزه با فاکتور ۶۰. مناسب پوست حساس. مقاوم در برابر آب.',
        keywords: ['ضد آفتاب', 'لاروش پوزه', 'SPF 60', 'کرم پوست'],
        slug: 'laroche-posay-anthelios-spf60',
        canonicalUrl:
            'https://shop.example.com/products/laroche-posay-anthelios-spf60',
        openGraph: {
          'title': 'کرم ضد آفتاب لاروش پوزه SPF 60',
          'description': 'محافظت کامل از پوست در برابر اشعه UV',
          'image':
              'https://images.unsplash.com/photo-1556228453-efd6c1ff04f6?w=1200',
        },
      ),
      createdAt: DateTime.now().subtract(Duration(days: 20)),
      updatedAt: DateTime.now().subtract(Duration(hours: 12)),
      isActive: true,
      isFeatured: true,
      isNewArrival: true,
      isBestSeller: true,
      warranty: ProductWarranty(
        hasWarranty: false,
        durationMonths: 0,
        type: '',
        description: 'ضمانت اصالت کالا و بازگشت ۷ روزه',
        provider: '',
      ),
      relatedProductIds: ['bh002', 'bh003', 'bh004'],
      variants: [
        ProductVariant(
          id: 'var4',
          colorId: 'default',
          sizeId: '60ml',
          sku: 'LRP-ANT-SPF60-60ML',
          price: 850000,
          stock: 45,
          images: [
            'https://images.unsplash.com/photo-1556228453-efd6c1ff04f6?w=500',
          ],
        ),
      ],
    ),

    // Sports - Running Shoes
    ProductModel(
      id: 'sp001',
      name: 'کفش دویدن نایکی ایر مکس',
      brand: 'Nike',
      model: 'Air Max 270',
      description:
          'کفش دویدن حرفه‌ای با تکنولوژی ایر مکس برای راحتی و عملکرد بهتر',
      shortDescriptions: [
        'تکنولوژی ایر مکس در پاشنه',
        'رویه مش قابل تنفس',
        'زیره فوم EVA سبک',
        'طراحی ارگونومیک',
      ],
      price: 4200000,
      originalPrice: 4800000,
      currency: 'تومان',
      images: [
        ProductImage(
          id: 'img1',
          url:
              'https://images.unsplash.com/photo-1549298916-b41d501d3772?w=500',
          altText: 'کفش دویدن نایکی ایر مکس - سفید آبی',
          isPrimary: true,
          colorVariant: 'white-blue',
          order: 1,
        ),
        ProductImage(
          id: 'img2',
          url:
              'https://images.unsplash.com/photo-1600185365483-26d7a4cc7519?w=500',
          altText: 'کفش دویدن نایکی ایر مکس - مشکی قرمز',
          isPrimary: false,
          colorVariant: 'black-red',
          order: 2,
        ),
      ],
      availableColors: [
        ProductColor(
          id: 'white-blue',
          name: 'سفید-آبی',
          hexCode: '#ffffff',
          imageUrl:
              'https://images.unsplash.com/photo-1549298916-b41d501d3772?w=100',
          isAvailable: true,
        ),
        ProductColor(
          id: 'black-red',
          name: 'مشکی-قرمز',
          hexCode: '#000000',
          imageUrl:
              'https://images.unsplash.com/photo-1600185365483-26d7a4cc7519?w=100',
          isAvailable: true,
        ),
      ],
      availableSizes: [
        ProductSize(
          id: '40',
          name: '۴۰',
          value: '40',
          unit: 'EU',
          isAvailable: true,
          stockCount: 8,
        ),
        ProductSize(
          id: '41',
          name: '۴۱',
          value: '41',
          unit: 'EU',
          isAvailable: true,
          stockCount: 12,
        ),
        ProductSize(
          id: '42',
          name: '۴۲',
          value: '42',
          unit: 'EU',
          isAvailable: true,
          stockCount: 15,
        ),
        ProductSize(
          id: '43',
          name: '۴۳',
          value: '43',
          unit: 'EU',
          isAvailable: true,
          stockCount: 10,
        ),
        ProductSize(
          id: '44',
          name: '۴۴',
          value: '44',
          unit: 'EU',
          isAvailable: false,
          stockCount: 0,
        ),
      ],
      categoryId: 'sports',
      categoryName: 'ورزش',
      subCategories: ['کفش', 'دویدن', 'نایکی'],
      rating: ProductRating(
        average: 4.4,
        totalReviews: 523,
        starDistribution: {5: 267, 4: 178, 3: 58, 2: 15, 1: 5},
        qualityRating: 4.6,
        valueRating: 4.1,
        shippingRating: 4.5,
      ),
      reviews: ProductReviews(
        totalCount: 523,
        latestReviews: [
          ProductReview(
            id: 'rev5',
            userId: 'user202',
            userName: 'احمد موسوی',
            userAvatar: 'https://i.pravatar.cc/150?img=5',
            rating: 4,
            title: 'کفش خوب برای دویدن',
            comment:
                'راحته و برای دویدن مناسبه. کیفیت ساختش هم خوبه ولی کمی گرون.',
            images: [
              'https://images.unsplash.com/photo-1549298916-b41d501d3772?w=200',
            ],
            isVerifiedPurchase: true,
            isRecommended: true,
            helpfulVotes: 21,
            createdAt: DateTime.now().subtract(Duration(days: 4)),
            pros: ['راحت', 'مناسب دویدن', 'کیفیت خوب'],
            cons: ['قیمت بالا', 'کمی سنگین'],
          ),
        ],
        verifiedPurchases: 445,
        recommendationCount: 478,
      ),
      specifications: ProductSpecifications(
        general: {
          'برند': 'Nike',
          'مدل': 'Air Max 270',
          'جنسیت': 'مردانه',
          'نوع': 'کفش دویدن',
        },
        technical: {
          'تکنولوژی میانه': 'Air Max',
          'تکنولوژی زیره': 'فوم EVA',
          'نوع بست': 'بند کفش',
          'ارتفاع پاشنه': '32mm',
        },
        physical: {
          'وزن': '310 گرم',
          'رویه': 'مش + سنتتیک',
          'زیره': 'لاستیک',
          'آستر': 'پارچه',
        },
        additional: {
          'مناسب برای': 'دویدن، پیاده‌روی، ورزش',
          'نوع سطح': 'آسفالت، ترک تان',
          'فصل': 'چهار فصل',
          'شستشو': 'دست شویی',
        },
      ),
      inventory: ProductInventory(
        totalStock: 60,
        availableStock: 45,
        reservedStock: 8,
        soldCount: 234,
        stockStatus: 'in_stock',
        lowStockThreshold: 10,
        variantStock: {
          'white-blue-42': 15,
          'black-red-41': 12,
          'white-blue-43': 10,
        },
      ),
      shipping: ProductShipping(
        weight: 0.62,
        dimensions: ProductDimensions(
          length: 32,
          width: 22,
          height: 12,
          unit: 'cm',
        ),
        freeShipping: true,
        shippingCost: 0,
        estimatedDeliveryDays: 3,
        shippingMethods: ['پیک', 'پست پیشتاز', 'تیپاکس'],
        availableRegions: ['تهران', 'کرج', 'اصفهان', 'مشهد', 'شیراز', 'تبریز'],
      ),
      salesInfo: ProductSales(
        totalSold: 234,
        monthlySales: 67,
        weeklySales: 18,
        revenue: 982800000,
        viewCount: 6789,
        wishlistCount: 334,
        cartAddCount: 456,
        conversionRate: 3.4,
      ),
      tags: ['کفش ورزشی', 'دویدن', 'نایکی', 'ایر مکس', 'راحت'],
      seo: ProductSEO(
        metaTitle: 'کفش دویدن نایکی ایر مکس 270 | فروشگاه سینا',
        metaDescription:
            'کفش دویدن نایکی ایر مکس 270 با تکنولوژی پیشرفته. راحت و مناسب ورزش. سایزهای متنوع.',
        keywords: ['کفش ورزشی', 'نایکی', 'ایر مکس', 'دویدن'],
        slug: 'nike-air-max-270-running-shoes',
        canonicalUrl:
            'https://shop.example.com/products/nike-air-max-270-running-shoes',
        openGraph: {
          'title': 'کفش دویدن نایکی ایر مکس 270',
          'description': 'کفش ورزشی حرفه‌ای برای دویدن',
          'image':
              'https://images.unsplash.com/photo-1549298916-b41d501d3772?w=1200',
        },
      ),
      createdAt: DateTime.now().subtract(Duration(days: 40)),
      updatedAt: DateTime.now().subtract(Duration(hours: 18)),
      isActive: true,
      isFeatured: false,
      isNewArrival: false,
      isBestSeller: true,
      warranty: ProductWarranty(
        hasWarranty: true,
        durationMonths: 6,
        type: 'گارانتی کیفیت',
        description: 'گارانتی ۶ ماهه کیفیت ساخت و مواد',
        provider: 'نمایندگی رسمی نایکی',
      ),
      relatedProductIds: ['sp002', 'sp003', 'acc003'],
      variants: [
        ProductVariant(
          id: 'var5',
          colorId: 'white-blue',
          sizeId: '42',
          sku: 'NK-AM270-WB-42',
          price: 4200000,
          stock: 15,
          images: [
            'https://images.unsplash.com/photo-1549298916-b41d501d3772?w=500',
          ],
        ),
      ],
    ),
  ];

  // Helper methods to simulate API responses
  static List<ProductModel> getAllProducts() => products;

  static ProductModel? getProductById(String id) {
    try {
      return products.firstWhere((product) => product.id == id);
    } catch (e) {
      return null;
    }
  }

  static List<ProductModel> getProductsByCategory(String categoryId) {
    return products
        .where((product) => product.categoryId == categoryId)
        .toList();
  }

  static List<ProductModel> searchProducts(String query) {
    final lowercaseQuery = query.toLowerCase();
    return products
        .where(
          (product) =>
              product.name.toLowerCase().contains(lowercaseQuery) ||
              product.brand.toLowerCase().contains(lowercaseQuery) ||
              product.description.toLowerCase().contains(lowercaseQuery) ||
              product.tags.any(
                (tag) => tag.toLowerCase().contains(lowercaseQuery),
              ),
        )
        .toList();
  }

  static List<ProductModel> getFeaturedProducts() {
    return products.where((product) => product.isFeatured).toList();
  }

  static List<ProductModel> getBestSellers() {
    return products.where((product) => product.isBestSeller).toList();
  }

  static List<ProductModel> getNewArrivals() {
    return products.where((product) => product.isNewArrival).toList();
  }

  static List<ProductModel> getProductsOnSale() {
    return products.where((product) => product.isOnSale).toList();
  }

  static List<ProductModel> getRelatedProducts(String productId) {
    final product = getProductById(productId);
    if (product == null) return [];

    return products
        .where((p) => product.relatedProductIds.contains(p.id))
        .toList();
  }

  static List<ProductModel> filterProducts({
    String? categoryId,
    String? brand,
    double? minPrice,
    double? maxPrice,
    double? minRating,
    List<String>? colors,
    List<String>? sizes,
    bool? inStockOnly,
  }) {
    return products.where((product) {
      if (categoryId != null && product.categoryId != categoryId) return false;
      if (brand != null && product.brand != brand) return false;
      if (minPrice != null && product.price < minPrice) return false;
      if (maxPrice != null && product.price > maxPrice) return false;
      if (minRating != null && product.rating.average < minRating) return false;
      if (inStockOnly == true && product.inventory.stockStatus != 'in_stock') {
        return false;
      }

      if (colors != null && colors.isNotEmpty) {
        bool hasColor = colors.any(
          (color) => product.availableColors.any(
            (pc) => pc.id == color && pc.isAvailable,
          ),
        );
        if (!hasColor) return false;
      }

      if (sizes != null && sizes.isNotEmpty) {
        bool hasSize = sizes.any(
          (size) => product.availableSizes.any(
            (ps) => ps.id == size && ps.isAvailable,
          ),
        );
        if (!hasSize) return false;
      }

      return true;
    }).toList();
  }

  static Map<String, dynamic> getProductStats() {
    return {
      'totalProducts': products.length,
      'totalCategories': products.map((p) => p.categoryId).toSet().length,
      'totalBrands': products.map((p) => p.brand).toSet().length,
      'totalReviews': products.fold<int>(
        0,
        (sum, p) => sum + p.rating.totalReviews,
      ),
      'averageRating':
          products.fold<double>(0, (sum, p) => sum + p.rating.average) /
          products.length,
      'totalRevenue': products.fold<double>(
        0,
        (sum, p) => sum + p.salesInfo.revenue,
      ),
      'totalSold': products.fold<int>(
        0,
        (sum, p) => sum + p.salesInfo.totalSold,
      ),
    };
  }
}
