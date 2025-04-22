import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:slide_countdown/slide_countdown.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:vendor/constants/app_colors.dart';
import 'package:vendor/models/order.dart';
import 'package:vendor/utils/utils.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:velocity_x/velocity_x.dart';
import '../../../constants/app_images.dart';
import '../../../constants/app_strings.dart';
import '../../../constants/app_text_styles.dart';
import '../../../requests/order.request.dart';
import '../../../utils/size_utils.dart';
import '../../../utils/ui_spacer.dart';
import '../../../view_models/orders.vm.dart';
import '../../../widgets/busy_indicator.dart';
import '../../../widgets/cards/amount_tile.dart';
import '../../../widgets/custom_image.view.dart';
import '../../../widgets/list_items/order_product.list_item.dart';

class OrderDetailsDialog extends StatelessWidget {
   const OrderDetailsDialog({
    required this.order,
    required this.onCancel,
    super.key,
  });

  final Order order;
  final Function(Order order, String note) onCancel;
  @override
  Widget build(BuildContext context) {
    OrdersViewModel orderRequest = OrdersViewModel(context);

    // print("Result =======> ${order.orderService!.service!.name}");
    String remainingTime = '';
    if (order.driverPickupTime!.isNotEmpty) {
      remainingTime =
          '${DateTime.now().difference(DateTime.parse(order.driverPickupTime!)).inMinutes}';
    }

    Widget orderInfo = Container(
      padding: EdgeInsets.only(right: getWidth(5)),
      alignment: Alignment.centerLeft,
      child: Text(
          '${order.user.getCapitalizedName()}\n'
          '#${order.code}',
          style: AppTextStyle.comicNeue20BoldTextStyle(
              color: AppColor.appMainColor)),
    );

    Widget readyInfo = Text('Ready in\n$remainingTime mins',
        maxLines: 4,
        textAlign: TextAlign.center,
        style: AppTextStyle.comicNeue20BoldTextStyle(
            color: AppColor.appMainColor));

    List<Widget> actions = [
      orderActionButton(
          title1: 'Reprint',
          title2: 'Receipt',
          image: AppImages.printer,
          onTap: () {}),
      orderActionButton(
          title1: 'Call',
          title2: 'Customer',
          image: AppImages.telephone,
          onTap: () => makeACall(order.user.phone)),
      orderActionButton(
          title1: 'Adjust',
          title2: 'Order',
          image: AppImages.wrenchTool,
          onTap: () => openAdjustOrderDialog(context)),
      orderActionButton(
          title1: 'Request',
          title2: 'Help',
          image: AppImages.supportDesk,
          onTap: () => openRequestHelpDialog(context)),
    ];

    List<Widget> orderItems = [
      Text(
              order.isPackageDelivery
                  ? "Package Details"
                  : order.isSerice
                      ? "Service"
                      : "Items:",
              style: AppTextStyle.comicNeue16BoldTextStyle(
                  color: AppColor.appMainColor))
          .py8(),
      if (order.isPackageDelivery)

        VStack(

          [

            AmountTile(
              "Package Type".tr(),
              order.packageType!.name,
            ),
            AmountTile("Width".tr(), "${order.width} cm"),
            AmountTile("Length".tr(), "${order.length} cm"),
            AmountTile("Height".tr(), "${order.height} cm"),
            AmountTile("Weight".tr(), "${order.weight} kg"),
          ],
          crossAlignment: CrossAxisAlignment.end,
        )
      else if (order.isSerice)
        VStack(
          [
            AmountTile(
              "Service".tr(),
              order.orderService!.service!.name,
            ),
            if (order.orderService!.service!.category != null)
              AmountTile(
                "Category".tr(),
                order.orderService!.service!.category!.name,
              ),
          ],
          crossAlignment: CrossAxisAlignment.end,
        )
      else
        for (int i = 0; i < (order.orderProducts ?? []).length; i++)
          InkWell(
            onTap: (){
              showDialog(context: context,
                  builder: (index){
                    return AlertDialog(
                      title: const Text("Delete item"),
                      content: const Text("Item not available"),
                      actions: [
                        TextButton(onPressed: ()async{
                          print(order.code);
                          print(order.orderProducts![i].id);
                          await orderRequest.removeItem(order.code, order.orderProducts![i].id, context) ;
                        }, child: const Text("Delete Item")),
                      ],

                    );

                  });
            },
            child: OrderProductListItem(
              orderProduct: order.orderProducts![i],
              index: i,
              divider: i != ((order.orderProducts ?? []).length - 1),
            ),
          ),

      //order photo
      (order.photo != null && !Utils.isDefaultImg(order.photo))
          ? CustomImage(
              imageUrl: order.photo!,
              boxFit: BoxFit.fill,
            ).h(context.percentHeight * 30).wFull(context)
          : UiSpacer.emptySpace(),

      const Divider(),
      HStack(
        [
          Text("Total",
                  style: AppTextStyle.comicNeue20BoldTextStyle(
                      color: AppColor.appMainColor))
              .px12()
              .expand(),

          Text("${AppStrings.currencySymbol}${order.subTotal}",
              style: AppTextStyle.comicNeue20BoldTextStyle(
                  color: AppColor.appMainColor)),
          //
        ],
      )
    ];

    List<Widget> driverInfo = [
      const SizedBox(
        height: 10.0,
      ),
      if (null != order.driver)
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                  color: AppColor.appMainColor,
                  borderRadius: BorderRadius.circular(100),
                  border: Border.all(width: 1, color: AppColor.appMainColor)),
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: CachedNetworkImage(
                    imageUrl: order.driver!.photo,
                    errorWidget: (context, imageUrl, _) => Image.asset(
                      AppImages.appLogo,
                      fit: BoxFit.cover,
                    ),
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                    progressIndicatorBuilder: (context, imageURL, progress) =>
                        const BusyIndicator().centered(),
                  )),
            ),
            const Expanded(child: SizedBox.shrink()),
            VStack([
              Container(
                padding: EdgeInsets.only(right: getWidth(8), left: getWidth(8)),
                alignment: Alignment.centerLeft,
                child: Text(
                    '${order.driver?.name.split(' ').first ?? order.driver?.name ?? ''}\nArriving in\n ${order.travelTime ?? 0} mins',
                    style: AppTextStyle.comicNeue20BoldTextStyle(
                        color: AppColor.appMainColor)),
              ),
              Container(
                padding: EdgeInsets.zero,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(width: 2, color: AppColor.appMainColor),
                ),
                child: Text('Call\nDriver',
                        textAlign: TextAlign.center,
                        style: AppTextStyle.comicNeue14BoldTextStyle(
                            color: AppColor.appMainColor))
                    .px20()
                    .py4(),
              ).p8().onInkTap(() => makeACall(order.driver?.phone ?? '')),
            ])
          ],
        )
      else
        Container(
          decoration: BoxDecoration(
              color: AppColor.appMainColor,
              borderRadius: BorderRadius.circular(100),
              border: Border.all(width: 1, color: AppColor.appMainColor)),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(100),
            child: ClipOval(
              child: Image.asset(
                AppImages.noImage,
                fit: BoxFit.cover,
                width: 100,
                height: 100,
              ),
            ),
          ),
        ),
      Text('Delivery Bag: ${order.vendor!.deliveryBag}',
              style: AppTextStyle.comicNeue14BoldTextStyle(
                  color: AppColor.appMainColor))
          .pOnly(bottom: 12),
      Text('Pizza Bag: ${order.vendor!.pizzaBag}',
              style: AppTextStyle.comicNeue14BoldTextStyle(
                  color: AppColor.appMainColor))
          .pOnly(bottom: 12),
      Text('Serving it Right: ${order.vendor!.servingRight}',
              style: AppTextStyle.comicNeue14BoldTextStyle(
                  color: AppColor.appMainColor))
          .pOnly(bottom: 12),
      Text('Completed store orders: ${order.vendor!.completedOrders}',
              style: AppTextStyle.comicNeue14BoldTextStyle(
                  color: AppColor.appMainColor))
          .pOnly(bottom: 12),
      Text('Missed store orders: ${order.vendor!.failedOrders}',
              style: AppTextStyle.comicNeue14BoldTextStyle(
                  color: AppColor.appMainColor))
          .pOnly(bottom: 12),
      Text('Account age: ${order.vendor!.age} ',
              style: AppTextStyle.comicNeue14BoldTextStyle(
                  color: AppColor.appMainColor))
          .pOnly(bottom: 12),
    ];

    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(width: 4, color: AppColor.appMainColor)),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Align(
              alignment: Alignment.topRight,
              child: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(
                    Icons.clear,
                    color: Colors.red,
                  )),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(child: orderInfo),
                      Expanded(child: readyInfo),
                    ],
                  ),
                ),
                if (SizeConfigs.isTablet) ...actions,
              ],
            ).px(10.0),
            if (!SizeConfigs.isTablet)
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: actions
                    .sublist(0, 2)
                    .map((e) => Expanded(
                            child: Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: e,
                        )))
                    .toList(),
              ).p(10.0),
            if (!SizeConfigs.isTablet)
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: actions
                    .sublist(2)
                    .map((e) => Expanded(
                            child: Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: e,
                        )))
                    .toList(),
              ).px(10.0),
            if (SizeConfigs.isTablet)
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: orderItems,
                    ),
                  ),
                  const SizedBox(
                    width: 20.0,
                  ),
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: driverInfo,
                    ),
                  ),
                ],
              )
            else ...[
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: orderItems,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 10.0, right: 10.0, bottom: 10.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: driverInfo,
                ),
              ),
            ]
          ],
        ),
      ),
    );
  }

  Widget orderSection(Widget child, BuildContext context) {
    return child
        .wFull(context)
        .box
        .shadowSm
        .color(context.theme.colorScheme.surface)
        .p12
        .roundedSM
        .make()
        .pOnly(bottom: 12);
  }

  void openAdjustOrderDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          insetPadding: EdgeInsets.zero,
          contentPadding: SizeConfigs.isTablet
              ? const EdgeInsets.all(15)
              : const EdgeInsets.all(10),
          backgroundColor: Colors.transparent,
          content: Container(
            //width: MediaQuery.sizeOf(context).shortestSide,
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                border: Border.all(width: 4, color: AppColor.appMainColor)),
            child: Column(
              mainAxisSize: MainAxisSize.min,
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
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(
                              width: 3, color: AppColor.appMainColor)),
                      constraints:
                          const BoxConstraints(minWidth: 110, minHeight: 40.0),
                      child: Text('Go Back',
                          textAlign: TextAlign.center,
                          style: AppTextStyle.comicNeue20BoldTextStyle(
                              color: AppColor.appMainColor)),
                    ).px4().onInkTap(() => Navigator.pop(context)),
                  ],
                ),
                const SizedBox(
                  height: 8.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(
                              width: 3, color: AppColor.appMainColor)),
                      constraints: const BoxConstraints(minWidth: 110),
                      child: Text('Item not\navailable',
                              textAlign: TextAlign.center,
                              style: AppTextStyle.comicNeue20BoldTextStyle(
                                  color: AppColor.appMainColor))
                          .p4(),
                    ).onInkTap(() {
                      onCancel.call(order, 'Item not available');
                      Navigator.pop(context);
                      Navigator.pop(context);
                    }),
                    const SizedBox(
                      width: 8.0,
                    ),
                    Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(
                              width: 3, color: AppColor.appMainColor)),
                      constraints: const BoxConstraints(minWidth: 110),
                      child: Text('Impossible\nInstructions',
                              textAlign: TextAlign.center,
                              style: AppTextStyle.comicNeue20BoldTextStyle(
                                  color: AppColor.appMainColor))
                          .p4(),
                    ).onInkTap(() {
                      onCancel.call(order, 'Impossible Instructions');
                      Navigator.pop(context);
                    }),
                    const SizedBox(
                      width: 8.0,
                    ),
                    Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(
                              width: 3, color: AppColor.appMainColor)),
                      constraints: const BoxConstraints(minWidth: 110),
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

  void openRequestHelpDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          insetPadding: EdgeInsets.zero,
          backgroundColor: Colors.transparent,
          content: Container(
            width: MediaQuery.sizeOf(context).shortestSide *
                (SizeConfigs.isTablet ? 1.25 : 1),
            padding: EdgeInsets.fromLTRB(
                getWidth(15), getWidth(15), getWidth(15), getWidth(15)),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                border: Border.all(width: 4, color: AppColor.appMainColor)),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Do You Want to Request Help for Maria’s Order?',
                        textAlign: TextAlign.center,
                        style: AppTextStyle.comicNeue35BoldTextStyle(
                            color: AppColor.appMainColor))
                    .px4(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(
                              width: 3, color: AppColor.appMainColor)),
                      child: Text('Go Back',
                              textAlign: TextAlign.center,
                              style: AppTextStyle.comicNeue20BoldTextStyle(
                                  color: AppColor.appMainColor))
                          .p4(),
                    ).onInkTap(() => Navigator.pop(context)),
                    Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(
                              width: 3, color: AppColor.appMainColor)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Image.asset(
                            AppImages.telephone,
                            fit: BoxFit.cover,
                            width: getShortestSide(40),
                          ).px4().pOnly(right: 10),
                          Text('Request Help',
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
                ).py(10),
              ],
            ),
          ),
        );
      },
    );
  }

  makeACall(String number) async {
    String url = "tel:$number";
    if (await canLaunchUrlString(url)) {
      await launchUrlString(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Widget orderActionButton(
      {required String title1,
      String title2 = "",
      required String image,
      VoidCallback? onTap}) {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.zero,
      margin: const EdgeInsets.symmetric(horizontal: 2.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(width: 2, color: AppColor.appMainColor),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            image,
            fit: BoxFit.cover,
            height: 30,
          ).px8(),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(title1,
                  textAlign: TextAlign.center,
                  style: AppTextStyle.comicNeue18BoldTextStyle(
                      color: AppColor.appMainColor)),
              if (title2.isNotEmpty)
                Text(title2,
                    textAlign: TextAlign.center,
                    style: AppTextStyle.comicNeue18BoldTextStyle(
                        color: AppColor.appMainColor)),
            ],
          ).p4(),
        ],
      ),
    ).onInkTap(onTap);
  }
}
