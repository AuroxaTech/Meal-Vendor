import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:vendor/models/product.dart';
import 'package:vendor/utils/ui_spacer.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../constants/app_colors.dart';
import '../../constants/app_images.dart';
import '../../constants/app_text_styles.dart';
import '../../utils/size_utils.dart';
import '../busy_indicator.dart';

class ManageProductListItem extends StatelessWidget {
  const ManageProductListItem(
      this.product, {
        this.isLoading = false,
        required this.onPressed,
        required this.onEditPressed,
        required this.onToggleStatusPressed,
        required this.onDeletePressed,
        required this.onUpdateProductAvailability,
        super.key,
      });

  final Product product;
  final bool isLoading;
  final Function(Product) onPressed;
  final Function(Product) onEditPressed;
  final Function(Product) onToggleStatusPressed;
  final Function(Product) onDeletePressed;
  final Function(
      {required Product product,
      required bool isAvailable,
      int? minutes}) onUpdateProductAvailability;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          Row(
            children: [
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppColor.primaryColor)),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: CachedNetworkImage(
                    imageUrl: product.photo,
                    errorWidget: (context, imageUrl, _) => Image.asset(
                      AppImages.platerImage,
                      fit: BoxFit.cover,
                    ),
                    fit: BoxFit.cover,
                    progressIndicatorBuilder: (context, imageURL, progress) =>
                        const BusyIndicator().centered(),
                    height: getWidth(70),
                    width: getWidth(70),
                  ),
                ),
              ),
              Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(product.name,
                          textAlign: TextAlign.end,
                          style: AppTextStyle.comicNeue20BoldTextStyle(
                              color: AppColor.appMainColor))
                          .pOnly(bottom: getWidth(5), right: getWidth(10)),
                      Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                        InkWell(
                            onTap: () {
                              openDialog(context, onUpdateProductAvailability);
                            },
                            child: Container(
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    width: 1,
                                    color: product.isActive == 1
                                        ? AppColor.appMainColor
                                        : Colors.red, // Red border for out of stock
                                  ),
                                ),
                                child: Text(
                                  product.isActive == 1
                                      ? 'Available'
                                      : 'Out of Stock', // Change text based on status
                                  textAlign: TextAlign.center,
                                  style: AppTextStyle.comicNeue20BoldTextStyle(
                                    color: product.isActive == 1
                                        ? AppColor.appMainColor
                                        : Colors.red, // Red text for out of stock
                                  ),
                                ).px20().py4()))
                            .pOnly(bottom: getWidth(5), right: getWidth(5)),
                      ]),
                    ],
                  ).pOnly(right: 8)),
            ],
          ).expand(),
          const Divider(thickness: 2).py1(),
        ],
      ),
    );
  }

  void openDialog(
      BuildContext context,
      Function({
      required Product product,
      required bool isAvailable,
      int? minutes,
      }) onUpdateProductAvailability,
      ) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          insetPadding: EdgeInsets.zero,
          backgroundColor: Colors.transparent,
          content: Container(
            padding: const EdgeInsets.all(20.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              border: Border.all(width: 4, color: AppColor.appMainColor),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(width: 3, color: AppColor.appGreenColor),
                  ),
                  child: Text('Available',
                      style: AppTextStyle.comicNeue27BoldTextStyle(
                          color: AppColor.appGreenColor))
                      .p4(),
                ).pOnly(right: 15).onInkTap(() {
                  Navigator.pop(context);
                  onUpdateProductAvailability.call(
                      product: product, isAvailable: true);
                  // Now instead of navigating, call the method to refresh the list
                }),
                const Spacer(),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(width: 3, color: Colors.red),
                  ),
                  child: Text('Out of Stock',
                      style: AppTextStyle.comicNeue27BoldTextStyle(
                          color: Colors.red))
                      .p4(),
                ).onInkTap(() {
                  Navigator.pop(context);
                  openOutOfStockDialog(
                      context, product, onUpdateProductAvailability);
                }),
              ],
            ),
          ),
        );
      },
    );
  }


  void openOutOfStockDialog(
      BuildContext context,
      Product product,
      Function(
          {required Product product,
          required bool isAvailable,
          int? minutes})
      onUpdateProductAvailability) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        DateTime now = DateTime.now();
        DateTime tomorrowMidnight = DateTime(now.year, now.month, now.day + 1);
        Duration difference = tomorrowMidnight.difference(now);
        int minutesUntilTomorrow = difference.inMinutes;
        return AlertDialog(
          insetPadding: EdgeInsets.zero,
          backgroundColor: Colors.transparent,
          content: Container(
            width: SizeConfigs.isTablet
                ? SizeConfigs.screenWidth! / 1.5
                : SizeConfigs.screenWidth! - (SizeConfigs.screenWidth! / 10),
            padding: const EdgeInsets.only(
                left: 8.0, right: 8.0, bottom: 8.0, top: 2.0),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                border: Border.all(width: 4, color: AppColor.appMainColor)),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('How long is it out of stock for?',
                    style: AppTextStyle.comicNeue27BoldTextStyle(
                        color: AppColor.appMainColor))
                    .px(8.0),
                UiSpacer.verticalSpace(space: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _outOfStockWidget(
                        context: context,
                        title: '1 hr',
                        minutes: 60,
                        onTap: () {
                          onUpdateProductAvailability.call(
                            product: product,
                            isAvailable: false,
                            minutes: 60,
                          );
                        }),
                    _outOfStockWidget(
                        context: context,
                        title: '4 hr',
                        minutes: 240,
                        onTap: () {
                          onUpdateProductAvailability.call(
                            product: product,
                            isAvailable: false,
                            minutes: 240,
                          );
                        }),
                    _outOfStockWidget(
                        context: context,
                        title: '8 hr',
                        minutes: 480,
                        onTap: () {
                          onUpdateProductAvailability.call(
                            product: product,
                            isAvailable: false,
                            minutes: 480,
                          );
                        }),
                    _outOfStockWidget(
                        context: context,
                        title: '24 hr',
                        minutes: 1440,
                        onTap: () {
                          onUpdateProductAvailability.call(
                            product: product,
                            isAvailable: false,
                            minutes: 1440,
                          );
                        }),
                  ],
                ),
                UiSpacer.verticalSpace(space: 10),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _outOfStockWidget(
                        context: context,
                        title: 'Till tomorrow',
                        minutes: minutesUntilTomorrow,
                        onTap: () {
                          onUpdateProductAvailability.call(
                            product: product,
                            isAvailable: false,
                            minutes: minutesUntilTomorrow,
                          );
                        }),
                    const SizedBox(
                      width: 10.0,
                    ),
                    _outOfStockWidget(
                        context: context,
                        title: 'Indefinitely',
                        minutes: -1,
                        onTap: () {
                          onUpdateProductAvailability.call(
                            product: product,
                            isAvailable: false,
                            minutes: -1,
                          );
                        }),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _outOfStockWidget(
      {required BuildContext context,
        required String title,
        required int minutes,
        required VoidCallback onTap}) {
    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(width: 3, color: AppColor.appMainColor)),
      child: Text(title,
          style: AppTextStyle.comicNeue27BoldTextStyle(
              color: AppColor.appMainColor))
          .p4()
          .px8(),
    ).onTap(() {
      Navigator.pop(context);
      onTap.call();
    });
  }
}
