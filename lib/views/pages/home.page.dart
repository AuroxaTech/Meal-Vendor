import 'dart:io';
import 'package:double_back_to_close/double_back_to_close.dart';
import 'package:flutter/material.dart';
import 'package:vendor/constants/app_images.dart';
import 'package:vendor/constants/app_upgrade_settings.dart';
import 'package:vendor/utils/utils.dart';
import 'package:vendor/views/pages/order_future/ordersFuture.page.dart';
import 'package:vendor/views/pages/profile/profile.page.dart';
import 'package:vendor/view_models/home.vm.dart';
import 'package:vendor/views/pages/support/support.page.dart';
import 'package:vendor/views/pages/vendor/vendor_details.page.dart';
import 'package:vendor/views/pages/vendor_chat_support/messages_page.dart';
import 'package:vendor/widgets/base.page.dart';
import 'package:stacked/stacked.dart';
import 'package:upgrader/upgrader.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:velocity_x/velocity_x.dart';
import 'Notifications/notifications.page.dart';
import 'order/orders.page.dart';
import 'order_history/ordersHistory.page.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    super.key,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  NavigationRailLabelType labelType = NavigationRailLabelType.none;
  final GlobalKey _navigationRailKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: DoubleBack(
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
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SingleChildScrollView(
                      child: Container(
                        height: 7 * 68,
                        padding: const EdgeInsets.symmetric(horizontal: 2),
                        child: NavigationRail(
                          key: _navigationRailKey,
                          selectedIndex: _selectedIndex,
                          groupAlignment: 0,
                          useIndicator: false,
                          onDestinationSelected: (int index) {
                            setState(() {
                              _selectedIndex = index;
                            });
                            Utils.navRailWidth = _getNavigationRailWidth();
                          },
                          minWidth: 52.0,
                          labelType: labelType,
                          destinations: <NavigationRailDestination>[
                            NavigationRailDestination(
                              indicatorColor: Colors.transparent,
                              /*padding: EdgeInsets.only(
                                  bottom: (MediaQuery.sizeOf(context).height /
                                          100) *
                                      2,
                                  top: (MediaQuery.sizeOf(context).height /
                                          100) *
                                      2),*/
                              icon: Image.asset(AppImages.orderActive),
                              // selectedIcon: Image.asset(AppImages.orderActive ,height: 80, width: 80,),
                              label: const Text('1'),
                            ),
                            NavigationRailDestination(
                              indicatorColor: Colors.transparent,
                              icon: Image.asset(AppImages.clockActive),
                              label: const Text('2'),
                            ),
                            NavigationRailDestination(
                              indicatorColor: Colors.transparent,
                              icon: Image.asset(AppImages.calenderActive),
                              label: const Text('3'),
                            ),
                            NavigationRailDestination(
                              indicatorColor: Colors.transparent,
                              icon: Image.asset(AppImages.settingActive),
                              label: const Text('4'),
                            ),
                            NavigationRailDestination(
                              indicatorColor: Colors.transparent,
                              icon: Image.asset(AppImages.menuActive),
                              label: const Text('5'),
                            ),
                            NavigationRailDestination(
                              indicatorColor: Colors.transparent,
                              icon: Image.asset(AppImages.supportActive),
                              label: const Text('6'),
                            ),
                            NavigationRailDestination(
                              indicatorColor: Colors.transparent,
                              icon: Image.asset(AppImages.notificationActive),
                              label: const Text('7'),
                            ),
                          ],
                        ),
                      ).w(80),
                    ),
                    const VerticalDivider(
                      thickness: 3,
                      width: 2,
                      color: Color(0xFF29798F),
                    ),
                    Expanded(
                        child: _selectedIndex == 0
                            ? const OrdersPage()
                            : _selectedIndex == 1
                                ? const OrdersHistoryPage()
                                : _selectedIndex == 2
                                    ? const OrdersFuturePage()
                                    : _selectedIndex == 3
                                        ? const ProfilePage()
                                        : _selectedIndex == 4
                                            ? Utils.vendorSectionPage(
                                                model.currentVendor)
                                            : _selectedIndex == 5
                                                ? const SupportPage()
                                                : _selectedIndex == 6
                                                    ? const MessagesPage()
                                                    : const VendorDetailsPage()),
                    // PageView(
                    //   controller: model.pageViewController,
                    //   onPageChanged: model.onPageChanged,
                    //   children: [
                    //     OrdersPage(),
                    //     //
                    //     Utils.vendorSectionPage(model.currentVendor),
                    //
                    //     VendorDetailsPage(),
                    //     ProfilePage(),
                    //   ],
                    // ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  double _getNavigationRailWidth() {
    final RenderBox renderBox =
        _navigationRailKey.currentContext!.findRenderObject() as RenderBox;
    return renderBox.size.width;
  }
}
