import 'dart:convert';

import 'package:domain/exceptions/network_exceptions.dart';
import 'package:domain/util/logger.dart';
import 'package:http/http.dart' as http;

abstract class ApiClient {
  String get baseUrl;

  Map<String, String> defaultHeaders() {
    return {
      //'Content-Type': 'application/json',
    };
  }

  Future<Map<String, String>> getAuthorizationHeader();

  Future<dynamic> get(
    String endpoint, {
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
    bool isAuthenticationRequired = true,
  }) async {
    final url = Uri.parse('$baseUrl/$endpoint').replace(
      queryParameters: queryParameters?.map(
        (key, value) => MapEntry(key, value.toString()),
      ),
    );

    final Map<String, String> mergedHeader = await _getMergedHeaders(
      headers: headers,
      isAuthenticationRequired: isAuthenticationRequired,
    );

    _logRequest('GET', url, headers: mergedHeader);

    final response = await http.get(url, headers: mergedHeader);

    _logResponse(response);

    return _processResponse(response);
  }

  Future<Map<String, dynamic>> post(
    String endpoint, {
    Map<String, dynamic>? data,
    Map<String, String>? headers,
    bool isAuthenticationRequired = true,
  }) async {
    final Map<String, String> mergedHeader = await _getMergedHeaders(
      headers: headers,
      isAuthenticationRequired: isAuthenticationRequired,
    );

    final response = await http.post(
      Uri.parse('$baseUrl/$endpoint'),
      body: jsonEncode(data),
      headers: mergedHeader,
    );

    _logRequest(
      'POST',
      Uri.parse('$baseUrl/$endpoint'),
      data: data,
      headers: mergedHeader,
    );

    _logResponse(response);

    return _processResponse(response);
  }

  Future<Map<String, dynamic>> put(
    String endpoint, {
    Map<String, dynamic>? data,
    Map<String, String>? headers,
    bool isAuthenticationRequired = true,
  }) async {
    final Map<String, String> mergedHeader = await _getMergedHeaders(
      headers: headers,
      isAuthenticationRequired: isAuthenticationRequired,
    );

    final response = await http.put(
      Uri.parse('$baseUrl/$endpoint'),
      body: jsonEncode(data),
      headers: mergedHeader,
    );

    _logRequest(
      'PUT',
      Uri.parse('$baseUrl/$endpoint'),
      data: data,
      headers: mergedHeader,
    );
    _logResponse(response);

    return _processResponse(response);
  }

  Future<Map<String, dynamic>> delete(
    String endpoint, {
    Map<String, String>? headers,
    bool isAuthenticationRequired = true,
  }) async {
    final Map<String, String> mergedHeader = await _getMergedHeaders(
      headers: headers,
      isAuthenticationRequired: isAuthenticationRequired,
    );

    _logRequest(
      'DELETE',
      Uri.parse('$baseUrl/$endpoint'),
      headers: mergedHeader,
    );

    final response = await http.delete(
      Uri.parse('$baseUrl/$endpoint'),
      headers: mergedHeader,
    );

    _logResponse(response);

    return _processResponse(response);
  }

  void _logRequest(
    String method,
    Uri url, {
    Map<String, dynamic>? data,
    Map<String, String>? headers,
  }) {
    Logger.info('Sending $method request to $url', prettyPrint: true);
    if (headers != null && headers.isNotEmpty) {
      var formattedHeaders = const JsonEncoder.withIndent(' ').convert(headers);
      Logger.info('Request Headers: $formattedHeaders');
    }
    if (data != null && data.isNotEmpty) {
      final formattedJsonStr = const JsonEncoder.withIndent(' ').convert(data);
      Logger.info('Request Data: $formattedJsonStr', prettyPrint: true);
    }
  }

  void _logResponse(http.Response response) {
    // Check if the response body is empty.
    // For DELETE operations, the response body is empty (No content).
    // we must check this, and log accordingly.
    if (response.body.isEmpty) {
      Logger.info(
        'Received response - Status code: ${response.statusCode}, Body: <No Content>',
        prettyPrint: true,
      );
    } else {
      try {
        // Try to decode the JSON response body
        final jsonObj = json.decode(
          utf8.decode(response.bodyBytes),
        );
        // Re-encode for a formatted JSON string
        final formattedJsonStr =
            const JsonEncoder.withIndent(' ').convert(jsonObj);
        Logger.info(
          'Received response - Status code: ${response.statusCode}, Body: $formattedJsonStr',
          prettyPrint: true,
        );
      } catch (e) {
        // If decoding fails, log the raw response body
        Logger.info(
          'Received response - Status code: ${response.statusCode}, Body: ${response.body}',
          prettyPrint: true,
        );
      }
    }

    // Log headers if present
    if (response.headers.isNotEmpty) {
      final formattedHeaders = const JsonEncoder.withIndent(' ').convert(
        response.headers,
      );
      Logger.info('Response Headers: $formattedHeaders');
    }
  }

  dynamic _processResponse(http.Response response) {
    // For DELETE operations, the response body is empty (No content).
    // We must check this, and return an empty map.
    final dynamic data = response.body.isEmpty
        ? {}
        : json.decode(
            utf8.decode(response.bodyBytes),
          );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (data is Map<String, dynamic> || data is List<dynamic>) {
        return data;
      } else {
        throw const FormatException('Unexpected response format');
      }
    } else {
      throw NetworkException(
        data['error'] ?? data['message'] ?? 'Unknown error',
        code: response.statusCode,
      );
    }
  }

  Future<Map<String, String>> _getMergedHeaders({
    Map<String, String>? headers,
    bool isAuthenticationRequired = true,
  }) async {
    Map<String, String>? mergedHeaders = defaultHeaders();
    if (isAuthenticationRequired) {
      mergedHeaders.addAll(await getAuthorizationHeader());
    }
    mergedHeaders.addAll(headers ?? {});
    return mergedHeaders;
  }
}
