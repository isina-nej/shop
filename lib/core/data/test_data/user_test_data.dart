import '../models/user_model.dart';

class UserTestData {
  static final List<UserModel> users = [
    // Premium User
    UserModel(
      id: 'user_001',
      email: 'ali.ahmadi@gmail.com',
      username: 'ali_ahmadi_92',
      profile: UserProfile(
        firstName: 'علی',
        lastName: 'احمدی',
        displayName: 'علی احمدی',
        avatar: 'https://i.pravatar.cc/300?img=1',
        phoneNumber: '+98912345678',
        dateOfBirth: DateTime(1992, 5, 15),
        gender: 'مرد',
        bio: 'علاقه‌مند به تکنولوژی و خرید آنلاین',
        website: 'https://ali-tech.ir',
        socialMedia: UserSocialMedia(
          instagram: '@ali_tech_92',
          telegram: '@ali_ahmadi',
          whatsapp: '+98912345678',
        ),
        occupation: 'مهندس نرم‌افزار',
        company: 'تک پارس',
        interests: ['تکنولوژی', 'ورزش', 'سینما', 'مطالعه'],
        language: 'fa',
        timezone: 'Asia/Tehran',
        country: 'ایران',
        city: 'تهران',
      ),
      account: UserAccount(
        accountType: 'premium',
        memberSince: DateTime(2021, 8, 12),
        subscription: UserSubscription(
          plan: 'premium',
          startDate: DateTime(2024, 1, 1),
          endDate: DateTime(2024, 12, 31),
          isActive: true,
          monthlyFee: 99000,
          benefits: [
            'ارسال رایگان همیشه',
            'پشتیبانی ویژه',
            'تخفیف ۱۰٪ همیشگی',
            'دسترسی زودهنگام به محصولات جدید',
          ],
        ),
        walletBalance: 2450000,
        creditBalance: 500000,
        loyaltyPoints: 15678,
        accountStatus: 'active',
        verification: UserVerification(
          emailVerified: true,
          phoneVerified: true,
          identityVerified: true,
          emailVerifiedAt: DateTime(2021, 8, 13),
          phoneVerifiedAt: DateTime(2021, 8, 14),
          identityVerifiedAt: DateTime(2021, 9, 5),
        ),
      ),
      preferences: UserPreferences(
        currency: 'تومان',
        language: 'fa',
        theme: 'dark',
        emailNotifications: true,
        pushNotifications: true,
        smsNotifications: false,
        favoriteCategories: ['electronics', 'sports', 'books'],
        favoriteBrands: ['Apple', 'Nike', 'Sony'],
        priceRange: 'premium',
        personalizedRecommendations: true,
        privacy: UserPrivacySettings(
          profileVisible: true,
          showPurchaseHistory: false,
          showWishlist: true,
          allowDataCollection: true,
          allowTargetedAds: true,
        ),
      ),
      activity: UserActivity(
        lastLoginAt: DateTime.now().subtract(Duration(hours: 2)),
        totalLogins: 1245,
        totalOrders: 67,
        totalSpent: 48750000,
        totalReviews: 45,
        totalWishlistItems: 23,
        recentlyViewedProducts: ['sm001', 'sp001', 'hg001'],
        searchHistory: ['آیفون 14', 'کفش نایکی', 'قهوه ساز', 'هدفون'],
        browsingHistory: UserBrowsingHistory(
          categoryViews: {'electronics': 234, 'sports': 156, 'fashion': 89},
          brandViews: {'Apple': 89, 'Nike': 67, 'Samsung': 45},
          productViews: {
            'sm001': DateTime.now().subtract(Duration(hours: 2)),
            'sp001': DateTime.now().subtract(Duration(hours: 5)),
            'hg001': DateTime.now().subtract(Duration(days: 1)),
          },
          totalPageViews: 3456,
          averageSessionDuration: 420.5,
        ),
      ),
      loyalty: UserLoyalty(
        currentPoints: 15678,
        totalEarned: 23456,
        totalSpent: 7778,
        tier: 'platinum',
        pointsToNextTier: 0,
        recentTransactions: [
          LoyaltyTransaction(
            id: 'lt001',
            type: 'earned',
            points: 487,
            source: 'purchase',
            orderId: 'order_123',
            createdAt: DateTime.now().subtract(Duration(days: 3)),
            description: 'امتیاز خرید سفارش #order_123',
          ),
          LoyaltyTransaction(
            id: 'lt002',
            type: 'spent',
            points: -1000,
            source: 'redemption',
            createdAt: DateTime.now().subtract(Duration(days: 7)),
            description: 'استفاده از امتیاز برای تخفیف',
          ),
        ],
        earningSources: {'purchase': 20456, 'review': 2345, 'referral': 655},
      ),
      security: UserSecurity(
        twoFactorEnabled: true,
        twoFactorMethod: 'sms',
        lastPasswordChange: DateTime(2024, 6, 15),
        activeSessions: [
          UserSession(
            id: 'session_001',
            deviceInfo: 'iPhone 14 Pro - iOS 17.1',
            location: 'تهران، ایران',
            ipAddress: '185.123.45.67',
            createdAt: DateTime.now().subtract(Duration(hours: 2)),
            lastActivityAt: DateTime.now(),
            isCurrent: true,
          ),
          UserSession(
            id: 'session_002',
            deviceInfo: 'MacBook Pro - macOS Sonoma',
            location: 'تهران، ایران',
            ipAddress: '185.123.45.68',
            createdAt: DateTime.now().subtract(Duration(days: 2)),
            lastActivityAt: DateTime.now().subtract(Duration(hours: 6)),
            isCurrent: false,
          ),
        ],
        recentSecurityEvents: [
          SecurityEvent(
            id: 'se001',
            type: 'login',
            description: 'ورود موفق از دستگاه جدید',
            ipAddress: '185.123.45.67',
            deviceInfo: 'iPhone 14 Pro',
            createdAt: DateTime.now().subtract(Duration(hours: 2)),
            status: 'success',
          ),
        ],
      ),
      notifications: UserNotifications(
        notifications: [
          UserNotification(
            id: 'notif_001',
            type: 'order',
            title: 'سفارش شما ارسال شد',
            message:
                'سفارش #12345 با موفقیت ارسال شد و در مسیر رسیدن به شماست.',
            isRead: false,
            createdAt: DateTime.now().subtract(Duration(hours: 3)),
            actionUrl: '/orders/12345',
            data: {'orderId': '12345', 'trackingCode': 'TR123456789'},
          ),
          UserNotification(
            id: 'notif_002',
            type: 'promotion',
            title: 'تخفیف ویژه برای شما!',
            message: 'تخفیف ۲۰٪ روی تمام محصولات الکترونیک تا پایان هفته.',
            isRead: true,
            createdAt: DateTime.now().subtract(Duration(days: 1)),
            actionUrl: '/categories/electronics',
            data: {'discountPercent': 20, 'categoryId': 'electronics'},
          ),
        ],
        unreadCount: 1,
        settings: UserNotificationSettings(
          orderUpdates: true,
          promotionalEmails: true,
          newArrivals: true,
          priceDropAlerts: true,
          backInStockAlerts: true,
          reviewReminders: false,
          loyaltyUpdates: true,
        ),
      ),
      shippingAddresses: UserShippingAddresses(
        addresses: [
          ShippingAddress(
            id: 'addr_001',
            label: 'خانه',
            fullName: 'علی احمدی',
            phoneNumber: '+98912345678',
            country: 'ایران',
            state: 'تهران',
            city: 'تهران',
            streetAddress: 'خیابان ولیعصر، کوچه شهید احمدی، پلاک 45',
            apartmentNumber: 'واحد 12',
            postalCode: '1234567890',
            isDefault: true,
            specialInstructions: 'زنگ آپارتمان شماره 12',
          ),
          ShippingAddress(
            id: 'addr_002',
            label: 'محل کار',
            fullName: 'علی احمدی',
            phoneNumber: '+98912345678',
            country: 'ایران',
            state: 'تهران',
            city: 'تهران',
            streetAddress: 'خیابان آزادی، برج تجاری پارس، طبقه 15',
            postalCode: '1987654321',
            isDefault: false,
            specialInstructions: 'تماس قبل از تحویل الزامی',
          ),
        ],
        defaultAddressId: 'addr_001',
      ),
      paymentMethods: UserPaymentMethods(
        methods: [
          PaymentMethod(
            id: 'pay_001',
            type: 'card',
            name: 'کارت ملی ایران',
            last4Digits: '4589',
            bankName: 'بانک ملی ایران',
            cardType: 'debit',
            isDefault: true,
            isVerified: true,
            createdAt: DateTime(2021, 9, 10),
          ),
          PaymentMethod(
            id: 'pay_002',
            type: 'wallet',
            name: 'کیف پول سینا',
            isDefault: false,
            isVerified: true,
            createdAt: DateTime(2022, 3, 5),
          ),
        ],
        defaultMethodId: 'pay_001',
      ),
      wishlist: UserWishlist(
        productIds: ['sm002', 'sp002', 'hg002', 'bh002'],
        totalCount: 23,
        lastUpdated: DateTime.now().subtract(Duration(hours: 12)),
        addedDates: {
          'sm002': DateTime.now().subtract(Duration(days: 5)),
          'sp002': DateTime.now().subtract(Duration(days: 2)),
          'hg002': DateTime.now().subtract(Duration(hours: 12)),
          'bh002': DateTime.now().subtract(Duration(days: 10)),
        },
      ),
      orders: UserOrders(
        totalOrders: 67,
        totalSpent: 48750000,
        recentOrderIds: ['order_123', 'order_122', 'order_121'],
        ordersByStatus: {
          'delivered': 58,
          'shipped': 3,
          'processing': 2,
          'pending': 1,
          'cancelled': 3,
        },
        favoriteCategory: 'electronics',
        favoriteBrand: 'Apple',
      ),
      reviews: UserReviews(
        totalReviews: 45,
        averageRating: 4.3,
        recentReviewIds: ['rev001', 'rev002', 'rev003'],
        helpfulVotes: 234,
        verifiedReviews: 43,
      ),
      createdAt: DateTime(2021, 8, 12),
      lastLoginAt: DateTime.now().subtract(Duration(hours: 2)),
      updatedAt: DateTime.now().subtract(Duration(minutes: 30)),
      isActive: true,
      isVerified: true,
      isPremium: true,
    ),

    // Regular User
    UserModel(
      id: 'user_002',
      email: 'sara.karimi@yahoo.com',
      username: 'sara_k_95',
      profile: UserProfile(
        firstName: 'سارا',
        lastName: 'کریمی',
        displayName: 'سارا کریمی',
        avatar: 'https://i.pravatar.cc/300?img=25',
        phoneNumber: '+98935678901',
        dateOfBirth: DateTime(1995, 11, 22),
        gender: 'زن',
        bio: 'علاقه‌مند به مد و زیبایی',
        socialMedia: UserSocialMedia(
          instagram: '@sara_beauty_95',
          telegram: '@sara_karimi',
        ),
        occupation: 'گرافیست',
        company: 'آژانس تبلیغاتی رویا',
        interests: ['مد', 'زیبایی', 'عکاسی', 'سفر'],
        language: 'fa',
        timezone: 'Asia/Tehran',
        country: 'ایران',
        city: 'اصفهان',
      ),
      account: UserAccount(
        accountType: 'basic',
        memberSince: DateTime(2022, 3, 8),
        walletBalance: 150000,
        creditBalance: 0,
        loyaltyPoints: 3450,
        accountStatus: 'active',
        verification: UserVerification(
          emailVerified: true,
          phoneVerified: true,
          identityVerified: false,
          emailVerifiedAt: DateTime(2022, 3, 9),
          phoneVerifiedAt: DateTime(2022, 3, 10),
        ),
      ),
      preferences: UserPreferences(
        currency: 'تومان',
        language: 'fa',
        theme: 'light',
        emailNotifications: true,
        pushNotifications: true,
        smsNotifications: true,
        favoriteCategories: ['beauty-health', 'fashion', 'home-appliances'],
        favoriteBrands: ['La Roche-Posay', 'Zara', 'L\'Oreal'],
        priceRange: 'mid-range',
        personalizedRecommendations: true,
        privacy: UserPrivacySettings(
          profileVisible: true,
          showPurchaseHistory: true,
          showWishlist: true,
          allowDataCollection: true,
          allowTargetedAds: false,
        ),
      ),
      activity: UserActivity(
        lastLoginAt: DateTime.now().subtract(Duration(hours: 8)),
        totalLogins: 456,
        totalOrders: 23,
        totalSpent: 8650000,
        totalReviews: 18,
        totalWishlistItems: 15,
        recentlyViewedProducts: ['bh001', 'fs001', 'bh002'],
        searchHistory: ['کرم ضد آفتاب', 'رژ لب', 'تی شرت زنانه'],
        browsingHistory: UserBrowsingHistory(
          categoryViews: {
            'beauty-health': 189,
            'fashion': 123,
            'home-appliances': 45,
          },
          brandViews: {'La Roche-Posay': 67, 'Zara': 54, 'L\'Oreal': 43},
          productViews: {
            'bh001': DateTime.now().subtract(Duration(hours: 8)),
            'fs001': DateTime.now().subtract(Duration(hours: 12)),
            'bh002': DateTime.now().subtract(Duration(days: 2)),
          },
          totalPageViews: 1234,
          averageSessionDuration: 285.3,
        ),
      ),
      loyalty: UserLoyalty(
        currentPoints: 3450,
        totalEarned: 4567,
        totalSpent: 1117,
        tier: 'silver',
        pointsToNextTier: 1550,
        recentTransactions: [
          LoyaltyTransaction(
            id: 'lt003',
            type: 'earned',
            points: 86,
            source: 'purchase',
            orderId: 'order_456',
            createdAt: DateTime.now().subtract(Duration(days: 2)),
            description: 'امتیاز خرید سفارش #order_456',
          ),
        ],
        earningSources: {'purchase': 3567, 'review': 890, 'referral': 110},
      ),
      security: UserSecurity(
        twoFactorEnabled: false,
        lastPasswordChange: DateTime(2024, 4, 20),
        activeSessions: [
          UserSession(
            id: 'session_003',
            deviceInfo: 'Samsung Galaxy S23 - Android 14',
            location: 'اصفهان، ایران',
            ipAddress: '185.98.76.54',
            createdAt: DateTime.now().subtract(Duration(hours: 8)),
            lastActivityAt: DateTime.now().subtract(Duration(hours: 1)),
            isCurrent: true,
          ),
        ],
        recentSecurityEvents: [
          SecurityEvent(
            id: 'se002',
            type: 'login',
            description: 'ورود موفق',
            ipAddress: '185.98.76.54',
            deviceInfo: 'Samsung Galaxy S23',
            createdAt: DateTime.now().subtract(Duration(hours: 8)),
            status: 'success',
          ),
        ],
      ),
      notifications: UserNotifications(
        notifications: [
          UserNotification(
            id: 'notif_003',
            type: 'promotion',
            title: 'محصولات جدید آرایشی',
            message: 'مجموعه جدید محصولات آرایشی وارد شده است.',
            isRead: true,
            createdAt: DateTime.now().subtract(Duration(days: 2)),
            actionUrl: '/categories/beauty-health',
          ),
        ],
        unreadCount: 0,
        settings: UserNotificationSettings(
          orderUpdates: true,
          promotionalEmails: true,
          newArrivals: true,
          priceDropAlerts: false,
          backInStockAlerts: true,
          reviewReminders: true,
          loyaltyUpdates: false,
        ),
      ),
      shippingAddresses: UserShippingAddresses(
        addresses: [
          ShippingAddress(
            id: 'addr_003',
            label: 'خانه',
            fullName: 'سارا کریمی',
            phoneNumber: '+98935678901',
            country: 'ایران',
            state: 'اصفهان',
            city: 'اصفهان',
            streetAddress: 'خیابان چهارباغ، کوچه گل‌ها، پلاک 23',
            postalCode: '8134567890',
            isDefault: true,
          ),
        ],
        defaultAddressId: 'addr_003',
      ),
      paymentMethods: UserPaymentMethods(
        methods: [
          PaymentMethod(
            id: 'pay_003',
            type: 'card',
            name: 'کارت پاسارگاد',
            last4Digits: '7823',
            bankName: 'بانک پاسارگاد',
            cardType: 'debit',
            isDefault: true,
            isVerified: true,
            createdAt: DateTime(2022, 4, 15),
          ),
        ],
        defaultMethodId: 'pay_003',
      ),
      wishlist: UserWishlist(
        productIds: ['bh003', 'fs002', 'bh004'],
        totalCount: 15,
        lastUpdated: DateTime.now().subtract(Duration(days: 1)),
        addedDates: {
          'bh003': DateTime.now().subtract(Duration(days: 3)),
          'fs002': DateTime.now().subtract(Duration(days: 1)),
          'bh004': DateTime.now().subtract(Duration(days: 7)),
        },
      ),
      orders: UserOrders(
        totalOrders: 23,
        totalSpent: 8650000,
        recentOrderIds: ['order_456', 'order_455', 'order_454'],
        ordersByStatus: {
          'delivered': 19,
          'shipped': 1,
          'processing': 1,
          'pending': 0,
          'cancelled': 2,
        },
        favoriteCategory: 'beauty-health',
        favoriteBrand: 'La Roche-Posay',
      ),
      reviews: UserReviews(
        totalReviews: 18,
        averageRating: 4.6,
        recentReviewIds: ['rev004', 'rev005', 'rev006'],
        helpfulVotes: 89,
        verifiedReviews: 16,
      ),
      createdAt: DateTime(2022, 3, 8),
      lastLoginAt: DateTime.now().subtract(Duration(hours: 8)),
      updatedAt: DateTime.now().subtract(Duration(hours: 2)),
      isActive: true,
      isVerified: true,
      isPremium: false,
    ),

    // New User
    UserModel(
      id: 'user_003',
      email: 'reza.mohammadi@outlook.com',
      username: 'reza_m_88',
      profile: UserProfile(
        firstName: 'رضا',
        lastName: 'محمدی',
        displayName: 'رضا محمدی',
        avatar: 'https://i.pravatar.cc/300?img=12',
        phoneNumber: '+98901234567',
        dateOfBirth: DateTime(1988, 7, 3),
        gender: 'مرد',
        socialMedia: UserSocialMedia(),
        occupation: 'معلم',
        interests: ['کتاب', 'ورزش', 'طبیعت'],
        language: 'fa',
        timezone: 'Asia/Tehran',
        country: 'ایران',
        city: 'شیراز',
      ),
      account: UserAccount(
        accountType: 'basic',
        memberSince: DateTime.now().subtract(Duration(days: 15)),
        walletBalance: 0,
        creditBalance: 0,
        loyaltyPoints: 150,
        accountStatus: 'active',
        verification: UserVerification(
          emailVerified: true,
          phoneVerified: false,
          identityVerified: false,
          emailVerifiedAt: DateTime.now().subtract(Duration(days: 14)),
        ),
      ),
      preferences: UserPreferences(
        currency: 'تومان',
        language: 'fa',
        theme: 'system',
        emailNotifications: true,
        pushNotifications: false,
        smsNotifications: false,
        favoriteCategories: ['books', 'sports'],
        favoriteBrands: [],
        priceRange: 'budget',
        personalizedRecommendations: false,
        privacy: UserPrivacySettings(
          profileVisible: false,
          showPurchaseHistory: false,
          showWishlist: false,
          allowDataCollection: false,
          allowTargetedAds: false,
        ),
      ),
      activity: UserActivity(
        lastLoginAt: DateTime.now().subtract(Duration(days: 1)),
        totalLogins: 8,
        totalOrders: 1,
        totalSpent: 450000,
        totalReviews: 0,
        totalWishlistItems: 3,
        recentlyViewedProducts: ['bk001', 'sp001'],
        searchHistory: ['کتاب داستان', 'کفش پیاده روی'],
        browsingHistory: UserBrowsingHistory(
          categoryViews: {'books': 12, 'sports': 8},
          brandViews: {'Nike': 5, 'Adidas': 3},
          productViews: {
            'bk001': DateTime.now().subtract(Duration(days: 1)),
            'sp001': DateTime.now().subtract(Duration(days: 2)),
          },
          totalPageViews: 45,
          averageSessionDuration: 180.2,
        ),
      ),
      loyalty: UserLoyalty(
        currentPoints: 150,
        totalEarned: 150,
        totalSpent: 0,
        tier: 'bronze',
        pointsToNextTier: 850,
        recentTransactions: [
          LoyaltyTransaction(
            id: 'lt004',
            type: 'earned',
            points: 150,
            source: 'signup',
            createdAt: DateTime.now().subtract(Duration(days: 15)),
            description: 'امتیاز عضویت در سایت',
          ),
        ],
        earningSources: {'signup': 150},
      ),
      security: UserSecurity(
        twoFactorEnabled: false,
        lastPasswordChange: DateTime.now().subtract(Duration(days: 15)),
        activeSessions: [
          UserSession(
            id: 'session_004',
            deviceInfo: 'Huawei P30 - Android 12',
            location: 'شیراز، ایران',
            ipAddress: '185.55.44.33',
            createdAt: DateTime.now().subtract(Duration(days: 1)),
            lastActivityAt: DateTime.now().subtract(Duration(hours: 12)),
            isCurrent: true,
          ),
        ],
        recentSecurityEvents: [
          SecurityEvent(
            id: 'se003',
            type: 'signup',
            description: 'ثبت‌نام در سایت',
            ipAddress: '185.55.44.33',
            deviceInfo: 'Huawei P30',
            createdAt: DateTime.now().subtract(Duration(days: 15)),
            status: 'success',
          ),
        ],
      ),
      notifications: UserNotifications(
        notifications: [
          UserNotification(
            id: 'notif_004',
            type: 'system',
            title: 'خوش آمدید!',
            message:
                'به فروشگاه سینا خوش آمدید. لطفاً شماره تلفن خود را تأیید کنید.',
            isRead: false,
            createdAt: DateTime.now().subtract(Duration(days: 15)),
          ),
        ],
        unreadCount: 1,
        settings: UserNotificationSettings(
          orderUpdates: true,
          promotionalEmails: false,
          newArrivals: false,
          priceDropAlerts: false,
          backInStockAlerts: false,
          reviewReminders: false,
          loyaltyUpdates: false,
        ),
      ),
      shippingAddresses: UserShippingAddresses(addresses: []),
      paymentMethods: UserPaymentMethods(methods: []),
      wishlist: UserWishlist(
        productIds: ['bk001', 'sp002', 'hg003'],
        totalCount: 3,
        lastUpdated: DateTime.now().subtract(Duration(days: 2)),
        addedDates: {
          'bk001': DateTime.now().subtract(Duration(days: 2)),
          'sp002': DateTime.now().subtract(Duration(days: 3)),
          'hg003': DateTime.now().subtract(Duration(days: 5)),
        },
      ),
      orders: UserOrders(
        totalOrders: 1,
        totalSpent: 450000,
        recentOrderIds: ['order_789'],
        ordersByStatus: {'delivered': 1},
        favoriteCategory: 'books',
        favoriteBrand: '',
      ),
      reviews: UserReviews(
        totalReviews: 0,
        averageRating: 0.0,
        recentReviewIds: [],
        helpfulVotes: 0,
        verifiedReviews: 0,
      ),
      createdAt: DateTime.now().subtract(Duration(days: 15)),
      lastLoginAt: DateTime.now().subtract(Duration(days: 1)),
      updatedAt: DateTime.now().subtract(Duration(days: 1)),
      isActive: true,
      isVerified: false,
      isPremium: false,
    ),
  ];

