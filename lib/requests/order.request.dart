import 'dart:convert';
import 'dart:io';

import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:mime/mime.dart';
import 'package:vendor/constants/api.dart';
import 'package:vendor/models/api_response.dart';
import 'package:vendor/models/order.dart';
import 'package:vendor/services/auth.service.dart';
import 'package:vendor/services/http.service.dart';
import 'package:dio/dio.dart';
import '../models/ticket_list_model.dart';
import 'package:http/http.dart' as http;
class OrderRequest extends HttpService {
  //
  Future<List<Order>> getOrders({
    int page = 1,
    String? status,
    String? type,
  }) async {
    final vendorId = (await AuthServices.getCurrentUser()).vendorId;

    final apiResult = await get(
      Api.orders,
      queryParameters: {
        "vendor_id": vendorId,
        "page": page,
        "status": status,
      },
    );
    final apiResponse = ApiResponse.fromResponse(apiResult);
    if (apiResponse.allGood) {
      return apiResponse.data.map((jsonObject) {
        return Order.fromJson(jsonObject);
      }).toList();
    } else {
      throw apiResponse.message;
    }
  }

  Future<List<Order>> getFutureOrders({
    int page = 1,
    String? status,
    String? type,
  }) async {
    final vendorId = (await AuthServices.getCurrentUser()).vendorId;

    final apiResult = await get(
      Api.futureOrders,
      queryParameters: {
        "vendor_id": vendorId,
        "page": page,
        "status": status,
      },
    );
    final apiResponse = ApiResponse.fromResponse(apiResult);
    if (apiResponse.allGood) {
      return apiResponse.data.map((jsonObject) {
        return Order.fromJson(jsonObject);
      }).toList();
    } else {
      throw apiResponse.message;
    }
  }

  //
  Future<Order> getOrderDetails({required int id}) async {
    final apiResult = await get("${Api.orders}/$id");
    //
    final apiResponse = ApiResponse.fromResponse(apiResult);
    if (apiResponse.allGood) {
      return Order.fromJson(apiResponse.body);
    } else {
      throw apiResponse.message;
    }
  }

  //
  Future<Order> updateOrder({
    required int id,
    String status = "delivered",
  }) async {
    final apiResult = await patch(
      "${Api.orders}/$id",
      {
        "status": status,
      },
    );
    //
    final apiResponse = ApiResponse.fromResponse(apiResult);
    print("response ==> ${apiResponse.body}");
    if (apiResponse.allGood) {
      return Order.fromJson(apiResponse.body["order"]);
    } else {
      throw apiResponse.message;
    }
  }

  Future<Order> cancelOrderWithNote({
    required String orderCode,
    required String note,
  }) async {
    final apiResult = await post(
      "${Api.managerOrderUpdate}/$orderCode",
      {
        "is_active": 0,
        "note": note,
      },
    );
    final apiResponse = ApiResponse.fromResponse(apiResult);
    print("Manager Order Update =====> ${apiResponse.body}");
    print("response ==> ${apiResponse.body}");
    if (apiResponse.allGood) {
      return Order.fromJson(apiResponse.body["order"]);
    } else {
      throw apiResponse.message;
    }
  }


  Future<ApiResponse> removeItemFromOrder({
    required String orderId,
    required int itemId,
    // e.g., "remove" or "itemNotAvailable"
  }) async {
    try {
      final apiResult = await post(
          "${Api.itemRemoved}/$orderId/$itemId",
          json.encode({
            "order_Id": orderId,
            "itemId": itemId
          })
      );


      final apiResponse = ApiResponse.fromResponse(apiResult);

      if (apiResponse.allGood) {
        return apiResponse;
      } else {
        throw apiResponse.message!;
      }
    } catch (e) {
      print(e);
      rethrow;
    }
  }


