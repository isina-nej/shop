class UserModel {
  final String id;
  final String email;
  final String username;
  final UserProfile profile;
  final UserAccount account;
  final UserPreferences preferences;
  final UserActivity activity;
  final UserLoyalty loyalty;
  final UserSecurity security;
  final UserNotifications notifications;
  final UserShippingAddresses shippingAddresses;
  final UserPaymentMethods paymentMethods;
  final UserWishlist wishlist;
  final UserOrders orders;
  final UserReviews reviews;
  final DateTime createdAt;
  final DateTime lastLoginAt;
  final DateTime updatedAt;
  final bool isActive;
  final bool isVerified;
  final bool isPremium;

  const UserModel({
    required this.id,
    required this.email,
    required this.username,
    required this.profile,
    required this.account,
    required this.preferences,
    required this.activity,
    required this.loyalty,
    required this.security,
    required this.notifications,
    required this.shippingAddresses,
    required this.paymentMethods,
    required this.wishlist,
    required this.orders,
    required this.reviews,
    required this.createdAt,
    required this.lastLoginAt,
    required this.updatedAt,
    required this.isActive,
    required this.isVerified,
    required this.isPremium,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'username': username,
      'profile': profile.toJson(),
      'account': account.toJson(),
      'preferences': preferences.toJson(),
      'activity': activity.toJson(),
      'loyalty': loyalty.toJson(),
      'security': security.toJson(),
      'notifications': notifications.toJson(),
      'shippingAddresses': shippingAddresses.toJson(),
      'paymentMethods': paymentMethods.toJson(),
      'wishlist': wishlist.toJson(),
      'orders': orders.toJson(),
      'reviews': reviews.toJson(),
      'createdAt': createdAt.toIso8601String(),
      'lastLoginAt': lastLoginAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'isActive': isActive,
      'isVerified': isVerified,
      'isPremium': isPremium,
    };
  }
}

class UserProfile {
  final String firstName;
  final String lastName;
  final String? middleName;
  final String displayName;
  final String? avatar;
  final String? phoneNumber;
  final DateTime? dateOfBirth;
  final String? gender;
  final String? bio;
  final String? website;
  final UserSocialMedia socialMedia;
  final String? occupation;
  final String? company;
  final List<String> interests;
  final String? language;
  final String? timezone;
  final String? country;
  final String? city;

  const UserProfile({
    required this.firstName,
    required this.lastName,
    this.middleName,
    required this.displayName,
    this.avatar,
    this.phoneNumber,
    this.dateOfBirth,
    this.gender,
    this.bio,
    this.website,
    required this.socialMedia,
    this.occupation,
    this.company,
    required this.interests,
    this.language,
    this.timezone,
    this.country,
    this.city,
  });

  String get fullName => middleName != null
      ? '$firstName $middleName $lastName'
      : '$firstName $lastName';

  Map<String, dynamic> toJson() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'middleName': middleName,
      'displayName': displayName,
      'avatar': avatar,
      'phoneNumber': phoneNumber,
      'dateOfBirth': dateOfBirth?.toIso8601String(),
      'gender': gender,
      'bio': bio,
      'website': website,
      'socialMedia': socialMedia.toJson(),
      'occupation': occupation,
      'company': company,
      'interests': interests,
      'language': language,
      'timezone': timezone,
      'country': country,
      'city': city,
    };
  }
}

class UserSocialMedia {
  final String? instagram;
  final String? telegram;
  final String? whatsapp;
  final String? twitter;
  final String? facebook;
  final String? linkedin;

  const UserSocialMedia({
    this.instagram,
    this.telegram,
    this.whatsapp,
    this.twitter,
    this.facebook,
    this.linkedin,
  });

  Map<String, dynamic> toJson() {
    return {
      'instagram': instagram,
      'telegram': telegram,
      'whatsapp': whatsapp,
      'twitter': twitter,
      'facebook': facebook,
      'linkedin': linkedin,
    };
  }
}

