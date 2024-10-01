import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:vendor/constants/app_routes.dart';
import 'package:vendor/models/order.dart';
import 'package:vendor/requests/order.request.dart';
import 'package:vendor/utils/size_utils.dart';
import 'package:vendor/view_models/base.view_model.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import '../models/user.dart';
import '../models/vendor.dart';
import '../services/auth.service.dart';
import '../views/pages/home.page.dart';
import '../views/pages/order/orders_details.dialog.dart';
import '../widgets/bottomsheets/vendor_switcher.bottomsheet.dart';
import 'ordersHistory.vm.dart';
//Updated Code
class OrdersViewModel extends MyBaseViewModel {
  OrdersViewModel(BuildContext context) {
    viewContext = context;
  }
  WebSocketChannel? channel;
  Timer? _timer;
  User? currentUser;
  Vendor? currentVendor;
  String preparationStatus = "normal";
  List<Order> orders = [];
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
  bool isWebSocketLoading = false;

  void initialise() async {
    currentUser = await AuthServices.getCurrentUser(force: true);
    currentVendor = await AuthServices.getCurrentVendor(force: true);
    connectWebSocket();
    await fetchPreparingOrders();
    await fetchReadyOrders();
    await fetchMyOrders();
  }
  // Connect to WebSocket server
  void connectWebSocket() {
    channel = WebSocketChannel.connect(Uri.parse('ws://15.222.4.249:3000/'));

    // Listen to WebSocket messages
    channel?.stream.listen((message) {
      Map<String, dynamic> data = jsonDecode(message);
      if (data.containsKey('order_count')) {
        // Refresh all orders (my orders, preparing orders, ready orders) without loading shimmer
        fetchMyOrders(fromWebSocket: true);
        fetchPreparingOrders(fromWebSocket: true);
        fetchReadyOrders(fromWebSocket: true);
      }
    }, onError: (error) {
      print('WebSocket error: $error');
    });

    // Refresh every 5 seconds without showing loading shimmer
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      fetchMyOrders(fromWebSocket: true);
      fetchPreparingOrders(fromWebSocket: true);
      fetchReadyOrders(fromWebSocket: true);
    });
  }
  @override
  void dispose() {
    // Dispose the WebSocket channel and the timer
    channel?.sink.close();
    _timer?.cancel();
    super.dispose();
  }


  void statusChanged(value) {
    selectedStatus = value;
    notifyListeners();
    fetchMyOrders();
  }

  Future<void> fetchPreparingOrders({bool initialLoading = true, bool fromWebSocket = false}) async {
    // Manage loading state for initial load but not for WebSocket updates
    if (initialLoading && !fromWebSocket) {
      setBusy(true);
      queryPagePreparing = 1;
    } else if (fromWebSocket) {
      // Manage a separate WebSocket loading state
      isWebSocketLoading = true;
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
      notifyListeners();
      clearErrors();
    } catch (error) {
      print("Order Error ==> $error");
      setError(error);
    }
    // Only stop the busy state if it's not a WebSocket-triggered update
    if (!fromWebSocket) {
      setBusy(false);
    } else {
      // Reset WebSocket loading state after the WebSocket call completes
      isWebSocketLoading = false;
    }
  }

  Future<void> fetchMyOrders({bool initialLoading = true, bool fromWebSocket = false}) async {
    // Manage loading state for initial load but not for WebSocket updates
    if (initialLoading && !fromWebSocket) {
      setBusy(true);
      queryPage = 1;
    } else if (fromWebSocket) {
      // Manage a separate WebSocket loading state
      isWebSocketLoading = true;
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

      notifyListeners();
      clearErrors();
    } catch (error) {
      setError(error);
    }

    // Only stop the busy state if it's not a WebSocket-triggered update
    if (!fromWebSocket) {
      setBusy(false);
    } else {
      // Reset WebSocket loading state after the WebSocket call completes
      isWebSocketLoading = false;
    }
  }

  bool isLoading() {
    // Check both regular loading and WebSocket loading
    return isBusy || isWebSocketLoading;
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
      fetchMyOrders();
      fetchReadyOrders();
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


  Future<void> fetchReadyOrders({bool initialLoading = true, bool fromWebSocket = false}) async {
    // Manage loading state for initial load but not for WebSocket updates
    if (initialLoading && !fromWebSocket) {
      setBusy(true);
      queryPageReady = 1;
    } else if (fromWebSocket) {
      // Manage a separate WebSocket loading state
      isWebSocketLoading = true;
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
      notifyListeners();
      clearErrors();
    } catch (error) {
      print("Order Error ==> $error");
      setError(error);
    }

    // Only stop the busy state if it's not a WebSocket-triggered update
    if (!fromWebSocket) {
      setBusy(false);
    } else {
      // Reset WebSocket loading state after the WebSocket call completes
      isWebSocketLoading = false;
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
