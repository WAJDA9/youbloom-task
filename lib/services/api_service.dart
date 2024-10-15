import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'dart:convert' as convert;

import 'package:youbloom/const/urls.dart';

enum HttpMethod { get, post, put, delete, patch }

class ApiService {
  static final FlutterSecureStorage _secureStorage = FlutterSecureStorage();

  static dynamic _invoke(
      {required String endPoint,
      required HttpMethod method,
      Map<String, dynamic>? query,
      bool decode = true,
      Map<String, dynamic>? body}) async {
    Uri uri = Uri.parse("${AppUrls.Base_Url}$endPoint")
        .replace(queryParameters: query);
    Map<String, String> header = <String, String>{};
    String? token = await _secureStorage.read(key: "accesstoken");

    if (token != null) {
      header = {"Authorization": "Bearer $token"};
    }
    late http.Response response;
    switch (method) {
      case HttpMethod.get:
        response = await http.get(uri, headers: header);
        debugPrint('get ${response.statusCode}');
        break;
      case HttpMethod.post:
        header["Content-Type"] = "application/json; charset=UTF-8";
        response = await http.post(uri,
            headers: header, body: convert.jsonEncode(body));
        debugPrint('post ${response.statusCode}');
        break;
      case HttpMethod.put:
        header["Content-Type"] = "application/json; charset=UTF-8";
        response = await http.put(uri,
            headers: header, body: convert.jsonEncode(body));
        break;
      case HttpMethod.delete:
        response = await http.delete(uri,
            headers: header, body: convert.jsonEncode(body));
        break;
      case HttpMethod.patch:
        header["Content-Type"] = "application/json; charset=UTF-8";
        response = await http.patch(uri,
            headers: header, body: convert.jsonEncode(body));
        break;
    }
    if ([200, 201, 204].contains(response.statusCode)) {
      return convert.jsonDecode(response.body);
    } else if (response.statusCode == 401) {
      // Attempt to refresh the token
    } else {
      throw HttpException(
          "Server respond with ${response.statusCode} http code and body = ${convert.jsonDecode(response.body)["message"]} ");
    }
  }

  // static Future<bool> _refreshToken() async {
  //   String? refreshToken = await _secureStorage.read(key: "refreshtoken");
  //   if (refreshToken == null) {
  //     return false;
  //   }

  //   Uri uri = Uri.parse("${AppUrls.Base_Url}${AppUrls.REFRESH_URL}");
  //   Map<String, String> headers = {
  //     "Content-Type": "application/json",
  //     "Authorization": "Bearer $refreshToken"
  //   };

  //   var response = await http.post(uri,
  //       headers: headers,
  //       body: convert.jsonEncode({"refreshToken": refreshToken}));
  //   if (response.statusCode == 200) {
  //     var data = convert.jsonDecode(response.body)["data"];
  //     debugPrint(data);
  //     await _secureStorage.write(key: "accesstoken", value: data["accesstoken"]);
  //     await _secureStorage.write(key: "refreshtoken", value: data["refreshtoken"]);
  //     return true;
  //   } else {
  //     return false;
  //   }
  // }

  static Future<dynamic> get(
      {required String endPoint, Map<String, dynamic>? query}) {
    return _invoke(endPoint: endPoint, method: HttpMethod.get, query: query);
  }

  static Future<dynamic> post(
      {required String endPoint,
      Map<String, dynamic>? body,
      Map<String, dynamic>? query,
      bool decode = true}) {
    return _invoke(
        endPoint: endPoint,
        method: HttpMethod.post,
        query: query,
        body: body,
        decode: decode);
  }

  static dynamic patch(
      {required String endPoint,
      Map<String, dynamic>? body,
      Map<String, dynamic>? query}) {
    return _invoke(
        endPoint: endPoint, method: HttpMethod.patch, query: query, body: body);
  }

  static dynamic put({required String endPoint, Map<String, dynamic>? body}) {
    return _invoke(endPoint: endPoint, method: HttpMethod.put, body: body);
  }

  static dynamic delete(String endPoint,
      {Map<String, dynamic>? query, Map<String, dynamic>? body}) {
    return _invoke(
        endPoint: endPoint,
        method: HttpMethod.delete,
        query: query,
        body: body);
  }

