import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:vendor/constants/app_images.dart';
import 'package:vendor/services/validator.service.dart';
import 'package:vendor/view_models/edit_profile.vm.dart';
import 'package:vendor/widgets/base.page.dart';
import 'package:vendor/widgets/busy_indicator.dart';
import 'package:vendor/widgets/buttons/custom_button.dart';
import 'package:vendor/widgets/custom_text_form_field.dart';
import 'package:stacked/stacked.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

class EditProfilePage extends StatelessWidget {
  const EditProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<EditProfileViewModel>.reactive(
      viewModelBuilder: () => EditProfileViewModel(context),
      onViewModelReady: (model) => model.initialise(),
      builder: (context, model, child) {
        return BasePage(
          showLeadingAction: true,
          showAppBar: true,
          title: "Edit Profile".tr(),
          body: SafeArea(
              top: true,
              bottom: false,
              child:
                  //
                  VStack(
                [
                  //
                  Stack(
                    children: [
                      //
                      model.currentUser == null
                          ? const BusyIndicator()
                          : model.newPhoto == null
                              ? CachedNetworkImage(
                                  imageUrl: model.currentUser?.photo ?? "",
                                  progressIndicatorBuilder:
                                      (context, url, progress) {
                                    return const BusyIndicator();
                                  },
                                  errorWidget: (context, imageUrl, progress) {
                                    return Image.asset(
                                      AppImages.user,
                                    );
                                  },
                                  fit: BoxFit.cover,
                                )
                                  .wh(
                                    Vx.dp64 * 1.3,
                                    Vx.dp64 * 1.3,
                                  )
                                  .box
                                  .rounded
                                  .clip(Clip.antiAlias)
                                  .make()
                              : Image.file(
                                  model.newPhoto!,
                                  fit: BoxFit.cover,
                                )
                                  .wh(
                                    Vx.dp64 * 1.3,
                                    Vx.dp64 * 1.3,
                                  )
                                  .box
                                  .rounded
                                  .clip(Clip.antiAlias)
                                  .make(),

                      //
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: const Icon(
                          FlutterIcons.camera_ant,
                          size: 16,
                        )
                            .p8()
                            .box
                            .color(context.theme.colorScheme.background)
                            .roundedFull
                            .shadow
                            .make()
                            .onInkTap(model.changePhoto),
                      ),
                    ],
                  ).box.makeCentered(),

                  //form
                  Form(
                    key: model.formKey,
                    child: VStack(
                      [
                        //
                        CustomTextFormField(
                          labelText: "Name".tr(),
                          textEditingController: model.nameTEC,
                          validator: FormValidator.validateName,
                        ).py12(),
                        //
                        CustomTextFormField(
                          labelText: "Email",
                          keyboardType: TextInputType.emailAddress,
                          textEditingController: model.emailTEC,
                          validator: FormValidator.validateEmail,
                        ).py12(),
                        //
                        CustomTextFormField(
                          labelText: "Phone",
                          keyboardType: TextInputType.phone,
                          textEditingController: model.phoneTEC,
                          validator: FormValidator.validatePhone,
                        ).py12(),

                        //
                        CustomButton(
                          title: "Update Profile".tr(),
                          loading: model.isBusy,
                          onPressed: model.processUpdate,
                        ).centered().py12(),
                      ],
                    ),
                  ).py20(),
                ],
              ).p20().scrollVertical()),
        );
      },
    );
  }
}
