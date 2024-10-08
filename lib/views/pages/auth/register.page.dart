import 'package:flag/flag.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:vendor/constants/api.dart';
import 'package:vendor/constants/app_colors.dart';
import 'package:vendor/constants/app_page_settings.dart';
import 'package:vendor/models/address.dart';
import 'package:vendor/services/custom_form_builder_validator.service.dart';
import 'package:vendor/utils/ui_spacer.dart';
import 'package:vendor/utils/utils.dart';
import 'package:vendor/view_models/register.view_model.dart';
import 'package:vendor/widgets/base.page.dart';
import 'package:vendor/widgets/buttons/custom_button.dart';
import 'package:vendor/widgets/cards/document_selection.view.dart';
import 'package:vendor/widgets/states/custom_loading.state.dart';

import 'package:stacked/stacked.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  @override
  Widget build(BuildContext context) {
    //
    const inputDec = InputDecoration(
      border: OutlineInputBorder(),
    );

    //
    return ViewModelBuilder<RegisterViewModel>.reactive(
      viewModelBuilder: () => RegisterViewModel(context),
      onViewModelReady: (vm) => vm.initialise(),
      builder: (context, vm, child) {
        return BasePage(
          isLoading: vm.isBusy,
          body: FormBuilder(
            key: vm.formBuilderKey,
            child: VStack(
              [
                //appbar
                SafeArea(
                  child: HStack(
                    [
                      Icon(
                        FlutterIcons.close_ant,
                        size: 24,
                        color: Utils.textColorByTheme(),
                      ).p8().onInkTap(() {
                        Navigator.pop(context);
                      }).p12(),
                    ],
                  ),
                ).box.color(AppColor.primaryColor).make().wFull(context),

                //
                VStack(
                  [
                    //
                    VStack(
                      [
                        "Become a partner"
                            .tr()
                            .text
                            .xl3
                            .color(Utils.textColorByTheme())
                            .bold
                            .make(),
                        "Fill form below to continue"
                            .tr()
                            .text
                            .light
                            .color(Utils.textColorByTheme())
                            .make(),
                      ],
                    )
                        .p20()
                        .box
                        .color(AppColor.primaryColor)
                        .make()
                        .wFull(context),

                    //form
                    VStack(
                      [
                        //
                        "Business Information"
                            .tr()
                            .text
                            .underline
                            .xl
                            .semiBold
                            .make(),
                        UiSpacer.vSpace(30),
                        //
                        FormBuilderTextField(
                          name: "vendor_name",
                          validator: CustomFormBuilderValidator.required,
                          decoration: inputDec.copyWith(
                            labelText: "Name".tr(),
                          ),
                        ),

                        //
                        20.heightBox,
                        //address
                        // TypeAheadField<Address>(
                        //   hideOnLoading: false,
                        //   hideWithKeyboard: false,
                        //   controller: vm.addressTEC,
                        //   debounceDuration: const Duration(seconds: 1),
                        //   builder: (context, controller, focusNode) {
                        //     return TextField(
                        //       controller: controller,
                        //       // note how the controller is passed
                        //       focusNode: focusNode,
                        //       autofocus: false,
                        //       decoration: InputDecoration(
                        //         border: OutlineInputBorder(
                        //           borderSide: BorderSide(
                        //             color: AppColor.primaryColor,
                        //           ),
                        //         ),
                        //         hintText: "Address".tr(),
                        //         labelText: "Address".tr(),
                        //         focusedBorder: OutlineInputBorder(
                        //           borderSide: BorderSide(
                        //             color: AppColor.primaryColor,
                        //           ),
                        //         ),
                        //         enabledBorder: OutlineInputBorder(
                        //           borderSide: BorderSide(
                        //             color: AppColor.primaryColor,
                        //           ),
                        //         ),
                        //       ),
                        //     );
                        //   },
                        //   suggestionsCallback: vm.searchAddress,
                        //   itemBuilder: (context, Address? suggestion) {
                        //     if (suggestion == null) {
                        //       return const Divider();
                        //     }
                        //     //
                        //     return VStack(
                        //       [
                        //         (suggestion.addressLine ?? '')
                        //             .text
                        //             .semiBold
                        //             .lg
                        //             .make()
                        //             .px(12),
                        //         const Divider(),
                        //       ],
                        //     );
                        //   },
                        //   onSelected: vm.onAddressSelected,
                        // ),


                        Autocomplete<Address>(
                          optionsBuilder: (TextEditingValue textEditingValue) async {
                            if (textEditingValue.text.isEmpty || textEditingValue.text.length < 4) {
                              return const Iterable<Address>.empty();
                            }
                            // Fetch suggestions based on the input
                            return await vm.searchAddress(textEditingValue.text);
                          },
                          displayStringForOption: (Address option) => option.addressLine ?? '',
                          fieldViewBuilder: (BuildContext context,
                              TextEditingController textEditingController,
                              FocusNode focusNode,
                              VoidCallback onFieldSubmitted) {
                            vm.addressTEC = textEditingController;
                            return TextField(
                              controller: textEditingController,
                              focusNode: focusNode,
                              autofocus: false,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: AppColor.primaryColor,
                                  ),
                                ),
                                hintText: "Address".tr(),
                                labelText: "Address".tr(),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: AppColor.primaryColor,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: AppColor.primaryColor,
                                  ),
                                ),
                              ),
                            );
                          },
                          onSelected: (Address selection) {
                            vm.onAddressSelected(selection);
                          },
                          optionsViewBuilder: (BuildContext context,
                              AutocompleteOnSelected<Address> onSelected, Iterable<Address> options) {
                            return Align(
                              alignment: Alignment.topLeft,
                              child: Material(
                                child: Container(
                                  width: MediaQuery.of(context).size.width - 40,
                                  child: ListView.builder(
                                    padding: EdgeInsets.all(8.0),
                                    itemCount: options.length,
                                    itemBuilder: (BuildContext context, int index) {
                                      final Address option = options.elementAt(index);
                                      return GestureDetector(
                                        onTap: () => onSelected(option),
                                        child: VStack(
                                          [
                                            (option.addressLine ?? '')
                                                .text
                                                .semiBold
                                                .lg
                                                .make()
                                                .px(12),
                                            const Divider(),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                        //
                        CustomLoadingStateView(
                          loading: vm.busy(vm.vendorTypes),
                          child: FormBuilderDropdown(
                            name: 'vendor_type_id',
                            decoration: inputDec.copyWith(
                              labelText: "Vendor Type".tr(),
                              hintText: 'Select Vendor Type'.tr(),
                            ),
                            initialValue: vm.selectedVendorTypeId,
                            onChanged: vm.changeSelectedVendorType,
                            validator: CustomFormBuilderValidator.required,
                            items: vm.vendorTypes
                                .map(
                                  (vendorType) => DropdownMenuItem(
                                    value: vendorType.id,
                                    child: '${vendorType.name}'.text.make(),
                                  ),
                                )
                                .toList(),
                          ),
                        ).py20(),

                        FormBuilderTextField(
                          name: "vendor_email",
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) =>
                              CustomFormBuilderValidator.compose(
                            [
                              CustomFormBuilderValidator.required(value),
                              CustomFormBuilderValidator.email(value),
                            ],
                          ),
                          decoration: inputDec.copyWith(
                            labelText: "Email".tr(),
                          ),
                        ),

                        FormBuilderTextField(
                          name: "vendor_phone",
                          keyboardType: TextInputType.phone,
                          validator: CustomFormBuilderValidator.required,
                          decoration: inputDec.copyWith(
                            labelText: "Phone".tr(),
                            prefixIcon: HStack(
                              [
                                //icon/flag
                                Flag.fromString(
                                  vm.selectedVendorCountry?.countryCode ?? "us",
                                  width: 20,
                                  height: 20,
                                ),
                                UiSpacer.horizontalSpace(space: 5),
                                //text
                                ("+${vm.selectedVendorCountry?.phoneCode ?? "1"}")
                                    .text
                                    .make(),
                              ],
                            )
                                .px8()
                                .onInkTap(() => vm.showCountryDialPicker(true)),
                          ),
                        ).py20(),

                        //business documents
                        DocumentSelectionView(
                          title: "Documents".tr(),
                          instruction:
                              AppPageSettings.vendorDocumentInstructions,
                          max: AppPageSettings.maxVendorDocumentCount,
                          onSelected: vm.onDocumentsSelected,
                        ),

                        UiSpacer.divider().py12(),
                        "Personal Information"
                            .tr()
                            .text
                            .underline
                            .xl
                            .semiBold
                            .make(),
                        UiSpacer.vSpace(30),

                        FormBuilderTextField(
                          name: "name",
                          validator: CustomFormBuilderValidator.required,
                          decoration: inputDec.copyWith(
                            labelText: "Name".tr(),
                          ),
                        ),

                        FormBuilderTextField(
                          name: "email",
                          keyboardType: TextInputType.emailAddress,
                          validator: CustomFormBuilderValidator.email,
                          decoration: inputDec.copyWith(
                            labelText: "Email".tr(),
                          ),
                        ).py20(),

                        FormBuilderTextField(
                          name: "phone",
                          keyboardType: TextInputType.phone,
                          validator: CustomFormBuilderValidator.required,
                          decoration: inputDec.copyWith(
                            labelText: "Phone".tr(),
                            prefixIcon: HStack(
                              [
                                //icon/flag
                                Flag.fromString(
                                  vm.selectedCountry?.countryCode ?? "us",
                                  width: 20,
                                  height: 20,
                                ),
                                UiSpacer.horizontalSpace(space: 5),
                                //text
                                ("+${vm.selectedCountry?.phoneCode ?? "1"}")
                                    .text
                                    .make(),
                              ],
                            ).px8().onInkTap(vm.showCountryDialPicker),
                          ),
                        ),

                        FormBuilderTextField(
                          name: "password",
                          obscureText: vm.hidePassword,
                          validator: CustomFormBuilderValidator.required,
                          decoration: inputDec.copyWith(
                            labelText: "Password".tr(),
                            suffixIcon: Icon(
                              vm.hidePassword
                                  ? FlutterIcons.ios_eye_ion
                                  : FlutterIcons.ios_eye_off_ion,
                            ).onInkTap(() {
                              vm.hidePassword = !vm.hidePassword;
                              vm.notifyListeners();
                            }),
                          ),
                        ).py20(),

                        FormBuilderCheckbox(
                          name: "agreed",
                          title: "I agree with"
                              .tr()
                              .richText
                              .semiBold
                              .withTextSpanChildren(
                            [
                              " ".textSpan.make(),
                              "terms and conditions"
                                  .tr()
                                  .textSpan
                                  .underline
                                  .semiBold
                                  .tap(() {
                                    vm.openWebpageLink(Api.terms);
                                  })
                                  .color(AppColor.primaryColor)
                                  .make(),
                            ],
                          ).make(),
                          validator: (value) =>
                              CustomFormBuilderValidator.required(
                            value,
                            errorTitle:
                                "Please confirm you have accepted our terms and conditions"
                                    .tr(),
                          ),
                        ),
                        //
                        CustomButton(
                          title: "Sign Up".tr(),
                          loading: vm.isBusy,
                          onPressed: vm.processLogin,
                        ).centered().py20(),
                      ],
                    ).p20(),
                  ],
                )
                    .wFull(context)
                    .scrollVertical()
                    .box
                    .color(context.cardColor)
                    .make()
                    .pOnly(
                      bottom: context.mq.viewInsets.bottom,
                    )
                    .expand(),
              ],
            ),
          ),
        );
      },
    );
  }
}
