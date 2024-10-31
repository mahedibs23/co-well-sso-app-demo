import 'package:data/remote/api_client/api_client.dart';
import 'package:data/remote/api_client/movie_api_client.dart';
import 'package:data/remote/api_service/movie_api_service.dart';
import 'package:data/remote/api_service/movie_api_service_impl.dart';
import 'package:data/repository/auth_repository_impl.dart';
import 'package:data/repository/location_repository_impl.dart';
import 'package:data/repository/movie_repository_impl.dart';
import 'package:domain/di/di_module.dart';
import 'package:domain/repository/auth_repository.dart';
import 'package:domain/repository/location_repository.dart';
import 'package:domain/repository/movie_repository.dart';

class DataModule {
  DataModule._internal();

  static final DataModule _instance = DataModule._internal();

  factory DataModule() => _instance;

  final DiModule _diModule = DiModule();

  Future<void> injectDependencies() async {
    await injectApiClient();
    await injectApiService();
    await injectLocalDataService();
    await injectRepositories();
  }

  Future<void> removeDependencies() async {
    await removeApiClient();
    await removeApiService();
    await removeLocalDataService();
    await removeRepositories();
  }

  Future<void> injectApiClient() async {
    await _diModule.registerSingleton<ApiClient>(MovieApiClient());
  }

  Future<void> removeApiClient() async {
    await _diModule.unregisterSingleton<ApiClient>();
  }

  Future<void> injectApiService() async {
    final apiClient = await _diModule.resolve<ApiClient>();
    await _diModule.registerSingleton<MovieApiService>(
      MovieApiServiceImpl(apiClient: apiClient),
    );
  }

  Future<void> removeApiService() async {
    await _diModule.unregisterSingleton<MovieApiService>();
  }

  Future<void> injectLocalDataService() async {
    //TODO: Implement local service injection
  }

  Future<void> removeLocalDataService() async {}

  Future<void> injectRepositories() async {
    final movieApiService = await _diModule.resolve<MovieApiService>();
    await _diModule.registerSingleton<MovieRepository>(
      MovieRepositoryImpl(movieApiService: movieApiService),
    );

    await _diModule.registerSingleton<AuthRepository>(AuthRepositoryImpl());

    await _diModule
        .registerSingleton<LocationRepository>(LocationRepositoryImpl());
  }

  Future<void> removeRepositories() async {
    await _diModule.unregisterSingleton<MovieRepository>();
  }
}
