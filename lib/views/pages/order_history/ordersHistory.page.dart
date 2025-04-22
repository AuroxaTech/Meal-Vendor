import 'package:flutter/material.dart';
import 'package:vendor/constants/app_colors.dart';
import 'package:vendor/utils/ui_spacer.dart';
import 'package:vendor/widgets/base.page.dart';
import 'package:vendor/widgets/buttons/custom_button.dart';
import 'package:vendor/widgets/custom_list_view.dart';
import 'package:vendor/widgets/list_items/unpaid_order.list_item.dart';
import 'package:vendor/widgets/states/error.state.dart';
import 'package:vendor/widgets/states/order.empty.dart';
import 'package:stacked/stacked.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../../constants/app_images.dart';
import '../../../constants/app_text_styles.dart';
import '../../../utils/size_utils.dart';
import '../../../view_models/ordersHistory.vm.dart';
import '../../../widgets/list_items/orderHistory.list_item.dart';

class OrdersHistoryPage extends StatefulWidget {
  const OrdersHistoryPage({super.key});

  @override
  State<OrdersHistoryPage> createState() => _OrdersHistoryPageState();
}

class _OrdersHistoryPageState extends State<OrdersHistoryPage>
    with AutomaticKeepAliveClientMixin<OrdersHistoryPage> {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    SizeConfigs().init(context);
    return SafeArea(
      child: ViewModelBuilder<OrdersHistoryViewModel>.reactive(
        viewModelBuilder: () => OrdersHistoryViewModel(context),
        onViewModelReady: (vm) => vm.initialise(),
        builder: (context, vm, child) {
          return BasePage(
            body: VStack(
              [
                //
                //  "Orders".tr().text.xl2.bold.color(AppColor.appMainColor).make().p20(),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Orders History',
                      style: AppTextStyle.comicNeue64BoldTextStyle(
                          color: AppColor.appMainColor)),
                ),

                Container(
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.zero,
                  width: SizeConfigs.isTablet
                      ? MediaQuery.sizeOf(context).width / 2
                      : MediaQuery.sizeOf(context).width / 1.6,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(width: 2, color: AppColor.appMainColor),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                          color: Colors.black.withOpacity(0.4),
                          offset: Offset(0, 3),
                          blurRadius: 1,
                          spreadRadius: 1)
                    ],
                  ),
                  child: TextField(
                    style: AppTextStyle.comicNeue25BoldTextStyle(
                        color: AppColor.appMainColor),
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.zero,
                      hintText: "Search Here",
                      hintStyle: AppTextStyle.comicNeue25BoldTextStyle(
                          color: AppColor.appMainColor),
                      border: const OutlineInputBorder(
                        borderSide: BorderSide.none,
                      ),
                      prefixIcon: Image.asset(
                        AppImages.search,
                        height: 35,
                        width: 25,
                      ).px12(),
                    ),
                    onChanged: (value) {
                      vm.SetOrdersHistory(value);
                    },
                  ),
                ).px12().py12(),

                SizeConfigs.isTablet
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          for (StatusHistoryList status in vm.statusHistory)
                            Container(
                              alignment: Alignment.centerLeft,
                              margin: const EdgeInsets.only(left: 5, right: 5),
                              child: Container(
                                padding: const EdgeInsets.fromLTRB(4, 5, 4, 5),
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(15),
                                    border: Border.all(
                                        width:
                                            status.status == vm.selectedStatus
                                                ? 4
                                                : 2,
                                        color: AppColor.appMainColor),
                                    boxShadow: <BoxShadow>[
                                      BoxShadow(
                                          color: Colors.black.withOpacity(0.4),
                                          offset: const Offset(0, 3),
                                          blurRadius: 1,
                                          spreadRadius: 1)
                                    ]),
                                child: CustomButton(
                                  title: status.name!
                                      .toLowerCase()
                                      .allWordsCapitilize(),
                                  onPressed: () =>
                                      vm.statusChanged(status.status),
                                  isSelected:
                                      status.status == vm.selectedStatus,
                                  elevation: 0,
                                  shapeRadius: 20,
                                ),
                              ),
                            ),
                        ],
                      )
                    : CustomListView(
                        scrollDirection: Axis.horizontal,
                        dataSet: vm.statusHistory,
                        padding:
                            const EdgeInsets.symmetric(horizontal: Vx.dp12),
                        itemBuilder: (context, index) {
                          final status = vm.statusHistory[index];
                          return Container(
                              alignment: Alignment.centerLeft,
                              margin: const EdgeInsets.all(3),
                              child: Container(
                                padding: const EdgeInsets.fromLTRB(4, 0, 4, 0),
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(15),
                                    border: Border.all(
                                        width:
                                            status.status == vm.selectedStatus
                                                ? 4
                                                : 2,
                                        color: AppColor.appMainColor),
                                    boxShadow: <BoxShadow>[
                                      BoxShadow(
                                          color: Colors.black.withOpacity(0.4),
                                          offset: const Offset(0, 3),
                                          blurRadius: 1,
                                          spreadRadius: 1)
                                    ]),
                                child: CustomButton(
                                  title: status.name!
                                      .toLowerCase()
                                      .allWordsCapitilize(),
                                  onPressed: () =>
                                      vm.statusChanged(status.status),
                                  isSelected:
                                      status.status == vm.selectedStatus,
                                  elevation: 0,
                                  shapeRadius: 20,
                                ),
                              ));
                        },
                      ).h(48).py4(),

                UiSpacer.verticalSpace(space: 10),

                CustomListView(
                  padding: const EdgeInsets.symmetric(horizontal: Vx.dp12),
                  onRefresh: vm.fetchMyOrdersHistory,
                  onLoading: () =>
                      vm.fetchMyOrdersHistory(initialLoading: false),
                  isLoading: vm.isBusy,
                  dataSet: vm.searchOrders,
                  hasError: vm.hasError,
                  errorWidget: LoadingError(
                    onrefresh: vm.fetchMyOrdersHistory,
                  ),
                  //
                  emptyWidget: EmptyOrder(status: vm.selectedStatus),
                  separatorBuilder: (context, index) =>
                      UiSpacer.verticalSpace(space: 5),
                  itemBuilder: (context, index) {
                    //
                    final order = vm.searchOrders[index];
                    if (order.isUnpaid) {
                      return UnPaidOrderListItem(order: order);
                    }
                    return OrderHistoryListItem(
                      order: order,
                      orderPressed: () => vm.openOrderDetail(context, order),
                    );
                  },
                ).expand(),
              ],
            ),
          );
        },
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