class UserAccount {
  final String accountType; // basic, premium, vip
  final DateTime memberSince;
  final UserSubscription? subscription;
  final double walletBalance;
  final double creditBalance;
  final int loyaltyPoints;
  final String accountStatus; // active, suspended, pending
  final UserVerification verification;

  const UserAccount({
    required this.accountType,
    required this.memberSince,
    this.subscription,
    required this.walletBalance,
    required this.creditBalance,
    required this.loyaltyPoints,
    required this.accountStatus,
    required this.verification,
  });

  Map<String, dynamic> toJson() {
    return {
      'accountType': accountType,
      'memberSince': memberSince.toIso8601String(),
      'subscription': subscription?.toJson(),
      'walletBalance': walletBalance,
      'creditBalance': creditBalance,
      'loyaltyPoints': loyaltyPoints,
      'accountStatus': accountStatus,
      'verification': verification.toJson(),
    };
  }
}

class UserSubscription {
  final String plan; // basic, premium, vip
  final DateTime startDate;
  final DateTime endDate;
  final bool isActive;
  final double monthlyFee;
  final List<String> benefits;

  const UserSubscription({
    required this.plan,
    required this.startDate,
    required this.endDate,
    required this.isActive,
    required this.monthlyFee,
    required this.benefits,
  });

  Map<String, dynamic> toJson() {
    return {
      'plan': plan,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'isActive': isActive,
      'monthlyFee': monthlyFee,
      'benefits': benefits,
    };
  }
}

class UserVerification {
  final bool emailVerified;
  final bool phoneVerified;
  final bool identityVerified;
  final DateTime? emailVerifiedAt;
  final DateTime? phoneVerifiedAt;
  final DateTime? identityVerifiedAt;

  const UserVerification({
    required this.emailVerified,
    required this.phoneVerified,
    required this.identityVerified,
    this.emailVerifiedAt,
    this.phoneVerifiedAt,
    this.identityVerifiedAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'emailVerified': emailVerified,
      'phoneVerified': phoneVerified,
      'identityVerified': identityVerified,
      'emailVerifiedAt': emailVerifiedAt?.toIso8601String(),
      'phoneVerifiedAt': phoneVerifiedAt?.toIso8601String(),
      'identityVerifiedAt': identityVerifiedAt?.toIso8601String(),
    };
  }
}

class UserPreferences {
  final String currency;
  final String language;
  final String theme; // light, dark, system
  final bool emailNotifications;
  final bool pushNotifications;
  final bool smsNotifications;
  final List<String> favoriteCategories;
  final List<String> favoriteBrands;
  final String priceRange; // budget, mid-range, premium
  final bool personalizedRecommendations;
  final UserPrivacySettings privacy;

  const UserPreferences({
    required this.currency,
    required this.language,
    required this.theme,
    required this.emailNotifications,
    required this.pushNotifications,
    required this.smsNotifications,
    required this.favoriteCategories,
    required this.favoriteBrands,
    required this.priceRange,
    required this.personalizedRecommendations,
    required this.privacy,
  });

  Map<String, dynamic> toJson() {
    return {
      'currency': currency,
      'language': language,
      'theme': theme,
      'emailNotifications': emailNotifications,
      'pushNotifications': pushNotifications,
      'smsNotifications': smsNotifications,
      'favoriteCategories': favoriteCategories,
      'favoriteBrands': favoriteBrands,
      'priceRange': priceRange,
      'personalizedRecommendations': personalizedRecommendations,
      'privacy': privacy.toJson(),
    };
  }
}

class UserPrivacySettings {
  final bool profileVisible;
  final bool showPurchaseHistory;
  final bool showWishlist;
  final bool allowDataCollection;
  final bool allowTargetedAds;

  const UserPrivacySettings({
    required this.profileVisible,
    required this.showPurchaseHistory,
    required this.showWishlist,
    required this.allowDataCollection,
    required this.allowTargetedAds,
  });

  Map<String, dynamic> toJson() {
    return {
      'profileVisible': profileVisible,
      'showPurchaseHistory': showPurchaseHistory,
      'showWishlist': showWishlist,
      'allowDataCollection': allowDataCollection,
      'allowTargetedAds': allowTargetedAds,
    };
  }
}

