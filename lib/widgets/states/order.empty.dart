import 'package:flutter/material.dart';
import 'package:vendor/constants/app_images.dart';
import 'package:vendor/widgets/states/empty.state.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:velocity_x/velocity_x.dart';

class EmptyOrder extends StatelessWidget {
  final String? status;

  const EmptyOrder({super.key, this.status});

  @override
  Widget build(BuildContext context) {
    return EmptyState(
      imageUrl: AppImages.emptyCart,
      title: "No Order".tr(),
      description: "When you have an order ${status ?? ''}, they will appear here",
    ).p20().centered();
  }
}