  static Future<dynamic> addPlayer({
    List<dynamic>? files,
    required String endPoint,
    Map<String, dynamic>? body,
  }) async {
    Uri uri = Uri.parse("${AppUrls.Base_Url}$endPoint");

    var request = http.MultipartRequest("POST", uri);

    Map<String, String> headers = {};
    String? token = await _secureStorage.read(key: "accesstoken");
    if (token != null) {
      headers["Authorization"] = "Bearer $token";
    }
    headers["Content-Type"] = "multipart/form-data";
    request.headers.addAll(headers);

    if (body != null) {
      body.forEach((key, value) {
        if (value != null) {
          request.fields[key] = value.toString();
        }
      });
    }
    request.fields.forEach((key, value) {
      debugPrint("$key : $value");
    });
    if (files != null) {
      for (var file in files) {
        request.files.add(http.MultipartFile(
          'playerFiles',
          file.readStream!,
          file.size,
          filename: file.name,
          contentType: MediaType(
            file.extension!.contains("pdf") ? "application" : "image",
            file.extension!.contains("pdf") ? "pdf" : file.extension!,
          ),
        ));
      }
    }

    var response = await request.send();
    final respStr = await response.stream.bytesToString();
    debugPrint(respStr);
    debugPrint("DATA ${jsonDecode(respStr)["data"]}");
    debugPrint("message ${jsonDecode(respStr)["message"]}");
    if ([200, 201, 204].contains(response.statusCode)) {
      return jsonDecode(respStr)["data"];
    } else {
      throw HttpException(
          "Server responded with ${response.statusCode} http code and body = ${jsonDecode(respStr)["message"]}");
    }
  }

  static Future<dynamic> addInjury({
    List<dynamic>? files,
    required String endPoint,
    Map<String, dynamic>? body,
  }) async {
    Uri uri = Uri.parse("${AppUrls.Base_Url}$endPoint");

    var request = http.MultipartRequest("POST", uri);

    Map<String, String> headers = {};
    String? token = await _secureStorage.read(key: "accesstoken");
    if (token != null) {
      headers["Authorization"] = "Bearer $token";
    }
    headers["Content-Type"] = "multipart/form-data";
    request.headers.addAll(headers);

    if (body != null) {
      body.forEach((key, value) {
        if (value != null) {
          request.fields[key] = value.toString();
        }
      });
    }
    request.fields.forEach((key, value) {
      debugPrint("$key : $value");
    });
    if (files != null) {
      for (var file in files) {
        request.files.add(http.MultipartFile(
          'files',
          file.readStream!,
          file.size,
          filename: file.name,
          contentType: MediaType(
            file.extension!.contains("pdf") ? "application" : "image",
            file.extension!.contains("pdf") ? "pdf" : file.extension!,
          ),
        ));
      }
    }

    var response = await request.send();
    final respStr = await response.stream.bytesToString();
    debugPrint(respStr);
    debugPrint("DATA ${jsonDecode(respStr)["data"]}");
    debugPrint("message ${jsonDecode(respStr)["message"]}");
    if ([200, 201, 204].contains(response.statusCode)) {
      return jsonDecode(respStr)["data"];
    } else {
      throw HttpException(
          "Server responded with ${response.statusCode} http code and body = ${jsonDecode(respStr)["message"]}");
    }
  }

  static Future<dynamic> addExercise({
    dynamic file,
    required String endPoint,
    Map<String, dynamic>? body,
  }) async {
    Uri uri = Uri.parse("${AppUrls.Base_Url}$endPoint");

    var request = http.MultipartRequest("POST", uri);

    Map<String, String> headers = {};
    String? token = await _secureStorage.read(key: "accesstoken");
    if (token != null) {
      headers["Authorization"] = "Bearer $token";
    }
    headers["Content-Type"] = "multipart/form-data";
    request.headers.addAll(headers);
    debugPrint("HQKLSDHFJ");
    if (body != null) {
      body.forEach((key, value) {
        if (value != null) {
          request.fields[key] = value.toString();
        }
      });
    } else {
      debugPrint("body is null");
    }
    request.fields.forEach((key, value) {
      debugPrint("$key : $value");
    });

    if (file.isNotEmpty) {
      for (var singleFile in file) {
        request.files.add(http.MultipartFile(
          'files',
          singleFile.readStream!,
          singleFile.size,
          filename: singleFile.name,
          contentType: MediaType(
            singleFile.extension!.contains("pdf") ? "application" : "image",
            singleFile.extension!.contains("pdf")
                ? "pdf"
                : singleFile.extension!,
          ),
        ));
      }
    } else {
      debugPrint("file is null");
    }

    var response = await request.send();
    debugPrint("req sent");
    final respStr = await response.stream.bytesToString();
    debugPrint(respStr);
    debugPrint("DATA ${jsonDecode(respStr)["data"]}");
    debugPrint("message ${jsonDecode(respStr)["message"]}");
    if ([200, 201, 204].contains(response.statusCode)) {
      return jsonDecode(respStr)["data"];
    } else {
      throw HttpException(
          "Server responded with ${response.statusCode} http code and body = ${jsonDecode(respStr)["message"]}");
    }
  }
}
