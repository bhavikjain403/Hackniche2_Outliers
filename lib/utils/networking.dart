import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:nomnom/models/common_res.dart';
import 'package:xml/xml.dart';

class BaseNetwork {
  static const String baseUrl =
      // "https://meeting-room-backend-production.up.onrender.app/api";
      "https://foodtruck-poi9.onrender.com/api";

  static Future<CommonResponse> postXML(
    String fullURL,
    dynamic body,
    void Function(CommonResponse) successCompletion,
    void Function(CommonResponse) errCompletion,
  ) async {
    Map<String, dynamic> json = {'success': true};
    late CommonResponse commonResponse;
    Dio dio = initDio(fullURL, false);
    await dio
        .post("",
            options: Options(
                contentType: 'application/soap+xml; charset=utf-8',
                headers: {
                  'SOAPAction': "http://tempuri.org/ILLoginAuthenticateOzone"
                }),
            data: body)
        .then((response) {
      //print(response.data);
      final XmlDocument xml = XmlDocument.parse(response.data);
      String xmlRes =
          xml.findAllElements('ILLoginAuthenticateOzoneResult').first.innerXml;
      if (xmlRes == 'Invalid login details') {
        json['success'] = false;
        json['msg'] = 'Invalid login details';
      }
      json['data'] = xmlRes;
      commonResponse = CommonResponse.fromJson(json);

      if (commonResponse.success!) {
        successCompletion(commonResponse);
        // print(commonResponse.data);
      } else {
        errCompletion(commonResponse);
        //print(commonResponse.data);
      }
    }).catchError((e) {
      if (e is DioException) {
        // print(partUrl);
        // print(e.response?.statusCode);
        //  print(e.response?.data);
        json['success'] = false;
        json['message'] = 'Unknown error occurred';
        commonResponse = CommonResponse.fromJson(json);
        debugPrint("err ==== ${e.response}");
        errCompletion(commonResponse);
      }
    });
    return commonResponse;
  }

  static Future<CommonResponse> get(
      String partUrl,
      String? token,
      void Function(CommonResponse) successCompletion,
      void Function(CommonResponse) errCompletion) async {
    late CommonResponse commonResponse;

    Map<String, dynamic> h = {};
    if (token != null) {
      h["Authorization"] = "Bearer $token";
    }

    Dio dio = initDio(partUrl, false);
    await dio
        .get(
      '',
      options: token != null
          ? Options(contentType: Headers.formUrlEncodedContentType, headers: h)
          : Options(contentType: Headers.formUrlEncodedContentType),
    )
        .then((response) {
      if (response.data != null) {
        debugPrint("res ====  ${response.data.toString()}");
        commonResponse = CommonResponse.fromJson(response.data);
        debugPrint(commonResponse.success.toString());
        if (commonResponse.success!) {
          successCompletion(commonResponse);
        } else {
          errCompletion(commonResponse);
        }
      }
    }).catchError((e) {
      if (e is DioException) {
        debugPrint(e.message);
        debugPrint(e.response.toString());
        commonResponse = CommonResponse.fromJson(e.response?.data);
        debugPrint("err ==== ${e.response}");
        errCompletion(commonResponse);
      }
    });

    return commonResponse;
  }

  static Future<CommonResponse> post(
      String partUrl,
      dynamic body,
      void Function(CommonResponse) successCompletion,
      void Function(CommonResponse) errCompletion,
      bool isMultipart,
      String? token) async {
    late CommonResponse commonResponse;
    Dio dio = initDio(partUrl, false);
    await dio
        .post("",
            options: token != null
                ? Options(
                    contentType: Headers.jsonContentType,
                    headers: {"Authorization": "Bearer $token"})
                : Options(contentType: Headers.jsonContentType),
            data: body)
        .then((response) {
      debugPrint("res ==== ${response.toString()}");
      commonResponse = CommonResponse.fromJson(response.data);

      if (commonResponse.success == true) {
        //print('sas');
        successCompletion(commonResponse);
      } else {
        print(response.data);
        errCompletion(commonResponse);
      }
    }).catchError((e) {
      if (e is DioException) {
        print(e.error);
        print(e.message);
        // print(partUrl);
        // print(e.response?.statusCode);
        debugPrint(e.response?.data.toString());
        commonResponse = CommonResponse.fromJson(e.response?.data ??
            {"msg": "no msg", "success": false, "data": []});
        debugPrint("err ==== ${e.response}");
        errCompletion(commonResponse);
      }
    });
    return commonResponse;
  }

  static Future<CommonResponse> put(
      String partUrl,
      dynamic body,
      void Function(CommonResponse) successCompletion,
      void Function(CommonResponse) errCompletion,
      bool isMultipart,
      String? token) async {
    late CommonResponse commonResponse;
    Dio dio = initDio(partUrl, false);
    await dio
        .put("",
            options: token != null
                ? Options(
                    contentType: Headers.jsonContentType,
                    headers: {"Authorization": "Bearer $token"})
                : Options(contentType: Headers.jsonContentType),
            data: body)
        .then((response) {
      // debugPrint("res ==== " + response.toString());
      commonResponse = CommonResponse.fromJson(response.data);

      if (commonResponse.success!) {
        successCompletion(commonResponse);
      } else {
        errCompletion(commonResponse);
      }
    }).catchError((e) {
      if (e is DioException) {
        commonResponse = CommonResponse.fromJson(e.response?.data);
        debugPrint("err ==== ${e.response}");
        errCompletion(commonResponse);
      }
    });
    return commonResponse;
  }

  static Future<CommonResponse> delete(
      String partUrl,
      dynamic body,
      void Function(CommonResponse) successCompletion,
      void Function(CommonResponse) errCompletion,
      bool isMultipart,
      String? token) async {
    late CommonResponse commonResponse;
    Dio dio = initDio(partUrl, false);
    await dio
        .delete("",
            options: token != null
                ? Options(
                    contentType: Headers.jsonContentType,
                    headers: {"Authorization": "Bearer $token"})
                : Options(contentType: Headers.jsonContentType),
            data: body)
        .then((response) {
      // debugPrint("res ==== " + response.toString());
      commonResponse = CommonResponse.fromJson(response.data);

      if (commonResponse.success!) {
        successCompletion(commonResponse);
      } else {
        errCompletion(commonResponse);
      }
    }).catchError((e) {
      if (e is DioException) {
        // print(partUrl);
        // print(e.response?.statusCode);
        // print(e.response?.data);
        commonResponse = CommonResponse.fromJson(e.response?.data);
        debugPrint("err ==== ${e.response}");
        errCompletion(commonResponse);
      }
    });
    return commonResponse;
  }

  static Dio initDio(String partUrl, bool isMultipart) {
    var dio = Dio();
    Map<String, String> headers;
    String acceptHeader;
    String contentTypeHeader;

    acceptHeader = 'application/json';
    contentTypeHeader =
        isMultipart ? 'multipart/form-data' : 'application/json';

    headers = {
      HttpHeaders.acceptHeader: acceptHeader,
      HttpHeaders.contentTypeHeader: contentTypeHeader,
    };
    final fullUrl = partUrl.startsWith('http') ? partUrl : "$baseUrl/$partUrl";
    debugPrint(fullUrl);
    BaseOptions options = BaseOptions(baseUrl: fullUrl, headers: headers);

    dio.options = options;

    return dio;
  }
}