class UserActivity {
  final DateTime lastLoginAt;
  final int totalLogins;
  final int totalOrders;
  final double totalSpent;
  final int totalReviews;
  final int totalWishlistItems;
  final List<String> recentlyViewedProducts;
  final List<String> searchHistory;
  final UserBrowsingHistory browsingHistory;

  const UserActivity({
    required this.lastLoginAt,
    required this.totalLogins,
    required this.totalOrders,
    required this.totalSpent,
    required this.totalReviews,
    required this.totalWishlistItems,
    required this.recentlyViewedProducts,
    required this.searchHistory,
    required this.browsingHistory,
  });

  Map<String, dynamic> toJson() {
    return {
      'lastLoginAt': lastLoginAt.toIso8601String(),
      'totalLogins': totalLogins,
      'totalOrders': totalOrders,
      'totalSpent': totalSpent,
      'totalReviews': totalReviews,
      'totalWishlistItems': totalWishlistItems,
      'recentlyViewedProducts': recentlyViewedProducts,
      'searchHistory': searchHistory,
      'browsingHistory': browsingHistory.toJson(),
    };
  }
}

class UserBrowsingHistory {
  final Map<String, int> categoryViews; // categoryId => count
  final Map<String, int> brandViews; // brandId => count
  final Map<String, DateTime> productViews; // productId => lastViewed
  final int totalPageViews;
  final double averageSessionDuration;

  const UserBrowsingHistory({
    required this.categoryViews,
    required this.brandViews,
    required this.productViews,
    required this.totalPageViews,
    required this.averageSessionDuration,
  });

  Map<String, dynamic> toJson() {
    return {
      'categoryViews': categoryViews,
      'brandViews': brandViews,
      'productViews': productViews.map(
        (key, value) => MapEntry(key, value.toIso8601String()),
      ),
      'totalPageViews': totalPageViews,
      'averageSessionDuration': averageSessionDuration,
    };
  }
}

class UserLoyalty {
  final int currentPoints;
  final int totalEarned;
  final int totalSpent;
  final String tier; // bronze, silver, gold, platinum
  final int pointsToNextTier;
  final List<LoyaltyTransaction> recentTransactions;
  final Map<String, int> earningSources; // purchase, review, referral => points

  const UserLoyalty({
    required this.currentPoints,
    required this.totalEarned,
    required this.totalSpent,
    required this.tier,
    required this.pointsToNextTier,
    required this.recentTransactions,
    required this.earningSources,
  });

  Map<String, dynamic> toJson() {
    return {
      'currentPoints': currentPoints,
      'totalEarned': totalEarned,
      'totalSpent': totalSpent,
      'tier': tier,
      'pointsToNextTier': pointsToNextTier,
      'recentTransactions': recentTransactions
          .map((tx) => tx.toJson())
          .toList(),
      'earningSources': earningSources,
    };
  }
}

class LoyaltyTransaction {
  final String id;
  final String type; // earned, spent
  final int points;
  final String source; // purchase, review, referral, redemption
  final String? orderId;
  final DateTime createdAt;
  final String description;

  const LoyaltyTransaction({
    required this.id,
    required this.type,
    required this.points,
    required this.source,
    this.orderId,
    required this.createdAt,
    required this.description,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'points': points,
      'source': source,
      'orderId': orderId,
      'createdAt': createdAt.toIso8601String(),
      'description': description,
    };
  }
}

class UserSecurity {
  final bool twoFactorEnabled;
  final String? twoFactorMethod; // sms, email, app
  final DateTime lastPasswordChange;
  final List<UserSession> activeSessions;
  final List<SecurityEvent> recentSecurityEvents;

  const UserSecurity({
    required this.twoFactorEnabled,
    this.twoFactorMethod,
    required this.lastPasswordChange,
    required this.activeSessions,
    required this.recentSecurityEvents,
  });

