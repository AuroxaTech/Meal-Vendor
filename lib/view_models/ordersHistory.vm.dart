import 'dart:async';

import 'package:flutter/material.dart';
import 'package:vendor/constants/app_routes.dart';
import 'package:vendor/models/order.dart';
import 'package:vendor/requests/order.request.dart';
import 'package:vendor/services/app.service.dart';
import 'package:vendor/view_models/base.view_model.dart';
import 'package:vendor/views/pages/order_history/orders_HistoryDetails.dialog.dart';
import 'package:url_launcher/url_launcher_string.dart';
import '../services/auth.service.dart';

class StatusHistoryList {
  String? name;
  String? status;

  StatusHistoryList({this.name, this.status});
}

class OrdersHistoryViewModel extends MyBaseViewModel {
  OrdersHistoryViewModel(BuildContext context) {
    this.viewContext = context;
  }

  OrderRequest orderRequest = OrderRequest();
  List<Order> ordersMain = [];
  List<Order> searchOrders = [];

  List<StatusHistoryList> statusHistory = [
    StatusHistoryList(name: "All Orders", status: 'All Orders'),
    StatusHistoryList(name: "Delivered", status: 'Delivered'),
    StatusHistoryList(name: "Cancelled", status: 'Cancelled'),
  ];

  String selectedStatus = "All Orders";
  int queryPage = 1;
  StreamSubscription? refreshOrderStream;

  void initialise() async {
    await AuthServices.getCurrentUser(force: true);
    refreshOrderStream = AppService().refreshAssignedOrders.listen((refresh) {
      if (refresh) {
        fetchMyOrdersHistory();
      }
    });

    await fetchMyOrdersHistory();
  }

  dispose() {
    super.dispose();
    refreshOrderStream?.cancel();
  }

  //
  void statusChanged(value) {
    selectedStatus = value;
    notifyListeners();
    fetchMyOrdersHistory();
  }

  Future<void> fetchMyOrdersHistory({bool initialLoading = true}) async {
    if (initialLoading) {
      setBusy(true);
      ordersMain.clear();
      queryPage = 1;
    } else {
      queryPage++;
    }

    try {
      final mOrders = await orderRequest.getOrders(
        page: queryPage,
        status:
            selectedStatus == "All Orders" ? "" : selectedStatus.toLowerCase(),
      );
      ordersMain.addAll(mOrders);

      searchOrders = ordersMain;
      clearErrors();
    } catch (error) {
      print("Order Error ==> $error");
      setError(error);
    }

    setBusy(false);
  }

  SetOrdersHistory(String searchText) async {
    try {
      if (searchText.isEmpty) {
        searchOrders = ordersMain;
      } else {
        searchOrders = ordersMain
            .where((element) => element.user.name
                .toLowerCase()
                .contains(searchText.toLowerCase()))
            .toList();
      }
      notifyListeners();
    } catch (error) {
      print("Order Error ==> $error");
      setError(error);
    }

    setBusy(false);
  }

  //
  openPaymentPage(Order order) async {
    launchUrlString(order.paymentLink);
  }

  openOrderDetails(Order order) async {
    debugPrint('openOrderDetails called');
    final result = await Navigator.of(viewContext).pushNamed(
      AppRoutes.orderDetailsRoute,
      arguments: order,
    );

    //
    if (result != null && result is Order) {
      final orderIndex = ordersMain.indexWhere((e) => e.id == result.id);
      ordersMain[orderIndex] = result;
      notifyListeners();
    } else if (result != null && result is bool) {
      fetchMyOrdersHistory();
    }
  }

  void openOrderDetail(BuildContext context, Order order) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return
            //   AlertDialog(
            //   insetPadding: EdgeInsets.zero,
            //   backgroundColor: Colors.transparent,
            //   content: OrderDetailsDialog(order: order),
            // );

            AlertDialog(
          insetPadding: EdgeInsets.zero,
          backgroundColor: Colors.transparent,
          content: OrderHistoryDetailsDialog(order: order),
        );
      },
    );
  }

  void openLogin() async {
    await Navigator.of(viewContext).pushNamed(AppRoutes.loginRoute);
    notifyListeners();
    fetchMyOrdersHistory();
  }
}
