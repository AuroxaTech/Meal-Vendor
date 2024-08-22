class AllProduct {
  int? currentPage;
  List<Data>? data;
  String? firstPageUrl;
  int? from;
  int? lastPage;
  String? lastPageUrl;
  List<Links>? links;
  String? nextPageUrl;
  String? path;
  int? perPage;
  String? prevPageUrl;
  int? to;
  int? total;

  AllProduct(
      {this.currentPage,
        this.data,
        this.firstPageUrl,
        this.from,
        this.lastPage,
        this.lastPageUrl,
        this.links,
        this.nextPageUrl,
        this.path,
        this.perPage,
        this.prevPageUrl,
        this.to,
        this.total});

  AllProduct.fromJson(Map<String, dynamic> json) {
    currentPage = json['current_page'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(Data.fromJson(v));
      });
    }
    firstPageUrl = json['first_page_url'];
    from = json['from'];
    lastPage = json['last_page'];
    lastPageUrl = json['last_page_url'];
    if (json['links'] != null) {
      links = <Links>[];
      json['links'].forEach((v) {
        links!.add(Links.fromJson(v));
      });
    }
    nextPageUrl = json['next_page_url'];
    path = json['path'];
    perPage = json['per_page'];
    prevPageUrl = json['prev_page_url'];
    to = json['to'];
    total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['current_page'] = currentPage;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['first_page_url'] = firstPageUrl;
    data['from'] = from;
    data['last_page'] = lastPage;
    data['last_page_url'] = lastPageUrl;
    if (links != null) {
      data['links'] = links!.map((v) => v.toJson()).toList();
    }
    data['next_page_url'] = nextPageUrl;
    data['path'] = path;
    data['per_page'] = perPage;
    data['prev_page_url'] = prevPageUrl;
    data['to'] = to;
    data['total'] = total;
    return data;
  }
}

class Data {
  int? id;
  String? name;
  String? sku;
  String? barcode;
  String? description;
  int? price;
  int? discountPrice;
  String? capacity;
  String? unit;
  String? packageCount;
  int? availableQty;
  int? featured;
  int? deliverable;
  int? isActive;
  int? plusOption;
  int? digital;
  bool? ageRestricted;
  int? vendorId;
  int? inOrder;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;
  int? reviewsCount;
  String? formattedDate;
  int? sellPrice;
  String? photo;
  bool? isFavourite;
  int? rating;
  List<dynamic>? optionGroups;
  List<String>? photos;
  List<dynamic>? digitalFiles;
  String? token;
  Vendor? vendor;
  List<dynamic>? tags;
  List<Categories>? categories;
  List<dynamic>? subCategories;
  List<dynamic>? menus;
  String? favourite;

