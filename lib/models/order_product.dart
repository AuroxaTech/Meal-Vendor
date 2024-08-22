import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:vendor/models/product.dart';
import 'order_product_option.dart';

class OrderProduct {
  OrderProduct({
    required this.id,
    required this.quantity,
    this.heatLevel,
    required this.price,
    required this.discountPrice,
    this.options,
    required this.orderId,
    required this.productId,
    required this.createdAt,
    required this.updatedAt,
    required this.formattedDate,
    this.product,
    required this.reviewed,
    required this.orderProductOptions,
    this.isSelected = false,
  });

  final int id;
  final int quantity;
  final int? heatLevel;
  final double price;
  final double discountPrice;
  final String? options;
  final int orderId;
  final int productId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String formattedDate;
  final Product? product;
  final bool reviewed;
  late final bool isSelected;
  final List<OrderProductOption> orderProductOptions;

  factory OrderProduct.fromJson(Map<String, dynamic> json) {
    if (kDebugMode) {
      print("JSON data: $json");
    }

    List<OrderProductOption> options = [];

    final optionsData = json['options_data'];
    if (kDebugMode) {
      print("Raw options_data: $optionsData");
    }

    if (optionsData != null) {
      try {
        // Check if options_data is a String and needs decoding
        if (optionsData is String && optionsData.isNotEmpty) {
          try {
            List<dynamic> parsedOptionsData = jsonDecode(optionsData);
            options = parsedOptionsData
                .map((data) => OrderProductOption.fromJson(data))
                .toList();
          } catch (e) {
            if (kDebugMode) {
              print("Error decoding options_data string: $e");
            }
          }
        } else if (optionsData is List) {
          // Handle if options_data is already a List
          options = optionsData
              .map((data) => OrderProductOption.fromJson(data))
              .toList();
        } else {
          if (kDebugMode) {
            print("options_data is neither String nor List.");
          }
        }
      } catch (e) {
        if (kDebugMode) {
          print("Error processing options_data: $e");
        }
      }

      if (kDebugMode && options.isNotEmpty) {
        for (var option in options) {
          print("Parsed Option: ${option.toJson()}");
        }
      }
    }

    double parsedDiscountPrice = json['product'] != null &&
        json['product']['discount_price'] != null
        ? double.tryParse(json['product']['discount_price'].toString()) ?? 0.0
        : 0.0;

    return OrderProduct(
      id: json["id"],
      reviewed: json["reviewed"] ?? false,
      quantity: int.tryParse(json["quantity"].toString()) ?? 1,
      heatLevel: json["heat_level"],
      price: double.tryParse(json["price"].toString()) ?? 0.0,
      discountPrice: parsedDiscountPrice,
      options: json["options"],
      orderId: int.tryParse(json["order_id"].toString()) ?? 0,
      productId: int.tryParse(json["product_id"].toString()) ?? 0,
      createdAt: json["created_at"] == null
          ? DateTime.now()
          : DateTime.tryParse(json["created_at"]) ?? DateTime.now(),
      updatedAt: json["updated_at"] == null
          ? DateTime.now()
          : DateTime.tryParse(json["updated_at"]) ?? DateTime.now(),
      formattedDate: json["formatted_date"] ?? '',
      product: json["product"] == null ? null : Product.fromJson(json["product"]),
      orderProductOptions: options.toList(), // Assigning the options list here
    );
  }

  Map<String, dynamic> toJson() => {

    "id": id,
    "reviewed": reviewed,
    "quantity": quantity,
    "heat_level": heatLevel,
    "price": price,
    "discount_price": discountPrice,
    "options": options,
    "order_id": orderId,
    "product_id": productId,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
    "formatted_date": formattedDate,
    "product": product?.toJson(),
    "orderProductOptions":
    orderProductOptions.map((option) => option.toJson()).toList(),
  };

  String heatLevelInfo() {
    switch (heatLevel) {
      case 0:
        return "Mild";
      case 1:
        return "Medium";
      case 2:
        return "Hot";
      default:
        return "";
    }
  }

  OrderProduct copy() {
    return OrderProduct(
      id: id,
      quantity: quantity,
      heatLevel: heatLevel,
      price: price,
      discountPrice: discountPrice,
      orderId: orderId,
      productId: productId,
      createdAt: createdAt,
      updatedAt: updatedAt,
      formattedDate: formattedDate,
      product: product,
      reviewed: reviewed,
      options: options,
      orderProductOptions: List.from(orderProductOptions),
      isSelected: isSelected,
    );
  }
}