  Map<String, dynamic> toJson() {
    return {
      'twoFactorEnabled': twoFactorEnabled,
      'twoFactorMethod': twoFactorMethod,
      'lastPasswordChange': lastPasswordChange.toIso8601String(),
      'activeSessions': activeSessions
          .map((session) => session.toJson())
          .toList(),
      'recentSecurityEvents': recentSecurityEvents
          .map((event) => event.toJson())
          .toList(),
    };
  }
}

class UserSession {
  final String id;
  final String deviceInfo;
  final String location;
  final String ipAddress;
  final DateTime createdAt;
  final DateTime lastActivityAt;
  final bool isCurrent;

  const UserSession({
    required this.id,
    required this.deviceInfo,
    required this.location,
    required this.ipAddress,
    required this.createdAt,
    required this.lastActivityAt,
    required this.isCurrent,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'deviceInfo': deviceInfo,
      'location': location,
      'ipAddress': ipAddress,
      'createdAt': createdAt.toIso8601String(),
      'lastActivityAt': lastActivityAt.toIso8601String(),
      'isCurrent': isCurrent,
    };
  }
}

class SecurityEvent {
  final String id;
  final String type; // login, password_change, 2fa_enabled, etc.
  final String description;
  final String? ipAddress;
  final String? deviceInfo;
  final DateTime createdAt;
  final String status; // success, failed, blocked

  const SecurityEvent({
    required this.id,
    required this.type,
    required this.description,
    this.ipAddress,
    this.deviceInfo,
    required this.createdAt,
    required this.status,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'description': description,
      'ipAddress': ipAddress,
      'deviceInfo': deviceInfo,
      'createdAt': createdAt.toIso8601String(),
      'status': status,
    };
  }
}

class UserNotifications {
  final List<UserNotification> notifications;
  final int unreadCount;
  final UserNotificationSettings settings;

  const UserNotifications({
    required this.notifications,
    required this.unreadCount,
    required this.settings,
  });

  Map<String, dynamic> toJson() {
    return {
      'notifications': notifications
          .map((notification) => notification.toJson())
          .toList(),
      'unreadCount': unreadCount,
      'settings': settings.toJson(),
    };
  }
}

class UserNotification {
  final String id;
  final String type; // order, promotion, system, review
  final String title;
  final String message;
  final bool isRead;
  final DateTime createdAt;
  final String? actionUrl;
  final Map<String, dynamic>? data;

  const UserNotification({
    required this.id,
    required this.type,
    required this.title,
    required this.message,
    required this.isRead,
    required this.createdAt,
    this.actionUrl,
    this.data,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'title': title,
      'message': message,
      'isRead': isRead,
      'createdAt': createdAt.toIso8601String(),
      'actionUrl': actionUrl,
      'data': data,
    };
  }
}

class UserNotificationSettings {
  final bool orderUpdates;
  final bool promotionalEmails;
  final bool newArrivals;
  final bool priceDropAlerts;
  final bool backInStockAlerts;
  final bool reviewReminders;
  final bool loyaltyUpdates;

  const UserNotificationSettings({
    required this.orderUpdates,
    required this.promotionalEmails,
    required this.newArrivals,
    required this.priceDropAlerts,
    required this.backInStockAlerts,
    required this.reviewReminders,
    required this.loyaltyUpdates,
  });

  Map<String, dynamic> toJson() {
    return {
      'orderUpdates': orderUpdates,
      'promotionalEmails': promotionalEmails,
      'newArrivals': newArrivals,
      'priceDropAlerts': priceDropAlerts,
      'backInStockAlerts': backInStockAlerts,
      'reviewReminders': reviewReminders,
      'loyaltyUpdates': loyaltyUpdates,
    };
  }
}

class UserShippingAddresses {
  final List<ShippingAddress> addresses;
  final String? defaultAddressId;

  const UserShippingAddresses({required this.addresses, this.defaultAddressId});

  Map<String, dynamic> toJson() {
    return {
      'addresses': addresses.map((address) => address.toJson()).toList(),
      'defaultAddressId': defaultAddressId,
    };
  }
}

