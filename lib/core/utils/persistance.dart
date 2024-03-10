import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AppPersist {
  final storage = const FlutterSecureStorage();

  setValue(String key, String value) async {
    return await storage.write(key: key, value: value);
  }

  getValue(String key) async {
    return await storage.read(key: key);
  }

  deleteAllValue(String key) async {
    return await storage.deleteAll();
  }
}
