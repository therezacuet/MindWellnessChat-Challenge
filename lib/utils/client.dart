import 'dart:io';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter/foundation.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import '../app/locator.dart';
import '../config/api_config.dart';
import '../services/firebase_auth_service.dart';
import 'formate_query_parameter.dart';

class Client {
  String baseUrl = ApiConfig.baseUrl;

  Dio? _dio;
  BaseOptions options = BaseOptions(
    connectTimeout: const Duration(milliseconds: (1000 * 300)),
    receiveTimeout: const Duration(milliseconds: (1000 * 300)),
  );

  Map<String, Object>? header;

  Client();

  Client setUrlEncoded() {
    header!.remove('Content-Type');
    header!.putIfAbsent('Content-Type', () => 'application/x-www-form-urlencoded');
    _dio!.options.headers = header;
    return this;
  }

  setHeaders(){
    _dio!.options.headers = header;
    return this;
  }

  Future<Client> setProtectedApiHeader() async {
    FirebaseAuthService _firebaseAuthService = locator<FirebaseAuthService>();
    String? idToken = await _firebaseAuthService.getIdToken();
    String? userId = await _firebaseAuthService.getUserid();
    header!.putIfAbsent('authorization', () => 'Bearer $idToken');
    header!.putIfAbsent('userid', () => userId!);
    return this;
  }

  Client builder() {
    header = <String, Object>{};
    header!.putIfAbsent('Accept', () => 'application/json');
    header!.putIfAbsent('Content-Type', () => 'application/json');
    _dio = Dio(options);
    _dio!.interceptors.add(dioInterceptor);
    _dio!.interceptors.add(PrettyDioLogger(requestBody: true, requestHeader:true,responseHeader: true,compact:false));
    _dio!.options.baseUrl = baseUrl;
    _dio!.options.headers = header;
    return this;
  }

  Dio build() {
    _dio!.options.headers = header;
    (_dio!.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (HttpClient client) {
          client.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
      return client;
    };
    if (kDebugMode) {
      print("HEAEDR 99 100 :- $header");
    }

    return _dio!;
  }
}

InterceptorsWrapper dioInterceptor = InterceptorsWrapper(
  onRequest: (options, handler) {
    if (kDebugMode) {
      print("options :- ${options.headers}");
    }
    if (options.method == 'GET') {
      if (options.queryParameters.isNotEmpty) {
        options.queryParameters =
            FormatQueryParameter().replaceSpace(options.queryParameters);
      }
    }
    return handler.next(options); //continue
  },
  onResponse: (response, handler) {
    return handler.next(response); // continue
  },
  onError: (DioError e, handler) async {
    Response? response = e.response;

    if (response != null) {
      int? statusCode = response.statusCode;

      if (statusCode != null) {
        if ((statusCode / 100).floor() == 5) {
        } else if ((statusCode / 100).floor() == 4) {}
      } else {
      }
    } else {
    }
    return handler.next(e); //continue
  },
);
