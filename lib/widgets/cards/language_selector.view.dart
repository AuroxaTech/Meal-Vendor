import 'package:flutter/material.dart';
import 'package:flag/flag.dart';
import 'package:vendor/constants/app_languages.dart';
import 'package:vendor/services/auth.service.dart';
import 'package:vendor/utils/ui_spacer.dart';
import 'package:vendor/utils/utils.dart';
import 'package:vendor/widgets/custom_grid_view.dart';

import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:velocity_x/velocity_x.dart';

class AppLanguageSelector extends StatelessWidget {
  const AppLanguageSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: VStack(
        [
          "Select your preferred language"
              .tr()
              .text
              .xl
              .semiBold
              .make()
              .py20()
              .px12(),
          UiSpacer.divider(),

          //
          CustomGridView(
            crossAxisCount: 3,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            padding: const EdgeInsets.all(12),
            dataSet: AppLanguages.codes,
            itemBuilder: (ctx, index) {
              return VStack(
                [
                  Flag.fromString(
                    AppLanguages.flags[index],
                    height: 40,
                    width: 40,
                  ),
                  UiSpacer.verticalSpace(space: 5),
                  //
                  AppLanguages.names[index].text.lg.make(),
                ],
                crossAlignment: CrossAxisAlignment.center,
                alignment: MainAxisAlignment.center,
              ).box.roundedSM.color(context.canvasColor).make().onTap(() {
                _onSelected(context, AppLanguages.codes[index]);
              });
            },
          ).expand(),
        ],
      ),
    ).hThreeForth(context);
  }

  void _onSelected(BuildContext context, String code) async {
    await AuthServices.setLocale(code);
    await Utils.setJiffyLocale();
    await LocalizeAndTranslate.setLanguageCode(code);
    if(context.mounted) {
      Navigator.pop(context);
    }
  }
}
