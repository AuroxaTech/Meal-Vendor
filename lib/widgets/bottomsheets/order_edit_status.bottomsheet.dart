import 'package:flutter/material.dart';
import 'package:vendor/utils/ui_spacer.dart';
import 'package:vendor/widgets/buttons/custom_button.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

class OrderEditStatusBottomSheet extends StatefulWidget {
  const OrderEditStatusBottomSheet(
    this.selectedStatus, {
    required this.onConfirm,
    super.key,
  });

  final Function(String) onConfirm;
  final String selectedStatus;

  @override
  State<OrderEditStatusBottomSheet> createState() =>
      _OrderEditStatusBottomSheetState();
}

class _OrderEditStatusBottomSheetState
    extends State<OrderEditStatusBottomSheet> {
  List<String> statues = [
    'pending',
    'preparing',
    'ready',
    'enroute',
    'failed',
    'cancelled',
    'delivered'
  ];
  String? selectedStatus;

  @override
  void initState() {
    super.initState();

    setState(() {
      selectedStatus = widget.selectedStatus;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: VStack(
        [
          "Change Order Status".tr().text.semiBold.xl.make(),
          //
          ...statues.map((e) {
            //
            return HStack(
              [
                Radio(
                  value: e,
                  groupValue: selectedStatus,
                  onChanged: _changeSelectedStatus,
                ),

                //
                e.tr().allWordsCapitilize().text.lg.light.make(),
              ],
            ).onInkTap(() => _changeSelectedStatus(e)).wFull(context);
          }),

          UiSpacer.verticalSpace(),
          //
          CustomButton(
            title: "Change".tr(),
            onPressed: selectedStatus != null
                ? () => widget.onConfirm(selectedStatus!)
                : null,
          ),
        ],
      ).p20().scrollVertical().hTwoThird(context),
    );
  }

  void _changeSelectedStatus(value) {
    setState(() {
      selectedStatus = value;
    });
  }
}
