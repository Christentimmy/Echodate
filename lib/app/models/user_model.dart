import 'dart:convert';

class UserModel {
  final String? id;
  final String? fullName;
  final String? email;
  final String? phoneNumber;
  final String? avatar;
  final String? bio;
  final List<String>? photos;
  final List<String>? hobbies;
  final String? status;
  final bool? profileCompleted;
  final bool? isEmailVerified;
  final bool? isPhoneNumberVerified;
  final bool? isPremium;
  final DateTime? lastActive;
  final String? gender;
  final String? interestedIn;
  final String? relationshipPreference;
  bool? weekendAvailability;
  final int? echocoinsBalance;
  final String? oneSignalId;
  final List<dynamic>? transactions;
  final String? recipientCode;
  final String? plan;
  final int? dailySwipes;
  final int? dailyMessages;
  final Preferences? preferences;
  final Location? location;
  final String? dob;
  final int? matchPercentage;
  final DateTime? createdAt;
  final bool? isVerified;
  String? password;
  String? otpCode;

  UserModel({
    this.id,
    this.fullName,
    this.email,
    this.phoneNumber,
    this.avatar,
    this.bio,
    this.photos,
    this.hobbies,
    this.status,
    this.profileCompleted,
    this.isEmailVerified,
    this.isPhoneNumberVerified,
    this.isPremium,
    this.lastActive,
    this.gender,
    this.interestedIn,
    this.relationshipPreference,
    this.weekendAvailability,
    this.echocoinsBalance,
    this.oneSignalId,
    this.transactions,
    this.recipientCode,
    this.plan,
    this.dailySwipes,
    this.dailyMessages,
    this.preferences,
    this.location,
    this.dob,
    this.matchPercentage,
    this.password,
    this.createdAt,
    this.otpCode,
    this.isVerified,
  });

  factory UserModel.fromJson(json) {
    return UserModel(
      id: json['_id'] ?? "",
      fullName: json['full_name'] ?? "",
      email: json['email'] as String?,
      phoneNumber: json['phone_number'] ?? "",
      avatar: json['avatar'] as String?,
      bio: json['bio'] ?? "",
      photos: (json['photos'] as List<dynamic>?)
              ?.map((e) => e?.toString() ?? '')
              .toList() ??
          [],
      hobbies: (json['hobbies'] as List<dynamic>?)
          ?.map((e) => e?.toString() ?? "")
          .toList(),
      status: json['status'] ?? "",
      profileCompleted: json['profile_completed'] ?? false,
      isEmailVerified: json['is_email_verified'] ?? false,
      isVerified: json['isVerified'] ?? false,
      isPhoneNumberVerified: json['is_phone_number_verified'] ?? false,
      isPremium: json['is_premium'] ?? false,
      lastActive: json['last_active'] != null
          ? DateTime.tryParse(json['last_active'])
          : null,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'])
          : null,
      gender: json['gender'] ?? "",
      interestedIn: json['interested_in'] ?? "",
      relationshipPreference: json['relationship_preference'] ?? "",
      weekendAvailability: json['weekend_availability'] ?? false,
      echocoinsBalance: (json['echocoins_balance'] as num?)?.toInt() ?? 0,
      oneSignalId: json['one_signal_id'] ?? "",
      transactions: json['transactions'] ?? [],
      recipientCode: json['recipient_code'] ?? "",
      plan: json['plan'] as String?,
      dailySwipes: json['daily_swipes'] ?? 0,
      dailyMessages: json['daily_messages'] ?? 0,
      preferences: json['preferences'] != null
          ? Preferences.fromJson(json['preferences'])
          : null,
      location:
          json['location'] != null ? Location.fromJson(json['location']) : null,
      dob: json['date_of_birth'] ?? "",
      matchPercentage: (json['matchPercentage'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (id != null) data['_id'] = id;
    if (otpCode != null && otpCode!.isNotEmpty) data["otp"] = otpCode;
    if (fullName != null && fullName!.isNotEmpty) data['full_name'] = fullName;
    if (email != null && email!.isNotEmpty) data['email'] = email;
    if (phoneNumber != null && phoneNumber!.isNotEmpty) {
      data['phone_number'] = phoneNumber;
    }
    if (avatar != null && avatar!.isNotEmpty) data['avatar'] = avatar;
    if (bio != null && bio!.isNotEmpty) data['bio'] = bio;
    if (photos != null && photos!.isNotEmpty) data['photos'] = photos;
    if (hobbies != null && hobbies!.isNotEmpty) data['hobbies'] = hobbies;
    if (status != null && status!.isNotEmpty) data['status'] = status;
    if (profileCompleted != null) data['profile_completed'] = profileCompleted;
    if (isPremium != null) data['is_premium'] = isPremium;
    if (lastActive != null) data['last_active'] = lastActive!.toIso8601String();
    if (gender != null && gender!.isNotEmpty) data['gender'] = gender;
    if (interestedIn != null && interestedIn!.isNotEmpty) {
      data['interested_in'] = interestedIn;
    }
    if (relationshipPreference != null && relationshipPreference!.isNotEmpty) {
      data['relationship_preference'] = relationshipPreference;
    }
    if (weekendAvailability != null) {
      data['weekend_availability'] = weekendAvailability;
    }
    if (echocoinsBalance != null) data['echocoins_balance'] = echocoinsBalance;
    if (oneSignalId != null && oneSignalId!.isNotEmpty) {
      data['one_signal_id'] = oneSignalId;
    }
    if (transactions != null && transactions!.isNotEmpty) {
      data['transactions'] = transactions;
    }
    if (recipientCode != null && recipientCode!.isNotEmpty) {
      data['recipient_code'] = recipientCode;
    }
    if (plan != null && plan!.isNotEmpty) data['plan'] = plan;
    if (dailySwipes != null) data['daily_swipes'] = dailySwipes;
    if (dailyMessages != null) data['daily_messages'] = dailyMessages;
    if (preferences != null) data['preferences'] = preferences!.toJson();
    if (location != null) data['location'] = location!.toJson();
    if (dob != null && dob!.isNotEmpty) data['dob'] = dob;
    if (password != null && password!.isNotEmpty) data['password'] = password;

    return data;
  }

  @override
  String toString() {
    return jsonEncode(toJson());
  }
}

class Preferences {
  final List<int>? ageRange;
  final int? maxDistance;

  Preferences({this.ageRange, this.maxDistance});

  factory Preferences.fromJson(json) {
    return Preferences(
      ageRange:
          (json['ageRange'] as List<dynamic>?)?.map((e) => e as int).toList(),
      maxDistance: json['maxDistance'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (ageRange != null && ageRange!.isNotEmpty) data['ageRange'] = ageRange;
    if (maxDistance != null) data['maxDistance'] = maxDistance;
    return data;
  }

  @override
  String toString() {
    return jsonEncode(toJson());
  }
}

class Location {
  final String? address;
  final List<double>? coordinates;

  Location({this.address, this.coordinates});

  factory Location.fromJson(json) {
    return Location(
      address: json['address'] ?? "",
      coordinates: (json['coordinates'] as List<dynamic>?)
          ?.map((e) => (e as num).toDouble())
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (address != null && address!.isNotEmpty) data['address'] = address;
    if (coordinates != null && coordinates!.isNotEmpty) {
      data['coordinates'] = coordinates;
    }
    return data;
  }

  @override
  String toString() {
    return jsonEncode(toJson());
  }
}
