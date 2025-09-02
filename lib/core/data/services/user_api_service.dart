import '../models/user_model.dart';
import '../test_data/user_test_data.dart';
import '../../utils/data_validator.dart';
import 'product_api_service.dart';

/// User API Service - Simulates real API calls
class UserApiService {
  // Simulate network delay
  static Future<void> _simulateDelay([int milliseconds = 500]) async {
    await Future.delayed(Duration(milliseconds: milliseconds));
  }

  /// Get all users with pagination (Admin only)
  static Future<ApiResponse<List<UserModel>>> getAllUsers({
    int page = 1,
    int limit = 20,
    String? sortBy,
    String? sortOrder = 'asc',
  }) async {
    await _simulateDelay();

    try {
      var users = UserTestData.getAllUsers();

      // Apply sorting
      if (sortBy != null) {
        users = _sortUsers(users, sortBy, sortOrder == 'desc');
      }

      // Apply pagination
      final startIndex = (page - 1) * limit;
      final endIndex = startIndex + limit;

      final paginatedUsers = users.length > startIndex
          ? users.sublist(
              startIndex,
              endIndex > users.length ? users.length : endIndex,
            )
          : <UserModel>[];

      return ApiResponse<List<UserModel>>(
        data: paginatedUsers,
        success: true,
        message: 'کاربران با موفقیت بارگذاری شد',
        metadata: {
          'totalCount': users.length,
          'currentPage': page,
          'totalPages': (users.length / limit).ceil(),
          'hasNextPage': endIndex < users.length,
          'hasPreviousPage': page > 1,
        },
      );
    } catch (e) {
      return ApiResponse<List<UserModel>>(
        data: [],
        success: false,
        message: 'خطا در بارگذاری کاربران: ${e.toString()}',
        errorCode: 'USERS_FETCH_ERROR',
      );
    }
  }

  /// Get user by ID
  static Future<ApiResponse<UserModel?>> getUserById(String id) async {
    await _simulateDelay(300);

    try {
      final user = UserTestData.getUserById(id);

      if (user != null) {
        return ApiResponse<UserModel?>(
          data: user,
          success: true,
          message: 'کاربر با موفقیت بارگذاری شد',
        );
      } else {
        return ApiResponse<UserModel?>(
          data: null,
          success: false,
          message: 'کاربر مورد نظر یافت نشد',
          errorCode: 'USER_NOT_FOUND',
        );
      }
    } catch (e) {
      return ApiResponse<UserModel?>(
        data: null,
        success: false,
        message: 'خطا در بارگذاری کاربر: ${e.toString()}',
        errorCode: 'USER_FETCH_ERROR',
      );
    }
  }

  /// Get user by email
  static Future<ApiResponse<UserModel?>> getUserByEmail(String email) async {
    await _simulateDelay(300);

    try {
      final user = UserTestData.getUserByEmail(email);

      if (user != null) {
        return ApiResponse<UserModel?>(
          data: user,
          success: true,
          message: 'کاربر با موفقیت بارگذاری شد',
        );
      } else {
        return ApiResponse<UserModel?>(
          data: null,
          success: false,
          message: 'کاربر با این ایمیل یافت نشد',
          errorCode: 'USER_NOT_FOUND',
        );
      }
    } catch (e) {
      return ApiResponse<UserModel?>(
        data: null,
        success: false,
        message: 'خطا در بارگذاری کاربر: ${e.toString()}',
        errorCode: 'USER_FETCH_ERROR',
      );
    }
  }

  /// Get user by username
  static Future<ApiResponse<UserModel?>> getUserByUsername(
    String username,
  ) async {
    await _simulateDelay(300);

    try {
      final user = UserTestData.getUserByUsername(username);

      if (user != null) {
        return ApiResponse<UserModel?>(
          data: user,
          success: true,
          message: 'کاربر با موفقیت بارگذاری شد',
        );
      } else {
        return ApiResponse<UserModel?>(
          data: null,
          success: false,
          message: 'کاربر با این نام کاربری یافت نشد',
          errorCode: 'USER_NOT_FOUND',
        );
      }
    } catch (e) {
      return ApiResponse<UserModel?>(
        data: null,
        success: false,
        message: 'خطا در بارگذاری کاربر: ${e.toString()}',
        errorCode: 'USER_FETCH_ERROR',
      );
    }
  }

