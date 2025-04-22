import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../../constants/app_colors.dart';
import '../../../constants/app_images.dart';
import '../../../constants/app_routes.dart';
import '../../../models/order.dart';
import '../../../models/order_product.dart';
import '../../../widgets/base.page.dart';

class MissingItemsDialog extends StatefulWidget {
  final Order order;

  const MissingItemsDialog({required this.order, super.key});

  @override
  State<MissingItemsDialog> createState() => _MissingItemsDialogState();
}

class _MissingItemsDialogState extends State<MissingItemsDialog> {
  int submitLevel = 0;

  @override
  void initState() {
    super.initState();
    //make each order product as separate
    List<OrderProduct> orderProducts = [];
    for (OrderProduct orderProduct in widget.order.orderProducts ?? []) {
      for (int i = 0; i < orderProduct.quantity; i++) {
        orderProducts.add(orderProduct.copy());
      }
    }
    widget.order.orderProducts = orderProducts;
  }

  @override
  Widget build(BuildContext context) {
    return BasePage(
      title: "Need Help",
      showLeadingAction: true,
      showAppBar: true,
      elevation: 0,
      appBarItemColor: AppColor.primaryColor,
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 30.0),
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              decoration: BoxDecoration(
                border: Border.all(color: AppColor.primaryColor, width: 3.0),
                borderRadius: BorderRadius.circular(30.0),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          widget.order.vendor?.name ?? "",
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: AppColor.primaryColor),
                        ),
                      ),
                      Text(
                        "${widget.order.total}\$",
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: AppColor.primaryColor),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 8.0,
                  ),
                  Text(
                    Jiffy.parse("${widget.order.createdAt}",
                            pattern: "yyyy-MM-dd HH:mm")
                        .format(pattern: "d MMM, y  EEEE"),
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColor.primaryColor),
                  ),
                  Text(
                    widget.order.code,
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColor.primaryColor),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(
                submitLevel == 0
                    ? "Select the missing items:"
                    : submitLevel == 1
                        ? "Missing Items"
                        : "",
                style: TextStyle(
                    fontSize: 25,
                    color: AppColor.primaryColor),
              ),
            ),
            if (submitLevel == 0)
              for (OrderProduct product in widget.order.orderProducts ?? [])
                ListTile(
                  title: Text(
                    product.product?.name ?? "",
                    style: TextStyle(
                      color: AppColor.primaryColor,
                    ),
                  ),
                  leading: Checkbox(
                    value: product.isSelected,
                    onChanged: (bool? value) {
                      setState(() {
                        product.isSelected = value ?? false;
                      });
                    },
                  ),
                  /*trailing: Text(
                    "${product.price}\$",
                    style: TextStyle(
                      color: AppColor.primaryColor,
                    ),
                  ),*/
                  subtitle: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      for (String option in product.options?.split(",") ?? [])
                        Text(
                          "    1 x $option",
                          style: TextStyle(
                            color: AppColor.primaryColor,
                          ),
                        ),
                    ],
                  ),
                )
            else if (submitLevel == 1)
              for (OrderProduct product in widget.order.orderProducts ?? [])
                if (product.isSelected)
                  ListTile(
                    title: Text(
                      "1.${product.product?.name}",
                      style: TextStyle(
                        color: AppColor.primaryColor,
                      ),
                    ),
                    /*trailing: Text(
                      "${product.price}\$",
                      style: TextStyle(
                        color: AppColor.primaryColor,
                      ),
                    ),*/
                    subtitle: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        for (String option in product.options?.split(",") ?? [])
                          Text(
                            "    1x $option",
                            style: TextStyle(
                              color: AppColor.primaryColor,
                            ),
                          ),
                      ],
                    ),
                  )
                else
                  SizedBox.shrink()
            else
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 30.0, vertical: 8.0),
                child: Text(
                  "We have notified the store and we are working with them and the delivery partner to solve this right away. You will be contacted/notified soon.\n\n\nPlease allow 5-15 minutes as the store might be busy during some hours. Rest assured the issue is being dealt with the highest of urgency and we appreciate allowing us the chance to correct any mistake.",
                  style: TextStyle(
                      fontSize: 20,
                      color: AppColor.primaryColor),
                ),
              ),
            const SizedBox(
              height: 20.0,
            ),
            Row(
              children: [
                const Spacer(),
                InkWell(
                  onTap: () {
                    if (submitLevel == 1) {
                      if (Navigator.canPop(context)) {
                        Navigator.of(context).popUntil(
                          (route) {
                            return route.settings.name == AppRoutes.homeRoute ||
                                route.isFirst;
                          },
                        );
                      }
                    } else {
                      bool canContinue = false;
                      if (submitLevel == 0) {
                        for (OrderProduct product
                            in widget.order.orderProducts ?? []) {
                          if (product.isSelected) {
                            canContinue = true;
                          }
                        }
                      } else {
                        canContinue = true;
                      }
                      if (canContinue) {
                        setState(() {
                          submitLevel = submitLevel + 1;
                        });
                      } else {
                        context.showToast(
                            msg: "Please select product(s)",
                            bgColor: Colors.red);
                      }
                    }
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      border:
                          Border.all(color: AppColor.primaryColor, width: 3.0),
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          submitLevel == 1 ? "Submit" : "Next",
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppColor.primaryColor),
                        ),
                        if (submitLevel != 1) ...[
                          const SizedBox(
                            width: 4.0,
                          ),
                          Image.asset(
                            AppImages.swipeArrows,
                            height: 32,
                          ),
                          const SizedBox(
                            width: 4.0,
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  width: 20.0,
                ),
              ],
            ),
            const SizedBox(
              height: 60.0,
            ),
          ],
        ),
      ),
    );
  }
}