  Data(
      {this.id,
        this.name,
        this.sku,
        this.barcode,
        this.description,
        this.price,
        this.discountPrice,
        this.capacity,
        this.unit,
        this.packageCount,
        this.availableQty,
        this.featured,
        this.deliverable,
        this.isActive,
        this.plusOption,
        this.digital,
        this.ageRestricted,
        this.vendorId,
        this.inOrder,
        this.createdAt,
        this.updatedAt,
        this.deletedAt,
        this.reviewsCount,
        this.formattedDate,
        this.sellPrice,
        this.photo,
        this.isFavourite,
        this.rating,
        this.optionGroups,
        this.photos,
        this.digitalFiles,
        this.token,
        this.vendor,
        this.tags,
        this.categories,
        this.subCategories,
        this.menus,
        this.favourite});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    sku = json['sku'];
    barcode = json['barcode'];
    description = json['description'];
    price = json['price'];
    discountPrice = json['discount_price'];
    capacity = json['capacity'];
    unit = json['unit'];
    packageCount = json['package_count'];
    availableQty = json['available_qty'];
    featured = json['featured'];
    deliverable = json['deliverable'];
    isActive = json['is_active'];
    plusOption = json['plus_option'];
    digital = json['digital'];
    ageRestricted = json['age_restricted'];
    vendorId = json['vendor_id'];
    inOrder = json['in_order'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
    reviewsCount = json['reviews_count'];
    formattedDate = json['formatted_date'];
    sellPrice = json['sell_price'];
    photo = json['photo'];
    isFavourite = json['is_favourite'];
    rating = json['rating'];
    if (json['option_groups'] != null) {
      optionGroups = <dynamic>[];
      json['option_groups'].forEach((v) {
        optionGroups!.add(v);
      });
    }
    photos = json['photos'].cast<String>();
    if (json['digital_files'] != null) {
      digitalFiles = <dynamic>[];
      json['digital_files'].forEach((v) {
        digitalFiles!.add(v);
      });
    }
    token = json['token'];
    vendor =
    json['vendor'] != null ? Vendor.fromJson(json['vendor']) : null;
    if (json['tags'] != null) {
      tags = <dynamic>[];
      json['tags'].forEach((v) {
        tags!.add(v);
      });
    }
    if (json['categories'] != null) {
      categories = <Categories>[];
      json['categories'].forEach((v) {
        categories!.add(Categories.fromJson(v));
      });
    }
    if (json['sub_categories'] != null) {
      subCategories = <dynamic>[];
      json['sub_categories'].forEach((v) {
        subCategories!.add(v);
      });
    }
    if (json['menus'] != null) {
      menus = <dynamic>[];
      json['menus'].forEach((v) {
        menus!.add(v);
      });
    }
    favourite = json['favourite'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['sku'] = sku;
    data['barcode'] = barcode;
    data['description'] = description;
    data['price'] = price;
    data['discount_price'] = discountPrice;
    data['capacity'] = capacity;
    data['unit'] = unit;
    data['package_count'] = packageCount;
    data['available_qty'] = availableQty;
    data['featured'] = featured;
    data['deliverable'] = deliverable;
    data['is_active'] = isActive;
    data['plus_option'] = plusOption;
    data['digital'] = digital;
    data['age_restricted'] = ageRestricted;
    data['vendor_id'] = vendorId;
    data['in_order'] = inOrder;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['deleted_at'] = deletedAt;
    data['reviews_count'] = reviewsCount;
    data['formatted_date'] = formattedDate;
    data['sell_price'] = sellPrice;
    data['photo'] = photo;
    data['is_favourite'] = isFavourite;
    data['rating'] = rating;
    if (optionGroups != null) {
      data['option_groups'] =
          optionGroups!.map((v) => v.toJson()).toList();
    }
    data['photos'] = photos;
    if (digitalFiles != null) {
      data['digital_files'] =
          digitalFiles!.map((v) => v.toJson()).toList();
    }
    data['token'] = token;
    if (vendor != null) {
      data['vendor'] = vendor!.toJson();
    }
    if (tags != null) {
      data['tags'] = tags!.map((v) => v.toJson()).toList();
    }
    if (categories != null) {
      data['categories'] = categories!.map((v) => v.toJson()).toList();
    }
    if (subCategories != null) {
      data['sub_categories'] =
          subCategories!.map((v) => v.toJson()).toList();
    }
    if (menus != null) {
      data['menus'] = menus!.map((v) => v.toJson()).toList();
    }
    data['favourite'] = favourite;
    return data;
  }
}

class Vendor {
  int? id;
  String? name;
  String? description;
  int? baseDeliveryFee;
  int? deliveryFee;
  int? deliveryRange;
  String? tax;
  String? phone;
  String? email;
  String? address;
  String? latitude;
  String? longitude;
  int? commission;
  int? pickup;
  int? delivery;
  int? isActive;
  int? chargePerKm;
  bool? isOpen;
  int? vendorTypeId;
  int? autoAssignment;
  int? autoAccept;
  bool? allowScheduleOrder;
  bool? hasSubCategories;
  String? minOrder;
  int? maxOrder;
  bool? useSubscription;
  int? hasDrivers;
  String? prepareTime;
  int? minPrepareTime;
  int? maxPrepareTime;
  String? deliveryTime;
  int? inOrder;
  int? featured;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;
  int? creatorId;
  int? reviewsCount;
  String? formattedDate;
  String? logo;
  String? featureImage;
  int? rating;
  bool? canRate;
  List<dynamic>? slots;
  int? isPackageVendor;
  bool? hasSubscription;
  bool? documentRequested;
  bool? pendingDocumentApproval;
  String? isFavourite;
  VendorType? vendorType;
  List<dynamic>? fees;
  List<dynamic>? days;

