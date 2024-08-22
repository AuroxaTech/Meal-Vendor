import 'package:flutter/material.dart';
import 'package:vendor/constants/app_colors.dart';
import 'package:vendor/view_models/base.view_model.dart';
import 'package:vendor/widgets/buttons/custom_button.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

class AccountVerificationEntry extends StatefulWidget {
  const AccountVerificationEntry({
    required this.onSubmit,
    required this.vm,
    super.key,
  });

  final Function(String) onSubmit;
  final MyBaseViewModel vm;

  @override
  State<AccountVerificationEntry> createState() =>
      _AccountVerificationEntryState();
}

class _AccountVerificationEntryState extends State<AccountVerificationEntry> {
  String smsCode = "";

  @override
  Widget build(BuildContext context) {
    //
    TextEditingController pinTEC = TextEditingController();

    return VStack(
      [
        //
        "Verify your phone number".tr().text.bold.xl2.makeCentered(),
        "Enter otp sent to your provided phone number".tr().text.makeCentered(),
        //pin code
        PinCodeTextField(
          appContext: context,
          length: 6,
          obscureText: false,
          keyboardType: TextInputType.number,
          animationType: AnimationType.fade,
          textStyle: context.textTheme.bodyLarge!.copyWith(fontSize: 20),
          controller: pinTEC,
          pinTheme: PinTheme(
            shape: PinCodeFieldShape.underline,
            fieldHeight: context.percentWidth * (100 / 8),
            fieldWidth: context.percentWidth * (100 / 8),
            activeFillColor: AppColor.primaryColor,
            selectedColor: AppColor.accentColor,
            inactiveColor: context.cardColor,
          ),
          animationDuration: const Duration(milliseconds: 300),
          backgroundColor: Colors.transparent,
          enableActiveFill: false,
          onCompleted: (pin) {
            smsCode = pin;
          },
          onChanged: (value) {
            smsCode = value;
          },
        ),

        //submit
        CustomButton(
          title: "Verify".tr(),
          loading: widget.vm.busy(widget.vm.firebaseVerificationId),
          onPressed: () => widget.onSubmit(smsCode),
        ),
      ],
    ).p20().h(context.percentHeight * 90);
  }
}
