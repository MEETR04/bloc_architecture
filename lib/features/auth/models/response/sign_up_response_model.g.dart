// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sign_up_response_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SignUpResponseModelAdapter extends TypeAdapter<SignUpResponseModel> {
  @override
  final int typeId = 1;

  @override
  SignUpResponseModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SignUpResponseModel(
      firstName: fields[0] as String?,
      lastName: fields[1] as String?,
      email: fields[2] as String?,
      countryCode: fields[3] as String?,
      phoneNumber: fields[4] as int?,
      userType: fields[5] as String?,
      loginType: fields[6] as String?,
      businessName: fields[7] as dynamic,
      profilePicture: fields[8] as String?,
      address: fields[9] as dynamic,
      latitude: fields[10] as dynamic,
      longitude: fields[11] as dynamic,
      isProfile: fields[12] as String?,
      isApproved: fields[13] as String?,
      isSubscription: fields[14] as String?,
      userId: fields[15] as String?,
      token: fields[16] as String?,
      deviceType: fields[17] as String?,
      deviceToken: fields[18] as String?,
      uuid: fields[19] as String?,
      osVersion: fields[20] as String?,
      deviceName: fields[21] as String?,
      modelName: fields[22] as String?,
      ip: fields[23] as String?,
      referralCode: fields[38] as String?,
      totalReferrals: fields[39] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, SignUpResponseModel obj) {
    writer
      ..writeByte(26)
      ..writeByte(0)
      ..write(obj.firstName)
      ..writeByte(1)
      ..write(obj.lastName)
      ..writeByte(2)
      ..write(obj.email)
      ..writeByte(3)
      ..write(obj.countryCode)
      ..writeByte(4)
      ..write(obj.phoneNumber)
      ..writeByte(5)
      ..write(obj.userType)
      ..writeByte(6)
      ..write(obj.loginType)
      ..writeByte(7)
      ..write(obj.businessName)
      ..writeByte(8)
      ..write(obj.profilePicture)
      ..writeByte(9)
      ..write(obj.address)
      ..writeByte(10)
      ..write(obj.latitude)
      ..writeByte(11)
      ..write(obj.longitude)
      ..writeByte(12)
      ..write(obj.isProfile)
      ..writeByte(13)
      ..write(obj.isApproved)
      ..writeByte(14)
      ..write(obj.isSubscription)
      ..writeByte(15)
      ..write(obj.userId)
      ..writeByte(16)
      ..write(obj.token)
      ..writeByte(17)
      ..write(obj.deviceType)
      ..writeByte(18)
      ..write(obj.deviceToken)
      ..writeByte(19)
      ..write(obj.uuid)
      ..writeByte(20)
      ..write(obj.osVersion)
      ..writeByte(21)
      ..write(obj.deviceName)
      ..writeByte(22)
      ..write(obj.modelName)
      ..writeByte(23)
      ..write(obj.ip)
      ..writeByte(38)
      ..write(obj.referralCode)
      ..writeByte(39)
      ..write(obj.totalReferrals);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SignUpResponseModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SignUpResponseModel _$SignUpResponseModelFromJson(Map<String, dynamic> json) =>
    SignUpResponseModel(
      firstName: json['first_name'] as String?,
      lastName: json['last_name'] as String?,
      email: json['email'] as String?,
      countryCode: json['country_code'] as String?,
      phoneNumber: (json['phone_number'] as num?)?.toInt(),
      userType: json['user_type'] as String?,
      loginType: json['login_type'] as String?,
      businessName: json['business_name'],
      profilePicture: json['profile_picture'] as String?,
      address: json['address'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      isProfile: json['is_profile'] as String?,
      isApproved: json['is_approved'] as String?,
      isSubscription: json['is_subscription'] as String?,
      userId: json['user_id'] as String?,
      token: json['token'] as String?,
      deviceType: json['device_type'] as String?,
      deviceToken: json['device_token'] as String?,
      uuid: json['uuid'] as String?,
      osVersion: json['os_version'] as String?,
      deviceName: json['device_name'] as String?,
      modelName: json['model_name'] as String?,
      ip: json['ip'] as String?,
      referralCode: json['referral_code'] as String?,
      totalReferrals: json['total_referrals'] as String?,
    );

Map<String, dynamic> _$SignUpResponseModelToJson(
  SignUpResponseModel instance,
) => <String, dynamic>{
  'first_name': instance.firstName,
  'last_name': instance.lastName,
  'email': instance.email,
  'country_code': instance.countryCode,
  'phone_number': instance.phoneNumber,
  'user_type': instance.userType,
  'login_type': instance.loginType,
  'business_name': instance.businessName,
  'profile_picture': instance.profilePicture,
  'address': instance.address,
  'latitude': instance.latitude,
  'longitude': instance.longitude,
  'is_profile': instance.isProfile,
  'is_approved': instance.isApproved,
  'is_subscription': instance.isSubscription,
  'user_id': instance.userId,
  'token': instance.token,
  'device_type': instance.deviceType,
  'device_token': instance.deviceToken,
  'uuid': instance.uuid,
  'os_version': instance.osVersion,
  'device_name': instance.deviceName,
  'model_name': instance.modelName,
  'ip': instance.ip,
  'referral_code': instance.referralCode,
  'total_referrals': instance.totalReferrals,
};
