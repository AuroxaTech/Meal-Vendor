import 'dart:io';

import 'package:dio/dio.dart';
import 'package:vendor/constants/api.dart';
import 'package:vendor/models/api_response.dart';
import 'package:vendor/models/service.dart';
import 'package:vendor/services/auth.service.dart';
import 'package:vendor/services/http.service.dart';

import '../models/vendor.dart';

class ServiceRequest extends HttpService {
  //
  Future<List<Service>> getServices({
    Map<String, dynamic>? queryParams,
    int? page = 1,
  }) async {
    final apiResult = await get(
      Api.services,
      queryParameters: {
        ...(queryParams ?? {}),
        "page": "$page",
      },
    );

    final apiResponse = ApiResponse.fromResponse(apiResult);
    if (apiResponse.allGood) {
      if (page == null || page == 0) {
        return (apiResponse.body as List)
            .map((jsonObject) => Service.fromJson(jsonObject))
            .toList();
      } else {
        return apiResponse.data
            .map((jsonObject) => Service.fromJson(jsonObject))
            .toList();
      }
    }

    throw apiResponse.message;
  }

  //
  Future<Service> serviceDetails(int id) async {
    //
    final apiResult = await get("${Api.services}/$id");
    final apiResponse = ApiResponse.fromResponse(apiResult);
    if (apiResponse.allGood) {
      return Service.fromJson(apiResponse.body);
    }

    throw apiResponse.message;
  }

  Future<ApiResponse> deleteService(Service service) async {
    final apiResult = await delete(
      "${Api.services}/${service.id}",
    );
    //
    return ApiResponse.fromResponse(apiResult);
  }

  Future<ApiResponse> updateService(
    Service service, {
    Map<String, dynamic>? data,
    List<File>? photos,
  }) async {
    Map<String, dynamic> postBody = {
      "_method": "PUT",
      ...(data ?? service.toJson()),
    };
    Vendor? currentVendor = await AuthServices.getCurrentVendor(force: true);
    if (null != currentVendor) {
      postBody["vendor_id"] = currentVendor.id;
    }

    FormData formData = FormData.fromMap(postBody);
    for (File file in photos ?? []) {
      formData.files.addAll([
        MapEntry("photos[]", await MultipartFile.fromFile(file.path)),
      ]);
    }

    final apiResult = await postWithFiles(
      "${Api.services}/${service.id}",
      null,
      formData: formData,
    );

    //
    return ApiResponse.fromResponse(apiResult);
  }

  Future<ApiResponse> newService({
    required Map<String, dynamic> data,
    List<File>? photos,
  }) async {
    Map<String, dynamic> postBody = {
      ...data,
    };
    Vendor? currentVendor = await AuthServices.getCurrentVendor(force: true);
    if (null != currentVendor) {
      postBody["vendor_id"] = currentVendor.id;
    }

    FormData formData = FormData.fromMap(postBody);
    for (File file in photos ?? []) {
      formData.files.addAll([
        MapEntry("photos[]", await MultipartFile.fromFile(file.path)),
      ]);
    }

    final apiResult = await postWithFiles(
      Api.services,
      null,
      formData: formData,
    );
    //
    return ApiResponse.fromResponse(apiResult);
  }

  Future<List<String>> getServiceDurations() async {
    final apiResult = await get(Api.serviceDurations);

    final apiResponse = ApiResponse.fromResponse(apiResult);
    if (apiResponse.allGood) {
      return (apiResponse.body as List).map((e) => e.toString()).toList();
    }

    throw apiResponse.message;
  }
}
