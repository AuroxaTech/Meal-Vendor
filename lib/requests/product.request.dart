import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:vendor/constants/api.dart';
import 'package:vendor/models/api_response.dart';
import 'package:vendor/models/product.dart';
import 'package:vendor/models/product_category.dart';
import 'package:vendor/services/auth.service.dart';
import 'package:vendor/services/http.service.dart';
import 'package:vendor/utils/utils.dart';

class ProductRequest extends HttpService {
  //
  Future<List<Product>> getProducts({
    String? keyword,
    int page = 1,
    String? categoriesId,
  }) async {
    final apiResult = await get(
      "${Api.products}$categoriesId",
      queryParameters: {
        "keyword": keyword,
        "type": "vendor",
        "page": page,
      },
    );
    //
    final apiResponse = ApiResponse.fromResponse(apiResult);
    print("Api Response ====> ${apiResponse.data}");
    if (apiResponse.allGood) {
      List<Product> products = [];
      for (var jsonObject in apiResponse.data) {
        try {
          final mProduct = Product.fromJson(jsonObject);
          products.add(mProduct);
          print("Product Api Response ====> ${mProduct.toJson()}");

        } catch (error) {
          print("Error ==> $error");
        }
      }
      return products;

    } else {
      throw apiResponse.message;
    }
  }

  //
  Future<Product> getProductDetails(int productId) async {
    final apiResult = await get(
      "${Api.products}/$productId",
    );
    //
    final apiResponse = ApiResponse.fromResponse(apiResult);
    if (apiResponse.allGood) {
      return Product.fromJson(apiResponse.body);
    } else {
      throw apiResponse.message;
    }
  }

  Future<List<ProductCategory>> getProductCategories({
    bool subCat = false,
    int? vendorTypeId,
  }) async {
    final apiResult = await get(
      Api.productCategories,
      queryParameters: {
        "type": subCat ? "sub" : "",
        "vendor_type_id": vendorTypeId
      },
    );
    //
    final apiResponse = ApiResponse.fromResponse(apiResult);
    if (apiResponse.allGood) {
      return apiResponse.data.map((jsonObject) {
        return ProductCategory.fromJson(jsonObject);
      }).toList();
    } else {
      throw apiResponse.message;
    }
  }

  Future<ApiResponse> newProduct(
    Map<String, dynamic> value, {
    List<File>? photos,
  }) async {
    //
    final postBody = {
      ...value,
      "vendor_id": AuthServices.currentVendor?.id,
    };

    FormData formData = FormData.fromMap(postBody);
    if (photos != null && photos.isNotEmpty) {
      for (File file in photos) {
        Uint8List? data = await Utils.compressFile(
          filePath: file.absolute.path,
          quality: 60,
        );
        if (data != null) {
          formData.files.addAll([
            MapEntry("photos[]", MultipartFile.fromBytes(data)),
          ]);
        }
      }
    }

    final apiResult = await postWithFiles(
      Api.products,
      null,
      formData: formData,
    );
    //
    return ApiResponse.fromResponse(apiResult);
  }

  Future<ApiResponse> deleteProduct(
    Product product,
  ) async {
    final apiResult = await delete(
      "${Api.products}/${product.id}",
    );
    return ApiResponse.fromResponse(apiResult);
  }

  Future<ApiResponse> updateProductAvailability(Product product,
      {required bool isAvailable, int? availableInMinutes}) async {
    final postBody = {
      "_method": "PUT",
      "id": product.id,
      "is_active": isAvailable ? 1 : 0,
      //"vendor_id": AuthServices.currentVendor?.id,
    };
    if (null != availableInMinutes) {
      postBody["available_in_minutes"] = availableInMinutes;
    }
    print(postBody);
    final apiResult = await post("${Api.products}/${product.id}", postBody);
    print("Post Api ====> ${apiResult.data}");
    return ApiResponse.fromResponse(apiResult);
  }

  Future<ApiResponse> updateDetails(
    Product product, {
    Map<String, dynamic>? data,
    List<File>? photos,
  }) async {
    //
    final postBody = {
      "_method": "PUT",
      ...(data ?? product.toJson()),
      "vendor_id": AuthServices.currentVendor?.id,
    };
    FormData formData = FormData.fromMap(
      postBody,
      ListFormat.multiCompatible,
    );

    if (photos != null && photos.isNotEmpty) {
      for (File file in photos) {
        Uint8List? data = await Utils.compressFile(
          filePath: file.absolute.path,
          quality: 60,
        );
        if (data != null) {
          formData.files.addAll([
            MapEntry("photos[]", MultipartFile.fromBytes(data)),
          ]);
        }
      }
    }

    final apiResult = await postWithFiles(
      "${Api.products}/${product.id}",
      null,
      formData: formData,
    );
    //
    return ApiResponse.fromResponse(apiResult);
  }

  Future<List<ProductCategory>> fetchSubCategories({
    required dynamic categoryId,
  }) async {
    final apiResult = await get(
      Api.productCategories,
      queryParameters: {
        "category_id": categoryId,
        "type": "sub",
      },
    );
    //
    final apiResponse = ApiResponse.fromResponse(apiResult);
    if (apiResponse.allGood) {
      return apiResponse.data.map((jsonObject) {
        return ProductCategory.fromJson(jsonObject);
      }).toList();
    } else {
      throw apiResponse.message;
    }
  }
}