  /// Search users (Admin only)
  static Future<ApiResponse<List<UserModel>>> searchUsers(
    String query, {
    int page = 1,
    int limit = 20,
    String? accountType,
    String? loyaltyTier,
    String? city,
    bool? isPremium,
    bool? isActive,
    bool? isVerified,
    String? sortBy,
    String? sortOrder = 'asc',
  }) async {
    await _simulateDelay(800);

    try {
      List<UserModel> users;

      if (query.trim().isEmpty) {
        users = UserTestData.getAllUsers();
      } else {
        users = UserTestData.searchUsers(query);
      }

      // Apply filters
      users = UserTestData.filterUsers(
        accountType: accountType,
        loyaltyTier: loyaltyTier,
        city: city,
        isPremium: isPremium,
        isActive: isActive,
        isVerified: isVerified,
      );

      // Apply sorting
      if (sortBy != null) {
        users = _sortUsers(users, sortBy, sortOrder == 'desc');
      }

      // Apply pagination
      final startIndex = (page - 1) * limit;
      final endIndex = startIndex + limit;

      final paginatedUsers = users.length > startIndex
          ? users.sublist(
              startIndex,
              endIndex > users.length ? users.length : endIndex,
            )
          : <UserModel>[];

      return ApiResponse<List<UserModel>>(
        data: paginatedUsers,
        success: true,
        message: 'نتایج جستجو با موفقیت بارگذاری شد',
        metadata: {
          'query': query,
          'totalCount': users.length,
          'currentPage': page,
          'totalPages': (users.length / limit).ceil(),
          'hasNextPage': endIndex < users.length,
          'hasPreviousPage': page > 1,
          'appliedFilters': {
            'accountType': accountType,
            'loyaltyTier': loyaltyTier,
            'city': city,
            'isPremium': isPremium,
            'isActive': isActive,
            'isVerified': isVerified,
          },
        },
      );
    } catch (e) {
      return ApiResponse<List<UserModel>>(
        data: [],
        success: false,
        message: 'خطا در جستجوی کاربران: ${e.toString()}',
        errorCode: 'SEARCH_ERROR',
      );
    }
  }

  /// Get premium users
  static Future<ApiResponse<List<UserModel>>> getPremiumUsers({
    int page = 1,
    int limit = 20,
  }) async {
    await _simulateDelay(400);

    try {
      var users = UserTestData.getPremiumUsers();

      // Apply pagination
      final startIndex = (page - 1) * limit;
      final endIndex = startIndex + limit;

      final paginatedUsers = users.length > startIndex
          ? users.sublist(
              startIndex,
              endIndex > users.length ? users.length : endIndex,
            )
          : <UserModel>[];

      return ApiResponse<List<UserModel>>(
        data: paginatedUsers,
        success: true,
        message: 'کاربران پریمیوم با موفقیت بارگذاری شد',
        metadata: {
          'totalCount': users.length,
          'currentPage': page,
          'totalPages': (users.length / limit).ceil(),
          'hasNextPage': endIndex < users.length,
          'hasPreviousPage': page > 1,
        },
      );
    } catch (e) {
      return ApiResponse<List<UserModel>>(
        data: [],
        success: false,
        message: 'خطا در بارگذاری کاربران پریمیوم: ${e.toString()}',
        errorCode: 'PREMIUM_USERS_ERROR',
      );
    }
  }

  /// Get new users
  static Future<ApiResponse<List<UserModel>>> getNewUsers({
    int days = 30,
    int page = 1,
    int limit = 20,
  }) async {
    await _simulateDelay(400);

    try {
      var users = UserTestData.getNewUsers(days: days);

      // Apply pagination
      final startIndex = (page - 1) * limit;
      final endIndex = startIndex + limit;

      final paginatedUsers = users.length > startIndex
          ? users.sublist(
              startIndex,
              endIndex > users.length ? users.length : endIndex,
            )
          : <UserModel>[];

      return ApiResponse<List<UserModel>>(
        data: paginatedUsers,
        success: true,
        message: 'کاربران جدید با موفقیت بارگذاری شد',
        metadata: {
          'days': days,
          'totalCount': users.length,
          'currentPage': page,
          'totalPages': (users.length / limit).ceil(),
          'hasNextPage': endIndex < users.length,
          'hasPreviousPage': page > 1,
        },
      );
    } catch (e) {
      return ApiResponse<List<UserModel>>(
        data: [],
        success: false,
        message: 'خطا در بارگذاری کاربران جدید: ${e.toString()}',
        errorCode: 'NEW_USERS_ERROR',
      );
    }
  }

