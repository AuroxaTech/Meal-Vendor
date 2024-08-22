import 'package:flutter/material.dart';
import 'package:vendor/constants/app_colors.dart';
import 'package:vendor/utils/ui_spacer.dart';
import 'package:vendor/widgets/base.page.dart';
import 'package:vendor/widgets/custom_list_view.dart';
import 'package:vendor/widgets/list_items/orderFuture.list_item.dart';
import 'package:vendor/widgets/list_items/unpaid_order.list_item.dart';
import 'package:vendor/widgets/states/error.state.dart';
import 'package:vendor/widgets/states/order.empty.dart';
import 'package:stacked/stacked.dart';
import 'package:velocity_x/velocity_x.dart';
import '../../../constants/app_text_styles.dart';
import '../../../utils/size_utils.dart';
import '../../../view_models/ordersFuture.vm.dart';

class OrdersFuturePage extends StatefulWidget {
  const OrdersFuturePage({super.key});

  @override
  State<OrdersFuturePage> createState() => _OrdersFuturePageState();
}

class _OrdersFuturePageState extends State<OrdersFuturePage>
    with AutomaticKeepAliveClientMixin<OrdersFuturePage> {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    SizeConfigs().init(context);
    return SafeArea(
      child: ViewModelBuilder<OrdersFutureViewModel>.reactive(
        viewModelBuilder: () => OrdersFutureViewModel(context),
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
                    Text(
                        SizeConfigs.isTablet
                            ? 'Future Orders'
                            : 'Future\nOrders',
                        style: AppTextStyle.comicNeue55BoldTextStyle(
                            color: AppColor.appMainColor)),
                    Container(
                      padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(
                              width: 3, color: AppColor.appMainColor)),
                      child: Text('Request Driver',
                          maxLines: 2,
                          textAlign: TextAlign.center,
                          style: AppTextStyle.comicNeue25BoldTextStyle(
                              color: AppColor.appMainColor)),
                    ).onInkTap(() => vm.openDriverRequest(context, vm)),
                  ],
                ).p8(),

                UiSpacer.verticalSpace(),

                CustomListView(
                  onRefresh: vm.fetchMyFutureOrders,
                  onLoading: () =>
                      vm.fetchMyFutureOrders(initialLoading: false),
                  isLoading: vm.isBusy,
                  dataSet: vm.orders,
                  hasError: vm.hasError,
                  errorWidget: LoadingError(
                    onrefresh: vm.fetchMyFutureOrders,
                  ),
                  emptyWidget: const EmptyOrder(status: ""),
                  separatorBuilder: (context, index) =>
                      UiSpacer.verticalSpace(space: 5),
                  itemBuilder: (context, index) {
                    //
                    final order = vm.orders[index];
                    if (order.isUnpaid) {
                      return UnPaidOrderListItem(order: order);
                    }
                    return OrderFutureListItem(
                      order: order,
                      orderPressed: () => vm.openOrderDetails(order),
                    );
                  },
                ).px20().expand(),
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