  Vendor(
      {this.id,
        this.name,
        this.description,
        this.baseDeliveryFee,
        this.deliveryFee,
        this.deliveryRange,
        this.tax,
        this.phone,
        this.email,
        this.address,
        this.latitude,
        this.longitude,
        this.commission,
        this.pickup,
        this.delivery,
        this.isActive,
        this.chargePerKm,
        this.isOpen,
        this.vendorTypeId,
        this.autoAssignment,
        this.autoAccept,
        this.allowScheduleOrder,
        this.hasSubCategories,
        this.minOrder,
        this.maxOrder,
        this.useSubscription,
        this.hasDrivers,
        this.prepareTime,
        this.minPrepareTime,
        this.maxPrepareTime,
        this.deliveryTime,
        this.inOrder,
        this.featured,
        this.createdAt,
        this.updatedAt,
        this.deletedAt,
        this.creatorId,
        this.reviewsCount,
        this.formattedDate,
        this.logo,
        this.featureImage,
        this.rating,
        this.canRate,
        this.slots,
        this.isPackageVendor,
        this.hasSubscription,
        this.documentRequested,
        this.pendingDocumentApproval,
        this.isFavourite,
        this.vendorType,
        this.fees,
        this.days});

  Vendor.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    baseDeliveryFee = json['base_delivery_fee'];
    deliveryFee = json['delivery_fee'];
    deliveryRange = json['delivery_range'];
    tax = json['tax'];
    phone = json['phone'];
    email = json['email'];
    address = json['address'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    commission = json['commission'];
    pickup = json['pickup'];
    delivery = json['delivery'];
    isActive = json['is_active'];
    chargePerKm = json['charge_per_km'];
    isOpen = json['is_open'];
    vendorTypeId = json['vendor_type_id'];
    autoAssignment = json['auto_assignment'];
    autoAccept = json['auto_accept'];
    allowScheduleOrder = json['allow_schedule_order'];
    hasSubCategories = json['has_sub_categories'];
    minOrder = json['min_order'];
    maxOrder = json['max_order'];
    useSubscription = json['use_subscription'];
    hasDrivers = json['has_drivers'];
    prepareTime = json['prepare_time'];
    minPrepareTime = json['min_prepare_time'];
    maxPrepareTime = json['max_prepare_time'];
    deliveryTime = json['delivery_time'];
    inOrder = json['in_order'];
    featured = json['featured'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
    creatorId = json['creator_id'];
    reviewsCount = json['reviews_count'];
    formattedDate = json['formatted_date'];
    logo = json['logo'];
    featureImage = json['feature_image'];
    rating = json['rating'];
    canRate = json['can_rate'];
    if (json['slots'] != null) {
      slots = <dynamic>[];
      json['slots'].forEach((v) {
        slots!.add(v);
      });
    }
    isPackageVendor = json['is_package_vendor'];
    hasSubscription = json['has_subscription'];
    documentRequested = json['document_requested'];
    pendingDocumentApproval = json['pending_document_approval'];
    isFavourite = json['is_favourite'];
    vendorType = json['vendor_type'] != null
        ? VendorType.fromJson(json['vendor_type'])
        : null;
    if (json['fees'] != null) {
      fees = <dynamic>[];
      json['fees'].forEach((v) {
        fees!.add(v);
      });
    }
    if (json['days'] != null) {
      days = <dynamic>[];
      json['days'].forEach((v) {
        days!.add(v);
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['description'] = description;
    data['base_delivery_fee'] = baseDeliveryFee;
    data['delivery_fee'] = deliveryFee;
    data['delivery_range'] = deliveryRange;
    data['tax'] = tax;
    data['phone'] = phone;
    data['email'] = email;
    data['address'] = address;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    data['commission'] = commission;
    data['pickup'] = pickup;
    data['delivery'] = delivery;
    data['is_active'] = isActive;
    data['charge_per_km'] = chargePerKm;
    data['is_open'] = isOpen;
    data['vendor_type_id'] = vendorTypeId;
    data['auto_assignment'] = autoAssignment;
    data['auto_accept'] = autoAccept;
    data['allow_schedule_order'] = allowScheduleOrder;
    data['has_sub_categories'] = hasSubCategories;
    data['min_order'] = minOrder;
    data['max_order'] = maxOrder;
    data['use_subscription'] = useSubscription;
    data['has_drivers'] = hasDrivers;
    data['prepare_time'] = prepareTime;
    data['min_prepare_time'] = minPrepareTime;
    data['max_prepare_time'] = maxPrepareTime;
    data['delivery_time'] = deliveryTime;
    data['in_order'] = inOrder;
    data['featured'] = featured;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['deleted_at'] = deletedAt;
    data['creator_id'] = creatorId;
    data['reviews_count'] = reviewsCount;
    data['formatted_date'] = formattedDate;
    data['logo'] = logo;
    data['feature_image'] = featureImage;
    data['rating'] = rating;
    data['can_rate'] = canRate;
    if (slots != null) {
      data['slots'] = slots!.map((v) => v.toJson()).toList();
    }
    data['is_package_vendor'] = isPackageVendor;
    data['has_subscription'] = hasSubscription;
    data['document_requested'] = documentRequested;
    data['pending_document_approval'] = pendingDocumentApproval;
    data['is_favourite'] = isFavourite;
    if (vendorType != null) {
      data['vendor_type'] = vendorType!.toJson();
    }
    if (fees != null) {
      data['fees'] = fees!.map((v) => v.toJson()).toList();
    }
    if (days != null) {
      data['days'] = days!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class VendorType {
  int? id;
  String? name;
  String? color;
  String? description;
  String? slug;
  int? isActive;
  int? inOrder;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;
  String? formattedDate;
  String? logo;
  String? websiteHeader;
  int? hasBanners;

  VendorType(
      {this.id,
        this.name,
        this.color,
        this.description,
        this.slug,
        this.isActive,
        this.inOrder,
        this.createdAt,
        this.updatedAt,
        this.deletedAt,
        this.formattedDate,
        this.logo,
        this.websiteHeader,
        this.hasBanners});

  VendorType.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    color = json['color'];
    description = json['description'];
    slug = json['slug'];
    isActive = json['is_active'];
    inOrder = json['in_order'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
    formattedDate = json['formatted_date'];
    logo = json['logo'];
    websiteHeader = json['website_header'];
    hasBanners = json['has_banners'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['color'] = color;
    data['description'] = description;
    data['slug'] = slug;
    data['is_active'] = isActive;
    data['in_order'] = inOrder;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['deleted_at'] = deletedAt;
    data['formatted_date'] = formattedDate;
    data['logo'] = logo;
    data['website_header'] = websiteHeader;
    data['has_banners'] = hasBanners;
    return data;
  }
}

class Categories {
  int? id;
  String? name;
  int? isActive;
  int? vendorTypeId;
  String? color;
  int? inOrder;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;
  String? formattedDateTime;
  String? formattedDate;
  String? formattedUpdatedDate;
  String? photo;
  Pivot? pivot;
  VendorType? vendorType;

  Categories(
      {this.id,
        this.name,
        this.isActive,
        this.vendorTypeId,
        this.color,
        this.inOrder,
        this.createdAt,
        this.updatedAt,
        this.deletedAt,
        this.formattedDateTime,
        this.formattedDate,
        this.formattedUpdatedDate,
        this.photo,
        this.pivot,
        this.vendorType});

  Categories.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    isActive = json['is_active'];
    vendorTypeId = json['vendor_type_id'];
    color = json['color'];
    inOrder = json['in_order'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
    formattedDateTime = json['formatted_date_time'];
    formattedDate = json['formatted_date'];
    formattedUpdatedDate = json['formatted_updated_date'];
    photo = json['photo'];
    pivot = json['pivot'] != null ? Pivot.fromJson(json['pivot']) : null;
    vendorType = json['vendor_type'] != null
        ? VendorType.fromJson(json['vendor_type'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['is_active'] = isActive;
    data['vendor_type_id'] = vendorTypeId;
    data['color'] = color;
    data['in_order'] = inOrder;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['deleted_at'] = deletedAt;
    data['formatted_date_time'] = formattedDateTime;
    data['formatted_date'] = formattedDate;
    data['formatted_updated_date'] = formattedUpdatedDate;
    data['photo'] = photo;
    if (pivot != null) {
      data['pivot'] = pivot!.toJson();
    }
    if (vendorType != null) {
      data['vendor_type'] = vendorType!.toJson();
    }
    return data;
  }
}

class Pivot {
  int? productId;
  int? categoryId;

  Pivot({this.productId, this.categoryId});

  Pivot.fromJson(Map<String, dynamic> json) {
    productId = json['product_id'];
    categoryId = json['category_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['product_id'] = productId;
    data['category_id'] = categoryId;
    return data;
  }
}

class Links {
  String? url;
  String? label;
  bool? active;

  Links({this.url, this.label, this.active});

  Links.fromJson(Map<String, dynamic> json) {
    url = json['url'];
    label = json['label'];
    active = json['active'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['url'] = url;
    data['label'] = label;
    data['active'] = active;
    return data;
  }
}