  /// Get users by loyalty tier
  static Future<ApiResponse<List<UserModel>>> getUsersByLoyaltyTier(
    String tier, {
    int page = 1,
    int limit = 20,
  }) async {
    await _simulateDelay(400);

    try {
      var users = UserTestData.getUsersByLoyaltyTier(tier);

      // Apply pagination
      final startIndex = (page - 1) * limit;
      final endIndex = startIndex + limit;

      final paginatedUsers = users.length > startIndex
          ? users.sublist(
              startIndex,
              endIndex > users.length ? users.length : endIndex,
            )
          : <UserModel>[];

      return ApiResponse<List<UserModel>>(
        data: paginatedUsers,
        success: true,
        message: 'کاربران سطح وفاداری $tier با موفقیت بارگذاری شد',
        metadata: {
          'tier': tier,
          'totalCount': users.length,
          'currentPage': page,
          'totalPages': (users.length / limit).ceil(),
          'hasNextPage': endIndex < users.length,
          'hasPreviousPage': page > 1,
        },
      );
    } catch (e) {
      return ApiResponse<List<UserModel>>(
        data: [],
        success: false,
        message: 'خطا در بارگذاری کاربران سطح وفاداری: ${e.toString()}',
        errorCode: 'LOYALTY_TIER_ERROR',
      );
    }
  }

  /// Get top spending users
  static Future<ApiResponse<List<UserModel>>> getTopSpenders({
    int limit = 10,
  }) async {
    await _simulateDelay(400);

    try {
      final users = UserTestData.getTopSpenders(limit: limit);

      return ApiResponse<List<UserModel>>(
        data: users,
        success: true,
        message: 'بیشترین خریداران با موفقیت بارگذاری شد',
        metadata: {'count': users.length},
      );
    } catch (e) {
      return ApiResponse<List<UserModel>>(
        data: [],
        success: false,
        message: 'خطا در بارگذاری بیشترین خریداران: ${e.toString()}',
        errorCode: 'TOP_SPENDERS_ERROR',
      );
    }
  }

  /// Get most active users
  static Future<ApiResponse<List<UserModel>>> getMostActiveUsers({
    int limit = 10,
  }) async {
    await _simulateDelay(400);

    try {
      final users = UserTestData.getMostActiveUsers(limit: limit);

      return ApiResponse<List<UserModel>>(
        data: users,
        success: true,
        message: 'فعال‌ترین کاربران با موفقیت بارگذاری شد',
        metadata: {'count': users.length},
      );
    } catch (e) {
      return ApiResponse<List<UserModel>>(
        data: [],
        success: false,
        message: 'خطا در بارگذاری فعال‌ترین کاربران: ${e.toString()}',
        errorCode: 'ACTIVE_USERS_ERROR',
      );
    }
  }

  /// Get user statistics
  static Future<ApiResponse<Map<String, dynamic>>> getUserStats() async {
    await _simulateDelay(200);

    try {
      final stats = UserTestData.getUserStats();

      return ApiResponse<Map<String, dynamic>>(
        data: stats,
        success: true,
        message: 'آمار کاربران با موفقیت بارگذاری شد',
      );
    } catch (e) {
      return ApiResponse<Map<String, dynamic>>(
        data: {},
        success: false,
        message: 'خطا در بارگذاری آمار کاربران: ${e.toString()}',
        errorCode: 'STATS_ERROR',
      );
    }
  }

