import 'dart:convert';

ProductCategory productCategoryFromJson(String str) =>
    ProductCategory.fromJson(json.decode(str));

String productCategoryToJson(ProductCategory data) =>
    json.encode(data.toJson());

class ProductCategory {
  ProductCategory({
    required this.id,
    required this.categoryId,
    required this.name,
    required this.photo,
  });

  int id;
  int? categoryId;
  String name;
  String photo;

  factory ProductCategory.fromJson(Map<String, dynamic> json) =>
      ProductCategory(
        id: json["id"],
        categoryId: json["category_id"],
        name: json["name"],
        photo: json["photo"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "category_id": categoryId,
        "name": name,
        "photo": photo,
      };
}
