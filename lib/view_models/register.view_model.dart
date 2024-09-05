import 'dart:io';

import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:vendor/extensions/string.dart';
import 'package:vendor/models/vendor_type.dart';
import 'package:vendor/requests/auth.request.dart';
import 'package:vendor/requests/vendor_type.request.dart';
import 'package:vendor/services/alert.service.dart';
import 'package:vendor/services/geocoder.service.dart';
import 'package:vendor/traits/qrcode_scanner.trait.dart';
import 'package:vendor/utils/utils.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import '../services/geocoder_service.dart';
import 'base.view_model.dart';

class RegisterViewModel extends MyBaseViewModel with QrcodeScannerTrait {
  //the textediting controllers
  TextEditingController nameTEC = TextEditingController();
  TextEditingController bEmailTEC = TextEditingController();
  TextEditingController bPhoneTEC = TextEditingController();
  TextEditingController passwordTEC = TextEditingController();
  TextEditingController addressTEC = TextEditingController();
  List<VendorType> vendorTypes = [];
  List<File> selectedDocuments = [];
  bool hidePassword = true;
  Country? selectedVendorCountry;
  Country? selectedCountry;
  int? selectedVendorTypeId;

  //
  String? address;
  String? latitude;
  String? longitude;

  //
  final AuthRequest _authRequest = AuthRequest();
  final VendorTypeRequest _vendorTypeRequest = VendorTypeRequest();

  RegisterViewModel(BuildContext context) {
    viewContext = context;
    selectedVendorCountry = Country.parse("us");
    selectedCountry = Country.parse("us");
  }

  void initialise() async {
    fetchVendorTypes();
    String countryCode = await Utils.getCurrentCountryCode();
    selectedCountry = Country.parse(countryCode);
    selectedVendorCountry = Country.parse(countryCode);
    notifyListeners();
  }

  Future<List<Address>> searchAddress(String keyword) async {
    if (keyword.length < 4) {
      return [];
    }

    List<Address> addresses = [];
    try {
      // Since findAddressesFromQuery returns a List<Address>, just assign it directly
      addresses = await GeocoderService().findAddressesFromQuery(keyword);
    } catch (error) {
      toastError("$error");
    }

    return addresses;
  }

  onAddressSelected(Address address) async {
    print("Place Id ===> ${address.placeId}");

    // Check if the address has a place_id
    if (address.placeId != null) {
      try {
        // Fetch full address details from the place_id
        Address fullAddress = await GeocoderService().getAddressDetails(address.placeId!);

        // Set the full address details including latitude and longitude
        this.address = fullAddress.addressLine;
        latitude = fullAddress.coordinates?.latitude.toString();
        longitude = fullAddress.coordinates?.longitude.toString();
        addressTEC.text = fullAddress.addressLine ?? "";

        print("Lat Lng ===> $latitude, $longitude");

        notifyListeners();
      } catch (error) {
        toastError("Failed to fetch address details: $error");
        print("Adress Details Error ====> Failed to fetch address details: $error");
      }
    } else {
      toastError("Selected address does not have a place ID");
    }
  }

  fetchVendorTypes() async {
    setBusyForObject(vendorTypes, true);
    try {
      vendorTypes = await _vendorTypeRequest.index();
      vendorTypes = vendorTypes
          .where(
            (e) => !e.slug.toLowerCase().contains("taxi"),
          )
          .toList();
    } catch (error) {
      toastError("$error");
    }
    setBusyForObject(vendorTypes, false);
  }

  showCountryDialPicker([bool vendorPhone = false]) {
    showCountryPicker(
      context: viewContext,
      showPhoneCode: true,
      onSelect: (value) => countryCodeSelected(value, vendorPhone),
    );
  }

  countryCodeSelected(Country country, bool vendorPhone) {
    if (vendorPhone) {
      selectedVendorCountry = country;
    } else {
      selectedCountry = country;
    }
    notifyListeners();
  }

  changeSelectedVendorType(int? vendorTypeId) {
    selectedVendorTypeId = vendorTypeId;
    notifyListeners();
  }

  void onDocumentsSelected(List<File> documents) {
    selectedDocuments = documents;
    notifyListeners();
  }

  void processLogin() async {
    // Validate returns true if the form is valid, otherwise false.
    if (formBuilderKey.currentState!.saveAndValidate()) {
      //

      Map<String, dynamic> params =
          Map.from(formBuilderKey.currentState!.value);
      String phone = params['phone'].toString().telFormat();
      params["phone"] = "+${selectedCountry?.phoneCode}${phone}";
      String vPhone = params['vendor_phone'].toString().telFormat();
      params["vendor_phone"] = "+${selectedVendorCountry?.phoneCode}${vPhone}";
      //add address and coordinates
      params["address"] = address;
      params["latitude"] = latitude;
      params["longitude"] = longitude;
      setBusy(true);
      print("Signup Params ====> ${params}");
      try {
        final apiResponse = await _authRequest.registerRequest(
          vals: params,
          docs: selectedDocuments,
        );
        if (apiResponse.allGood) {
          await AlertService.success(
            title: "Become a partner".tr(),
            text: "${apiResponse.message}",
          );
          //
        } else {
          toastError("${apiResponse.message}");
        }
      } catch (error) {
        toastError("$error");
      }
      setBusy(false);
    }
  }
}
