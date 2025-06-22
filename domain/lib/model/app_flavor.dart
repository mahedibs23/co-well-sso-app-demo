enum AppFlavor {
  dev,
  test,
  staging,
  prod;

  String get name {
    switch (this) {
      case AppFlavor.dev:
        return 'dev';
      case AppFlavor.test:
        return 'test';
      case AppFlavor.staging:
        return 'staging';
      case AppFlavor.prod:
        return 'prod';
    }
  }
}
