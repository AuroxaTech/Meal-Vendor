import 'dart:io';
import 'package:double_back_to_close/double_back_to_close.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:vendor/constants/app_upgrade_settings.dart';
import 'package:vendor/utils/utils.dart';
import 'package:vendor/views/pages/profile/profile.page.dart';
import 'package:vendor/view_models/home.vm.dart';
import 'package:vendor/views/pages/vendor/vendor_details.page.dart';
import 'package:vendor/widgets/base.page.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:stacked/stacked.dart';
import 'package:upgrader/upgrader.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import 'order/orders.page.dart';

class HomePage1 extends StatefulWidget {
  const HomePage1({
    super.key,
  });

  @override
  State<HomePage1> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage1> {
  @override
  Widget build(BuildContext context) {
    return DoubleBack(
      message: "Press back again to close".tr(),
      child: ViewModelBuilder<HomeViewModel>.reactive(
        viewModelBuilder: () => HomeViewModel(context),
        onViewModelReady: (model) => model.initialise(),
        builder: (context, model, child) {
          return BasePage(
            body: UpgradeAlert(
              showIgnore: !AppUpgradeSettings.forceUpgrade(),
              shouldPopScope: () => !AppUpgradeSettings.forceUpgrade(),
              dialogStyle: Platform.isIOS
                  ? UpgradeDialogStyle.cupertino
                  : UpgradeDialogStyle.material,
              child: PageView(
                controller: model.pageViewController,
                onPageChanged: model.onPageChanged,
                children: [
                  const OrdersPage(),
                  //
                  Utils.vendorSectionPage(model.currentVendor),

                  const VendorDetailsPage(),
                  const ProfilePage(),
                ],
              ),
            ),
            bottomNavigationBar: VxBox(
              child: SafeArea(
                child: GNav(
                  gap: 8,
                  activeColor: Theme.of(context).primaryColor,
                  color: Theme.of(context).textTheme.bodyLarge!.color,
                  iconSize: 24,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  duration: const Duration(seconds: 2),
                  curve: Curves.bounceInOut,
                  tabBackgroundColor: Colors.transparent,
                  style: GnavStyle.oldSchool,
                  textSize: 14,
                  tabBorderRadius: 0,
                  tabs: [
                    GButton(
                      icon: FlutterIcons.inbox_ant,
                      text: 'Orders'.tr(),
                    ),
                    GButton(
                      icon: Utils.vendorIconIndicator(model.currentVendor),
                      text: Utils.vendorTypeIndicator(model.currentVendor).tr(),
                    ),
                    GButton(
                      icon: FlutterIcons.briefcase_fea,
                      text: 'Vendor'.tr(),
                    ),
                    GButton(
                      icon: FlutterIcons.menu_fea,
                      text: 'More'.tr(),
                    ),
                  ],
                  selectedIndex: model.currentIndex,
                  onTabChange: model.onTabChange,
                ),
              ),
            )
                .p16
                .shadow
                .color(Theme.of(context).bottomSheetTheme.backgroundColor!)
                .make(),
          );
        },
      ),
    );
  }
}