  // Helper methods to simulate API responses
  static List<UserModel> getAllUsers() => users;

  static UserModel? getUserById(String id) {
    try {
      return users.firstWhere((user) => user.id == id);
    } catch (e) {
      return null;
    }
  }

  static UserModel? getUserByEmail(String email) {
    try {
      return users.firstWhere((user) => user.email == email);
    } catch (e) {
      return null;
    }
  }

  static UserModel? getUserByUsername(String username) {
    try {
      return users.firstWhere((user) => user.username == username);
    } catch (e) {
      return null;
    }
  }

  static List<UserModel> searchUsers(String query) {
    final lowercaseQuery = query.toLowerCase();
    return users
        .where(
          (user) =>
              user.profile.firstName.toLowerCase().contains(lowercaseQuery) ||
              user.profile.lastName.toLowerCase().contains(lowercaseQuery) ||
              user.profile.displayName.toLowerCase().contains(lowercaseQuery) ||
              user.email.toLowerCase().contains(lowercaseQuery) ||
              user.username.toLowerCase().contains(lowercaseQuery),
        )
        .toList();
  }

  static List<UserModel> getPremiumUsers() {
    return users.where((user) => user.isPremium).toList();
  }

  static List<UserModel> getActiveUsers() {
    return users.where((user) => user.isActive).toList();
  }

