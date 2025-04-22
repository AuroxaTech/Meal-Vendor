import 'dart:math';

import 'package:flutter/material.dart';
import 'package:vendor/constants/app_images.dart';
import 'package:vendor/utils/size_utils.dart';
import 'package:vendor/widgets/buttons/custom_text_button.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:velocity_x/velocity_x.dart';

class OverlayPermissionBottomSheet extends StatelessWidget {
  const OverlayPermissionBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    Widget imageWidget = Image.asset(
      AppImages.overflowPermission,
      width: min(context.percentHeight, context.percentWidth) * 50,
      // height: context.percentWidth * 50,
    ).centered();

    Widget titleWidget = "Never miss a new order".tr().text.xl2.semiBold.make();
    Widget descriptionWidget =
        "Please allow the app to draw over other apps to enable the app to show pop alert about new order when the app is in background."
            .tr()
            .text
            .make();

    Widget allowWidget = CustomTextButton(
      title: "Allow".tr(),
      onPressed: () => Navigator.pop(context, true),
    ).wFull(context);
    Widget cancelWidget = CustomTextButton(
      title: "Cancel".tr(),
      onPressed: () => Navigator.pop(context),
    ).wFull(context);

    if (SizeConfigs.isTablet) {
      return HStack([
        imageWidget.expand(),
        VStack([
          titleWidget,
          2.heightBox,
          descriptionWidget,
          20.heightBox,
          allowWidget,
          cancelWidget,
          20.heightBox,
        ]).scrollVertical().expand(),
      ]).p20().py12().box.white.topRounded().make();
    }
    return VStack(
      [
        imageWidget,
        //description
        titleWidget,
        descriptionWidget,
        20.heightBox,
        allowWidget,
        cancelWidget,

        20.heightBox,
      ],
      spacing: 10,
    ).scrollVertical().p20().py12().box.white.topRounded().make();
  }
}
