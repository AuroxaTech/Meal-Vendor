import 'dart:io';

import 'package:flutter/material.dart';
import 'package:vendor/utils/ui_spacer.dart';
import 'package:vendor/widgets/buttons/custom_button.dart';
import 'package:vendor/widgets/custom_image.view.dart';
import 'package:image_picker/image_picker.dart';
import 'package:velocity_x/velocity_x.dart';

class ImageSelectorView extends StatefulWidget {
  const ImageSelectorView({
    this.imageUrl = "",
    required this.onImageSelected,
    super.key,
  });

  final String imageUrl;
  final Function(File) onImageSelected;

  @override
  State<ImageSelectorView>  createState() => _ImageSelectorViewState();
}

class _ImageSelectorViewState extends State<ImageSelectorView> {
  //
  File? selectedFile;
  final picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return VStack(
      [
        //
        if (showImageUrl() && !showSelectedImage())
          CustomImage(
            imageUrl: widget.imageUrl,
          ).h20(context).wFull(context),

        //
        showSelectedImage()
            ? Image.file(
                selectedFile!,
                fit: BoxFit.cover,
              ).h20(context).wFull(context)
            : UiSpacer.emptySpace(),
        //
        Visibility(
          // visible: !showImageUrl() && !showSelectedImage(),
          visible: true,
          child: CustomButton(
            title: "Select a photo",
            onPressed: pickNewPhoto,
          ).centered(),
        ),
      ],
    )
        .wFull(context)
        .box
        .clip(Clip.antiAlias)
        .border(color: context.accentColor)
        .roundedSM
        .outerShadow
        .make()
        .onTap(pickNewPhoto);
  }

  bool showImageUrl() {
    return widget.imageUrl.isNotBlank;
  }

  bool showSelectedImage() {
    return selectedFile != null;
  }

  //
  pickNewPhoto() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      selectedFile = File(pickedFile.path);
      //
      widget.onImageSelected(selectedFile!);
    }
  }
}
