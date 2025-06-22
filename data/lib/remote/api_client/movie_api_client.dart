//ignore_for_file: depend_on_referenced_packages
import 'package:data/local/shared_preference/entity/user_session_shared_pref_entity.dart';
import 'package:data/remote/api_client/api_client.dart';
import 'package:domain/util/secret_manager.dart';

class MovieApiClient extends ApiClient {
  @override
  String get baseUrl => SecretManager.getSecret('API_BASE_URL') ?? '';

  @override
  Future<Map<String, String>> getAuthorizationHeader() async {
    final accessToken = (await UserSessionSharedPrefEntity.example
            .getFromSharedPref() as UserSessionSharedPrefEntity)
        .accessToken;
    return {
      'Authorization': 'Bearer $accessToken',
      'Content-Type': 'application/json',
    };
  }
}
