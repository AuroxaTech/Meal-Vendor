import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:vendor/constants/api.dart';
import 'package:vendor/constants/app_images.dart';
import 'package:vendor/utils/size_utils.dart';
import 'package:vendor/view_models/profile.vm.dart';
import 'package:vendor/views/pages/profile/paymet_accounts.page.dart';
import 'package:vendor/widgets/busy_indicator.dart';
import 'package:vendor/widgets/menu_item.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../constants/app_colors.dart';
import '../../constants/app_text_styles.dart';
import '../../utils/utils.dart';

class ProfileCard extends StatelessWidget {
  const ProfileCard(this.model, {super.key});

  final ProfileViewModel model;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width:
              (MediaQuery.sizeOf(context).width - (Utils.navRailWidth * 1.5)),
          alignment: Alignment.center,
          padding: EdgeInsets.fromLTRB(getWidth(5), 2, getWidth(5), 2),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(25),
              border: Border.all(width: 2, color: AppColor.appMainColor)),
          child: (model.isBusy || model.currentUser == null)
              ? const BusyIndicator().centered().p20()
              : Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    //
                    Container(
                      child: CachedNetworkImage(
                        imageUrl: model.currentUser!.photo,
                        width: getWidth(40),
                        fit: BoxFit.cover,
                        progressIndicatorBuilder:
                            (context, imageUrl, progress) {
                          return const BusyIndicator();
                        },
                        errorWidget: (context, imageUrl, progress) {
                          return Image.asset(
                            AppImages.noImage,
                          );
                        },
                      ).p4(),
                    ),

                    //
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(model.currentUser?.name ?? "",
                            textAlign: TextAlign.end,
                            style: AppTextStyle.comicNeue25BoldTextStyle(
                                color: AppColor.appMainColor)),
                        Text(model.currentUser?.email ?? "",
                            textAlign: TextAlign.end,
                            style: AppTextStyle.comicNeue25BoldTextStyle(
                                color: AppColor.appMainColor)),
                      ],
                    ).expand(),

                    //
                  ],
                ).p8(),
        ).py20(),
        //profile card
        Container(
          width:
              (MediaQuery.sizeOf(context).width - (Utils.navRailWidth * 1.5)),
          alignment: Alignment.center,
          padding: const EdgeInsets.fromLTRB(10, 2, 10, 2),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(25),
              border: Border.all(width: 2, color: AppColor.appMainColor)),
          child: Column(
            children: [
              //
              Visibility(
                visible: !Platform.isIOS,
                child: MenuItem(
                  title: "Backend".tr(),
                  onPressed: () async {
                    try {
                      final url = await Api.redirectAuth(Api.backendUrl);
                      model.openExternalWebpageLink(url);
                    } catch (error) {
                      model.toastError("$error");
                    }
                  },
                ),
              ),
              //
              MenuItem(
                title: "Payment Accounts".tr(),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: ((ctx) => const PaymentAccountsPage())));
                },
                topDivider: true,
              ),
              //
              MenuItem(
                title: "Edit Profile".tr(),
                onPressed: model.openEditProfile,
                topDivider: true,
              ),
              //change password
              MenuItem(
                title: "Change Password".tr(),
                onPressed: model.openChangePassword,
                topDivider: true,
              ),
              //
              MenuItem(
                onPressed: model.deleteAccount,
                divider: false,
                suffix: const Icon(
                  FlutterIcons.x_circle_fea,
                  size: 16,
                  color: Vx.red600,
                ),
                child: "Delete Account".tr().text.red500.lg.make(),
              ),
            ],
          ).px20(),
        ),
      ],
    );
  }
}
