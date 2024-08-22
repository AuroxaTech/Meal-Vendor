import 'package:flutter/material.dart';
import 'package:vendor/models/service.dart';
import 'package:vendor/requests/service.request.dart';
import 'package:vendor/services/auth.service.dart';
import 'package:vendor/view_models/base.view_model.dart';
import 'package:vendor/views/pages/service/new_service.page.dart';
import 'package:vendor/views/pages/service/service_details.page.dart';

class ServiceViewModel extends MyBaseViewModel {
  ServiceViewModel(BuildContext context) {
    viewContext = context;
  }
  final ServiceRequest _serviceRequest = ServiceRequest();
  List<Service> services = [];
  int queryPage = 1;

  void initialise() {
    fetchMyServices();
  }

  Future<void> fetchMyServices({bool initialLoading = true}) async {
    if (initialLoading) {
      queryPage = 1;
      setBusy(true);
    } else {
      queryPage += 1;
    }

    try {
      final mServices = await _serviceRequest.getServices(
        queryParams: {
          "vendor_id": await AuthServices.currentVendor?.id,
        },
        page: queryPage,
      );

      //
      if (initialLoading) {
        services = mServices;
      } else {
        services.addAll(mServices);
      }
      clearErrors();
    } catch (error) {
      print("Package Type Pricing Error ==> $error");
      setError(error);
    }

    setBusy(false);
  }

  openServiceDetails(Service service) async {
    final result = await Navigator.push(viewContext,
        MaterialPageRoute(builder: (context) => ServiceDetailsPage(service)));
    if (result != null && result) {
      services.removeWhere((e) => e.id == service.id);
    } else if (result != null && result is Service) {
      final index = services.indexWhere((e) => e.id == service.id);
      if (index >= 0) {
        services[index] = result;
      }
    }
    notifyListeners();
  }

  void newPackageTypePricing() async {
    final result = await Navigator.push(
        viewContext, MaterialPageRoute(builder: (context) => NewServicePage()));
    if (result != null) {
      fetchMyServices();
    }
  }
}
