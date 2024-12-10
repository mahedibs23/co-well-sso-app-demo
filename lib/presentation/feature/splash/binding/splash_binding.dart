import 'package:domain/repository/app_repository.dart';
import 'package:hello_flutter/presentation/base/base_binding.dart';
import 'package:hello_flutter/presentation/feature/splash/splash_view_model.dart';

class SplashBinding extends BaseBinding {
  @override
  Future<void> addDependencies() async {
    AppRepository appRepository = await diModule.resolve<AppRepository>();
    return diModule.registerInstance(
      SplashViewModel(appRepository: appRepository),
    );
  }

  @override
  Future<void> removeDependencies() async {
    return diModule.unregister<SplashViewModel>();
  }
}
