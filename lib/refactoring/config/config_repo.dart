import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:testnay/app_constants.dart';

import 'configration_model.dart';
import '../../dio/dio_client.dart';

class ConfigRepository {
  final DioClient dioClient;
  final SharedPreferences sharedPreferences;

  ConfigRepository({
    required this.dioClient,
    required this.sharedPreferences,
  });

  static const String _configKey = 'app_config';

   Future<ConfigModel> fetchConfig() async {
    try {
      final response = await dioClient.get(AppConstants.configUri);
      final config = ConfigModel.fromJson(response.data);
      await _saveConfig(config);
      return config;
    } catch (e) {
      // If API fails, try to load from cache
      final cachedConfig = getCachedConfig();
      if (cachedConfig != null) {
        return cachedConfig;
      }
      rethrow;
    }
  }

  Future<void> _saveConfig(ConfigModel config) async {
    await sharedPreferences.setString(
      _configKey,
      jsonEncode(config.toJson()),
    );
  }

  ConfigModel? getCachedConfig() {
    final configJson = sharedPreferences.getString(_configKey);
    if (configJson != null) {
      return ConfigModel.fromJson(jsonDecode(configJson));
    }
    return null;
  }
}