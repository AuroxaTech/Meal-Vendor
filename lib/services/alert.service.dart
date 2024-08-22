import 'dart:async';
import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:vendor/services/app.service.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

class AlertService {
  //

  static Future<bool> showConfirm({
    String? title,
    required String text,
    String cancelBtnText = "Cancel",
    String confirmBtnText = "Ok",
    Function? onConfirm,
  }) async {
    //
    bool result = false;

    await CoolAlert.show(
        context: AppService().navigatorKey.currentContext!,
        type: CoolAlertType.confirm,
        title: title,
        text: text,
        cancelBtnText: cancelBtnText.tr(),
        confirmBtnText: confirmBtnText.tr(),
        onConfirmBtnTap: () {
          if (onConfirm == null) {
            result = true;
            if (null != AppService().navigatorKey.currentContext) {
              Navigator.pop(AppService().navigatorKey.currentContext!);
            }
          } else {
            onConfirm();
          }
        });

    //
    return result;
  }

  static Future<bool> success({
    String? title,
    required String text,
    String cancelBtnText = "Cancel",
    String confirmBtnText = "Ok",
  }) async {
    //
    bool result = false;

    await CoolAlert.show(
        context: AppService().navigatorKey.currentContext!,
        type: CoolAlertType.success,
        title: title,
        text: text,
        confirmBtnText: confirmBtnText.tr(),
        onConfirmBtnTap: () {
          result = true;
          if (null != AppService().navigatorKey.currentContext) {
            Navigator.pop(AppService().navigatorKey.currentContext!);
          }
        });

    //
    return result;
  }

  static Future<bool> error({
    String? title,
    required String text,
    String confirmBtnText = "Ok",
  }) async {
    //
    bool result = false;

    await CoolAlert.show(
        context: AppService().navigatorKey.currentContext!,
        type: CoolAlertType.error,
        title: title,
        text: text,
        confirmBtnText: confirmBtnText.tr(),
        onConfirmBtnTap: () {
          result = true;
          if (null != AppService().navigatorKey.currentContext) {
            Navigator.pop(AppService().navigatorKey.currentContext!);
          }
        });

    //
    return result;
  }

  static void showLoading() {
    CoolAlert.show(
      context: AppService().navigatorKey.currentContext!,
      type: CoolAlertType.loading,
      title: "".tr(),
      text: "Processing. Please wait...".tr(),
      barrierDismissible: false,
    );
  }

  static void stopLoading() {
    if (null != AppService().navigatorKey.currentContext) {
      Navigator.pop(AppService().navigatorKey.currentContext!);
    }
  }
}
