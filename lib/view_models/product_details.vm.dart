import 'package:dartx/dartx.dart';
import 'package:flutter/material.dart';
import 'package:vendor/models/option.dart';
import 'package:vendor/models/option_group.dart';
import 'package:vendor/models/product.dart';
import 'package:vendor/requests/product.request.dart';
import 'package:vendor/view_models/base.view_model.dart';
import 'package:vendor/constants/app_strings.dart';

class ProductDetailsViewModel extends MyBaseViewModel {
  //
  ProductDetailsViewModel(BuildContext context, this.product) {
    this.viewContext = context;
    updatedSelectedQty(1);
  }

  //
  ProductRequest productRequest = ProductRequest();

  //
  Product product;
  List<Option> selectedProductOptions = [];
  List<int> selectedProductOptionsIDs = [];
  double subTotal = 0.0;
  double total = 0.0;
  final currencySymbol = AppStrings.currencySymbol;

  //
  void getProductDetails() async {
    //
    setBusyForObject(product, true);

    try {
      product = await productRequest.getProductDetails(product.id);
      clearErrors();
      calculateTotal();
    } catch (error) {
      setError(error);
    }
    setBusyForObject(product, false);
  }

  //
  isOptionSelected(Option option) {
    return selectedProductOptionsIDs.contains(option.id);
  }

  //
  toggleOptionSelection(OptionGroup optionGroup, Option option) {
    //
    if (selectedProductOptionsIDs.contains(option.id)) {
      selectedProductOptionsIDs.remove(option.id);
      selectedProductOptions.remove(option);
    } else {
      //if it allows only one selection
      if (optionGroup.multiple == 0) {
        //
        final foundOption = selectedProductOptions.firstOrNullWhere(
          (option) => option.optionGroupId == optionGroup.id,
        );
        if (foundOption != null) {
          selectedProductOptionsIDs.remove(foundOption.id);
          selectedProductOptions.remove(foundOption);
        }
      }

      selectedProductOptionsIDs.add(option.id);
      selectedProductOptions.add(option);
    }

    //
    calculateTotal();
  }

  //
  updatedSelectedQty(int qty) async {
    product.selectedQty = qty;
    calculateTotal();
  }

  //
  calculateTotal() {
    //
    double productPrice =
        !product.showDiscount ? product.price : product.discountPrice;

    //
    double totalOptionPrice = 0.0;
    for (var option in selectedProductOptions) {
      totalOptionPrice += option.price;
    }

    //
    subTotal = productPrice + totalOptionPrice;
    total = subTotal * (product.selectedQty);
    notifyListeners();
  }
}
