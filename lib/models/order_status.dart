// To parse this JSON data, do
//
//     final orderStatus = orderStatusFromJson(jsonString);

import 'dart:convert';

OrderStatus orderStatusFromJson(String str) =>
    OrderStatus.fromJson(json.decode(str));

String orderStatusToJson(OrderStatus data) => json.encode(data.toJson());

class OrderStatus {
  OrderStatus({
    this.id,
    this.name,
    this.reason,
    this.modelType,
    this.modelId,
    this.createdAt,
    this.updatedAt,
    this.passed = true,
  });

  int? id;
  String? name;
  dynamic reason;
  String? modelType;
  int? modelId;
  DateTime? createdAt;
  DateTime? updatedAt;
  bool? passed;

  factory OrderStatus.fromJson(Map<String, dynamic> json) {
    return OrderStatus(
      id: json["id"],
      name: json["name"],
      reason: json["reason"],
      modelType: json["model_type"],
      modelId: json["model_id"],
      createdAt: json["created_at"] == null
          ? null
          : DateTime.parse(json["created_at"]),
      updatedAt: json["updated_at"] == null
          ? null
          : DateTime.parse(json["updated_at"]),
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "reason": reason,
        "passed": passed,
        "model_type": modelType,
        "model_id": modelId,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };
}
