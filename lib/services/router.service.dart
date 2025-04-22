import 'package:firestore_chat/firestore_chat.dart';
import 'package:flutter/material.dart';
import 'package:vendor/constants/app_routes.dart';
import 'package:vendor/models/order.dart';
import 'package:vendor/models/notification.dart';
import 'package:vendor/models/product.dart';
import 'package:vendor/views/pages/auth/forgot_password.page.dart';
import 'package:vendor/views/pages/auth/login.page.dart';
import 'package:vendor/views/pages/home.page.dart';
import 'package:vendor/views/pages/notification/notification_details.page.dart';
import 'package:vendor/views/pages/onboarding.page.dart';
import 'package:vendor/views/pages/order/orders_details.page.dart';
import 'package:vendor/views/pages/product/product_details.page.dart';
import 'package:vendor/views/pages/profile/change_password.page.dart';
import 'package:vendor/views/pages/profile/edit_profile.page.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case AppRoutes.welcomeRoute:
      return MaterialPageRoute(builder: (context) => OnboardingPage());

    case AppRoutes.loginRoute:
      return MaterialPageRoute(builder: (context) => LoginPage());

    case AppRoutes.forgotPasswordRoute:
      return MaterialPageRoute(builder: (context) => ForgotPasswordPage());

    case AppRoutes.homeRoute:
      return MaterialPageRoute(
        settings: const RouteSettings(name: AppRoutes.homeRoute, arguments: {}),
        builder: (context) => HomePage(),
      );

    //order details page
    case AppRoutes.orderDetailsRoute:
      return MaterialPageRoute(
        settings: const RouteSettings(name: AppRoutes.orderDetailsRoute),
        builder: (context) => OrderDetailsPage(
          order: settings.arguments as Order,
        ),
      );
    case AppRoutes.productDetailsRoute:
      return MaterialPageRoute(
        settings: const RouteSettings(name: AppRoutes.productDetailsRoute),
        builder: (context) => ProductDetailsPage(
          product: settings.arguments as Product,
        ),
      );
    //chat page
    case AppRoutes.chatRoute:
      return FirestoreChat().chatPageWidget(
        settings.arguments as ChatEntity,
      );

    //
    case AppRoutes.editProfileRoute:
      return MaterialPageRoute(
        settings: const RouteSettings(name: AppRoutes.editProfileRoute),
        builder: (context) => const EditProfilePage(),
      );

    //change password
    case AppRoutes.changePasswordRoute:
      return MaterialPageRoute(
        settings: const RouteSettings(name: AppRoutes.changePasswordRoute),
        builder: (context) => const ChangePasswordPage(),
      );

    //profile settings/actions
    // case AppRoutes.notificationsRoute:
    //   return MaterialPageRoute(
    //     settings:
    //         RouteSettings(name: AppRoutes.notificationsRoute, arguments: Map()),
    //     builder: (context) => NotificationsPageOld(),
    //   );

    //
       case AppRoutes.notificationDetailsRoute:
      return MaterialPageRoute(
        settings: const RouteSettings(
            name: AppRoutes.notificationDetailsRoute, arguments: {}),
        builder: (context) => NotificationDetailsPage(
          notification: settings.arguments as NotificationModel,
        ),
      );

    default:
      return MaterialPageRoute(builder: (context) => OnboardingPage());
  }
}
