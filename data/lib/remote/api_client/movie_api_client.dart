import 'package:data/local/shared_preference/entity/user_session_shared_pref_entity.dart';
import 'package:data/remote/api_client/api_client.dart';

class MovieApiClient extends ApiClient {
  @override
  String get baseUrl => "https://yts.mx/api/v2";

  @override
  Future<Map<String, String>> getCustomHeader() async {
    final accessToken = (await UserSessionSharedPrefEntity.example
            .getFromSharedPref() as UserSessionSharedPrefEntity)
        .accessToken;
    return {
      'Authorization': 'Bearer $accessToken',
      'Content-Type': 'application/json',
    };
  }
}
