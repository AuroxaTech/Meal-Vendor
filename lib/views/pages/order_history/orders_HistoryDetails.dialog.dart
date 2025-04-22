import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:vendor/constants/app_colors.dart';
import 'package:vendor/models/order.dart';
import 'package:vendor/utils/utils.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:vendor/views/pages/order_history/missing_items.dialog.dart';
import '../../../constants/app_images.dart';
import '../../../constants/app_strings.dart';
import '../../../constants/app_text_styles.dart';
import '../../../utils/size_utils.dart';
import '../../../utils/ui_spacer.dart';
import '../../../widgets/busy_indicator.dart';
import '../../../widgets/cards/amount_tile.dart';
import '../../../widgets/custom_image.view.dart';
import '../../../widgets/custom_list_view.dart';
import '../../../widgets/list_items/order_product.list_item.dart';

class OrderHistoryDetailsDialog extends StatelessWidget {
  const OrderHistoryDetailsDialog({
    required this.order,
    super.key,
  });

  final Order order;

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    DateTime createdAt = order.driver != null
        ? DateTime.parse(order.driver!.createdAt!)
        : DateTime.now();
    Duration accountAge = now.difference(createdAt);
    String years = '';
    if (accountAge.inDays ~/ 365 > 0) {
      years = '${accountAge.inDays ~/ 365} year';
      if (accountAge.inDays ~/ 365 > 1) {
        years = '${accountAge.inDays ~/ 365} years';
      }
    }
    String months = '';
    if ((accountAge.inDays % 365) ~/ 30 > 0) {
      months = '${(accountAge.inDays % 365) ~/ 30} month';
      if ((accountAge.inDays % 365) ~/ 30 > 1) {
        months = '${(accountAge.inDays % 365) ~/ 30} months';
      }
    }
    String days = '';
    if (accountAge.inDays % 30 > 0) {
      days = '${accountAge.inDays % 30} day';
      if (accountAge.inDays % 30 > 1) {
        days = '${accountAge.inDays % 30} days';
      }
    }
    return SizeConfigs.isTablet
        ? Container(
            height: MediaQuery.sizeOf(context).shortestSide * 0.8,
            width: MediaQuery.sizeOf(context).longestSide * 0.8,
            padding: const EdgeInsets.fromLTRB(10, 15, 10, 0),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                border: Border.all(width: 4, color: AppColor.appMainColor)),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(
                        padding: EdgeInsets.only(right: getWidth(10)),
                        alignment: Alignment.centerLeft,
                        child: Text(
                            '${order.user.getCapitalizedName()}\n'
                            '#${order.code}',
                            style: AppTextStyle.comicNeue18BoldTextStyle(
                                color: AppColor.appMainColor)),
                      ),
                      Container(
                              child: Text('${order.status.capitalized}',
                                  maxLines: 4,
                                  style: AppTextStyle.comicNeue18BoldTextStyle(
                                      color: AppColor.appMainColor)))
                          .px8(),
                    ],
                  ).py8(),

                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: EdgeInsets.zero,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(
                              width: 2, color: AppColor.appMainColor),
                        ),
                        child: Row(
                          children: [
                            Image.asset(
                              AppImages.printer,
                              fit: BoxFit.cover,
                              width: getShortestSide(30),
                            ).px4(),
                            Text('Reprint\nReceipt',
                                    textAlign: TextAlign.center,
                                    style:
                                        AppTextStyle.comicNeue18BoldTextStyle(
                                            color: AppColor.appMainColor))
                                .p4(),
                          ],
                        ).px12(),
                      ).onInkTap(() {}),
                      Container(
                        padding: EdgeInsets.zero,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(
                              width: 2, color: AppColor.appMainColor),
                        ),
                        child: Row(
                          children: [
                            Image.asset(
                              AppImages.telephone,
                              fit: BoxFit.cover,
                              width: getShortestSide(30),
                            ).px4(),
                            Text('Call\nCustomer',
                                    textAlign: TextAlign.center,
                                    style:
                                        AppTextStyle.comicNeue18BoldTextStyle(
                                            color: AppColor.appMainColor))
                                .p4(),
                          ],
                        ).px12(),
                      ).px4().onInkTap(() => makeACall(order.user.phone)),
                      Container(
                        padding: EdgeInsets.zero,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(
                              width: 2, color: AppColor.appMainColor),
                        ),
                        child: Row(
                          children: [
                            Text('Missed items\nWrong items',
                                    textAlign: TextAlign.center,
                                    style:
                                        AppTextStyle.comicNeue18BoldTextStyle(
                                            color: AppColor.appMainColor))
                                .p4(),
                          ],
                        ).px12(),
                      ).onInkTap(() => openItemIssueDialog(context)),
                      Container(
                        padding: EdgeInsets.zero,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(
                              width: 2, color: AppColor.appMainColor),
                        ),
                        child: Row(
                          children: [
                            Image.asset(
                              AppImages.supportDesk,
                              fit: BoxFit.cover,
                              width: getShortestSide(30),
                            ).px4(),
                            Text('Request\nHelp',
                                    textAlign: TextAlign.center,
                                    style:
                                        AppTextStyle.comicNeue18BoldTextStyle(
                                            color: AppColor.appMainColor))
                                .p4(),
                          ],
                        ).px12(),
                      )
                          .pOnly(left: 4)
                          .onInkTap(() => makeACall(Utils.supportNumber)),
                    ],
                  ).py8(),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: SizedBox(
                          child: VStack(
                            [
                              Text(
                                  order.isPackageDelivery
                                      ? "Package Details"
                                      : order.isSerice
                                          ? "Service"
                                          : "Items:",
                                  style: AppTextStyle.comicNeue14BoldTextStyle(
                                      color: AppColor.appMainColor)),
                              order.isPackageDelivery
                                  ? VStack(
                                      [
                                        AmountTile(
                                          "Package Type".tr(),
                                          order.packageType!.name,
                                        ),
                                        AmountTile(
                                            "Width".tr(), "${order.width} cm"),
                                        AmountTile("Length".tr(),
                                            "${order.length} cm"),
                                        AmountTile("Height".tr(),
                                            "${order.height} cm"),
                                        AmountTile("Weight".tr(),
                                            "${order.weight} kg"),
                                      ],
                                      crossAlignment: CrossAxisAlignment.end,
                                    )
                                  : order.isSerice
                                      ? VStack(
                                          [
                                            AmountTile(
                                              "Service".tr(),
                                              order.orderService!.service!.name,
                                            ),
                                            if (order.orderService!.service!
                                                    .category !=
                                                null)
                                              AmountTile(
                                                "Category".tr(),
                                                order.orderService!.service!
                                                    .category!.name,
                                              ),
                                          ],
                                          crossAlignment:
                                              CrossAxisAlignment.end,
                                        )
                                      : CustomListView(
                                          noScrollPhysics: true,
                                          dataSet: order.orderProducts ?? [],
                                          separatorBuilder: (context, index) =>
                                              UiSpacer.divider(
                                                  height: 10, thickness: 0.6),
                                          itemBuilder: (context, index) {
                                            //
                                            final orderProduct =
                                                order.orderProducts![index];
                                            return OrderProductListItem(
                                              orderProduct: orderProduct,
                                              index: index,
                                            );
                                          },
                                        ),

                              //order photo
                              (order.photo != null &&
                                      !Utils.isDefaultImg(order.photo))
                                  ? CustomImage(
                                      imageUrl: order.photo!,
                                      boxFit: BoxFit.fill,
                                    )
                                      .h(context.percentHeight * 30)
                                      .wFull(context)
                                  : UiSpacer.emptySpace(),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(width: 50),
                      Expanded(
                        child: SizedBox(
                          child: VStack(
                            [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                        color: AppColor.appMainColor,
                                        borderRadius: BorderRadius.circular(
                                            getShortestSide(100)),
                                        border: Border.all(
                                            width: 1,
                                            color: AppColor.appMainColor)),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(
                                          getShortestSide(100)),
                                      child: order.driver != null
                                          ? CachedNetworkImage(
                                              imageUrl: order.driver!.photo,
                                              errorWidget:
                                                  (context, imageUrl, _) =>
                                                      Image.asset(
                                                AppImages.appLogo,
                                                fit: BoxFit.cover,
                                              ),
                                              width: getShortestSide(100),
                                              fit: BoxFit.cover,
                                              progressIndicatorBuilder:
                                                  (context, imageURL,
                                                          progress) =>
                                                      BusyIndicator()
                                                          .centered(),
                                            )
                                          : ClipOval(
                                              child: Image.asset(
                                                AppImages.noImage,
                                                fit: BoxFit.cover,
                                                width: getShortestSide(100),
                                              ),
                                            ),
                                    ),
                                  ),
                                  Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Container(
                                          padding: EdgeInsets.only(
                                              right: getWidth(8)),
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                              '${order.driver?.name.split(' ').first ?? ''}\nArriving in\n ${order.travelTime ?? 0} mins',
                                              style: AppTextStyle
                                                  .comicNeue20BoldTextStyle(
                                                      color: AppColor
                                                          .appMainColor)),
                                        ).px12(),
                                        Container(
                                          width: 90,
                                          alignment: Alignment.centerRight,
                                          padding: EdgeInsets.zero,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            border: Border.all(
                                                width: 2,
                                                color: AppColor.appMainColor),
                                          ),
                                          child: Text('Call\nDriver',
                                                  textAlign: TextAlign.center,
                                                  style: AppTextStyle
                                                      .comicNeue14BoldTextStyle(
                                                          color: AppColor
                                                              .appMainColor))
                                              .px20()
                                              .py4(),
                                        ).p8().onInkTap(() => makeACall(
                                            order.driver?.phone ?? '')),
                                      ]).expand()
                                ],
                              ),
                              Text('Delivery Bag: ${order.vendor!.deliveryBag}',
                                      style:
                                          AppTextStyle.comicNeue14BoldTextStyle(
                                              color: AppColor.appMainColor))
                                  .pOnly(bottom: 12),
                              Text('Pizza Bag: ${order.vendor!.pizzaBag}',
                                      style:
                                          AppTextStyle.comicNeue14BoldTextStyle(
                                              color: AppColor.appMainColor))
                                  .pOnly(bottom: 12),
                              Text('Serving it Right: ${order.vendor!.servingRight}',
                                      style:
                                          AppTextStyle.comicNeue14BoldTextStyle(
                                              color: AppColor.appMainColor))
                                  .pOnly(bottom: 12),
                              Text('Completed store orders: ${order.vendor!.completedOrders}',
                                      style:
                                          AppTextStyle.comicNeue14BoldTextStyle(
                                              color: AppColor.appMainColor))
                                  .pOnly(bottom: 12),
                              Text('Missed store orders: ${order.vendor!.failedOrders}',
                                      style:
                                          AppTextStyle.comicNeue14BoldTextStyle(
                                              color: AppColor.appMainColor))
                                  .pOnly(bottom: 12),
                              Text('Account age: ${order.vendor!.age} ',
                                      style:
                                          AppTextStyle.comicNeue14BoldTextStyle(
                                              color: AppColor.appMainColor))
                                  .pOnly(bottom: 12),
                            ],
                          ),
                        ).pOnly(top: 12),
                      ),
                    ],
                  ).p8(),
                  // Row(
                  //   crossAxisAlignment: CrossAxisAlignment.start,
                  //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //   children: [
                  //     SizedBox(
                  //       width: MediaQuery.sizeOf(context).shortestSide / 3,
                  //       child: VStack(
                  //         [
                  //
                  //           Text(order.isPackageDelivery
                  //               ? "Package Details"
                  //               : order.isSerice
                  //               ? "Service"
                  //               : "Items:",
                  //               style: AppTextStyle.comicNeue14BoldTextStyle(
                  //                   color: AppColor.appMainColor)),
                  //           order.isPackageDelivery
                  //               ? VStack(
                  //             [
                  //               AmountTile(
                  //                 "Package Type".tr(),
                  //                 order.packageType!.name,
                  //               ),
                  //               AmountTile("Width".tr(), "${order.width} cm"),
                  //               AmountTile("Length".tr(), "${order.length} cm"),
                  //               AmountTile("Height".tr(), "${order.height} cm"),
                  //               AmountTile("Weight".tr(), "${order.weight} kg"),
                  //             ],
                  //             crossAlignment: CrossAxisAlignment.end,
                  //           )
                  //               : order.isSerice
                  //               ? VStack(
                  //             [
                  //               AmountTile(
                  //                 "Service".tr(),
                  //                 order.orderService!.service!.name,
                  //               ),
                  //               if (order.orderService!.service!.category != null)
                  //                 AmountTile(
                  //                   "Category".tr(),
                  //                   order.orderService!.service!.category!.name,
                  //                 ),
                  //             ],
                  //             crossAlignment: CrossAxisAlignment.end,
                  //           )
                  //               : CustomListView(
                  //             noScrollPhysics: true,
                  //             dataSet: order.orderProducts ?? [],
                  //             separatorBuilder: (context, index) =>
                  //                 UiSpacer.divider(height: 10, thickness: 0.6),
                  //             itemBuilder: (context, index) {
                  //               //
                  //               final orderProduct = order.orderProducts![index];
                  //               return OrderProductListItem(
                  //                 orderProduct: orderProduct,index: index,
                  //               );
                  //             },
                  //           ),
                  //
                  //           //order photo
                  //           (order.photo != null && !Utils.isDefaultImg(order.photo))
                  //               ? CustomImage(
                  //             imageUrl: order.photo!,
                  //             boxFit: BoxFit.fill,
                  //           ).h(context.percentHeight * 30).wFull(context)
                  //               : UiSpacer.emptySpace(),
                  //         ],
                  //       ),
                  //     ),
                  //
                  //     SizedBox(
                  //       width: MediaQuery.sizeOf(context).shortestSide / 3,
                  //       child: VStack(
                  //         [
                  //
                  //           HStack(
                  //             [
                  //               order.driver != null
                  //                   ? CachedNetworkImage(
                  //                 imageUrl: order.driver!.photo,
                  //                 errorWidget: (context, imageUrl, _) => Image.asset(
                  //                   AppImages.appLogo,
                  //                   fit: BoxFit.cover,
                  //                 ),
                  //                 width: getShortestSide(50),
                  //                 fit: BoxFit.cover,
                  //                 progressIndicatorBuilder:
                  //                     (context, imageURL, progress) =>
                  //                     BusyIndicator().centered(),
                  //               )
                  //                   : ClipOval(
                  //                 child:  Image.asset(
                  //                   AppImages.noImage,
                  //                   fit: BoxFit.cover,
                  //                   width: getShortestSide(50),),
                  //               ),
                  //
                  //               Spacer(),
                  //
                  //               VStack([
                  //
                  //                 Container(
                  //                   padding:
                  //                   EdgeInsets.only(right: getWidth(8), left: getWidth(8)),
                  //                   alignment: Alignment.centerLeft,
                  //                   child: Text('${order.driver?.name.split(' ').first ?? ''}',
                  //                       style: AppTextStyle.comicNeue20BoldTextStyle(
                  //                           color: AppColor.appMainColor)),
                  //                 ),
                  //                 Container(
                  //                   padding: EdgeInsets.zero,
                  //                   decoration: BoxDecoration(
                  //                     color: Colors.white,
                  //                     borderRadius: BorderRadius.circular(25),
                  //                     border: Border.all(
                  //                         width: 2,
                  //                         color: AppColor.appMainColor), ),
                  //                   child:   Text('Call\nDriver',
                  //                       textAlign: TextAlign.center,
                  //                       style: AppTextStyle.comicNeue14BoldTextStyle(
                  //                           color: AppColor.appMainColor)).px20().py8(),
                  //                 ).p12().onInkTap(() => makeACall(order.driver?.phone ?? '')),
                  //               ])
                  //             ],
                  //           ),
                  //           Text('Delivery Bag: ${order.vendor!.deliveryBag}',
                  //               style: AppTextStyle.comicNeue14BoldTextStyle(
                  //                   color: AppColor.appMainColor)).p12(),
                  //
                  //           Text('Pizza Bag: ${order.vendor!.pizzaBag}',
                  //               style: AppTextStyle.comicNeue14BoldTextStyle(
                  //                   color: AppColor.appMainColor)).p12(),
                  //
                  //           Text('Serving it Right: ${order.vendor!.servingRight}',
                  //               style: AppTextStyle.comicNeue14BoldTextStyle(
                  //                   color: AppColor.appMainColor)).p12(),
                  //
                  //           Text('Completed store orders: ${order.vendor!.completedOrders}',
                  //               style: AppTextStyle.comicNeue14BoldTextStyle(
                  //                   color: AppColor.appMainColor)).p12(),
                  //
                  //           Text('Missed store orders: ${order.vendor!.failedOrders}',
                  //               style: AppTextStyle.comicNeue14BoldTextStyle(
                  //                   color: AppColor.appMainColor)).p12(),
                  //
                  //           Text('Account age: $years $months $days ',
                  //               style: AppTextStyle.comicNeue14BoldTextStyle(
                  //                   color: AppColor.appMainColor)).p12(),
                  //
                  //         ],
                  //       ),
                  //     ).py12(),
                  //   ],
                  // ),
                ],
              ),
            ),
          )
        : Container(
            width: MediaQuery.sizeOf(context).shortestSide * 0.9,
            constraints: BoxConstraints(
              minHeight: 200,
              maxHeight: MediaQuery.sizeOf(context).longestSide * 0.7,
            ),
            padding: const EdgeInsets.fromLTRB(15, 15, 15, 0),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                border: Border.all(width: 4, color: AppColor.appMainColor)),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: EdgeInsets.only(right: getWidth(5)),
                        alignment: Alignment.centerLeft,
                        child: Text(order.user.getCapitalizedName(),
                            style: AppTextStyle.comicNeue20BoldTextStyle(
                                color: AppColor.appMainColor)),
                      ),
                      Container(
                              child: Text('${order.status}',
                                  maxLines: 4,
                                  style: AppTextStyle.comicNeue20BoldTextStyle(
                                      color: AppColor.appMainColor)))
                          .px12(),
                    ],
                  ).py8(),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: EdgeInsets.zero,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(
                              width: 2, color: AppColor.appMainColor),
                        ),
                        child: Row(
                          children: [
                            Image.asset(
                              AppImages.printer,
                              fit: BoxFit.cover,
                              width: getShortestSide(30),
                            ).px4(),
                            Text('Reprint\nReceipt',
                                    textAlign: TextAlign.center,
                                    style:
                                        AppTextStyle.comicNeue18BoldTextStyle(
                                            color: AppColor.appMainColor))
                                .p4(),
                          ],
                        ).px12(),
                      ).onInkTap(() {}),
                      Container(
                        padding: EdgeInsets.zero,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(
                              width: 2, color: AppColor.appMainColor),
                        ),
                        child: Row(
                          children: [
                            Image.asset(
                              AppImages.telephone,
                              fit: BoxFit.cover,
                              width: getShortestSide(30),
                            ).px4(),
                            Text('Call\nCustomer',
                                    textAlign: TextAlign.center,
                                    style:
                                        AppTextStyle.comicNeue18BoldTextStyle(
                                            color: AppColor.appMainColor))
                                .p4(),
                          ],
                        ).px12(),
                      ).px4().onInkTap(() => makeACall(order.user.phone))
                    ],
                  ).py8(),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: EdgeInsets.zero,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(
                              width: 2, color: AppColor.appMainColor),
                        ),
                        child: Row(
                          children: [
                            Text('Missed items\nWrong items',
                                    textAlign: TextAlign.center,
                                    style:
                                        AppTextStyle.comicNeue18BoldTextStyle(
                                            color: AppColor.appMainColor))
                                .p4(),
                          ],
                        ).px12(),
                      ).onInkTap(() => openItemIssueDialog(context)),
                      Container(
                        padding: EdgeInsets.zero,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(
                              width: 2, color: AppColor.appMainColor),
                        ),
                        child: Row(
                          children: [
                            Image.asset(
                              AppImages.supportDesk,
                              fit: BoxFit.cover,
                              width: getShortestSide(30),
                            ).px4(),
                            Text('Request\nHelp',
                                    textAlign: TextAlign.center,
                                    style:
                                        AppTextStyle.comicNeue18BoldTextStyle(
                                            color: AppColor.appMainColor))
                                .p4(),
                          ],
                        ).px12(),
                      )
                          .pOnly(left: 4)
                          .onInkTap(() => makeACall(Utils.supportNumber)),
                    ],
                  ).py8(),
                  SizedBox(
                    child: VStack(
                      [
                        Text(
                                order.isPackageDelivery
                                    ? "Package Details"
                                    : order.isSerice
                                        ? "Service"
                                        : "Items:",
                                style: AppTextStyle.comicNeue16BoldTextStyle(
                                    color: AppColor.appMainColor))
                            .py8(),
                        CustomListView(
                          noScrollPhysics: true,
                          dataSet: order.orderProducts ?? [],
                          separatorBuilder: (context, index) =>
                              UiSpacer.divider(height: 10, thickness: 0.6),
                          itemBuilder: (context, index) {
                            //
                            final orderProduct = order.orderProducts![index];
                            return OrderProductListItem(
                              orderProduct: orderProduct,
                              index: index,
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    child: VStack(
                      [
                        HStack(
                          [
                            Container(
                                decoration: BoxDecoration(
                                    color: AppColor.appMainColor,
                                    borderRadius: BorderRadius.circular(
                                        getShortestSide(100)),
                                    border: Border.all(
                                        width: 2,
                                        color: AppColor.appMainColor)),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(
                                      getShortestSide(100)),
                                  child: order.driver != null
                                      ? CachedNetworkImage(
                                          imageUrl: order.driver!.photo,
                                          errorWidget: (context, imageUrl, _) =>
                                              Image.asset(
                                            AppImages.appLogo,
                                            fit: BoxFit.cover,
                                          ),
                                          width: getShortestSide(100),
                                          height: getShortestSide(100),
                                          fit: BoxFit.cover,
                                          progressIndicatorBuilder:
                                              (context, imageURL, progress) =>
                                                  BusyIndicator().centered(),
                                        )
                                      : ClipOval(
                                          child: Image.asset(
                                            AppImages.noImage,
                                            fit: BoxFit.cover,
                                            width: getShortestSide(100),
                                            height: getShortestSide(100),
                                          ),
                                        ),
                                )),
                            Spacer(),
                            Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    padding: EdgeInsets.only(right: 22),
                                    alignment: Alignment.centerRight,
                                    child: Text(
                                        '${order.driver?.name.split(' ').first ?? ''}',
                                        textAlign: TextAlign.right,
                                        style: AppTextStyle
                                            .comicNeue20BoldTextStyle(
                                                color: AppColor.appMainColor)),
                                  ),
                                  Container(
                                    padding: EdgeInsets.zero,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(15),
                                      border: Border.all(
                                          width: 2,
                                          color: AppColor.appMainColor),
                                    ),
                                    child: Text('Call\nDriver',
                                            textAlign: TextAlign.center,
                                            style: AppTextStyle
                                                .comicNeue14BoldTextStyle(
                                                    color:
                                                        AppColor.appMainColor))
                                        .px20()
                                        .py8(),
                                  ).p4().onInkTap(() =>
                                      makeACall(order.driver?.phone ?? '')),
                                ])
                          ],
                        ),
                        Text('Delivery Bag: Verified',
                                style: AppTextStyle.comicNeue16BoldTextStyle(
                                    color: AppColor.appMainColor))
                            .p4(),
                        Text('Pizza Bag: Verified',
                                style: AppTextStyle.comicNeue16BoldTextStyle(
                                    color: AppColor.appMainColor))
                            .p4(),
                        Text('Serving it Right: Verified',
                                style: AppTextStyle.comicNeue16BoldTextStyle(
                                    color: AppColor.appMainColor))
                            .p4(),
                        Text('Completed store orders: 39',
                                style: AppTextStyle.comicNeue16BoldTextStyle(
                                    color: AppColor.appMainColor))
                            .p4(),
                        Text('Missed store orders: 00',
                                style: AppTextStyle.comicNeue16BoldTextStyle(
                                    color: AppColor.appMainColor))
                            .p4(),
                        Text('Account age: $years $months $days ',
                                style: AppTextStyle.comicNeue16BoldTextStyle(
                                    color: AppColor.appMainColor))
                            .p4(),
                      ],
                    ),
                  ).py12(),
                ],
              ),
            ),
          );
  }

  // Dialogue

  Widget orderSection(Widget child, BuildContext context) {
    return child
        .wFull(context)
        .box
        .shadowSm
        .color(context.theme.colorScheme.background)
        .p12
        .roundedSM
        .make()
        .pOnly(bottom: 12);
  }

  void openItemIssueDialog(BuildContext context) {
    Navigator.pop(context);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.transparent,
          content: Container(
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                border: Border.all(width: 4, color: AppColor.appMainColor)),
            padding: EdgeInsets.all(15.0),
            child: Wrap(
              alignment: WrapAlignment.center,
              children: <Widget>[
                Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      border:
                          Border.all(width: 3, color: AppColor.appMainColor)),
                  width: 108.0,
                  height: 68,
                  child: Text('Request\nRedelivery',
                      style: AppTextStyle.comicNeue20BoldTextStyle(
                          color: AppColor.appMainColor)),
                )
                    .pOnly(right: getWidth(15))
                    .onInkTap(() => openRequestRedeliveryDialog(context)),
                Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      border:
                          Border.all(width: 3, color: AppColor.appMainColor)),
                  width: 108.0,
                  height: 68,
                  child: Text('Refund',
                      style: AppTextStyle.comicNeue20BoldTextStyle(
                          color: AppColor.appMainColor)),
                ).onInkTap(() => openRefundDialog(context, order))
              ],
            ),
          ),
        );
      },
    );
  }

  void openRequestRedeliveryDialog(BuildContext context) {
    Navigator.pop(context);
    String? _selectedValue;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder:
              (BuildContext context, void Function(void Function()) newState) {
            return AlertDialog(
              backgroundColor: Colors.transparent,
              content: Container(
                height: SizeConfigs.isTablet ? getHeight(250) : getHeight(320),
                padding: const EdgeInsets.fromLTRB(15, 15, 15, 0),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(width: 4, color: AppColor.appMainColor)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text('Select Reason',
                            style: AppTextStyle.comicNeue30BoldTextStyle(
                                color: AppColor.appMainColor))
                        .p8(),
                    Spacer(),
                    RadioListTile(
                      contentPadding: EdgeInsets.zero,
                      visualDensity: VisualDensity.compact,
                      activeColor: AppColor.appMainColor,
                      title: Text("Food Made Wrong",
                          style: AppTextStyle.comicNeue20BoldTextStyle(
                              color: AppColor.appMainColor)),
                      value: 'food_mad_wrong',
                      onChanged: (newValue) {
                        _selectedValue = newValue;
                        newState(() {});
                      },
                      controlAffinity: ListTileControlAffinity.leading,
                      groupValue: _selectedValue, //  <-- leading Checkbox
                    ),
                    RadioListTile(
                      contentPadding: EdgeInsets.zero,
                      visualDensity: VisualDensity.compact,
                      activeColor: AppColor.appMainColor,
                      title: Text("Missed Order Items",
                          style: AppTextStyle.comicNeue20BoldTextStyle(
                              color: AppColor.appMainColor)),
                      value: "missed_order_items",
                      onChanged: (newValue) {
                        _selectedValue = newValue;
                        newState(() {});
                      },
                      controlAffinity: ListTileControlAffinity.leading,
                      groupValue: _selectedValue, //  <-- leading Checkbox
                    ),
                    RadioListTile(
                      contentPadding: EdgeInsets.zero,
                      visualDensity: VisualDensity.compact,
                      activeColor: AppColor.appMainColor,
                      title: Text("Wrong Order Handed",
                          style: AppTextStyle.comicNeue20BoldTextStyle(
                              color: AppColor.appMainColor)),
                      value: "wrong_order_handed",
                      onChanged: (newValue) {
                        _selectedValue = newValue;
                        newState(() {});
                      },
                      controlAffinity: ListTileControlAffinity.leading,
                      groupValue: _selectedValue, //  <-- leading Checkbox
                    ),
                    Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Spacer(),
                        Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(
                                  width: 3, color: AppColor.appMainColor)),
                          child: Text('Request Driver',
                                  style: AppTextStyle.comicNeue25BoldTextStyle(
                                      color: AppColor.appMainColor))
                              .p8(),
                        ).onInkTap(() {
                          Navigator.of(context).pop();
                          if (_selectedValue == "missed_order_items") {
                            openItemsMissingDialog(context,order);
                          }
                        }).pOnly(right: 5),
                      ],
                    ),
                    Spacer(),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Future<void> openRefundDialog(BuildContext context, Order order) async {
    Navigator.pop(context);
    List<bool> isChecked =
        List.generate(order.orderProducts!.length, (index) => false);
    double refundAmount = 0.0;

    await showDialog(
      context: context,
      builder: (BuildContext context) => StatefulBuilder(
        builder:
            (BuildContext context, void Function(void Function()) newState) {
          return Dialog(
            insetPadding: EdgeInsets.symmetric(horizontal: padding16),
            insetAnimationCurve: Curves.fastOutSlowIn,
            insetAnimationDuration: const Duration(milliseconds: 500),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: Container(
              width: MediaQuery.sizeOf(context).shortestSide / 2,
              padding: const EdgeInsets.fromLTRB(10, 15, 10, 15),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(width: 4, color: AppColor.appMainColor)),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(
                      left: 5,
                      right: 5,
                      top: 10,
                    ),
                    child: Text("Select items for refund",
                        style: AppTextStyle.comicNeue30BoldTextStyle(
                            color: AppColor.appMainColor)),
                  ),
                  Container(
                    height: order.orderProducts!.length * 50 >
                            SizeConfigs.longestSide! / 2
                        ? SizeConfigs.longestSide! / 2
                        : order.orderProducts!.length * 50,
                    child: ListView.builder(
                        padding: EdgeInsets.only(
                            left: 5, right: 5, top: 5, bottom: 5),
                        shrinkWrap: true,
                        itemCount: order.orderProducts!.length,
                        itemBuilder: (context, i) {
                          return CheckboxListTile(
                            contentPadding: EdgeInsets.zero,
                            visualDensity: VisualDensity.compact,
                            activeColor: AppColor.appMainColor,
                            title: Text(
                                "${order.orderProducts![i].product!.name}",
                                style: AppTextStyle.comicNeue20BoldTextStyle(
                                    color: AppColor.appMainColor)),
                            value: isChecked[i],
                            onChanged: (newValue) {
                              newState(() {
                                isChecked[i] = newValue!;
                                if (isChecked[i]) {
                                  refundAmount = refundAmount +
                                      order.orderProducts![i].product!.price;
                                } else {
                                  refundAmount = refundAmount -
                                      order.orderProducts![i].product!.price;
                                }
                              });
                            },
                            side: BorderSide(
                              color: AppColor.appMainColor,
                              width: 3,
                            ),
                            controlAffinity: ListTileControlAffinity
                                .leading, //  <-- leading Checkbox
                          );
                        }),
                  ),
                  Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        border:
                            Border.all(width: 3, color: AppColor.appMainColor)),
                    width: MediaQuery.sizeOf(context).shortestSide,
                    child: RichText(
                      maxLines: 5,
                      textAlign: TextAlign.end,
                      text: TextSpan(
                        children: [
                          TextSpan(
                              text: 'Refund',
                              style: AppTextStyle.comicNeue25BoldTextStyle(
                                  color: AppColor.appMainColor)),
                          TextSpan(
                              text: refundAmount > 0
                                  ? ' ${AppStrings.currencySymbol} $refundAmount'
                                  : '',
                              style: AppTextStyle.comicNeue25BoldTextStyle(
                                  color: AppColor.appMainColor)),
                          TextSpan(
                              text: refundAmount > 0
                                  ? ' plus taxes and fees'
                                  : '',
                              style: AppTextStyle.comicNeue14BoldTextStyle(
                                  color: AppColor.appMainColor)),
                        ],
                      ),
                    ).p8(),
                  ).px20().py4().onInkTap(() => Navigator.pop(context))
                ],
              ),
            ), //open dialogue
          );
        },
      ),
    );
  }

  void openItemsMissingDialog(BuildContext context,Order order) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.transparent,
          content: MissingItemsDialog(order: order,),
        );
      },
    );
  }

  void openRequestHelpDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.transparent,
          content: Container(
            height: MediaQuery.sizeOf(context).longestSide / 6,
            width: MediaQuery.sizeOf(context).shortestSide,
            padding: EdgeInsets.fromLTRB(
                getWidth(15), getWidth(5), getWidth(15), getWidth(5)),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                border: Border.all(width: 4, color: AppColor.appMainColor)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Do You Want to Request Help for Maria’s Order?',
                        textAlign: TextAlign.center,
                        style: AppTextStyle.comicNeue40BoldTextStyle(
                            color: AppColor.appMainColor))
                    .px4(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      height: getShortestSide(70),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(
                              width: 3, color: AppColor.appMainColor)),
                      width: (MediaQuery.sizeOf(context).shortestSide -
                              Utils.navRailWidth) /
                          3,
                      child: Text('Go\nBack',
                              textAlign: TextAlign.center,
                              style: AppTextStyle.comicNeue20BoldTextStyle(
                                  color: AppColor.appMainColor))
                          .p4(),
                    ).onInkTap(() => Navigator.pop(context)),
                    Container(
                      height: getShortestSide(70),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(
                              width: 3, color: AppColor.appMainColor)),
                      width: (MediaQuery.sizeOf(context).shortestSide -
                              Utils.navRailWidth) /
                          3,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Image.asset(
                            AppImages.telephone,
                            fit: BoxFit.cover,
                            width: getShortestSide(30),
                          ).px4().pOnly(right: 10),
                          Text('Request\nHelp',
                                  textAlign: TextAlign.center,
                                  style: AppTextStyle.comicNeue18BoldTextStyle(
                                      color: AppColor.appMainColor))
                              .p4(),
                        ],
                      ).px12(),
                    )
                        .pOnly(left: 12)
                        .onInkTap(() => makeACall(Utils.supportNumber)),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void openAdjustOrderDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          insetPadding: EdgeInsets.zero,
          backgroundColor: Colors.transparent,
          content: Container(
            height: SizeConfigs.isTablet
                ? MediaQuery.sizeOf(context).longestSide / 6
                : MediaQuery.sizeOf(context).longestSide / 5,
            width: MediaQuery.sizeOf(context).shortestSide,
            padding: EdgeInsets.fromLTRB(
                getWidth(15), getWidth(15), getWidth(15), getWidth(15)),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                border: Border.all(width: 4, color: AppColor.appMainColor)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text('Maria’s Order',
                            textAlign: TextAlign.start,
                            style: AppTextStyle.comicNeue30BoldTextStyle(
                                color: AppColor.appMainColor))
                        .px4(),
                    Container(
                      height: SizeConfigs.isTablet
                          ? getShortestSide(45)
                          : getLongestSide(30),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(
                              width: 3, color: AppColor.appMainColor)),
                      width: (MediaQuery.sizeOf(context).shortestSide -
                              Utils.navRailWidth) /
                          3,
                      child: Text('Go Back',
                          textAlign: TextAlign.center,
                          style: AppTextStyle.comicNeue20BoldTextStyle(
                              color: AppColor.appMainColor)),
                    ).px4().onInkTap(() => Navigator.pop(context)),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      height: SizeConfigs.isTablet
                          ? getShortestSide(80)
                          : getLongestSide(50),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(
                              width: 3, color: AppColor.appMainColor)),
                      width: (MediaQuery.sizeOf(context).shortestSide -
                              Utils.navRailWidth) /
                          4,
                      child: Text('Item not\navailable',
                              textAlign: TextAlign.center,
                              style: AppTextStyle.comicNeue20BoldTextStyle(
                                  color: AppColor.appMainColor))
                          .p4(),
                    ).onInkTap(() => Navigator.pop(context)),
                    Container(
                      height: SizeConfigs.isTablet
                          ? getShortestSide(80)
                          : getLongestSide(50),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(
                              width: 3, color: AppColor.appMainColor)),
                      width: (MediaQuery.sizeOf(context).shortestSide -
                              Utils.navRailWidth) /
                          4,
                      child: Text('Impossible\nInstructions',
                              textAlign: TextAlign.center,
                              style: AppTextStyle.comicNeue20BoldTextStyle(
                                  color: AppColor.appMainColor))
                          .p4(),
                    ).onInkTap(() => Navigator.pop(context)),
                    Container(
                      height: SizeConfigs.isTablet
                          ? getShortestSide(80)
                          : getLongestSide(50),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(
                              width: 3, color: AppColor.appMainColor)),
                      width: (MediaQuery.sizeOf(context).shortestSide -
                              Utils.navRailWidth) /
                          4,
                      child: Text('Add\nPrice',
                              textAlign: TextAlign.center,
                              style: AppTextStyle.comicNeue20BoldTextStyle(
                                  color: AppColor.appMainColor))
                          .p4(),
                    ).onInkTap(() => Navigator.pop(context))
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  makeACall(String number) async {
    String url = "tel:$number";
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}