  static List<UserModel> getVerifiedUsers() {
    return users.where((user) => user.isVerified).toList();
  }

  static List<UserModel> getNewUsers({int days = 30}) {
    final cutoffDate = DateTime.now().subtract(Duration(days: days));
    return users.where((user) => user.createdAt.isAfter(cutoffDate)).toList();
  }

  static List<UserModel> getUsersByLoyaltyTier(String tier) {
    return users.where((user) => user.loyalty.tier == tier).toList();
  }

  static List<UserModel> getUsersByAccountType(String accountType) {
    return users
        .where((user) => user.account.accountType == accountType)
        .toList();
  }

  static List<UserModel> getUsersByCity(String city) {
    return users.where((user) => user.profile.city == city).toList();
  }

  static List<UserModel> filterUsers({
    String? accountType,
    String? loyaltyTier,
    String? city,
    bool? isPremium,
    bool? isActive,
    bool? isVerified,
    DateTime? memberSince,
  }) {
    return users.where((user) {
      if (accountType != null && user.account.accountType != accountType) {
        return false;
      }
      if (loyaltyTier != null && user.loyalty.tier != loyaltyTier) {
        return false;
      }
      if (city != null && user.profile.city != city) return false;
      if (isPremium != null && user.isPremium != isPremium) return false;
      if (isActive != null && user.isActive != isActive) return false;
      if (isVerified != null && user.isVerified != isVerified) return false;
      if (memberSince != null &&
          user.account.memberSince.isBefore(memberSince)) {
        return false;
      }

      return true;
    }).toList();
  }