  /// User authentication
  static Future<ApiResponse<UserAuthResponse>> authenticateUser(
    String email,
    String password,
  ) async {
    await _simulateDelay(1000);

    try {
      final user = UserTestData.getUserByEmail(email);

      if (user == null) {
        return ApiResponse<UserAuthResponse>(
          data: UserAuthResponse(
            user: null,
            token: null,
            refreshToken: null,
            expiresAt: null,
          ),
          success: false,
          message: 'کاربری با این ایمیل یافت نشد',
          errorCode: 'USER_NOT_FOUND',
        );
      }

      if (!user.isActive) {
        return ApiResponse<UserAuthResponse>(
          data: UserAuthResponse(
            user: null,
            token: null,
            refreshToken: null,
            expiresAt: null,
          ),
          success: false,
          message: 'حساب کاربری غیرفعال است',
          errorCode: 'ACCOUNT_INACTIVE',
        );
      }

      // Simulate password verification (in real app, hash would be checked)
      if (password.length < 6) {
        return ApiResponse<UserAuthResponse>(
          data: UserAuthResponse(
            user: null,
            token: null,
            refreshToken: null,
            expiresAt: null,
          ),
          success: false,
          message: 'رمز عبور صحیح نیست',
          errorCode: 'INVALID_PASSWORD',
        );
      }

      // Generate mock tokens
      final token = _generateMockToken();
      final refreshToken = _generateMockToken();
      final expiresAt = DateTime.now().add(Duration(hours: 24));

      return ApiResponse<UserAuthResponse>(
        data: UserAuthResponse(
          user: user,
          token: token,
          refreshToken: refreshToken,
          expiresAt: expiresAt,
        ),
        success: true,
        message: 'ورود با موفقیت انجام شد',
        metadata: {
          'loginTime': DateTime.now().toIso8601String(),
          'userAgent': 'Mobile App',
        },
      );
    } catch (e) {
      return ApiResponse<UserAuthResponse>(
        data: UserAuthResponse(
          user: null,
          token: null,
          refreshToken: null,
          expiresAt: null,
        ),
        success: false,
        message: 'خطا در ورود: ${e.toString()}',
        errorCode: 'AUTH_ERROR',
      );
    }
  }

  /// Register new user
  static Future<ApiResponse<UserAuthResponse>> registerUser({
    required String email,
    required String username,
    required String password,
    required String firstName,
    required String lastName,
    String? phoneNumber,
  }) async {
    await _simulateDelay(1200);

    try {
      // Check if email already exists
      if (UserTestData.getUserByEmail(email) != null) {
        return ApiResponse<UserAuthResponse>(
          data: UserAuthResponse(
            user: null,
            token: null,
            refreshToken: null,
            expiresAt: null,
          ),
          success: false,
          message: 'کاربری با این ایمیل قبلاً ثبت‌نام کرده است',
          errorCode: 'EMAIL_EXISTS',
        );
      }

      // Check if username already exists
      if (UserTestData.getUserByUsername(username) != null) {
        return ApiResponse<UserAuthResponse>(
          data: UserAuthResponse(
            user: null,
            token: null,
            refreshToken: null,
            expiresAt: null,
          ),
          success: false,
          message: 'این نام کاربری قبلاً استفاده شده است',
          errorCode: 'USERNAME_EXISTS',
        );
      }

      // Create new user (simplified version)
      final newUser = _createNewUser(
        email: email,
        username: username,
        firstName: firstName,
        lastName: lastName,
        phoneNumber: phoneNumber,
      );

      // Generate tokens
      final token = _generateMockToken();
      final refreshToken = _generateMockToken();
      final expiresAt = DateTime.now().add(Duration(hours: 24));

      return ApiResponse<UserAuthResponse>(
        data: UserAuthResponse(
          user: newUser,
          token: token,
          refreshToken: refreshToken,
          expiresAt: expiresAt,
        ),
        success: true,
        message: 'ثبت‌نام با موفقیت انجام شد',
        metadata: {
          'registrationTime': DateTime.now().toIso8601String(),
          'welcomeBonus': 150,
        },
      );
    } catch (e) {
      return ApiResponse<UserAuthResponse>(
        data: UserAuthResponse(
          user: null,
          token: null,
          refreshToken: null,
          expiresAt: null,
        ),
        success: false,
        message: 'خطا در ثبت‌نام: ${e.toString()}',
        errorCode: 'REGISTRATION_ERROR',
      );
    }
  }

