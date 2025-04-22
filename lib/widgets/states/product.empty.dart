import 'package:flutter/material.dart';
import 'package:vendor/constants/app_images.dart';
import 'package:vendor/widgets/states/empty.state.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:velocity_x/velocity_x.dart';

class EmptyProduct extends StatelessWidget {
  const EmptyProduct({super.key});

  @override
  Widget build(BuildContext context) {
    return EmptyState(
      imageUrl: AppImages.emptyCart,
      title: "No Product".tr(),
      description: "All products will appear here".tr(),
    ).p20().centered();
  }
}
