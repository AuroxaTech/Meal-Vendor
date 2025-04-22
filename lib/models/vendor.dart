import 'dart:convert';

import 'package:dartx/dartx.dart';
import 'package:vendor/models/category.dart';
import 'package:vendor/models/delivery_address.dart';
import 'package:vendor/models/delivery_slot.dart';
import 'package:vendor/models/menu.dart';
import 'package:vendor/models/package_type_pricing.dart';
import 'package:vendor/models/vendor_type.dart';
import 'package:random_string/random_string.dart';
//

class Vendor {
  Vendor({
    required this.id,
    required this.vendorType,
    required this.name,
    required this.description,
    required this.baseDeliveryFee,
    required this.deliveryFee,
    required this.deliveryRange,
    required this.tax,
    required this.phone,
    required this.email,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.comission,
    required this.pickup,
    required this.delivery,
    required this.rating,
    required this.chargePerKm,
    required this.isOpen,
    required this.isActive,
    required this.logo,
    required this.featureImage,
    this.menus = const [],
    this.categories = const [],
    this.packageTypesPricing = const [],
    this.cities = const [],
    this.states = const [],
    this.countries = const [],
    this.deliverySlots = const [],
    this.commission,
    this.vendorTypeId,
    this.autoAssignment,
    this.autoAccept,
    this.hasSubCategories,
    //this.minOrder,
    //this.maxOrder,
    this.hasDrivers,
    this.minPrepareTime,
    this.maxPrepareTime,
    this.extraPrepareTime,
    this.deliveryTime,
    this.inOrder,
    this.featured,
    this.deliveryBag,
    this.pizzaBag,
    this.servingRight,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.creatorId,
    this.reviewsCount,
    this.formattedDate,
    this.isPackageVendor,
    this.isFavourite,
    this.age,
    this.completedOrders,
    this.failedOrders,
    this.fees,
    this.days,
    required this.canRate,
    required this.allowScheduleOrder,
    required this.hasSubcategories,
    required this.useSubscription,
    required this.hasSubscription,
    required this.prepareTime,
    this.documentRequested = false,
    this.pendingDocumentApproval = false,
  }) {
    heroTag = "${randomAlphaNumeric(15)}$id";
  }

  int id;
  String name;
  String description;
  double baseDeliveryFee;
  double deliveryFee;
  double? deliveryRange;
  String tax;
  String phone;
  String email;
  String? address;
  String? latitude;
  String? longitude;
  double? comission;
  int pickup;
  int delivery;
  int chargePerKm;
  bool isOpen;
  VendorType? vendorType;
  String? heroTag;
  int rating;
  int isActive;
  String logo;
  String featureImage;
  List<Menu> menus;
  List<Category> categories;
  List<PackageTypePricing> packageTypesPricing;
  List<DeliverySlot> deliverySlots;
  List<String> cities;
  List<String> states;
  List<String> countries;
  bool canRate;
  bool allowScheduleOrder;
  bool hasSubcategories;
  bool useSubscription;
  bool hasSubscription;
  String prepareTime = '';
  bool documentRequested;
  bool pendingDocumentApproval;

  int? commission;
  int? vendorTypeId;
  int? autoAssignment;
  int? autoAccept;
  bool? hasSubCategories;

  //int? minOrder;
  //int? maxOrder;
  int? hasDrivers;
  int? minPrepareTime;
  int? maxPrepareTime;
  int? extraPrepareTime;
  String? deliveryTime;
  int? inOrder;
  int? featured;
  String? deliveryBag;
  String? pizzaBag;
  String? servingRight;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;
  int? creatorId;
  int? reviewsCount;
  String? formattedDate;
  int? isPackageVendor;
  bool? isFavourite;
  String? age;
  int? completedOrders;
  int? failedOrders;
  List<dynamic>? fees;
  List<dynamic>? days;

