import 'dart:convert';
import 'package:flutter/services.dart';

/// ModuleConfig handles loading and parsing the module configuration
/// from a JSON file. It contains a list of ModuleInfo objects which represent
/// each module's configuration, including its slug, enabled status, and
/// whether it should be initialized at startup.
class ModuleConfig {
  final List<ModuleInfo> modules;

  ModuleConfig({required this.modules});

  factory ModuleConfig.fromJson(Map<String, dynamic> json) {
    print("Parsing ModuleConfig from JSON...");

    var modulesJson = json['modules'] as List;
    List<ModuleInfo> modulesList = modulesJson.map((i) => ModuleInfo.fromJson(i)).toList();

    // Debugging: Log each module's configuration
    for (var module in modulesList) {
      print("Loaded ModuleInfo: slug=${module.slug}, enabled=${module.enabled}, initAtStartup=${module.initAtStartup}");
    }

    return ModuleConfig(modules: modulesList);
  }

  static Future<ModuleConfig> loadConfig() async {
    print("Loading module configuration from JSON file...");

    String jsonString = await rootBundle.loadString('assets/config/modules_config.json');
    print("Module configuration JSON loaded: $jsonString");

    Map<String, dynamic> json = jsonDecode(jsonString);
    print("Module configuration JSON parsed: $json");

    return ModuleConfig.fromJson(json);
  }
}

class ModuleInfo {
  final String slug;
  final bool enabled;
  final bool initAtStartup;

  ModuleInfo({required this.slug, required this.enabled, required this.initAtStartup});

  factory ModuleInfo.fromJson(Map<String, dynamic> json) {
    print("Parsing ModuleInfo: $json");

    return ModuleInfo(
      slug: json['slug'],
      enabled: json['enabled'],
      initAtStartup: json['initAtStartup'],
    );
  }
}
