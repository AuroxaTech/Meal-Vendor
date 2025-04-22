import 'package:flutter/material.dart';
import 'package:vendor/constants/app_images.dart';
import 'package:vendor/utils/size_utils.dart';
import 'package:vendor/view_models/splash.vm.dart';
import 'package:vendor/widgets/base.page.dart';
import 'package:stacked/stacked.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    SizeConfigs().init(context);
    return BasePage(
      body: ViewModelBuilder<SplashViewModel>.reactive(
        viewModelBuilder: () => SplashViewModel(context),
        onViewModelReady: (vm) => vm.initialise(),
        builder: (context, model, child) {
          return VStack(
            [
              //
              Container(
                  alignment: Alignment.center,
                  child: Image.asset(
                    AppImages.appLogo,
                    width: getWidth(120),
                  ).py12()),
              "Loading Please wait...".tr().text.makeCentered(),
            ],
          ).centered();
        },
      ),
    );
  }
}
