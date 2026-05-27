import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'sign_up_response_model.g.dart';

@HiveType(typeId: 1)
@JsonSerializable()
class SignUpResponseModel {
  SignUpResponseModel({
    this.firstName,
    this.lastName,
    this.email,
    this.countryCode,
    this.phoneNumber,
    this.userType,
    this.loginType,
    this.businessName,
    this.profilePicture,
    this.address,
    this.latitude,
    this.longitude,
    this.isProfile,
    this.isApproved,
    this.isSubscription,
    this.userId,
    this.token,
    this.deviceType,
    this.deviceToken,
    this.uuid,
    this.osVersion,
    this.deviceName,
    this.modelName,
    this.ip,
    this.referralCode,
    this.totalReferrals,
  });

  factory SignUpResponseModel.fromJson(Map<String, dynamic> json) =>
      _$SignUpResponseModelFromJson(json);
  @HiveField(0)
  @JsonKey(name: 'first_name')
  final String? firstName;

  @HiveField(1)
  @JsonKey(name: 'last_name')
  final String? lastName;

  @HiveField(2)
  @JsonKey(name: 'email')
  final String? email;

  @HiveField(3)
  @JsonKey(name: 'country_code')
  final String? countryCode;

  @HiveField(4)
  @JsonKey(name: 'phone_number')
  final int? phoneNumber;

  @HiveField(5)
  @JsonKey(name: 'user_type')
  final String? userType;

  @HiveField(6)
  @JsonKey(name: 'login_type')
  final String? loginType;

  @HiveField(7)
  @JsonKey(name: 'business_name')
  dynamic businessName;

  @HiveField(8)
  @JsonKey(name: 'profile_picture')
  final String? profilePicture;

  @HiveField(9)
  @JsonKey(name: 'address')
  final dynamic address;

  @HiveField(10)
  @JsonKey(name: 'latitude')
  final dynamic latitude;

  @HiveField(11)
  @JsonKey(name: 'longitude')
  final dynamic longitude;

  @HiveField(12)
  @JsonKey(name: 'is_profile')
  final String? isProfile;

  @HiveField(13)
  @JsonKey(name: 'is_approved')
  final String? isApproved;

  @HiveField(14)
  @JsonKey(name: 'is_subscription')
  final String? isSubscription;

  @HiveField(15)
  @JsonKey(name: 'user_id')
  final String? userId;

  @HiveField(16)
  @JsonKey(name: 'token')
  final String? token;

  @HiveField(17)
  @JsonKey(name: 'device_type')
  final String? deviceType;

  @HiveField(18)
  @JsonKey(name: 'device_token')
  final String? deviceToken;

  @HiveField(19)
  @JsonKey(name: 'uuid')
  final String? uuid;

  @HiveField(20)
  @JsonKey(name: 'os_version')
  final String? osVersion;

  @HiveField(21)
  @JsonKey(name: 'device_name')
  final String? deviceName;

  @HiveField(22)
  @JsonKey(name: 'model_name')
  final String? modelName;

  @HiveField(23)
  @JsonKey(name: 'ip')
  final String? ip;

  @HiveField(38)
  @JsonKey(name: 'referral_code')
  final String? referralCode;

  @HiveField(39)
  @JsonKey(name: 'total_referrals')
  final String? totalReferrals;

  Map<String, dynamic> toJson() => _$SignUpResponseModelToJson(this);
}