  Future<Order> assignOrderToDriver({
    required int id,
    required int driverId,
    required String status,
  }) async {
    final apiResult = await patch(
      "${Api.orders}/$id",
      {
        "status": status,
        "driver_id": driverId,
      },
    );
    //
    final apiResponse = ApiResponse.fromResponse(apiResult);
    if (apiResponse.allGood) {
      return Order.fromJson(apiResponse.body["order"]);
    } else {
      throw apiResponse.message;
    }
  }

  Future<Message?> replyToTicket({
    required int? ticketId,
    required String message,
    required bool isUser,
    required bool isAdmin,
    required bool isVendor,
    File? photo,
  }) async {
    try {
      // Determine the MIME type of the selected image
      String? mimeType = photo != null ? lookupMimeType(photo.path) : null;
      final userToken = await AuthServices.getAuthBearerToken();

      FormData formData = FormData.fromMap({
        'ticket_id': ticketId.toString(),
        'message': message,
        'is_user': isUser ? '1' : '0',
        'is_admin': isAdmin ? '1' : '0',
        'is_vendor': isVendor ? '1' : '0',
        if (photo != null)
          'photo': await MultipartFile.fromFile(
            photo.path,
            filename: photo.path
                .split('/')
                .last,
          ),
      });

      final response = await dio!.post(Api.ticketReply, data: formData,
        options: Options(
          headers: {
            'Authorization': 'Bearer $userToken',
          },
        ),
      );

      print('API Response: ${response.data}');

      final apiResponse = ApiResponse.fromResponse(response);

      if (apiResponse.allGood) {
        // Handle the response when no message data is returned
        if (apiResponse.data is Map<String, dynamic>) {
          return Message.fromJson(apiResponse.data as Map<String, dynamic>);
        } else if (apiResponse.data is List && apiResponse.data.isNotEmpty) {
          return Message.fromJson(apiResponse.data[0] as Map<String, dynamic>);
        } else {
          // Return null or a default Message if no actual message data is returned
          print('No message data returned from the API.');
          return null;
        }
      } else {
        throw Exception('Failed to send message');
      }
    } catch (e) {
      print("Error in replyToTicket: $e");
      rethrow;
    }
  }

  Future<List<Ticket>> getTickets() async {
    final userToken = await AuthServices.getAuthBearerToken();
    final id = await AuthServices.getCurrentUser(force: true);
    print(id.vendorId);

    try {
      // Constructing the API URL
      final url = "https://mealknight.ca/api/ticket/list?vendor_id=${id
          .vendorId}";

      // Making the GET request
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $userToken',
          'Content-Type': 'application/json',
        },
      );

      // Checking for a successful response
      if (response.statusCode == 200) {
        final apiResponse = jsonDecode(response.body);
        print("Api Response =====> $apiResponse");
        List<Ticket> tickets = [];
        for (var ticketJson in apiResponse) {
          tickets.add(Ticket.fromJson(ticketJson));
        }
        return tickets;
      } else {
        print('Failed to get tickets =====> ${response.body}');
        return [];
      }
    } catch (e) {
      print('Error fetching tickets: $e');
      rethrow;
    }
  }

  Future<void> updatePreparationTime(String status) async {
    // URL for the API request
    final url = Uri.parse(
        "https://mealknight.ca/api/increase-preparation/$status");
    final userToken = await AuthServices.getAuthBearerToken();
    try {
      // Define headers, including authorization if needed
      final headers = {
        'Authorization': 'Bearer $userToken', // Add your API token here
        'Content-Type': 'application/json',
      };

      // Make the GET request with headers
      final response = await http.get(url, headers: headers);

      // Check the status code
      if (response.statusCode == 200) {
        print("Raw Response Body===> ${response.body}");

        if (response.headers['content-type']?.contains('application/json') ==
            true) {
          final responseBody = jsonDecode(response.body);
          final message = responseBody["message"];
          print("Success Message===> $message");
        } else {
          print("Unexpected non-JSON response===> ${response.body}");
        }
      } else {
        print("Error: Received status code ${response.statusCode}");
        print("Error Body: ${response.body}");
      }
    } catch (error) {
      print("Error Message===> $error");
    }
  }
}
