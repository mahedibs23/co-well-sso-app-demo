class AppInfo {
  final AppPlatform platform;
  final String name;
  final String packageName;
  final String version;
  final String buildNumber;

  AppInfo({
    required this.platform,
    required this.name,
    required this.packageName,
    required this.version,
    required this.buildNumber,
  });

  factory AppInfo.fromJson(Map<String, dynamic> json) {
    return AppInfo(
      platform: json['platform'],
      name: json['name'],
      packageName: json['packageName'],
      version: json['version'],
      buildNumber: json['buildNumber'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'platform': platform,
      'name': name,
      'packageName': packageName,
      'version': version,
      'buildNumber': buildNumber,
    };
  }
}

enum AppPlatform {
  android,
  ios;

  @override
  toString() {
    switch (this) {
      case AppPlatform.android:
        return 'Android';
      case AppPlatform.ios:
        return 'iOS';
    }
  }
}
