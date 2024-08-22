import 'package:flutter/material.dart';
import 'package:vendor/constants/app_colors.dart';
import 'package:vendor/utils/ui_spacer.dart';
import 'package:vendor/view_models/orders.vm.dart';
import 'package:vendor/widgets/base.page.dart';
import 'package:vendor/widgets/buttons/custom_button.dart';
import 'package:vendor/widgets/custom_list_view.dart';
import 'package:stacked/stacked.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../constants/app_text_styles.dart';
import '../../../utils/size_utils.dart';
import '../../../utils/utils.dart';

class OrdersOldPage extends StatefulWidget {
  const OrdersOldPage({super.key});

  @override
  State<OrdersOldPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersOldPage>
    with AutomaticKeepAliveClientMixin<OrdersOldPage> {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    SizeConfigs().init(context);
    return SafeArea(
      child: ViewModelBuilder<OrdersViewModel>.reactive(
        viewModelBuilder: () => OrdersViewModel(context),
        onViewModelReady: (vm) => vm.initialise(),
        builder: (context, vm, child) {
          return BasePage(
            body: VStack(
              [
                //
                //  "Orders".tr().text.xl2.bold.color(AppColor.appMainColor).make().p20(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('Orders',
                          style: AppTextStyle.comicNeue64BoldTextStyle(
                              color: AppColor.appMainColor)),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        SizedBox(
                          width: (MediaQuery.sizeOf(context).width -
                                  Utils.navRailWidth) /
                              2,
                          child: Text(vm.currentUser?.name ?? '',
                                  maxLines: 5,
                                  textAlign: TextAlign.end,
                                  style: AppTextStyle.comicNeue30BoldTextStyle(
                                      color: AppColor.appMainColor))
                              .p(10),
                        ),
                        InkWell(
                          onTap: () {
                            openDialog();
                          },
                          child: Container(
                            padding: const EdgeInsets.fromLTRB(15, 2, 15, 2),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(30),
                                border: Border.all(
                                    width: 3, color: AppColor.appMainColor)),
                            child: Text(
                                vm.currentUser?.isOnline ?? false
                                    ? 'Open-Online'
                                    : 'Open-Normal',
                                style: AppTextStyle.comicNeue25BoldTextStyle(
                                    color: AppColor.appMainColor)),
                          ),
                        ),
                      ],
                    ).px8(),
                  ],
                ),

                CustomListView(
                  scrollDirection: Axis.horizontal,
                  dataSet: vm.statusesOld,
                  padding: const EdgeInsets.symmetric(horizontal: Vx.dp20),
                  itemBuilder: (context, index) {
                    //
                    final status = vm.statusesOld[index];
                    //
                    return Container(
                      padding: const EdgeInsets.all(1),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(
                              width: status == vm.selectedStatus ? 4 : 2,
                              color: AppColor.appMainColor)),
                      child: CustomButton(
                          title: status.toLowerCase().tr().allWordsCapitilize(),
                          count: status == vm.selectedStatus
                              ? '${vm.ordersOld.length}'
                              : '',
                          onPressed: () => vm.statusChanged(status),
                          isSelected: status == vm.selectedStatus,
                          elevation: 0,
                          shapeRadius: 18),
                    );
                  },
                ).h(50).py12(),
                UiSpacer.verticalSpace(),
                //

                //
                // CustomListView(
                //   canRefresh: true,
                //   canPullUp: true,
                //   refreshController: vm.refreshController,
                //   onRefresh: vm.fetchMyOrders,
                //   onLoading: () => vm.fetchMyOrders(initialLoading: false),
                //   isLoading: vm.isBusy,
                //   dataSet: vm.orders,
                //   hasError: vm.hasError,
                //   errorWidget: LoadingError(
                //     onrefresh: vm.fetchMyOrders,
                //   ),
                //   //
                //   emptyWidget: EmptyOrder(),
                //   separatorBuilder: (context, index) =>
                //       UiSpacer.verticalSpace(space: 5),
                //   itemBuilder: (context, index) {
                //     //
                //     final order = vm.orders[index];
                //     if (order.isUnpaid) {
                //       return UnPaidOrderListItem(order: order);
                //     }
                //     return OrderListItem(
                //       order: order,
                //       orderPressed: () => vm.openOrderDetails(context,order),
                //     );
                //   },
                // ).px20().expand(),
              ],
            ),
          );
        },
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;

  void openDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.transparent,
          content: Container(
            height: getLongestSide(210),
            padding: const EdgeInsets.fromLTRB(15, 15, 15, 0),
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
                  children: [
                    Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(
                              width: 3, color: AppColor.appMainColor)),
                      width: SizeConfigs.isTablet
                          ? (MediaQuery.sizeOf(context).width -
                                  Utils.navRailWidth) /
                              4
                          : (MediaQuery.sizeOf(context).width -
                                  Utils.navRailWidth) /
                              5,
                      height: getLongestSide(60),
                      child: Text('On\nTime',
                              style: AppTextStyle.comicNeue25BoldTextStyle(
                                  color: AppColor.appMainColor))
                          .p4(),
                    ).pOnly(right: 10),
                    Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(
                              width: 3, color: AppColor.appMainColor)),
                      width: SizeConfigs.isTablet
                          ? (MediaQuery.sizeOf(context).width -
                                  Utils.navRailWidth) /
                              4
                          : (MediaQuery.sizeOf(context).width -
                                  Utils.navRailWidth) /
                              5,
                      height: getLongestSide(60),
                      child: Text('Busy\n+10 min',
                              style: AppTextStyle.comicNeue25BoldTextStyle(
                                  color: AppColor.appMainColor))
                          .p4(),
                    ).pOnly(right: 10),
                    Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(
                              width: 3, color: AppColor.appMainColor)),
                      width: SizeConfigs.isTablet
                          ? (MediaQuery.sizeOf(context).width -
                                  Utils.navRailWidth) /
                              4
                          : (MediaQuery.sizeOf(context).width -
                                  Utils.navRailWidth) /
                              5,
                      height: getLongestSide(60),
                      child: Text('Super busy\n+15 min',
                              style: AppTextStyle.comicNeue25BoldTextStyle(
                                  color: AppColor.appMainColor))
                          .p4(),
                    ),
                  ],
                ),
                const Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Spacer(),
                    const Spacer(),
                    Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(
                              width: 3, color: AppColor.appYellowColor)),
                      width: SizeConfigs.isTablet
                          ? (MediaQuery.sizeOf(context).width -
                                  Utils.navRailWidth) /
                              4
                          : (MediaQuery.sizeOf(context).width -
                                  Utils.navRailWidth) /
                              5,
                      height: getLongestSide(60),
                      child: Text('Pause\nOrders',
                              style: AppTextStyle.comicNeue25BoldTextStyle(
                                  color: AppColor.appYellowColor))
                          .p4(),
                    ).pOnly(right: 5),
                    const Spacer(),
                    Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(width: 3, color: Colors.red)),
                      width: SizeConfigs.isTablet
                          ? (MediaQuery.sizeOf(context).width -
                                  Utils.navRailWidth) /
                              4
                          : (MediaQuery.sizeOf(context).width -
                                  Utils.navRailWidth) /
                              5,
                      height: getLongestSide(60),
                      child: Text('Close\nStore',
                              style: AppTextStyle.comicNeue25BoldTextStyle(
                                  color: Colors.red))
                          .p4(),
                    ).pOnly(right: 5),
                    const Spacer(),
                    const Spacer(),
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
}
