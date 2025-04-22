import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vendor/utils/size_utils.dart';
import 'package:vendor/utils/ui_spacer.dart';
import 'package:vendor/view_models/profile.vm.dart';
import 'package:vendor/widgets/base.page.dart';
import 'package:stacked/stacked.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../../constants/app_colors.dart';
import '../../../constants/app_images.dart';
import '../../../constants/app_text_styles.dart';
import '../../../utils/utils.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    SizeConfigs().init(context);
    return SafeArea(
      child: ViewModelBuilder<ProfileViewModel>.reactive(
        viewModelBuilder: () => ProfileViewModel(context),
        onViewModelReady: (model) => model.initialise(),
        builder: (context, model, child) {
          return BasePage(
            body: VStack(
              [
                SizeConfigs.isTablet
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Settings',
                              style: AppTextStyle.comicNeue64BoldTextStyle(
                                  color: AppColor.appMainColor)),
                          Row(
                            children: [
                              InkWell(
                                onTap: () => openDialog(context),
                                child: Container(
                                  alignment: Alignment.center,
                                  padding: EdgeInsets.fromLTRB(
                                      getWidth(5), 2, getWidth(5), 2),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(15),
                                      border: Border.all(
                                          width: 2,
                                          color: AppColor.appMainColor)),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Image.asset(
                                        AppImages.moreInfo,
                                        height: getWidth(20),
                                        width: getWidth(20),
                                      ),
                                      Text('More Info',
                                          style: AppTextStyle
                                              .comicNeue20BoldTextStyle(
                                                  color:
                                                      AppColor.appMainColor)),
                                    ],
                                  ),
                                ),
                              ).py8(),
                              7.widthBox,
                              InkWell(
                                onTap: model.logoutPressed,
                                child: Container(
                                  alignment: Alignment.center,
                                  padding: EdgeInsets.fromLTRB(
                                      getWidth(5), 2, getWidth(5), 2),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(15),
                                      border: Border.all(
                                          width: 2,
                                          color: AppColor.appMainColor)),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Image.asset(
                                        AppImages.powerButton,
                                        height: getWidth(20),
                                        width: getWidth(20),
                                      ),
                                      Text('Logout',
                                          style: AppTextStyle
                                              .comicNeue20BoldTextStyle(
                                                  color:
                                                      AppColor.appMainColor)),
                                    ],
                                  ),
                                ),
                              ).py8(),
                            ],
                          ),
                        ],
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Settings',
                              textAlign: TextAlign.left,
                              style: AppTextStyle.comicNeue64BoldTextStyle(
                                  color: AppColor.appMainColor)),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              InkWell(
                                onTap: () => openDialog(context),
                                child: Container(
                                  alignment: Alignment.center,
                                  padding: EdgeInsets.fromLTRB(
                                      getWidth(5), 2, getWidth(5), 2),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(25),
                                      border: Border.all(
                                          width: 2,
                                          color: AppColor.appMainColor)),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Image.asset(
                                        AppImages.moreInfo,
                                        height: getWidth(25),
                                        width: getWidth(25),
                                      ),
                                      Text('More Info',
                                          style: AppTextStyle
                                              .comicNeue25BoldTextStyle(
                                                  color:
                                                      AppColor.appMainColor)),
                                    ],
                                  ),
                                ),
                              ).py12(),
                              InkWell(
                                onTap: model.logoutPressed,
                                child: Container(
                                  alignment: Alignment.center,
                                  padding: EdgeInsets.fromLTRB(
                                      getWidth(5), 2, getWidth(5), 2),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(25),
                                      border: Border.all(
                                          width: 2,
                                          color: AppColor.appMainColor)),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Image.asset(
                                        AppImages.powerButton,
                                        height: getWidth(25),
                                        width: getWidth(25),
                                      ),
                                      Text('Logout',
                                          style: AppTextStyle
                                              .comicNeue25BoldTextStyle(
                                                  color:
                                                      AppColor.appMainColor)),
                                    ],
                                  ),
                                ),
                              ).py12(),
                            ],
                          ),
                        ],
                      ),
                UiSpacer.vSpace(20),
                items('Set up Printer', 'Connected to:', 'epson mx3476937842r7',
                    'assets/images/printer.png',
                    context: context),
                UiSpacer.vSpace(20),
                PopupMenuButton<int>(
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: 1,
                      // row with two children
                      child: Row(
                        children: [
                          Icon(Icons.crop_landscape),
                          SizedBox(
                            width: 10,
                          ),
                          Text("Landscape")
                        ],
                      ),
                    ),
                    const PopupMenuItem(
                      value: 2,
                      // row with 2 children
                      child: Row(
                        children: [
                          Icon(Icons.crop_portrait),
                          SizedBox(
                            width: 10,
                          ),
                          Text("Portrait")
                        ],
                      ),
                    ),
                    const PopupMenuItem(
                      value: 3,
                      // row with two children
                      child: Row(
                        children: [
                          Icon(Icons.crop_rotate_outlined),
                          SizedBox(
                            width: 10,
                          ),
                          Text("Auto")
                        ],
                      ),
                    ),
                  ],
                  offset: const Offset(0, 80),
                  //color: Colors.grey,
                  elevation: 2,
                  // on selected we show the dialog box
                  onSelected: (value) {
                    List<DeviceOrientation> orientations = [];
                    if (value == 1 || value == 3) {
                      orientations.addAll([
                        DeviceOrientation.landscapeLeft,
                        DeviceOrientation.landscapeRight
                      ]);
                    }
                    if (value == 2 || value == 3) {
                      orientations.addAll([
                        DeviceOrientation.portraitUp,
                        DeviceOrientation.portraitDown
                      ]);
                    }
                    SystemChrome.setPreferredOrientations(orientations);
                  },
                  child: items(
                      'Device Settings',
                      'Orientation: ${MediaQuery.of(context).orientation == Orientation.portrait ? "Portrait" : "Landscape"}',
                      'Dark Mode: OFF',
                      'assets/images/settings_2.png',
                      context: context),
                ),
                UiSpacer.vSpace(20),
                items('App Update', '', 'Version 1.03',
                    'assets/images/version.png',
                    context: context),
                UiSpacer.vSpace(20),
              ],
            ).p8().scrollVertical(),
          );
        },
      ),
    );
  }

  Widget items(
      String title, String description, String description2, String image,
      {required BuildContext context, VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: (MediaQuery.sizeOf(context).width - (Utils.navRailWidth * 1.5)),
        alignment: Alignment.center,
        margin: const EdgeInsets.symmetric(vertical: 3),
        padding: const EdgeInsets.fromLTRB(10, 2, 10, 2),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(19),
            border: Border.all(width: 2, color: AppColor.appMainColor)),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyle.comicNeue30BoldTextStyle(
                        color: AppColor.appMainColor),
                  ),
                  Text(
                    description,
                    style: AppTextStyle.comicNeue16BoldTextStyle(
                        color: AppColor.appMainColor),
                  ),
                  Text(
                    description2,
                    style: AppTextStyle.comicNeue16BoldTextStyle(
                        color: AppColor.appMainColor),
                  )
                ],
              ),
            ),
            Image.asset(
              image,
              width: 75,
              height: 75,
            )
          ],
        ),
      ),
    );
  }

  void openDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          insetPadding: EdgeInsets.zero,
          backgroundColor: Colors.transparent,
          content: Container(
            height: getLongestSide(100),
            width: SizeConfigs.isTablet
                ? SizeConfigs.shortestSide! - 80
                : SizeConfigs.shortestSide!,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                border: Border.all(width: 2, color: AppColor.appMainColor)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: MediaQuery.sizeOf(context).shortestSide / 4,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      border:
                          Border.all(width: 3, color: AppColor.appMainColor)),
                  height: getLongestSide(60),
                  child: Text('Privacy\npolicy',
                          style: AppTextStyle.comicNeue25BoldTextStyle(
                              color: AppColor.appMainColor))
                      .p4(),
                ).onInkTap(() => Navigator.pop(context)),
                Container(
                  width: MediaQuery.sizeOf(context).shortestSide / 4,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      border:
                          Border.all(width: 3, color: AppColor.appMainColor)),
                  height: getLongestSide(60),
                  child: Text('Terms \'n\nConditions',
                          style: AppTextStyle.comicNeue25BoldTextStyle(
                              color: AppColor.appMainColor))
                      .p4(),
                ).onInkTap(() => Navigator.pop(context)),
                Container(
                  width: MediaQuery.sizeOf(context).shortestSide / 4,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      border:
                          Border.all(width: 3, color: AppColor.appMainColor)),
                  height: getLongestSide(60),
                  child: Text('FAQ\'s',
                          style: AppTextStyle.comicNeue35BoldTextStyle(
                              color: AppColor.appMainColor))
                      .p4(),
                ).onInkTap(() => Navigator.pop(context)),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}
