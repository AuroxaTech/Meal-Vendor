import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:vendor/constants/app_routes.dart';
import 'package:vendor/models/product.dart';
import 'package:vendor/requests/product.request.dart';
import 'package:vendor/view_models/base.view_model.dart';
import 'package:vendor/views/pages/product/edit_product.page.dart';
import 'package:vendor/views/pages/product/new_product.page.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../models/product_category.dart';
import '../models/vendor.dart';
import '../requests/vendor.request.dart';
import '../services/auth.service.dart';

class ProductViewModel extends MyBaseViewModel {
  ProductViewModel(BuildContext context) {
    viewContext = context;
  }

  VendorRequest vendorRequest = VendorRequest();
  ProductRequest productRequest = ProductRequest();
  List<Product> products = [];

  //List<ProductCategory> allCategories = [];
  int queryPage = 1;
  String keyword = "";
  int menuId = -1;

  String selectedStatus = "All Product";
  Vendor? vendor;

  void initialise() {
    getCurrentVendorDetails();
    fetchMyProducts();
  }

  void statusChanged(value) {
    selectedStatus = value;
    notifyListeners();
    fetchMyProducts();
  }

  void statusCategories(value) {
    menuId = value;
    notifyListeners();
    fetchMyProducts();
  }

  void getCurrentVendorDetails() async {
    Vendor? currentVendor = await AuthServices.getCurrentVendor(force: true);
    if (null != currentVendor) {
      try {
        vendor = await vendorRequest.vendorDetails(
          currentVendor.id,
          params: {
            "type": "small",
          },
        );
        notifyListeners();
        clearErrors();
      } catch (error) {
        setError(error);
        if (kDebugMode) {
          print("error ==> $error");
        }
      }
    }
  }

  fetchMyProducts({bool initialLoading = true}) async {
    if (initialLoading) {
      setBusy(true);
      queryPage = 1;
    } else {
      queryPage++;
    }

    try {
      final mProducts = await productRequest.getProducts(
          page: queryPage,
          keyword: keyword == "All Product" ? "" : keyword.toLowerCase(),
          categoriesId: menuId < 0 ? '' : '?menu_id=$menuId');
      if (!initialLoading) {
        products.addAll(mProducts);
      } else {
        products = mProducts;
      }
      /*
      allCategories.clear();
      for (var element in products) {
        for (var categoriesElement in element.categories) {
          if (!allCategories.contains(categoriesElement)) {
            allCategories.add(categoriesElement);
          }
        }
      }
       */
      clearErrors();
    } catch (error) {
      print("Product Error ==> $error");
      setError(error);
    }

    setBusy(false);
  }

  //
  productSearch(String value) {
    keyword = value;
    fetchMyProducts();
  }

  //
  openProductDetails(Product product) {
    Navigator.of(viewContext).pushNamed(
      AppRoutes.productDetailsRoute,
      arguments: product,
    );
  }

  void newProduct() async {
    final result = await Navigator.push(
        viewContext,
        MaterialPageRoute(
          builder: (context) => const NewProductPage(),
        ));
    //
    if (result != null) {
      fetchMyProducts();
    }
  }

  editProduct(Product product) async {
    //
    final result = await Navigator.push(viewContext,
        MaterialPageRoute(builder: (context) => EditProductPage(product)));
    if (result != null) {
      fetchMyProducts();
    }
  }

  changeProductStatus(Product product) {
    //
    CoolAlert.show(
      context: viewContext,
      type: CoolAlertType.confirm,
      title: "Status Update".tr(),
      text:
          "${"Are you sure you want to".tr()} ${(product.isActive != 1 ? "Activate" : "Deactivate").tr()} ${product.name}?",
      onConfirmBtnTap: () {
        //
        Navigator.pop(viewContext);
        processStatusUpdate(product);
      },
    );
  }

  processStatusUpdate(Product product) async {
    //
    product.isActive = product.isActive == 1 ? 0 : 1;
    //
    setBusyForObject(product.id, true);
    try {
      final apiResponse = await productRequest.updateDetails(
        product,
      );
      //
      if (apiResponse.allGood) {
        fetchMyProducts();
      }
      //show dialog to present state
      CoolAlert.show(
        context: viewContext,
        type: apiResponse.allGood ? CoolAlertType.success : CoolAlertType.error,
        title: "Status Update".tr(),
        text: apiResponse.message,
      );
      clearErrors();
    } catch (error) {
      print("Update Status Package Type Pricing Error ==> $error");
      setError(error);
    }
    setBusyForObject(product.id, false);
  }

  //

  deleteProduct(Product product) {
    CoolAlert.show(
      context: viewContext,
      type: CoolAlertType.confirm,
      title: "Delete Product".tr(),
      text: "${"Are you sure you want to delete".tr()} ${product.name}?",
      onConfirmBtnTap: () {
        Navigator.pop(viewContext);
        processDeletion(product);
      },
    );
  }

  onUpdateProductAvailability(
      {required Product product,
      required bool isAvailable,
      int? minutes}) async {
    setBusyForObject(product.id, true);
    try {
      final apiResponse = await productRequest.updateProductAvailability(
          product,
          isAvailable: isAvailable,
          availableInMinutes: minutes);
      if (apiResponse.allGood) {
        //update UI
      }
      clearErrors();
    } catch (error) {
      print("onUnAvailable product Error ==> $error");
      setError(error);
    }
    setBusyForObject(product.id, false);
  }

  processDeletion(Product product) async {
    //
    setBusyForObject(product.id, true);
    try {
      final apiResponse = await productRequest.deleteProduct(
        product,
      );
      //
      if (apiResponse.allGood) {
        products.removeWhere((element) => element.id == product.id);
      }
      //show dialog to present state
      CoolAlert.show(
        context: viewContext,
        type: apiResponse.allGood ? CoolAlertType.success : CoolAlertType.error,
        title: "Delete Product".tr(),
        text: apiResponse.message,
      );
      clearErrors();
    } catch (error) {
      print("delete product Error ==> $error");
      setError(error);
    }
    setBusyForObject(product.id, false);
  }
}
