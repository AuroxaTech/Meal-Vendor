import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:vendor/constants/app_routes.dart';
import 'package:vendor/models/order.dart';
import 'package:vendor/requests/order.request.dart';
import 'package:vendor/services/app.service.dart';
import 'package:vendor/utils/size_utils.dart';
import 'package:vendor/view_models/base.view_model.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:velocity_x/velocity_x.dart';

import '../models/user.dart';
import '../models/vendor.dart';
import '../services/auth.service.dart';
import '../views/pages/home.page.dart';
import '../views/pages/order/orders.page.dart';
import '../views/pages/order/orders_details.dialog.dart';
import '../widgets/bottomsheets/vendor_switcher.bottomsheet.dart';
import 'ordersHistory.vm.dart';

class OrdersViewModel extends MyBaseViewModel {
  OrdersViewModel(BuildContext context) {
    viewContext = context;
  }



  User? currentUser;
  Vendor? currentVendor;
  String preparationStatus = "normal";

  OrderRequest orderRequest = OrderRequest();
  List<Order> ordersOld = [];
  List<Order> ordersPreparing = [];
  List<Order> ordersReady = [];
  String selectedStatus = "Preparing";

  List<StatusHistoryList> statuses = [
    StatusHistoryList(name: "In kitchen", status: 'Preparing'),
    StatusHistoryList(name: "Ready", status: 'Ready'),
  ];
  List<String> statusesOld = [
    'All Orders',
    'Pending',
    'Scheduled',
    'Preparing',
    'Enroute',
    'Failed',
    'Cancelled',
    'Delivered'
  ];

  int queryPagePreparing = 1;
  int queryPage = 1;
  int queryPageReady = 1;
  bool isPreparing = false;
  bool isReady = false;
  StreamSubscription? refreshOrderStream;

  void initialise() async {
    currentUser = await AuthServices.getCurrentUser(force: true);
    currentVendor = await AuthServices.getCurrentVendor(force: true);
    refreshOrderStream = AppService().refreshAssignedOrders.listen((refresh) {
      if (refresh) {
        if (SizeConfigs.isTablet) {
          fetchPreparingOrders();
          fetchReadyOrders();
        } else {
          fetchMyOrders();
        }
      }
    });
    //if (SizeConfigs.isTablet) {
    await fetchPreparingOrders();
    await fetchReadyOrders();
    //} else {
    await fetchMyOrders();
    //}
  }

  dispose() {
    super.dispose();
    refreshOrderStream?.cancel();
  }

  //
  void statusChanged(value) {
    selectedStatus = value;
    notifyListeners();
    fetchMyOrders();
  }

  Future<void> fetchPreparingOrders({bool initialLoading = true}) async {
    if (initialLoading) {
      setBusy(true);
      queryPagePreparing = 1;
    } else {
      queryPagePreparing++;
    }

    try {
      final mOrders = await orderRequest.getOrders(
        page: queryPagePreparing,
        status: 'preparing',
      );

      if (!initialLoading) {
        ordersPreparing.addAll(mOrders);
      } else {
        ordersPreparing = mOrders;
      }
      isPreparing = true;
      clearErrors();
    } catch (error) {
      print("Order Error ==> $error");
      setError(error);
    }

    if (isPreparing && isReady) setBusy(false);
  }

  Future<void> fetchMyOrders({bool initialLoading = true}) async {
    if (initialLoading) {
      setBusy(true);
      queryPage = 1;
    } else {
      queryPage++;
    }

    try {
      final mOrders = await orderRequest.getOrders(
        page: queryPage,
        status: selectedStatus.lowerCamelCase,
      );

      if (!initialLoading) {
        ordersOld.addAll(mOrders);
      } else {
        ordersOld = mOrders;
      }
      clearErrors();
    } catch (error) {
      if (kDebugMode) {
        print("Order Error ==> $error");
      }
      setError(error);
    }
    setBusy(false);
  }
  Future<void> updatePreparationTime(String status) async {
    setBusy(true);
    try {
      await orderRequest.updatePreparationTime(status); // Call the method from OrderRequest
      // Update the preparationStatus based on the selected time
      preparationStatus = status == "on-time"
          ? "normal"
          : status == "busy"
          ? "busy"
          : "super-busy";
      notifyListeners(); // Notify UI to update

      viewContext.showToast(
        msg: "Vendor preparation time updated successfully",
        bgColor: Colors.green,
      );
    } catch (error) {
      viewContext.showToast(
        msg: "Failed to update preparation time: $error",
        bgColor: Colors.red,
      );
    }
    setBusy(false);
  }


