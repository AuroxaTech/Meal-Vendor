import 'package:flutter/material.dart';
import 'package:vendor/constants/app_colors.dart';
import 'package:vendor/models/order.dart';
import 'package:vendor/utils/size_utils.dart';
import 'package:jiffy/jiffy.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../constants/app_text_styles.dart';

class OrderFutureListItem extends StatelessWidget {
  const OrderFutureListItem({
    required this.order,
    this.onPayPressed,
    required this.orderPressed,
    super.key,
  });

  final Order order;
  final Function? onPayPressed;
  final Function orderPressed;

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    DateTime createdAt = order.pickupDate!.isNotEmpty
        ? DateTime.parse(order.pickupDate!)
        : DateTime.now().add(const Duration(days: 1));
    Duration accountAge = createdAt.difference(now);

    String days = '';
    if (accountAge.inDays % 30 > 0) {
      days = '${accountAge.inDays % 30} day';
      if (accountAge.inDays % 30 > 1) days = '${accountAge.inDays % 30} days';
    }
    String hours = '';
    if (createdAt.difference(now).inHours > 0 &&
        createdAt.difference(now).inHours < 24) {
      hours = '${createdAt.difference(now).inHours} Hour';
      if (createdAt.difference(now).inHours > 1) {
        hours = '${createdAt.difference(now).inHours} Hours';
      }
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(width: 2, color: AppColor.appMainColor)),
      child: VStack(
        [
          //
          //amount and total products
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  Text(order.user.getCapitalizedName(),
                          maxLines: 4,
                          style: AppTextStyle.comicNeue20BoldTextStyle(
                              color: AppColor.appMainColor))
                      .pOnly(right: getWidth(15)),
                  Text("#${order.code}",
                          maxLines: 4,
                          style: AppTextStyle.comicNeue20BoldTextStyle(
                              color: AppColor.appMainColor))
                      .pOnly(right: getWidth(15)),
                ],
              ),
              Flexible(
                  flex: 1,
                  child: FittedBox(
                      child: Text(
                              order.pickupDate!.isNotEmpty
                                  ? '${order.pickupDate}'
                                  : Jiffy.parseFromDateTime(DateTime.now()
                                          .add(const Duration(days: 1)))
                                      .format(pattern: "EEEE,dd MMM, yyyy"),
                              maxLines: 5,
                              style: AppTextStyle.comicNeue20BoldTextStyle(
                                  color: AppColor.appMainColor))
                          .pOnly(right: 5))),
              Flexible(
                  flex: 1,
                  child: FittedBox(
                      child: Text('$days $hours',
                              maxLines: 5,
                              style: AppTextStyle.comicNeue20BoldTextStyle(
                                  color: AppColor.appMainColor))
                          .pOnly(right: 5))),
            ],
          ),
        ],
      ).p12(),
    );
  }
}
