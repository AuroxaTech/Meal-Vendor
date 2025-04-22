import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:dio/dio.dart';
//import 'package:dio_http_cache_lts/dio_http_cache_lts.dart';
import 'package:vendor/constants/api.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'auth.service.dart';
import 'local_storage.service.dart';

class HttpService {
  String host = Api.baseUrl;
  late BaseOptions baseOptions;
  late Dio dio;
  late SharedPreferences prefs;

  Future<Map<String, String>> getHeaders() async {
    final userToken = await AuthServices.getAuthBearerToken();
    log('queryParameters userToken====================${jsonEncode({
      HttpHeaders.acceptHeader: "application/json",
      HttpHeaders.authorizationHeader: "Bearer $userToken",
      "lang": LocalizeAndTranslate.getLocale().languageCode,
    })}');
    return {
      HttpHeaders.acceptHeader: "application/json",
      HttpHeaders.authorizationHeader: "Bearer $userToken",
      "lang": LocalizeAndTranslate.getLocale().languageCode,
    };
  }

  HttpService() {
    LocalStorageService.getPrefs();

    baseOptions = BaseOptions(
      baseUrl: host,
      validateStatus: (status) {
        return status != null && status <= 500;
      },
      // connectTimeout: 300,
    );
    dio = Dio(baseOptions);
    //dio.interceptors.add(getCacheManager().interceptor);
    // customization
    // dio.interceptors.add(
    //   PrettyDioLogger(
    //     requestHeader: false,
    //     requestBody: true,
    //     responseBody: true,
    //     responseHeader: false,
    //     error: true,
    //     compact: true,
    //     maxWidth: 90,
    //   ),
    // );
  }

  /*DioCacheManager getCacheManager() {
    return DioCacheManager(
      CacheConfig(
        baseUrl: host,
        defaultMaxAge: Duration(hours: 1),
      ),
    );
  }*/

  //for get api calls
  Future<Response> get(
    String url, {
    Map<String, dynamic>? queryParameters,
    bool includeHeaders = true,
  }) async {
    //preparing the api uri/url
    String uri = "$host$url";

    log('queryParameters uri====================$uri');
    log('queryParameters queryParameters====================${jsonEncode(queryParameters)}');
    //preparing the post options if header is required
    final mOptions = !includeHeaders
        ? null
        : Options(
            headers: await getHeaders(),
          );

  try{
    return dio.get(
      uri,
      options: mOptions,
      queryParameters: queryParameters,
    );
  }catch(w){
    rethrow;
  }
  }

  //for post api calls
  Future<Response> post(
    String url,
    body, {
    bool includeHeaders = true,
  }) async {
    //preparing the api uri/url
    String uri = "$host$url";

    log('queryParameters uri====================$uri');
    //preparing the post options if header is required
    final mOptions = !includeHeaders
        ? null
        : Options(
            headers: await getHeaders(),
          );

    return dio.post(
      uri,
      data: body,
      options: mOptions,
    );
  }

  //for post api calls with file upload
  Future<Response> postWithFiles(
    String url,
    body, {
    FormData? formData,
    bool includeHeaders = true,
  }) async {
    //preparing the api uri/url
    String uri = "$host$url";
    //preparing the post options if header is required
    final mOptions = !includeHeaders
        ? null
        : Options(
            headers: await getHeaders(),
          );

    Response response;

    try {
      response = await dio.post(
        uri,
        data: formData ?? FormData.fromMap(body),
        options: mOptions,
      );
    } on DioError catch (error) {
      response = formatDioException(error);
    } catch (error) {
      throw "$error";
    }

    return response;
  }

  Future<Response> postCustomFiles(
    String url,
    body, {
    FormData? formData,
    bool includeHeaders = true,
  }) async {
    //preparing the api uri/url
    String uri = "$host$url";
    //preparing the post options if header is required
    final mOptions = !includeHeaders
        ? null
        : Options(
            headers: await getHeaders(),
          );

    Response response;

    try {
      response = await dio.post(
        uri,
        data: formData ?? FormData.fromMap(body),
        options: mOptions,
      );
    } on DioError catch (error) {
      response = formatDioException(error);
    }

    return response;
  }

  //for patch api calls
  Future<Response> patch(String url, Map<String, dynamic> body) async {
    String uri = "$host$url";
    return dio.patch(
      uri,
      data: body,
      options: Options(
        headers: await getHeaders(),
      ),
    );
  }

  //for delete api calls
  Future<Response> delete(
    String url,
  ) async {
    String uri = "$host$url";
    return dio.delete(
      uri,
      options: Options(
        headers: await getHeaders(),
      ),
    );
  }

  Response formatDioException(DioException ex) {
    Response response = Response(requestOptions: ex.requestOptions);
    response.statusCode = 400;
    try {
      if (ex.type == DioExceptionType.unknown) {
        response.data = {
          "message":
              "Connection timeout. Please check your internet connection and try again",
        };
      } else {
        response.data = {
          "message": "Please check your internet connection and try again",
        };
      }
    } catch (error) {
      response.statusCode = 400;
      response.data = {
        "message": "Please check your internet connection and try again",
      };
    }

    return response;
  }
}
