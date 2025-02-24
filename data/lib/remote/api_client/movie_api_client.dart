//ignore_for_file: depend_on_referenced_packages
import 'package:data/local/shared_preference/entity/user_session_shared_pref_entity.dart';
import 'package:data/remote/api_client/api_client.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class MovieApiClient extends ApiClient {
  @override
  String get baseUrl => dotenv.env['API_BASE_URL']!;

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
