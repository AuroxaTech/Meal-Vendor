import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:vendor/constants/app_images.dart';
import 'package:vendor/constants/app_strings.dart';
import 'package:vendor/extensions/dynamic.dart';
import 'package:vendor/models/order.dart';
import 'package:vendor/requests/order.request.dart';
import 'package:vendor/views/pages/order/orders_details.page.dart';
import 'package:vendor/widgets/busy_indicator.dart';
import 'package:vendor/widgets/buttons/custom_button.dart';
import 'package:vendor/widgets/buttons/custom_text_button.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:velocity_x/velocity_x.dart';

class NewOrderAlertBottomSheet extends StatefulWidget {
  const NewOrderAlertBottomSheet({
    required this.orderId,
    super.key,
  });
  final int orderId;

  @override
  State<NewOrderAlertBottomSheet> createState() =>
      _NewOrderAlertBottomSheetState();
}

class _NewOrderAlertBottomSheetState extends State<NewOrderAlertBottomSheet> {
  //
  AssetsAudioPlayer assetsAudioPlayer = AssetsAudioPlayer();

  @override
  void initState() {
    //play after finish loading
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      playNotificationSound();
    });
    super.initState();
  }

  @override
  void dispose() {
    assetsAudioPlayer.isPlaying.value ? assetsAudioPlayer.stop() : null;
    super.dispose();
  }

  //
  void playNotificationSound() {
    try {
      assetsAudioPlayer.stop();
    } catch (error) {
      if (kDebugMode) {
        print("Error stopping audio player");
      }
    }

    //
    assetsAudioPlayer.open(
      Audio("assets/audio/new_order_alert.mp3"),
      loopMode: LoopMode.single,
      notificationSettings: const NotificationSettings(
        nextEnabled: false,
        prevEnabled: false,
        stopEnabled: false,
        seekBarEnabled: false,
      ),
      showNotification: false,
      playInBackground: PlayInBackground.enabled,
    );
  }

  void stopNotificationSound() {
    try {
      assetsAudioPlayer.stop();
    } catch (error) {
      if (kDebugMode) {
        print("Error stopping audio player");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return VStack(
      [
        Image.asset(
          AppImages.newOrderAlert,
          width: context.percentWidth * 50,
          // height: context.percentWidth * 50,
        ).centered(),
        //title
        "New Order".tr().text.xl2.semiBold.makeCentered(),
        "A new order has been placed".tr().text.makeCentered(),
        10.heightBox,
        //order details
        FutureBuilder<Order>(
            future: OrderRequest().getOrderDetails(id: widget.orderId),
            builder: (context, snapshot) {
              //
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const BusyIndicator().centered();
              } else if (snapshot.hasError) {
                return 0.heightBox;
              }
              //
              Order order = snapshot.data!;
              return VStack(
                [
                  HStack([
                    "Order Code".tr().text.semiBold.make().expand(),
                    "#${order.code}".text.make(),
                  ]),
                  HStack([
                    "Total".tr().text.semiBold.make().expand(),
                    "${AppStrings.currencySymbol} ${order.total}"
                        .currencyFormat()
                        .text
                        .make(),
                  ]),
                  HStack([
                    "Payment Method".tr().text.semiBold.make().expand(),
                    "${order.paymentMethod?.name}".text.make(),
                  ]),
                  if (order.deliveryAddress == null)
                    "Pickup Order".tr().text.semiBold.make().centered(),
                  if (order.deliveryAddress != null)
                    HStack([
                      "Delivery Address".tr().text.semiBold.make().expand(),
                      "${order.deliveryAddress?.address}".text.make(),
                    ]),

                  //
                  CustomButton(
                    title: "Open Order Details".tr(),
                    onPressed: () {
                      stopNotificationSound();
                      Navigator.of(context).pop();
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => OrderDetailsPage(
                            order: order,
                          ),
                        ),
                      );
                    },
                  ).wFull(context),
                ],
                spacing: 10,
              ).p(12).box.border(color: Colors.grey).roundedSM.make();
            }),
        15.heightBox,

        CustomTextButton(
          title: "Ok, Close popup".tr(),
          onPressed: () {
            stopNotificationSound();
            Navigator.of(context).pop();
          },
        ).wFull(context),
        10.heightBox,
      ],
      spacing: 5,
    )
        .scrollVertical()
        .p20()
        .py12()
        .box
        .white
        .topRounded()
        .make()
        .h(context.percentHeight * 85);
  }
}
