import 'dart:io';

import 'package:cool_alert/cool_alert.dart';

//import 'package:custom_faqs/custom_faqs.dart';
import 'package:flutter/material.dart';
import 'package:vendor/views/pages/profile/account_delete.page.dart';
import 'package:vendor/views/pages/splash.page.dart';
import 'package:vendor/constants/api.dart';
import 'package:vendor/constants/app_routes.dart';
import 'package:vendor/constants/app_strings.dart';
import 'package:vendor/models/user.dart';
import 'package:vendor/requests/auth.request.dart';
import 'package:vendor/services/auth.service.dart';
import 'package:vendor/view_models/base.view_model.dart';
import 'package:vendor/widgets/cards/language_selector.view.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:velocity_x/velocity_x.dart';

class ProfileViewModel extends MyBaseViewModel {
  //
  String appVersionInfo = "";
  User? currentUser;

  //
  final AuthRequest _authRequest = AuthRequest();

  ProfileViewModel(BuildContext context) {
    viewContext = context;
  }

  void initialise() async {
    //
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String versionName = packageInfo.version;
    String versionCode = packageInfo.buildNumber;
    appVersionInfo = "$versionName($versionCode)";
    setBusy(true);
    currentUser = await AuthServices.getCurrentUser(force: true);
    setBusy(false);
  }

  /**
   * Edit Profile
   */

  openEditProfile() async {
    final result = await Navigator.of(viewContext).pushNamed(
      AppRoutes.editProfileRoute,
    );

    if (result != null && result is bool && result) {
      initialise();
    }
  }

  /**
   * Change Password
   */

  openChangePassword() async {
    Navigator.of(viewContext).pushNamed(
      AppRoutes.changePasswordRoute,
    );
  }

  /**
   * Logout
   */
  logoutPressed() async {
    CoolAlert.show(
      context: viewContext,
      type: CoolAlertType.confirm,
      title: "Logout".tr(),
      text: "Are you sure you want to logout?".tr(),
      onConfirmBtnTap: () {
        Navigator.pop(viewContext);
        processLogout();
      },
    );
  }

  void processLogout() async {
    //
    CoolAlert.show(
      context: viewContext,
      type: CoolAlertType.loading,
      title: "Logout".tr(),
      text: "Logging out Please wait...".tr(),
      barrierDismissible: false,
    );

    final apiResponse = await _authRequest.logoutRequest();

    Navigator.pop(viewContext);

    if (!apiResponse.allGood) {
      //
      CoolAlert.show(
        context: viewContext,
        type: CoolAlertType.error,
        title: "Logout",
        text: apiResponse.message,
      );
    } else {
      //
      await AuthServices.logout();
      Navigator.of(viewContext).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => SplashPage()),
        (route) => false,
      );
    }
  }

  openNotification() async {
    Navigator.of(viewContext).pushNamed(
      AppRoutes.notificationsRoute,
    );
  }

  /**
   * App Rating & Review
   */
  openReviewApp() async {
    final InAppReview inAppReview = InAppReview.instance;
    if (Platform.isAndroid) {
      inAppReview.openStoreListing(appStoreId: AppStrings.appStoreId);
    } else if (await inAppReview.isAvailable()) {
      inAppReview.requestReview();
    } else {
      inAppReview.openStoreListing(appStoreId: AppStrings.appStoreId);
    }
  }

  /* openFaqs() {
    viewContext.nextPage(
      CustomFaqPage(
        title: 'Faqs'.tr(),
        link: Api.baseUrl + Api.faqs,
      ),
    );
  }*/

  //
  openPrivacyPolicy() async {
    final url = Api.privacyPolicy;
    openWebpageLink(url);
  }

  openTerms() {
    final url = Api.terms;
    openWebpageLink(url);
  }

  //
  openContactUs() async {
    final url = Api.contactUs;
    openWebpageLink(url);
  }

  openLivesupport() async {
    final url = Api.inappSupport;
    openWebpageLink(url);
  }

  //
  changeLanguage() async {
    showModalBottomSheet(
      context: viewContext,
      isScrollControlled: true,
      builder: (context) {
        return const AppLanguageSelector();
      },
    );
  }

  deleteAccount() {
    viewContext.nextPage(const AccountDeletePage());
  }
}
