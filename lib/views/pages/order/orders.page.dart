import 'package:flutter/material.dart';
import 'package:vendor/constants/app_colors.dart';
import 'package:vendor/utils/ui_spacer.dart';
import 'package:vendor/view_models/orders.vm.dart';
import 'package:vendor/widgets/base.page.dart';
import 'package:vendor/widgets/buttons/custom_button.dart';
import 'package:vendor/widgets/custom_list_view.dart';
import 'package:vendor/widgets/list_items/order.list_item.dart';
import 'package:vendor/widgets/list_items/unpaid_order.list_item.dart';
import 'package:vendor/widgets/states/error.state.dart';
import 'package:vendor/widgets/states/order.empty.dart';
import 'package:stacked/stacked.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../../constants/app_text_styles.dart';
import '../../../utils/size_utils.dart';
import '../../../utils/utils.dart';

class OrdersPage extends StatefulWidget {
  const OrdersPage({super.key});

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage>
    with AutomaticKeepAliveClientMixin<OrdersPage> {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    SizeConfigs().init(context);

    return SafeArea(
      child: ViewModelBuilder<OrdersViewModel>.reactive(
        viewModelBuilder: () => OrdersViewModel(context),
        onViewModelReady: (vm) {
          vm.initialise();
        },
        builder: (context, vm, child) {
          return BasePage(
            body: Column(
              children: [
                //
                //  "Orders".tr().text.xl2.bold.color(AppColor.appMainColor).make().p20(),
                Row(
                  children: [
                    Expanded(
                      child: Text(vm.currentVendor?.name ?? '',
                          maxLines: 5,
                          textAlign: TextAlign.end,
                          style: AppTextStyle
                              .comicNeue30BoldTextStyle(
                              color: AppColor.appMainColor))
                          .p(8)
                          .onTap(vm.openVendorProfileSwitcher),
                    ),
                    if (vm.currentUser?.hasMultipleVendors ?? false)
                      Icon(
                        Icons.swap_vert,
                        size: 20,
                        color: AppColor.appMainColor,
                      ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5.0),
                      child: Text('Orders',
                          style: AppTextStyle.comicNeue64BoldTextStyle(
                              color: AppColor.appMainColor)),
                    ),
                    InkWell(
                      onTap: () {
                        openDialog(vm);
                      },
                      child: Container(
                        padding: const EdgeInsets.fromLTRB(15, 2, 15, 2),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(width: 3, color: AppColor.appMainColor),
                        ),
                        child: Text(
                          vm.preparationStatus == "normal"
                              ? (vm.currentUser?.isOnline ?? false ? 'Open-Online' : 'Open-Normal')
                              : vm.preparationStatus == "busy"
                              ? "Busy"
                              : "Super Busy", // Dynamically change based on status
                          style: AppTextStyle.comicNeue25BoldTextStyle(
                            color: AppColor.appMainColor,
                          ),
                        ),
                      ),
                    ).px(8),
                  ],
                ),
                SizeConfigs.isTablet
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            alignment: Alignment.centerLeft,
                            margin: const EdgeInsets.only(left: 5),
                            width: SizeConfigs.screenWidth! / 2.4,
                            child: Container(
                              padding: const EdgeInsets.fromLTRB(4, 5, 4, 5),
                              width: SizeConfigs.screenWidth! / 3,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                      width: 2, color: AppColor.appMainColor)),
                              child:
                              Text(
                                  '${vm.statuses[0].name} (${vm.ordersPreparing.length})',
                                  textAlign: TextAlign.center,
                                  style: AppTextStyle.comicNeue27BoldTextStyle(
                                      color: AppColor.appMainColor)),
                            ),
                          ),
                          Container(
                            alignment: Alignment.centerLeft,
                            margin: const EdgeInsets.only(left: 20),
                            child: Container(
                              padding: const EdgeInsets.fromLTRB(4, 5, 4, 5),
                              width: SizeConfigs.screenWidth! / 3,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                      width: 2, color: AppColor.appMainColor)),
                              child: Text(
                                  '${vm.statuses[1].name} (${vm.ordersReady.length})',
                                  textAlign: TextAlign.center,
                                  style: AppTextStyle.comicNeue27BoldTextStyle(
                                      color: AppColor.appMainColor)),
                            ),
                          ),
                        ],
                      )
                    : CustomListView(
                        scrollDirection: Axis.horizontal,
                        dataSet: vm.statuses,
                        itemBuilder: (context, index) {

                          final status = vm.statuses[index];
                          print("Status ===> ${status.status}");
                          return Container(
                            // width: SizeConfigs.screenWidth!/3,
                            padding: EdgeInsets.zero,
                            alignment: Alignment.centerLeft,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                    width: status.status == vm.selectedStatus
                                        ? 4
                                        : 2,
                                    color: AppColor.appMainColor)),
                            child: CustomOrderButton(
                                title: status.name!
                                    .toLowerCase()
                                    .allWordsCapitilize(),
                                count: status.status == vm.selectedStatus
                                    ? '${vm.ordersOld.length}'
                                    : '',
                                onPressed: () =>
                                    vm.statusChanged(status.status),
                                isSelected: status.status == vm.selectedStatus,
                                elevation: 0,
                                shapeRadius: 18),
                          );
                        },
                      ).h(45).py12(),

                SizeConfigs.isTablet
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Container(
                                alignment: Alignment.topCenter,
                                margin:
                                    const EdgeInsets.only(left: 5, right: 3),
                                color: Colors.white,
                                child: CustomListView(
                                  onRefresh: vm.fetchPreparingOrders,
                                  onLoading: () {
                                    vm.fetchPreparingOrders(
                                        initialLoading: false);
                                  },
                                  isLoading: vm.isBusy,
                                  dataSet: vm.ordersPreparing,
                                  hasError: vm.hasError,
                                  errorWidget: LoadingError(
                                    onrefresh: vm.fetchPreparingOrders,
                                  ),
                                  //
                                  emptyWidget:
                                      const EmptyOrder(status: "prepared"),
                                  separatorBuilder: (context, index) =>
                                      UiSpacer.verticalSpace(space: 5),
                                  itemBuilder: (context, index) {
                                    //
                                    final order = vm.ordersPreparing[index];
                                    if (order.isUnpaid) {
                                      return UnPaidOrderListItem(order: order);
                                    }
                                    return OrderListPreparingItem(
                                      order: order,
                                      orderPressed: () =>
                                          vm.openOrderDetails(context, order),
                                      onPayPressed: () =>
                                          vm.markOrderAsReady(order),
                                    );
                                  },
                                )),
                          ),
                          VerticalDivider(
                              thickness: 1,
                              width: 1,
                              color: Colors.grey.shade300),
                          Expanded(
                            child: Container(
                                alignment: Alignment.topCenter,
                                margin:
                                    const EdgeInsets.only(right: 3, left: 5),
                                color: Colors.white,
                                child: CustomListView(
                                  onRefresh: vm.fetchReadyOrders,
                                  onLoading: () {
                                    vm.fetchReadyOrders(initialLoading: false);
                                  },
                                  isLoading: vm.isBusy,
                                  dataSet: vm.ordersReady,
                                  hasError: vm.hasError,
                                  errorWidget: LoadingError(
                                    onrefresh: vm.fetchReadyOrders,
                                  ),
                                  //
                                  emptyWidget:
                                      const EmptyOrder(status: "ready"),
                                  separatorBuilder: (context, index) =>
                                      UiSpacer.verticalSpace(space: 5),
                                  itemBuilder: (context, index) {
                                    //
                                    final order = vm.ordersReady[index];
                                    if (order.isUnpaid) {
                                      return UnPaidOrderListItem(order: order);
                                    }
                                    return OrderListReadyItem(
                                      order: order,
                                      orderPressed: () =>
                                          vm.openOrderDetails(context, order),
                                    );
                                  },
                                ),),
                          )
                        ],
                      ).py8().expand()
                    :CustomListView(
                  onRefresh: vm.fetchMyOrders,
                  onLoading: () => vm.fetchMyOrders(initialLoading: false),
                  isLoading: vm.isLoading(), // Update to use the new loading check
                  dataSet: vm.ordersOld,  // Ensure correct list is passed here
                  hasError: vm.hasError,
                  errorWidget: LoadingError(
                    onrefresh: vm.fetchMyOrders,
                  ),
                  emptyWidget: vm.ordersOld.isEmpty
                      ? const EmptyOrder() // Display when there are no orders
                      : null,
                  separatorBuilder: (context, index) => UiSpacer.verticalSpace(space: 5),
                  itemBuilder: (context, index) {
                    final order = vm.ordersOld[index];
                    if (order.isUnpaid) {
                      return UnPaidOrderListItem(order: order);
                    }
                    return vm.selectedStatus == "Preparing"
                        ? OrderListPreparingItem(
                      order: order,
                      orderPressed: () => vm.openOrderDetails(context, order),
                      onPayPressed: () => vm.markOrderAsReady(order),
                    )
                        : OrderListReadyItem(
                      order: order,
                      orderPressed: () => vm.openOrderDetails(context, order),
                    );
                  },
                ).px8().expand(),
              ],
            ),
          );
        },
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;

  void openDialog(OrdersViewModel vm) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          insetPadding: EdgeInsets.zero,
          backgroundColor: Colors.transparent,
          content: Container(
            height: SizeConfigs.isTablet
                ? SizeConfigs.longestSide! - 80
                : getLongestSide(250),
            width: SizeConfigs.isTablet
                ? SizeConfigs.longestSide! - 80
                : SizeConfigs.shortestSide!,
            padding: const EdgeInsets.fromLTRB(10, 15, 10, 0),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                border: Border.all(width: 4, color: AppColor.appMainColor)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('Status:',
                    style: AppTextStyle.comicNeue40BoldTextStyle(
                        color: AppColor.appMainColor))
                    .p8(),
                UiSpacer.verticalSpace(space: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // "On Time" will trigger the "on-time" API request
                    statusWidget("On\nTime",
                        color: AppColor.appMainColor,
                        onTap: () {
                          Navigator.pop(context);  // Close dialog
                          vm.updatePreparationTime("on-time");
                        }),
                    statusWidget("Busy\n+10 min",
                        color: AppColor.appMainColor,
                        onTap: () {
                          Navigator.pop(context);  // Close dialog
                          vm.updatePreparationTime("busy");
                        }),
                    statusWidget("Super busy\n+15 min",
                        color: AppColor.appMainColor,
                        onTap: () {
                          Navigator.pop(context);  // Close dialog
                          vm.updatePreparationTime("super-busy");
                        }),
                  ],
                ),
                const Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    statusWidget("Pause\nOrders",
                        color: AppColor.appYellowColor,
                        onTap: () => Navigator.pop(context)),
                    statusWidget("Close\nStore",
                        color: Colors.red, onTap: () => Navigator.pop(context)),
                  ],
                ),
                const Spacer(),
              ],
            ),
          ),
        );
      },
    );
  }

  statusWidget(String title, {required Color color, VoidCallback? onTap}) {
    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(width: 3, color: color)),
      width: (MediaQuery.sizeOf(context).width - Utils.navRailWidth) / 4,
      child: Text(title,
              textAlign: TextAlign.center,
              style: AppTextStyle.comicNeue25BoldTextStyle(color: color))
          .p4(),
    ).onInkTap(onTap).pOnly(right: 5);
  }
}