  static Map<String, dynamic> getUserStats() {
    final totalUsers = users.length;
    final activeUsers = users.where((u) => u.isActive).length;
    final premiumUsers = users.where((u) => u.isPremium).length;
    final verifiedUsers = users.where((u) => u.isVerified).length;
    final totalOrders = users.fold<int>(
      0,
      (sum, u) => sum + u.orders.totalOrders,
    );
    final totalSpent = users.fold<double>(
      0,
      (sum, u) => sum + u.orders.totalSpent,
    );
    final totalReviews = users.fold<int>(
      0,
      (sum, u) => sum + u.reviews.totalReviews,
    );

    return {
      'totalUsers': totalUsers,
      'activeUsers': activeUsers,
      'premiumUsers': premiumUsers,
      'verifiedUsers': verifiedUsers,
      'totalOrders': totalOrders,
      'totalSpent': totalSpent,
      'totalReviews': totalReviews,
      'averageOrderValue': totalOrders > 0 ? totalSpent / totalOrders : 0,
      'loyaltyTierDistribution': {
        'bronze': users.where((u) => u.loyalty.tier == 'bronze').length,
        'silver': users.where((u) => u.loyalty.tier == 'silver').length,
        'gold': users.where((u) => u.loyalty.tier == 'gold').length,
        'platinum': users.where((u) => u.loyalty.tier == 'platinum').length,
      },
      'accountTypeDistribution': {
        'basic': users.where((u) => u.account.accountType == 'basic').length,
        'premium': users
            .where((u) => u.account.accountType == 'premium')
            .length,
        'vip': users.where((u) => u.account.accountType == 'vip').length,
      },
    };
  }

  static List<UserModel> getTopSpenders({int limit = 10}) {
    final sortedUsers = List<UserModel>.from(users);
    sortedUsers.sort(
      (a, b) => b.orders.totalSpent.compareTo(a.orders.totalSpent),
    );
    return sortedUsers.take(limit).toList();
  }

  static List<UserModel> getMostActiveUsers({int limit = 10}) {
    final sortedUsers = List<UserModel>.from(users);
    sortedUsers.sort(
      (a, b) => b.activity.totalLogins.compareTo(a.activity.totalLogins),
    );
    return sortedUsers.take(limit).toList();
  }
}
