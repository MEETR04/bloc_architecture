import 'package:bloc_architecture/core/locator/locator.dart';
import 'package:bloc_architecture/features/auth/models/response/sign_up_response_model.dart';
import 'package:hive/hive.dart';

class AppDB {
  AppDB._(this._box);
  static const _appDbBox = '_appDbBox';
  static const fcmKey = 'fcm_key';
  static const platform = 'platform';
  final Box<dynamic> _box;

  static Future<AppDB> getInstance() async {
    final box = await Hive.openBox<dynamic>(_appDbBox);
    final db = AppDB._(box);
    return db;
  }

  T getValue<T>(String key, {T? defaultValue}) =>
      _box.get(key, defaultValue: defaultValue) as T;

  Future<void> setValue<T>(String key, T value) => _box.put(key, value);

  ///for set/get login
  bool get isLogin => getValue('isLogin', defaultValue: false);

  set isLogin(bool update) => setValue('isLogin', update);

  ///for set/get walkthrough visited
  bool get isFirstTime => getValue('isFirstTime', defaultValue: true);

  set isFirstTime(bool update) => setValue('isFirstTime', update);

  ///for get complete profile
  bool get isCompleteProfile =>
      getValue('isCompleteProfile', defaultValue: true);

  set isCompleteProfile(bool update) => setValue('isCompleteProfile', update);

  ///for get complete profile
  bool get isGuestUser => getValue('isGuestUser', defaultValue: false);

  set isGuestUser(bool update) => setValue('isGuestUser', update);

  String get apiKey => getValue(
    'apiKey',
    defaultValue:
        'YKoGcMbFZwUFJf0LF7UUXEG91LDuEmNFLRn14vKNupVdciQXs2XthzSyF77TQPbz',
  );

  set apiKey(String update) => setValue('apiKey', update);

  String get token => getValue('token', defaultValue: '');

  set token(String update) => setValue('token', update);

  String get fcmToken => getValue('fcm_token', defaultValue: '0');

  set fcmToken(String update) => setValue('fcm_token', update);

  SignUpResponseModel? get user => getValue('user');

  set user(SignUpResponseModel? user) => setValue('user', user);

  String get deviceuuid => getValue('deviceuuid', defaultValue: '');

  set deviceuuid(String deviceuuid) => setValue('deviceuuid', deviceuuid);

  String get deviceapilvl => getValue('deviceapilvl', defaultValue: '');

  set deviceapilvl(String deviceapilvl) =>
      setValue('deviceapilvl', deviceapilvl);

  String get devicedetails => getValue('devicedetails', defaultValue: '');

  set devicedetails(String devicedetails) =>
      setValue('devicedetails', devicedetails);

  String get deviceIp => getValue('deviceIp', defaultValue: '');

  set deviceIp(String deviceIp) => setValue('deviceIp', deviceIp);

  String get appLanguage => getValue('appLanguage', defaultValue: 'English');

  set appLanguage(String update) => setValue('appLanguage', update);

  void logout() {
    token = '';
    // user = null;
    isLogin = false;
  }
}

final appDB = locator<AppDB>();
