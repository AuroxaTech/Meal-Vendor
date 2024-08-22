import 'package:flutter/material.dart';
import 'package:vendor/constants/app_colors.dart';
import 'package:vendor/models/payment_account.dart';
import 'package:vendor/services/validator.service.dart';
import 'package:vendor/utils/ui_spacer.dart';
import 'package:vendor/view_models/payout.vm.dart';
import 'package:vendor/widgets/busy_indicator.dart';
import 'package:vendor/widgets/buttons/custom_button.dart';
import 'package:vendor/widgets/buttons/custom_text_button.dart';
import 'package:vendor/widgets/custom_text_form_field.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:stacked/stacked.dart';
import 'package:velocity_x/velocity_x.dart';

class PayoutBottomSheet extends StatelessWidget {
  const PayoutBottomSheet({required this.totalEarningAmount, super.key});

  final double totalEarningAmount;

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<PayoutViewModel>.reactive(
      viewModelBuilder: () => PayoutViewModel(context, totalEarningAmount),
      onViewModelReady: (vm) => vm.initialise(),
      builder: (context, vm, child) {
        return VStack(
          [
            "Payout".tr().text.medium.xl2.makeCentered(),
            vm.isBusy
                ? const BusyIndicator().centered().p20().expand()
                : VStack(
                    [
                      Form(
                        key: vm.formKey,
                        child: vm.busy(vm.paymentAccounts)
                            ? const BusyIndicator().centered().py20()
                            : VStack(
                                [
                                  const Divider(thickness: 2).py12(),
                                  "Request Payout".tr().text.semiBold.xl.make(),
                                  UiSpacer.verticalSpace(),
                                  //
                                  "Payment Account".tr().text.base.light.make(),
                                  DropdownButtonFormField<PaymentAccount>(
                                    decoration: const InputDecoration.collapsed(
                                        hintText: ""),
                                    value: vm.selectedPaymentAccount,
                                    onChanged: (value) {
                                      vm.selectedPaymentAccount = value;
                                      vm.notifyListeners();
                                    },
                                    items: (vm.paymentAccounts ?? []).map(
                                      (e) {
                                        return DropdownMenuItem(
                                            value: e,
                                            child:
                                                Text("${e.name}(${e.number})")
                                            // .text
                                            // .make(),
                                            );
                                      },
                                    ).toList(),
                                  )
                                      .p12()
                                      .box
                                      .border(color: AppColor.accentColor)
                                      .roundedSM
                                      .make()
                                      .py4(),
                                  //
                                  UiSpacer.verticalSpace(space: 10),
                                  CustomTextFormField(
                                    labelText: "Amount".tr(),
                                    textEditingController: vm.amountTEC,
                                    keyboardType:
                                        const TextInputType.numberWithOptions(
                                      decimal: true,
                                    ),
                                    validator: (value) =>
                                        FormValidator.validateCustom(
                                      value,
                                      rules:
                                          "required||numeric||lte:$totalEarningAmount",
                                    ),
                                  ).py12(),
                                  CustomButton(
                                    title: "Request Payout".tr(),
                                    loading: vm.busy(vm.selectedPaymentAccount),
                                    onPressed: vm.processPayoutRequest,
                                  ).centered().py12(),
                                  //
                                  CustomTextButton(
                                    title: "Close".tr(),
                                    onPressed: () => Navigator.pop(context),
                                  ).centered(),
                                ],
                              ).scrollVertical(),
                      ),
                    ],
                    crossAlignment: CrossAxisAlignment.center,
                    alignment: MainAxisAlignment.center,
                  ),
          ],
        )
            .p20()
            .scrollVertical()
            .h(context.percentHeight * 95)
            .box
            .color(context.theme.colorScheme.background)
            .topRounded()
            .make()
            .pOnly(
              bottom: context.mq.viewPadding.bottom,
            );
      },
    );
  }
}