// class ShowAlertWeekList extends StatefulWidget {
//
//   final Order order;
//   const ShowAlertWeekList(this.order)
//       : super();
//
//   @override
//   _ShowAlertWeekListState createState() => _ShowAlertWeekListState();
// }
//
// class _ShowAlertWeekListState extends State<ShowAlertWeekList> {
//   List<OrderProduct>? orderProducts = [];
//   int weekIndex = 0;
//   List<bool> isChecked = [];
//
//   @override
//   void initState() {
//     super.initState();
//     isChecked = List.generate(widget.order.orderProducts!.length, (index) => false);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Dialog(
//       insetPadding: EdgeInsets.symmetric(horizontal: padding16),
//       insetAnimationCurve: Curves.fastOutSlowIn,
//       insetAnimationDuration: const Duration(milliseconds: 500),
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(radius20),
//       ),
//       child: Stack(
//         children: <Widget>[
//           Container(
//             width: MediaQuery.sizeOf(context).shortestSide / 1.7,
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(radius5),
//               color: Colors.white,
//               shape: BoxShape.rectangle,
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.black26,
//                   offset: const Offset(0.0, 10.0),
//                 ),
//               ],
//             ),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: <Widget>[
//                 Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Container(
//                       padding: EdgeInsets.only(
//                         left: padding50,
//                         right: padding50,
//                         top: padding20,
//                       ),
//                       child: Text("Select items for refund",
//                         style: TextStyle(
//                             height: getHeight(1.5),
//                             fontSize: getFont(font16) ),
//                         textAlign: TextAlign.center,
//                         maxLines: 4,
//                       ),
//                     ),
//                     Container(
//                       height: SizeConfigs.screenHeight! / 4,
//                       child: ListView.builder(
//                           padding: EdgeInsets.only(
//                               left: padding20,
//                               right: padding20,
//                               top: padding22,
//                               bottom: padding16),
//                           shrinkWrap: true,
//                           itemCount: widget.order.orderProducts!.length,
//                           itemBuilder: (context, i) {
//                             return CheckboxListTile(
//                               contentPadding: EdgeInsets.zero,
//                               visualDensity: VisualDensity.compact,
//                               activeColor: AppColor.appMainColor,
//                               title: Text("${widget.order.orderProducts![i].product!.name}",style: AppTextStyle.comicNeue20BoldTextStyle(
//                                   color: AppColor.appMainColor) ),
//                               value: isChecked[i],
//                               onChanged: (newValue) {
//                                 setState(() {
//                                   isChecked[i] = newValue!;
//                                 });
//                               }, side: BorderSide(
//                               color: AppColor.appMainColor,width: 3,
//                             ),
//                               controlAffinity: ListTileControlAffinity.leading,  //  <-- leading Checkbox
//                             );
//                           }),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ), //open dialogue
//     );
//   }
//
// }
