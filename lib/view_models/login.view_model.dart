import 'package:cool_alert/cool_alert.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:vendor/constants/app_routes.dart';
import 'package:vendor/models/api_response.dart';
import 'package:vendor/requests/auth.request.dart';
import 'package:vendor/services/auth.service.dart';
import 'package:vendor/traits/qrcode_scanner.trait.dart';
import 'package:vendor/views/pages/auth/register.page.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'base.view_model.dart';
import 'package:velocity_x/velocity_x.dart';

class LoginViewModel extends MyBaseViewModel with QrcodeScannerTrait {
  TextEditingController emailTEC = TextEditingController();
  TextEditingController passwordTEC = TextEditingController();

  //
  final AuthRequest _authRequest = AuthRequest();

  LoginViewModel(BuildContext context) {
    viewContext = context;
  }
//mailto:manager1@demo.com
// password
  void initialise() {
    emailTEC.text = kReleaseMode ? "" : "manager@demo.com";
    passwordTEC.text = kReleaseMode ? "" : "password";
  }

  void processLogin() async {
    // Validate returns true if the form is valid, otherwise false.
    if (formKey.currentState!.validate()) {
      setBusy(true);
      final apiResponse = await _authRequest.loginRequest(
        email: emailTEC.text,
        password: passwordTEC.text,
      );
      await handleDeviceLogin(apiResponse);

      setBusy(false);
    }
  }

  //QRCode login
  void initateQrcodeLogin() async {
    //
    final loginCode = await openScanner(viewContext);
    if (loginCode == null) {
      toastError("Operation failed/cancelled".tr());
    } else {
      setBusy(true);

      try {
        final apiResponse = await _authRequest.qrLoginRequest(
          code: loginCode,
        );
        //
        handleDeviceLogin(apiResponse);
      } catch (error) {
        print("QR Code login error ==> $error");
      }

      setBusy(false);
    }
  }

  ///
  ///
  ///
  handleDeviceLogin(ApiResponse apiResponse) async {
    try {
      if (apiResponse.hasError()) {
        //there was an error
        CoolAlert.show(
          context: viewContext,
          type: CoolAlertType.error,
          title: "Login Failed".tr(),
          text: apiResponse.message,
        );
      } else {
        //everything works well
        //firebase auth
       // final fbToken = apiResponse.body["fb_token"];
       // await FirebaseAuth.instance.signInWithCustomToken(fbToken);
        await AuthServices.saveUser(apiResponse.body["user"]);
        await AuthServices.saveVendor(apiResponse.body["vendor"]);
        await AuthServices.setAuthBearerToken(apiResponse.body["token"]);
        await AuthServices.isAuthenticated();
        print('AppRoutes.homeRoute ========================== 1');
        Navigator.of(viewContext).pushNamedAndRemoveUntil(
          AppRoutes.homeRoute,
          (route) => false,
        );
      }
    } on FirebaseAuthException catch (error) {
      CoolAlert.show(
        context: viewContext,
        type: CoolAlertType.error,
        title: "Login Failed".tr(),
        text: "${error.message}",
      );
    } catch (error) {
      CoolAlert.show(
        context: viewContext,
        type: CoolAlertType.error,
        title: "Login Failed".tr(),
        text: "$error",
      );
    }
  }

  void openForgotPassword() {
    Navigator.of(viewContext).pushNamed(
      AppRoutes.forgotPasswordRoute,
    );
  }

  void openRegistrationlink() async {
    viewContext.nextPage(RegisterPage());
    /*
    final url = Api.register;
    openExternalWebpageLink(url);
    */
  }
}