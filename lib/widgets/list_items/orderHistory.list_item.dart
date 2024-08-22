import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../constants/app_colors.dart';
import '../../constants/app_images.dart';
import '../../constants/app_text_styles.dart';
import '../../models/order.dart';
import '../../utils/size_utils.dart';
import '../../utils/utils.dart';
import '../busy_indicator.dart';

class OrderHistoryListItem extends StatelessWidget {
  const OrderHistoryListItem({
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
    String remainingTime = '';
    if (order.driverPickupTime!.isNotEmpty) {
      remainingTime =
          '${DateTime.now().difference(DateTime.parse(order.driverPickupTime!)).inMinutes}';
    }
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
                SizedBox(
                  width: 4.0,
                ),
                SizedBox(
                    width: SizeConfigs.isTablet
                        ? (MediaQuery.sizeOf(context).width -
                                Utils.navRailWidth) /
                            3.5
                        : (MediaQuery.sizeOf(context).width -
                                Utils.navRailWidth) /
                            5,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        if (order.status.toLowerCase() != "cancelled")
                          Text('Picked up $remainingTime mins ago',
                                  maxLines: 6,
                                  style: AppTextStyle.comicNeue16BoldTextStyle(
                                      color: AppColor.appMainColor))
                              .pOnly(bottom: 4),
                        Text(order.status.capitalized,
                            maxLines: 6,
                            style: AppTextStyle.comicNeue16BoldTextStyle(
                                color: AppColor.appMainColor)),
                      ],
                    )).pOnly(right: 5),
                Image.asset(AppImages.like,
                        height: SizeConfigs.isTablet ? 35 : 20,
                        width: SizeConfigs.isTablet ? 35 : 20)
                    .pOnly(right: SizeConfigs.isTablet ? 8 : 4),
                Image.asset(
                  AppImages.disLike,
                  height: SizeConfigs.isTablet ? 35 : 20,
                  width: SizeConfigs.isTablet ? 35 : 20,
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.only(right: 5, left: 5),
                  alignment: Alignment.centerLeft,
                  child: Text(
                      order.driver?.name.split(' ').first ??
                          order.driver?.name ??
                          '',
                      style: AppTextStyle.comicNeue20BoldTextStyle(
                          color: AppColor.appMainColor)),
                ),
                const Spacer(),
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
                    child: order.driver != null
                        ? CachedNetworkImage(
                            imageUrl: order.driver!.photo,
                            errorWidget: (context, imageUrl, _) => Image.asset(
                              AppImages.appLogo,
                              fit: BoxFit.cover,
                            ),
                            width: SizeConfigs.isTablet ? 45 : 30,
                            height: SizeConfigs.isTablet ? 45 : 30,
                            fit: BoxFit.cover,
                            progressIndicatorBuilder:
                                (context, imageURL, progress) =>
                                    const BusyIndicator().centered(),
                          )
                        : ClipOval(
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
        ).p8().onInkTap(() => orderPressed()));
  }
}
