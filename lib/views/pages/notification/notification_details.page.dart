import 'package:flutter/material.dart';
import 'package:vendor/models/notification.dart';
import 'package:vendor/widgets/base.page.dart';
import 'package:vendor/widgets/custom_image.view.dart';
import 'package:velocity_x/velocity_x.dart';

class NotificationDetailsPage extends StatelessWidget {
  const NotificationDetailsPage({
    required this.notification,
    super.key,
  });

  final NotificationModel notification;

  @override
  Widget build(BuildContext context) {
    return BasePage(
      title: "Notification Details",
      showAppBar: true,
      showLeadingAction: true,
      body: SafeArea(
        child: VStack(
          [
            //title
            "${notification.title}".text.bold.xl2.make(),
            //time
            notification.formattedTimeStamp.text.medium
                .color(Colors.grey)
                .make()
                .pOnly(bottom: 10),
            //image
            if (notification.image != null && notification.image!.isNotBlank)
              CustomImage(
                imageUrl: notification.image!,
                width: double.infinity,
                height: context.percentHeight * 30,
              ).py12(),

            //body
            "${notification.body}".text.lg.make(),
          ],
        ).p20().scrollVertical(),
      ),
    );
  }
}
