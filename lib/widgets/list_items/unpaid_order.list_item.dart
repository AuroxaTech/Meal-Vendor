import 'package:flutter/material.dart';
import 'package:vendor/constants/app_colors.dart';
import 'package:vendor/models/order.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../constants/app_images.dart';
import '../../constants/app_text_styles.dart';
import '../../utils/size_utils.dart';
import '../../utils/utils.dart';

class UnPaidOrderListItem extends StatelessWidget {
  const UnPaidOrderListItem({
    required this.order,
    super.key,
  });

  final Order order;

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(width: 2, color: AppColor.appMainColor)),
        child: VStack(
          [
            //amount and total products
            Row(
              children: [
                SizedBox(
                  width:
                      (MediaQuery.sizeOf(context).width - Utils.navRailWidth) /
                          5,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(order.user.getCapitalizedName(),
                          style: AppTextStyle.comicNeue20BoldTextStyle(
                              color: AppColor.appMainColor)),
                      Text("#${order.code}",
                          maxLines: 2,
                          style: AppTextStyle.comicNeue14BoldTextStyle(
                              color: AppColor.appMainColor)),
                    ],
                  ),
                ),
                const SizedBox(
                  width: 5.0,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                              "Order payment yet to be completed, hence you can't open order"
                                  .tr(),
                              maxLines: 6,
                              style: AppTextStyle.comicNeue16BoldTextStyle(
                                  color: AppColor.getStausColor(order.status)))
                          .pOnly(bottom: 4),
                      Text(order.status.capitalized,
                          maxLines: 6,
                          style: AppTextStyle.comicNeue16BoldTextStyle(
                              color: AppColor.appMainColor)),
                    ],
                  ),
                ),
                const SizedBox(
                  width: 5.0,
                ),
                Container(
                  decoration: BoxDecoration(
                      color: AppColor.appMainColor,
                      borderRadius:
                          BorderRadius.circular(SizeConfigs.isTablet ? 45 : 30),
                      border:
                          Border.all(width: 1, color: AppColor.appMainColor)),
                  child: ClipRRect(
                    borderRadius:
                        BorderRadius.circular(SizeConfigs.isTablet ? 45 : 30),
                    child: ClipOval(
                      child: Image.asset(
                        AppImages.noImage,
                        fit: BoxFit.cover,
                        width: SizeConfigs.isTablet ? 45 : 30,
                        height: SizeConfigs.isTablet ? 45 : 30,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ).p8());
  }
}