  /// Update user profile
  static Future<ApiResponse<UserModel>> updateUserProfile(
    String userId,
    Map<String, dynamic> updates,
  ) async {
    await _simulateDelay(800);

    try {
      final user = UserTestData.getUserById(userId);

      if (user == null) {
        return ApiResponse<UserModel>(
          data: user!,
          success: false,
          message: 'کاربر مورد نظر یافت نشد',
          errorCode: 'USER_NOT_FOUND',
        );
      }

      // Clean and validate incoming data to prevent null issues
      final cleanedUpdates = DataValidator.cleanData(updates);

      // Validate required fields with defaults
      final validatedUpdates =
          DataValidator.validateRequiredFields(cleanedUpdates, {
            'firstName': user.profile.firstName,
            'lastName': user.profile.lastName,
            'email': user.email,
          });

      // Validate specific field types
      if (validatedUpdates.containsKey('email')) {
        final email = DataValidator.safeString(validatedUpdates['email']);
        if (!DataValidator.isValidEmail(email)) {
          return ApiResponse<UserModel>(
            data: user,
            success: false,
            message: 'فرمت ایمیل صحیح نیست',
            errorCode: 'INVALID_EMAIL',
          );
        }
      }

      if (validatedUpdates.containsKey('firstName')) {
        final firstName = DataValidator.safeString(
          validatedUpdates['firstName'],
        );
        if (!DataValidator.isValidString(firstName, minLength: 2)) {
          return ApiResponse<UserModel>(
            data: user,
            success: false,
            message: 'نام باید حداقل ۲ کاراکتر باشد',
            errorCode: 'INVALID_FIRST_NAME',
          );
        }
      }

      // In a real app, you would update the user data in the database
      // Here we'll just return the existing user as if it was updated

      return ApiResponse<UserModel>(
        data: user,
        success: true,
        message: 'پروفایل کاربر با موفقیت به‌روزرسانی شد',
        metadata: {
          'updatedFields': validatedUpdates.keys.toList(),
          'updateTime': DateTime.now().toIso8601String(),
          'validationPassed': true,
        },
      );
    } catch (e) {
      return ApiResponse<UserModel>(
        data: UserTestData.getUserById(userId)!,
        success: false,
        message: 'خطا در به‌روزرسانی پروفایل: ${e.toString()}',
        errorCode: 'UPDATE_ERROR',
      );
    }
  }

  // Helper methods
  static List<UserModel> _sortUsers(
    List<UserModel> users,
    String sortBy,
    bool descending,
  ) {
    final sortedUsers = List<UserModel>.from(users);

    switch (sortBy.toLowerCase()) {
      case 'name':
        sortedUsers.sort(
          (a, b) => descending
              ? b.profile.displayName.compareTo(a.profile.displayName)
              : a.profile.displayName.compareTo(b.profile.displayName),
        );
        break;
      case 'email':
        sortedUsers.sort(
          (a, b) => descending
              ? b.email.compareTo(a.email)
              : a.email.compareTo(b.email),
        );
        break;
      case 'joindate':
        sortedUsers.sort(
          (a, b) => descending
              ? b.createdAt.compareTo(a.createdAt)
              : a.createdAt.compareTo(b.createdAt),
        );
        break;
      case 'spending':
        sortedUsers.sort(
          (a, b) => descending
              ? b.orders.totalSpent.compareTo(a.orders.totalSpent)
              : a.orders.totalSpent.compareTo(b.orders.totalSpent),
        );
        break;
      case 'orders':
        sortedUsers.sort(
          (a, b) => descending
              ? b.orders.totalOrders.compareTo(a.orders.totalOrders)
              : a.orders.totalOrders.compareTo(b.orders.totalOrders),
        );
        break;
      case 'points':
        sortedUsers.sort(
          (a, b) => descending
              ? b.loyalty.currentPoints.compareTo(a.loyalty.currentPoints)
              : a.loyalty.currentPoints.compareTo(b.loyalty.currentPoints),
        );
        break;
      default:
        // Default sort by name
        sortedUsers.sort(
          (a, b) => descending
              ? b.profile.displayName.compareTo(a.profile.displayName)
              : a.profile.displayName.compareTo(b.profile.displayName),
        );
        break;
    }

    return sortedUsers;
  }