  factory Vendor.fromRawJson(String str) => Vendor.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Vendor.fromJson(Map<String, dynamic> json) {
    print("Vendor Details ====> ${json.toString()}");
    return Vendor(
      id: json["id"],
      vendorType: json["vendor_type"] == null
          ? null
          : VendorType.fromJson(json["vendor_type"]),
      name: json["name"],
      description: json["description"],
      baseDeliveryFee: json["base_delivery_fee"] == null
          ? 0.00
          : double.parse(json["base_delivery_fee"].toString()),
      deliveryFee: json["delivery_fee"] == null
          ? 0.00
          : double.parse(json["delivery_fee"].toString()),
      deliveryRange: json["delivery_range"] == null
          ? null
          : double.parse(json["delivery_range"].toString()),
      tax: json["tax"],
      phone: json["phone"],
      email: json["email"],
      address: json["address"],
      latitude: json["latitude"],
      longitude: json["longitude"],
      comission: json["comission"] == null
          ? null
          : double.parse(json["comission"].toString()),
      pickup: json["pickup"] == null ? 0 : int.parse(json["pickup"].toString()),
      delivery:
          json["delivery"] == null ? 0 : int.parse(json["delivery"].toString()),
      rating: int.tryParse(json["rating"].toString()) ?? 0,
      chargePerKm: json["charge_per_km"] == null
          ? 0
          : int.parse(json["charge_per_km"].toString()),
      isOpen: json["is_open"] ?? true,
      isActive: json["is_active"] == null
          ? 0
          : int.parse(json["is_active"].toString()),

      logo: json["logo"],
      featureImage: json["feature_image"],
      menus: json["menus"] == null
          ? []
          : List<Menu>.from(json["menus"].map((x) => Menu.fromJson(x))),
      categories: json["categories"] == null
          ? []
          : List<Category>.from(
              json["categories"].map((x) => Category.fromJson(x))),
      packageTypesPricing: json["package_types_pricing"] == null
          ? []
          : List<PackageTypePricing>.from(json["package_types_pricing"]
              .map((x) => PackageTypePricing.fromJson(x))),
      //cities
      cities: json["cities"] == null
          ? []
          : List<String>.from(json["cities"].map((e) => e["name"])),
      states: json["states"] == null
          ? []
          : List<String>.from(json["states"].map((e) => e["name"])),
      countries: json["cities"] == null
          ? []
          : List<String>.from(json["countries"].map((e) => e["name"])),
      //
      deliverySlots: json["slots"] == null
          ? []
          : List<DeliverySlot>.from(
              json["slots"].map((x) => DeliverySlot.fromJson(x))),

      prepareTime: json['prepare_time'] ??
          "${(null != json['min_prepare_time'] && null != json['max_prepare_time']) ? "${json['min_prepare_time']} - ${json['max_prepare_time']}" : '0'}",
      canRate: json["can_rate"],
      hasSubcategories: json["has_sub_categories"] ?? false,
      allowScheduleOrder: json["allow_schedule_order"] ?? false,
      hasSubscription: json["has_subscription"] ?? false,
      useSubscription: json["use_subscription"] ?? false,
      documentRequested: json["document_requested"] ?? false,
      pendingDocumentApproval: json["pending_document_approval"] ?? false,

      commission: json['commission'],
      vendorTypeId: json['vendor_type_id'],
      autoAssignment: json['auto_assignment'],
      autoAccept: json['auto_accept'],
      hasSubCategories: json['has_sub_categories'],
      //minOrder:json['min_order'],
      //maxOrder:json['max_order'],
      hasDrivers: json['has_drivers'],
      minPrepareTime: json['min_prepare_time'],
      maxPrepareTime: json['max_prepare_time'],
      extraPrepareTime: json['extra_prepare_time'],
      deliveryTime: json['delivery_time'],
      inOrder: json['in_order'],
      featured: json['featured'],
      deliveryBag: json['delivery_bag'] == 1 ? 'Verified' : 'Not Verified',
      pizzaBag: json['pizza_bag'] == 1 ? 'Verified' : 'Not Verified',
      servingRight: json['serving_right'] == 1 ? 'Verified' : 'Not Verified',
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      deletedAt: json['deleted_at'],
      creatorId: json['creator_id'],
      reviewsCount: json['reviews_count'],
      formattedDate: json['formatted_date'],
      isPackageVendor: json['is_package_vendor'],
      isFavourite: json['is_favourite'],
      age: json['age'],
      completedOrders: json['completed_orders'],
      failedOrders: json['failed_orders'],
      fees: json['fees'] ?? [],
      days: json['days'] ?? [],
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "description": description,
        "base_delivery_fee": baseDeliveryFee,
        "prepare_time": prepareTime,
        "delivery_fee": deliveryFee,
        "delivery_range": deliveryRange,
        "tax": tax,
        "phone": phone,
        "email": email,
        "address": address,
        "latitude": latitude,
        "longitude": longitude,
        "comission": comission,
        "pickup": pickup,
        "delivery": delivery,
        "rating": rating,
        "charge_per_km": chargePerKm,
        "is_open": isOpen,
        "is_active": isActive,
        "logo": logo,
        "feature_image": featureImage,
        "can_rate": canRate,
        "allow_schedule_order": allowScheduleOrder,
        "vendor_type": vendorType?.toJson(),
        "menus": List<dynamic>.from(menus.map((x) => x.toJson())),
        "categories": List<dynamic>.from(categories.map((x) => x.toJson())),
        "package_types_pricing":
            List<dynamic>.from(packageTypesPricing.map((x) => x.toJson())),
        "slots": List<dynamic>.from(deliverySlots.map((x) => x.toJson())),
        'has_subscription': hasSubscription,
        'use_subscription': useSubscription,
        "document_requested": documentRequested,
        "pending_document_approval": pendingDocumentApproval,
        'commission': commission,
        'vendor_type_id': vendorTypeId,
        'auto_assignment': autoAssignment,
        'auto_accept': autoAccept,
        'has_sub_categories': hasSubCategories,
        //'min_order':minOrder,
        //'max_order':maxOrder,
        'has_drivers': hasDrivers,
        'min_prepare_time': minPrepareTime,
        'max_prepare_time': maxPrepareTime,
        'extra_prepare_time': extraPrepareTime,
        'delivery_time': deliveryTime,
        'in_order': inOrder,
        'featured': featured,
        'delivery_bag': deliveryBag,
        'pizza_bag': pizzaBag,
        'serving_right': servingRight,
        'created_at': createdAt,
        'updated_at': updatedAt,
        'deleted_at': deletedAt,
        'creator_id': creatorId,
        'reviews_count': reviewsCount,
        'formatted_date': formattedDate,
        'fees': fees,
        'days': days,
        'is_package_vendor': isPackageVendor,
        'is_favourite': isFavourite,
        'age': age,
        'completed_orders': completedOrders,
        'failed_orders': failedOrders,
      };

  //
  bool get allowOnlyDelivery => delivery == 1 && pickup == 0;

  bool get allowOnlyPickup => delivery == 0 && pickup == 1;

  bool get isPackageType {
    return (vendorType != null && vendorType?.slug == "parcel");
  }

  bool get isServiceType {
    return (vendorType != null && vendorType?.slug == "service");
  }

  //
  bool canServiceLocation(DeliveryAddress deliveryaddress) {
    //cities,states & countries
    final foundCountry = countries.firstOrNullWhere(
      (element) =>
          element.toLowerCase() == deliveryaddress.country.toLowerCase(),
    );
    if (foundCountry != null) {
      return true;
    }
    //states
    final foundState = states.firstOrNullWhere(
      (element) => element.toLowerCase() == deliveryaddress.state.toLowerCase(),
    );
    if (foundState != null) {
      print("state found");
      return true;
    }
    //cities
    final foundCity = this.cities.firstOrNullWhere(
      (element) {
        return element.toLowerCase() == deliveryaddress.city.toLowerCase();
      },
    );
    if (foundCity != null) {
      print("city found");
      return true;
    }
    return false;
  }
}
