import 'dart:async';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:vendor/constants/app_languages.dart';
import 'package:vendor/my_app.dart';
import 'package:vendor/services/local_storage.service.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'firebase_options.dart';
import 'services/firebase.service.dart';
import 'services/general_app.service.dart';
import 'services/notification.service.dart';

//ssll handshake error
class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

void main() async {
  await runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();
      //setting up firebase notifications
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );

      await LocalizeAndTranslate.init(
        assetLoader: const AssetLoaderRootBundleJson('assets/lang/'),
        supportedLanguageCodes: AppLanguages.codes,
        defaultType: LocalizationDefaultType.asDefined,
      );

      //
      await LocalStorageService.getPrefs();
      //await NotificationService.clearIrrelevantNotificationChannels();
      await NotificationService.initializeAwesomeNotification();
      await NotificationService.listenToActions();
      await FirebaseService().setUpFirebaseMessaging();
      FirebaseMessaging.onBackgroundMessage(
          GeneralAppService.onBackgroundMessageHandler);

      //prevent ssl error
      HttpOverrides.global = MyHttpOverrides();
      FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
      // Run app!
      runApp(
        const LocalizedApp(
          child: MyApp(),
        ),
      );
    },
    (error, stackTrace) {
      FirebaseCrashlytics.instance.recordError(error, stackTrace);
    },
  );
}
