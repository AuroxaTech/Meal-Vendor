import 'package:flutter/material.dart';
import 'package:slide_countdown/slide_countdown.dart';
import 'package:vendor/constants/app_colors.dart';
import 'package:vendor/models/order.dart';
import 'package:velocity_x/velocity_x.dart';
import '../../constants/app_text_styles.dart';
import '../../utils/size_utils.dart';
import '../../utils/utils.dart';

class OrderListPreparingItem extends StatelessWidget {
  const OrderListPreparingItem({
    required this.order,
    this.onPayPressed,
    this.orderPressed,
    super.key,
  });

  final Order order;
  final VoidCallback? onPayPressed;
  final VoidCallback? orderPressed;

  @override
  Widget build(BuildContext context) {
    SizeConfigs().init(context);

    return InkWell(
      onTap: orderPressed,
      child: Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: EdgeInsets.zero,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(width: 2, color: AppColor.appMainColor)),
          child: HStack(
            [
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(order.user.getCapitalizedName(),
                        style: AppTextStyle.comicNeue16BoldTextStyle(
                                color: AppColor.appMainColor)
                            .copyWith(fontSize: 16.0)),
                    Text('#${order.code}',
                        style: AppTextStyle.comicNeue16BoldTextStyle(
                                color: AppColor.appMainColor)
                            .copyWith(fontSize: 16.0)),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  alignment: Alignment.center,
                  width:
                      (MediaQuery.sizeOf(context).width - Utils.navRailWidth) /
                          4,
                  child: Column(
                    children: [
                      Text('Ready in',
                              style: AppTextStyle.comicNeue16BoldTextStyle(
                                      color: AppColor.appMainColor)
                                  .copyWith(fontSize: 16.0))
                          .pOnly(bottom: 5),
                      if (order.remainingMinutes > 0)
                        RawSlideCountdown(
                          streamDuration: StreamDuration(
                            config: StreamDurationConfig(
                              countDownConfig: CountDownConfig(
                                duration:
                                    Duration(minutes: order.remainingMinutes),
                              ),
                            ),
                          ),
                          builder: (context, duration) {
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                RawDigitItem(
                                  duration: duration,
                                  timeUnit: TimeUnit.minutes,
                                  digitType: DigitType.first,
                                  countUp: false,
                                  style: AppTextStyle.comicNeue16BoldTextStyle(
                                          color: AppColor.appMainColor)
                                      .copyWith(fontSize: 16.0),
                                ),
                                RawDigitItem(
                                  duration: duration,
                                  timeUnit: TimeUnit.minutes,
                                  digitType: DigitType.second,
                                  countUp: false,
                                  style: AppTextStyle.comicNeue16BoldTextStyle(
                                          color: AppColor.appMainColor)
                                      .copyWith(fontSize: 16.0),
                                ),
                                Text(
                                  ' mins',
                                  style: AppTextStyle.comicNeue16BoldTextStyle(
                                          color: AppColor.appMainColor)
                                      .copyWith(fontSize: 16.0),
                                ),
                              ],
                            );
                          },
                        )
                      else
                        Text(
                          '0 mins',
                          style: AppTextStyle.comicNeue16BoldTextStyle(
                                  color: AppColor.appMainColor)
                              .copyWith(fontSize: 16.0),
                        ),
                    ],
                  ),
                ),
              ),
              InkWell(
                onTap: onPayPressed,
                child: Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 8.0),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border:
                          Border.all(width: 2, color: AppColor.appMainColor)),
                  child: Text("Ready",
                      style: AppTextStyle.comicNeue20BoldTextStyle(
                              color: AppColor.appMainColor)
                          .copyWith(fontSize: 16.0)),
                ),
              ),
            ],
          ).px8().py12()),
    );
  }
}

class OrderListReadyItem extends StatelessWidget {
  const OrderListReadyItem({
    required this.order,
    this.onPayPressed,
    required this.orderPressed,
    super.key,
  });

  final Order order;
  final Function? onPayPressed;
  final VoidCallback orderPressed;

  @override
  Widget build(BuildContext context) {
    SizeConfigs().init(context);

    return InkWell(
      onTap: orderPressed,
      child: Container(
        padding: EdgeInsets.zero,
        decoration: BoxDecoration(
            color: AppColor.appMainColor,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(width: 2, color: AppColor.appMainColor)),
        child: HStack(
          [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(order.user.getCapitalizedName(),
                      style: AppTextStyle.comicNeue16BoldTextStyle(
                              color: Colors.white)
                          .copyWith(fontSize: 16.0)),
                  Text('#${order.code}',
                      style: AppTextStyle.comicNeue16BoldTextStyle(
                              color: Colors.white)
                          .copyWith(fontSize: 16.0)),
                ],
              ),
            ),
            Expanded(
              child: Container(
                alignment: Alignment.centerRight,
                width:
                    (MediaQuery.sizeOf(context).width - Utils.navRailWidth) / 4,
                child: Column(
                  children: [
                    Text('Arriving in',
                            style: AppTextStyle.comicNeue16BoldTextStyle(
                                    color: Colors.white)
                                .copyWith(fontSize: 16.0))
                        .pOnly(bottom: 5),
                    if (order.remainingTravelMinutes > 0)
                      Wrap(children: [
                        SlideCountdown(
                          duration:
                              Duration(minutes: order.remainingTravelMinutes),
                          decoration: BoxDecoration(
                            color: AppColor.appMainColor,
                          ),
                          separatorStyle: AppTextStyle.comicNeue16BoldTextStyle(
                                  color: Colors.white)
                              .copyWith(fontSize: 16.0),
                          style: AppTextStyle.comicNeue16BoldTextStyle(
                                  color: Colors.white)
                              .copyWith(fontSize: 16.0),
                        ),
                        Text(
                          ' mins',
                          style: AppTextStyle.comicNeue16BoldTextStyle(
                                  color: Colors.white)
                              .copyWith(fontSize: 16.0),
                        ),
                      ])
                    else
                      Text(
                        '0 mins',
                        style: AppTextStyle.comicNeue16BoldTextStyle(
                                color: Colors.white)
                            .copyWith(fontSize: 16.0),
                      ),
                  ],
                ),
              ),
            ),
            /*Container(
                  alignment: Alignment.center,
                  width: SizeConfigs.isTablet
                      ? (MediaQuery.sizeOf(context).width -
                              Utils.navRailWidth) /
                          4.5
                      : 90,
                  padding: const EdgeInsets.all(10),
                  margin: const EdgeInsets.only(left: 10.0),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(width: 2, color: Colors.white)),
                  child: Text(order.status.capitalize(),
                      style: AppTextStyle.comicNeue25BoldTextStyle(
                          color: Colors.black)),
                ),*/
          ],
        ).px8().py12(),
      ),
    );
  }
}
