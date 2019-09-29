import 'dart:async';
import 'dart:convert' show json;

import 'package:go_here/data/model/category.dart';
import 'package:go_here/data/model/content_response.dart';
import 'package:go_here/data/serializer/serializers.dart';
import 'package:go_here/utils/log.dart';
import 'package:http/http.dart' as http;
import 'package:built_collection/built_collection.dart';
import 'package:http_parser/src//media_type.dart';

const _tag = "api_service";
const _baseUrl = "demo138.foxtrot.vkhackathon.com";

class HttpCode {
  static const OK = 200;
  static const TIME_OUT = 504;
}

class ApiService {
  static const _headers = {"Content-type": "application/json"};
  static const _timeoutDuration = Duration(seconds: 30);
  final _client = http.Client();

  ApiService();

  Future<ContentResponse> getContentUrl() async {
    final jsonResponse = await _get('content/generateContentLinks');
    if (jsonResponse == null) {
      Log.e(_tag, "Response is null");
      return null;
    }
    return deserialize<ContentResponse>(jsonResponse);
  }

  Future<bool> sendVideo(String url, String userId) async {
    final body = '{"userId":"$userId","contentLink":"$url"}';
    final jsonResponse = await _post('content', body: body);
    return jsonResponse == null;
  }

  Future<bool> uploadVideo(String path, String uploadLink) async {
    final uri = Uri.parse(uploadLink);
    Log.d(_tag, "-> PUT url = $uri path = $path");
    final request = http.MultipartRequest("PUT", uri);
    final pic = await http.MultipartFile.fromPath("file", path,contentType: MediaType('image', 'jpeg'));
    request.headers.addAll({'Content-Type': 'video/mp4'});
    request.files.add(pic);
    final response =
        await request.send().timeout(_timeoutDuration).catchError((error) {
      Log.e(_tag,
          "<- PUT url = $uri, Error while making POST request, error = $error");
      return false;
    });
    Log.d(_tag, "<- PUT url = $uri, code = ${response.statusCode}");
    return response.statusCode == HttpCode.OK;
  }

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

  Future<dynamic> _post(
    String path, {
    body,
    Map<String, String> params,
  }) async {
    final uri = _buildUri("$path", params: params);
    Log.d(_tag, "-> POST url = $uri, params = $params, body = $body");

    final response = await _client
        .post(uri, body: body, headers: _headers)
        .timeout(_timeoutDuration, onTimeout: _onTimeout)
        .catchError((error) {
      Log.e(_tag,
          "<- POST url = $uri, Error while making POST request, error = $error");
      return null;
    });

    if (response == null) {
      return null;
    }

    Log.d(_tag, "<- POST url = $uri, code = ${response.statusCode}");
    Log.d(_tag, "<- POST url = $uri, body = ${response.body}");

    if (response.statusCode != HttpCode.OK) {
      return null;
    }

    if (response.body == null || response.body.isEmpty) {
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
