import 'package:flutter/material.dart';
import 'package:numeral/numeral.dart';
import 'package:vendor/constants/app_colors.dart';
import 'package:vendor/extensions/dynamic.dart';
import 'package:vendor/utils/ui_spacer.dart';
import 'package:vendor/view_models/vendor_details.view_model.dart';
import 'package:vendor/views/pages/vendor/widgets/request_payout.btn.dart';
import 'package:vendor/views/pages/vendor/widgets/vendor_sales.chart.dart';
import 'package:vendor/widgets/base.page.dart';
import 'package:vendor/widgets/busy_indicator.dart';
import 'package:vendor/widgets/buttons/custom_button.dart';
import 'package:vendor/widgets/currency_hstack.dart';
import 'package:stacked/stacked.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import 'widgets/document_request.view.dart';
import 'widgets/online_status.toggle.dart';
import 'widgets/vendor_profile.switch.dart';

class VendorDetailsPage extends StatefulWidget {
  const VendorDetailsPage({super.key});

  @override
  State<VendorDetailsPage> createState() => _VendorDetailsPageState();
}

class _VendorDetailsPageState extends State<VendorDetailsPage> {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<VendorDetailsViewModel>.reactive(
      viewModelBuilder: () => VendorDetailsViewModel(context),
      onViewModelReady: (vm) => vm.initialise(),
      builder: (context, vm, child) {
        return BasePage(
          body: SafeArea(
            child: RefreshIndicator(
              onRefresh: vm.fetchVendorDetails,
              child: (vm.isBusy || vm.vendor == null)
                  ? BusyIndicator().centered()
                  : VStack(
                      [
                        "Vendor Details".tr().text.xl2.semiBold.make().p20(),
                        //vendor switcher
                        VendorProfileSwitcher(vm).px20(),
                        //
                        DocumentRequestView(),
                        //online status
                        OnlineStatusToggle(vm).px20(),

                        //subscription section
                        VStack(
                          [
                            //subscription indicator

                            Visibility(
                              visible: vm.vendor!.useSubscription,
                              child: HStack(
                                [
                                  "Subscription Status"
                                      .tr()
                                      .text
                                      .medium
                                      .lg
                                      .make()
                                      .expand(),
                                  UiSpacer.hSpace(),
                                  ((vm.vendor!.hasSubscription)
                                          ? "Subscribed"
                                          : "No Subscription")
                                      .text
                                      .semiBold
                                      .xl
                                      .color((vm.vendor!.hasSubscription)
                                          ? AppColor.openColor
                                          : AppColor.closeColor)
                                      .make(),
                                ],
                              ),
                            ),
                            UiSpacer.vSpace(6),
                            //subscription payment indicator
                            Visibility(
                              visible: (vm.vendor!.useSubscription) &&
                                  !(vm.vendor!.hasSubscription),
                              child: HStack(
                                [
                                  "Your subscription has expired"
                                      .tr()
                                      .text
                                      .lg
                                      .white
                                      .make()
                                      .expand(),
                                  CustomButton(
                                    color: Colors.white,
                                    onPressed: vm.openSubscriptionPage,
                                    child: "Subscribe"
                                        .tr()
                                        .text
                                        .xl
                                        .medium
                                        .color(Colors.red.shade400)
                                        .makeCentered(),
                                  ),
                                ],
                              )
                                  .p8()
                                  .box
                                  .color(Colors.red.shade400)
                                  .roundedSM
                                  .make()
                                  .wFull(context),
                            ),
                          ],
                        ).px20().py12(),

                        //
                        VStack(
                          [
                            // transactions/orders stats
                            VendorSalesChart(vm: vm),
                            //total orders
                            HStack(
                              [
                                //
                                "Total Orders"
                                    .tr()
                                    .text
                                    .lg
                                    .white
                                    .make()
                                    .expand(),
                                UiSpacer.horizontalSpace(),
                                Numeral(vm.totalOrders)
                                    .numeral()
                                    .text
                                    .xl
                                    .semiBold
                                    .white
                                    .make(),
                              ],
                            )
                                .p20()
                                .box
                                .rounded
                                .shadow
                                .color(AppColor.accentColor.withOpacity(0.8))
                                .make()
                                .py16(),

                            ////earnings

                            HStack(
                              [
                                //
                                "Total Earnings \n(Currently)"
                                    .tr()
                                    .text
                                    .lg
                                    .white
                                    .make()
                                    .expand(),
                                UiSpacer.horizontalSpace(),
                                CurrencyHStack(
                                  [
                                    "${vm.currencySymbol} "
                                        .text
                                        .xl
                                        .semiBold
                                        .white
                                        .make(),
                                    "${vm.totalEarning.currencyValueFormat()} "
                                        .text
                                        .xl
                                        .semiBold
                                        .white
                                        .make(),
                                  ],
                                ),
                              ],
                            )
                                .p20()
                                .box
                                .rounded
                                .outerShadow
                                .color(AppColor.accentColor)
                                .make(),
                            //request payout
                            RequestPayoutButton(vm: vm),

                            //vendor details
                            VStack(
                              [
                                //name
                                "Name".tr().text.lg.make(),
                                "${vm.vendor?.name}"
                                    .text
                                    .xl
                                    .semiBold
                                    .make()
                                    .pOnly(bottom: Vx.dp12),
                                // address
                                "Address".tr().text.lg.make(),
                                "${vm.vendor?.address ?? ''}"
                                    .text
                                    .xl
                                    .semiBold
                                    .make()
                                    .pOnly(bottom: Vx.dp12),
                              ],
                            )
                                .p20()
                                .box
                                .rounded
                                .color(context.cardColor)
                                .outerShadow
                                .make()
                                .wFull(context)
                                .pOnly(top: Vx.dp12, bottom: Vx.dp32),
                          ],
                        ).px20(),
                      ],
                    ).scrollVertical(),
            ),
          ),
        );
      },
    );
  }

//
//
}
