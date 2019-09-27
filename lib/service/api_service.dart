import 'dart:async';
import 'dart:convert' show json;

import 'package:go_here/data/model/category.dart';
import 'package:go_here/data/serializer/serializers.dart';
import 'package:go_here/utils/log.dart';
import 'package:http/http.dart' as http;
import 'package:built_collection/built_collection.dart';

const _tag = "api_service";
const _baseUrl = "demo138.foxtrot.vkhackathon.com:8080";

class HttpCode {
  static const OK = 200;
  static const TIME_OUT = 504;
}

class ApiService {
  static const _timeoutDuration = Duration(seconds: 30);
  final _client = http.Client();

  ApiService();

  Future<BuiltList<Category>> getPlaces() async {
    final jsonResponse = await _get('places');
    if (jsonResponse == null) {
      Log.e(_tag, "Response is null");
      return BuiltList();
    }
    return deserializeListOf<Category>(jsonResponse);
  }

  Future<dynamic> _get(String path, {Map<String, String> params}) async {
    final uri = _buildUri("$path", params: params);
    Log.d(_tag, "-> GET url = $uri, params = $params");

    final response = await _client
        .get(uri)
        .timeout(_timeoutDuration, onTimeout: _onTimeout)
        .catchError((error) {
      Log.e(_tag,
          "<- GET url = $uri, Error while making GET request, error = $error");
      return null;
    });

    if (response == null) {
      return null;
    }

    Log.d(_tag, "<- GET url = $uri, code = ${response.statusCode}");
    Log.d(_tag, "<- GET url = $uri, body = ${response.body}");

    if (response.statusCode != HttpCode.OK) {
      return null;
    }

    return json.decode(response.body);
  }

  Uri _buildUri(String path, {Map<String, String> params}) {
    return Uri.http(_baseUrl, path, params);
  }

  http.Response _onTimeout() {
    Log.e(_tag, "Request timeout ${_timeoutDuration.inSeconds}s");
    return http.Response("Timeout error", HttpCode.TIME_OUT);
  }
}
