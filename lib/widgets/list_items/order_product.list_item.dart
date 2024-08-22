import 'package:flutter/material.dart';
import 'package:vendor/models/order_product.dart';
import 'package:vendor/constants/app_strings.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../constants/app_colors.dart';
import '../../constants/app_text_styles.dart';
import '../../utils/ui_spacer.dart';

class OrderProductListItem extends StatelessWidget {
  const OrderProductListItem({
    required this.orderProduct,
    required this.index,
    this.divider = false,
    super.key,
  });

  final int index;
  final OrderProduct orderProduct;
  final bool divider;

  @override
  Widget build(BuildContext context) {
    return VStack([
      HStack(
        [
          //qty
          Text("${index + 1}. ${orderProduct.product?.name} x ${orderProduct.quantity}",
              style: AppTextStyle.comicNeue20BoldTextStyle(
                  color: AppColor.appMainColor)),
          /*Visibility(
            visible: orderProduct.options != null &&
                orderProduct.options!.isNotEmpty,
            child: (orderProduct.options ?? '').text.sm.gray500.medium.make(),
          ).px12().expand(),*/
          const Expanded(child: SizedBox.shrink()),
          Text("${AppStrings.currencySymbol}${orderProduct.discountPrice}",
              style: AppTextStyle.comicNeue20BoldTextStyle(
                  color: AppColor.appMainColor)),
          //
        ],
      ),
      if (orderProduct.heatLevelInfo().isNotEmpty)
        Text("Heat Level : ${orderProduct.heatLevelInfo()}",
            style: AppTextStyle.comicNeue16BoldTextStyle(
                color: AppColor.appMainColor)),
      ...orderProduct.orderProductOptions.map((orderProductOption) => HStack(
            [
              Text(
                  "   ${orderProductOption.quantity} x ${orderProductOption.title}",
                  style: AppTextStyle.comicNeue16BoldTextStyle(
                      color: AppColor.appMainColor)),

              const Expanded(child: SizedBox.shrink()),
              Text("${AppStrings.currencySymbol}${orderProductOption.quantity * orderProductOption.price}",
                  style: AppTextStyle.comicNeue16BoldTextStyle(
                      color: AppColor.appMainColor)),
              //
            ],
          )),
      if (divider) UiSpacer.divider(height: 10, thickness: 0.6),
    ]);
  }
}