class ShippingAddress {
  final String id;
  final String label; // home, work, other
  final String fullName;
  final String phoneNumber;
  final String country;
  final String state;
  final String city;
  final String streetAddress;
  final String? apartmentNumber;
  final String postalCode;
  final bool isDefault;
  final String? specialInstructions;

  const ShippingAddress({
    required this.id,
    required this.label,
    required this.fullName,
    required this.phoneNumber,
    required this.country,
    required this.state,
    required this.city,
    required this.streetAddress,
    this.apartmentNumber,
    required this.postalCode,
    required this.isDefault,
    this.specialInstructions,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'label': label,
      'fullName': fullName,
      'phoneNumber': phoneNumber,
      'country': country,
      'state': state,
      'city': city,
      'streetAddress': streetAddress,
      'apartmentNumber': apartmentNumber,
      'postalCode': postalCode,
      'isDefault': isDefault,
      'specialInstructions': specialInstructions,
    };
  }
}

class UserPaymentMethods {
  final List<PaymentMethod> methods;
  final String? defaultMethodId;

  const UserPaymentMethods({required this.methods, this.defaultMethodId});

  Map<String, dynamic> toJson() {
    return {
      'methods': methods.map((method) => method.toJson()).toList(),
      'defaultMethodId': defaultMethodId,
    };
  }
}

class PaymentMethod {
  final String id;
  final String type; // card, wallet, bank_transfer
  final String name;
  final String? last4Digits;
  final String? bankName;
  final String? cardType; // visa, mastercard, etc.
  final bool isDefault;
  final bool isVerified;
  final DateTime createdAt;

  const PaymentMethod({
    required this.id,
    required this.type,
    required this.name,
    this.last4Digits,
    this.bankName,
    this.cardType,
    required this.isDefault,
    required this.isVerified,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'name': name,
      'last4Digits': last4Digits,
      'bankName': bankName,
      'cardType': cardType,
      'isDefault': isDefault,
      'isVerified': isVerified,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}

class UserWishlist {
  final List<String> productIds;
  final int totalCount;
  final DateTime lastUpdated;
  final Map<String, DateTime> addedDates; // productId => addedAt

  const UserWishlist({
    required this.productIds,
    required this.totalCount,
    required this.lastUpdated,
    required this.addedDates,
  });

  Map<String, dynamic> toJson() {
    return {
      'productIds': productIds,
      'totalCount': totalCount,
      'lastUpdated': lastUpdated.toIso8601String(),
      'addedDates': addedDates.map(
        (key, value) => MapEntry(key, value.toIso8601String()),
      ),
    };
  }
}

class UserOrders {
  final int totalOrders;
  final double totalSpent;
  final List<String> recentOrderIds;
  final Map<String, int> ordersByStatus; // status => count
  final String favoriteCategory;
  final String favoriteBrand;

  const UserOrders({
    required this.totalOrders,
    required this.totalSpent,
    required this.recentOrderIds,
    required this.ordersByStatus,
    required this.favoriteCategory,
    required this.favoriteBrand,
  });

  Map<String, dynamic> toJson() {
    return {
      'totalOrders': totalOrders,
      'totalSpent': totalSpent,
      'recentOrderIds': recentOrderIds,
      'ordersByStatus': ordersByStatus,
      'favoriteCategory': favoriteCategory,
      'favoriteBrand': favoriteBrand,
    };
  }
}

class UserReviews {
  final int totalReviews;
  final double averageRating;
  final List<String> recentReviewIds;
  final int helpfulVotes;
  final int verifiedReviews;

  const UserReviews({
    required this.totalReviews,
    required this.averageRating,
    required this.recentReviewIds,
    required this.helpfulVotes,
    required this.verifiedReviews,
  });

  Map<String, dynamic> toJson() {
    return {
      'totalReviews': totalReviews,
      'averageRating': averageRating,
      'recentReviewIds': recentReviewIds,
      'helpfulVotes': helpfulVotes,
      'verifiedReviews': verifiedReviews,
    };
  }
}