  static String _generateMockToken() {
    final now = DateTime.now().millisecondsSinceEpoch;
    final random = (now % 1000000).toString().padLeft(6, '0');
    return 'mock_token_$random';
  }

  static UserModel _createNewUser({
    required String email,
    required String username,
    required String firstName,
    required String lastName,
    String? phoneNumber,
  }) {
    final now = DateTime.now();
    final userId = 'user_${now.millisecondsSinceEpoch}';

    return UserModel(
      id: userId,
      email: email,
      username: username,
      profile: UserProfile(
        firstName: firstName,
        lastName: lastName,
        displayName: '$firstName $lastName',
        avatar: 'https://i.pravatar.cc/300?u=$userId',
        phoneNumber: phoneNumber,
        socialMedia: UserSocialMedia(),
        interests: [],
        language: 'fa',
        timezone: 'Asia/Tehran',
        country: 'ایران',
      ),
      account: UserAccount(
        accountType: 'basic',
        memberSince: now,
        walletBalance: 0,
        creditBalance: 0,
        loyaltyPoints: 150, // Welcome bonus
        accountStatus: 'active',
        verification: UserVerification(
          emailVerified: false,
          phoneVerified: false,
          identityVerified: false,
        ),
      ),
      preferences: UserPreferences(
        currency: 'تومان',
        language: 'fa',
        theme: 'system',
        emailNotifications: true,
        pushNotifications: true,
        smsNotifications: false,
        favoriteCategories: [],
        favoriteBrands: [],
        priceRange: 'budget',
        personalizedRecommendations: false,
        privacy: UserPrivacySettings(
          profileVisible: true,
          showPurchaseHistory: false,
          showWishlist: false,
          allowDataCollection: false,
          allowTargetedAds: false,
        ),
      ),
      activity: UserActivity(
        lastLoginAt: now,
        totalLogins: 1,
        totalOrders: 0,
        totalSpent: 0,
        totalReviews: 0,
        totalWishlistItems: 0,
        recentlyViewedProducts: [],
        searchHistory: [],
        browsingHistory: UserBrowsingHistory(
          categoryViews: {},
          brandViews: {},
          productViews: {},
          totalPageViews: 0,
          averageSessionDuration: 0,
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
            id: 'welcome_$userId',
            type: 'earned',
            points: 150,
            source: 'signup',
            createdAt: now,
            description: 'امتیاز عضویت در سایت',
          ),
        ],
        earningSources: {'signup': 150},
      ),
      security: UserSecurity(
        twoFactorEnabled: false,
        lastPasswordChange: now,
        activeSessions: [],
        recentSecurityEvents: [
          SecurityEvent(
            id: 'signup_$userId',
            type: 'signup',
            description: 'ثبت‌نام در سایت',
            createdAt: now,
            status: 'success',
          ),
        ],
      ),
      notifications: UserNotifications(
        notifications: [
          UserNotification(
            id: 'welcome_$userId',
            type: 'system',
            title: 'خوش آمدید!',
            message: 'به فروشگاه سینا خوش آمدید. امتیاز عضویت شما اعمال شد.',
            isRead: false,
            createdAt: now,
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
        productIds: [],
        totalCount: 0,
        lastUpdated: now,
        addedDates: {},
      ),
      orders: UserOrders(
        totalOrders: 0,
        totalSpent: 0,
        recentOrderIds: [],
        ordersByStatus: {},
        favoriteCategory: '',
        favoriteBrand: '',
      ),
      reviews: UserReviews(
        totalReviews: 0,
        averageRating: 0.0,
        recentReviewIds: [],
        helpfulVotes: 0,
        verifiedReviews: 0,
      ),
      createdAt: now,
      lastLoginAt: now,
      updatedAt: now,
      isActive: true,
      isVerified: false,
      isPremium: false,
    );
  }
}

/// User authentication response
class UserAuthResponse {
  final UserModel? user;
  final String? token;
  final String? refreshToken;
  final DateTime? expiresAt;

  UserAuthResponse({
    required this.user,
    required this.token,
    required this.refreshToken,
    required this.expiresAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'user': user?.toJson(),
      'token': token,
      'refreshToken': refreshToken,
      'expiresAt': expiresAt?.toIso8601String(),
    };
  }
}
