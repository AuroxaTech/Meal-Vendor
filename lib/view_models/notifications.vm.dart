import 'package:flutter/material.dart';
import 'package:vendor/constants/app_routes.dart';
import 'package:vendor/models/notification.dart';
import 'package:vendor/services/notification.service.dart';
import 'package:vendor/view_models/base.view_model.dart';

class NotificationsViewModel extends MyBaseViewModel {
  List<NotificationModel> notifications = [];

  NotificationsViewModel(BuildContext context) {
    viewContext = context;
  }

  @override
  void initialise() async {
    super.initialise();
    //getting notifications
    getNotifications();
  }

  void getNotifications() async {
    notifications = await NotificationService.getNotifications();
    notifyListeners();
  }

  void showNotificationDetails(NotificationModel notificationModel) async {
    notificationModel.read = true;
    NotificationService.updateNotification(notificationModel);

    await Navigator.pushNamed(
      viewContext,
      AppRoutes.notificationDetailsRoute,
      arguments: notificationModel,
    );

    getNotifications();
  }
}
