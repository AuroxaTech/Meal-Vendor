import 'dart:async';

import 'package:flutter/material.dart';
import 'package:vendor/constants/app_routes.dart';
import 'package:vendor/models/order.dart';
import 'package:vendor/requests/order.request.dart';
import 'package:vendor/services/app.service.dart';
import 'package:vendor/view_models/base.view_model.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../services/auth.service.dart';
import '../views/pages/order_future/request_driver.dialog.dart';

class OrdersFutureViewModel extends MyBaseViewModel {
  OrdersFutureViewModel(BuildContext context) {
    viewContext = context;
  }

  OrderRequest orderRequest = OrderRequest();
  List<Order> orders = [];
  int queryPage = 1;
  StreamSubscription? refreshOrderStream;

  void initialise() async {
    await AuthServices.getCurrentUser(force: true);
    refreshOrderStream = AppService().refreshAssignedOrders.listen((refresh) {
      if (refresh) {
        fetchMyFutureOrders();
      }
    });

    await fetchMyFutureOrders();
  }

  dispose() {
    super.dispose();
    refreshOrderStream?.cancel();
  }

  void statusChanged(value) {
    notifyListeners();
    fetchMyFutureOrders();
  }

  Future<void> fetchMyFutureOrders({bool initialLoading = true}) async {
    if (initialLoading) {
      setBusy(true);
      queryPage = 1;
    } else {
      queryPage++;
    }

    try {
      final mOrders = await orderRequest.getFutureOrders(
        page: queryPage,
        status: '',
      );
      if (!initialLoading) {
        orders.addAll(mOrders);
      } else {
        orders = mOrders;
      }
      clearErrors();
    } catch (error) {
      print("Order Error ==> $error");
      setError(error);
    }

    setBusy(false);
  }

  openPaymentPage(Order order) async {
    launchUrlString(order.paymentLink);
  }

  void openDriverRequest(
      BuildContext context, OrdersFutureViewModel viewModel) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: EdgeInsets.zero,
          insetPadding: EdgeInsets.zero,
          backgroundColor: Colors.transparent,
          content: RequestDriverDialog(viewModel: viewModel),
        );
      },
    );
  }

  openOrderDetails(Order order) async {
    final result = await Navigator.of(viewContext).pushNamed(
      AppRoutes.orderDetailsRoute,
      arguments: order,
    );

    if (result != null && result is Order) {
      final orderIndex = orders.indexWhere((e) => e.id == result.id);
      orders[orderIndex] = result;
      notifyListeners();
    } else if (result != null && result is bool) {
      fetchMyFutureOrders();
    }
  }

  void openLogin() async {
    await Navigator.of(viewContext).pushNamed(AppRoutes.loginRoute);
    notifyListeners();
    fetchMyFutureOrders();
  }
}
