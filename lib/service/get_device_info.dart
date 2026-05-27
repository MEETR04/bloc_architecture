import 'dart:io';

import 'package:bloc_architecture/core/db/app_db.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';

class DeviceInfo {
  DeviceInfo._({
    required this.deviceName,
    required this.modelName,
    required this.osVersion,
    required this.ip,
    required this.uuid,
  });
  final String? deviceName;
  final String? modelName;
  final String? osVersion;
  final String? ip;
  final String uuid;

  static Future<DeviceInfo> fetch() async {
    final deviceInfoPlugin = DeviceInfoPlugin();
    const uuidGen = Uuid();

    String? deviceName;
    String? modelName;
    String? osVersion;
    String? ip;
    late String uuid;

    // Retrieve or generate persisted UUID
    if (appDB.deviceuuid.isNotEmpty) {
      uuid = appDB.deviceuuid;
    } else {
      uuid = uuidGen.v4();
      appDB.deviceuuid = uuid;
    }

    // Fetch device model info
    if (Platform.isAndroid) {
      final info = await deviceInfoPlugin.androidInfo;
      deviceName = info.brand;
      modelName = info.model;
      osVersion = info.version.release;
    } else if (Platform.isIOS) {
      final info = await deviceInfoPlugin.iosInfo;
      deviceName = info.name;
      modelName = info.utsname.machine;
      osVersion = info.systemVersion;
    }

    // Fetch public IP with a 1.5s timeout to prevent startup blocking
    try {
      final response = await http
          .get(Uri.parse('https://api.ipify.org'))
          .timeout(const Duration(milliseconds: 1500));
      if (response.statusCode == 200) {
        ip = response.body;
        appDB.deviceIp = ip;
      } else {
        ip = appDB.deviceIp.isNotEmpty ? appDB.deviceIp : null;
      }
    } catch (_) {
      ip = appDB.deviceIp.isNotEmpty ? appDB.deviceIp : null;
    }

    return DeviceInfo._(
      deviceName: deviceName,
      modelName: modelName,
      osVersion: osVersion,
      ip: ip,
      uuid: uuid,
    );
  }
}