  Future<void> fetchReadyOrders({bool initialLoading = true}) async {
    if (initialLoading) {
      setBusy(true);
      queryPageReady = 1;
    } else {
      queryPageReady++;
    }

    try {
      final mOrders = await orderRequest.getOrders(
        page: queryPageReady,
        status: 'ready',
      );
      if (!initialLoading) {
        ordersReady.addAll(mOrders);
      } else {
        ordersReady = mOrders;
      }

      isReady = true;
      clearErrors();
    } catch (error) {
      if (kDebugMode) {
        print("Order Error ==> $error");
      }
      setError(error);
    }

    if (isPreparing && isReady) {
      setBusy(false);
    }
  }

  cancelOrderWithNote(Order order, String note) async {
    setBusy(true);
    try {
      order = await orderRequest.cancelOrderWithNote(
        orderCode: order.code,
        note: note,
      );
      await fetchPreparingOrders();
      await fetchReadyOrders();
      await fetchMyOrders();
      clearErrors();
    } catch (error) {
      print("Error ==> $error");
      setErrorForObject(order, error);
      viewContext.showToast(
        msg: "$error",
        bgColor: Colors.red,
      );
    }
    setBusy(false);
  }


  removeItem(orderId, itemId,context) async {
    setBusy(true);
    try {
      var order = await orderRequest.removeItemFromOrder(
        orderId: orderId,
        itemId: itemId,
      );
      print(order);
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage()),);
      await fetchPreparingOrders();
      await fetchReadyOrders();
      await fetchMyOrders();
      clearErrors();
    } catch (error) {
      print("Error ==> $error");
      viewContext.showToast(
        msg: "$error",
        bgColor: Colors.red,
      );
    }
    setBusy(false);
  }

  markOrderAsReady(Order order) async {
    setBusy(true);
    try {
      order = await orderRequest.updateOrder(
        id: order.id,
        status: "ready",
      );
      await fetchPreparingOrders();
      await fetchReadyOrders();
      await fetchMyOrders();
      clearErrors();
    } catch (error) {
      print("Error ==> $error");
      setErrorForObject(order, error);
      viewContext.showToast(
        msg: "$error",
        bgColor: Colors.red,
      );
    }
    setBusy(false);
  }

  //
  openPaymentPage(Order order) async {
    launchUrlString(order.paymentLink);
  }

  openOrderDetails(BuildContext context, Order order) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        var jsonData = order.toJson();
        print("Full Order Data: ${jsonEncode(jsonData)}");
        return AlertDialog(
          insetPadding: EdgeInsets.zero,
          backgroundColor: Colors.transparent,
          content:
              OrderDetailsDialog(order: order,
                  onCancel: cancelOrderWithNote,

              ),
        );
      },
    );
  }

  void openLogin() async {
    await Navigator.of(viewContext).pushNamed(AppRoutes.loginRoute);
    notifyListeners();
    if (SizeConfigs.isTablet) {
      fetchPreparingOrders();
      fetchReadyOrders();
    } else {
      fetchMyOrders();
    }
  }

  openVendorProfileSwitcher() async {
    if (currentUser?.hasMultipleVendors ?? false) {
      await showModalBottomSheet(
        context: viewContext,
        builder: (context) {
          return const VendorSwitcherBottomSheetView();
        },
      );
    }
  }
}
