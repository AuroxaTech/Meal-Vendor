import 'package:flutter/foundation.dart';

class OrderProductOption {
  OrderProductOption({
    required this.optionId,
    required this.quantity,
    required this.price,
    required this.title,
  });

  final int optionId;
  final int quantity;
  final double price;
  final String title;

  factory OrderProductOption.fromJson(Map<String, dynamic> json) {
    if (kDebugMode) {
      print("OrderProductOption JSON: $json");
    }

    return OrderProductOption(
      optionId: json["id"] ?? 0,
      quantity: json["qty"] != null
          ? int.tryParse(json["qty"].toString()) ?? 1
          : 1,
      price: json["price"] != null
          ? double.tryParse(json["price"].toString()) ?? 0.0
          : 0.0,
      title: json["title"] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    "id": optionId,
    "qty": quantity,
    "price": price,
    "title": title,
  };
}
