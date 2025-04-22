import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:vendor/utils/ui_spacer.dart';
import 'package:vendor/widgets/buttons/custom_button.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:velocity_x/velocity_x.dart';

class CustomTextEditorPage extends StatefulWidget {
  const CustomTextEditorPage({
    required this.title,
    this.content,
    super.key,
  });

  final String? content;
  final String title;

  @override
  State<CustomTextEditorPage> createState() => _CustomTextEditorPageState();
}

class _CustomTextEditorPageState extends State<CustomTextEditorPage> {
  QuillController quillEditorController = QuillController.basic();

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        automaticallyImplyLeading: true,
      ),
      body: VStack(
        [
          QuillToolbar.simple(
            configurations: QuillSimpleToolbarConfigurations(
                controller: quillEditorController,
                sharedConfigurations: const QuillSharedConfigurations(
                  locale: Locale('en'),
                ),
                color: Colors.cyan.shade50,
                customButtons: [
                  QuillToolbarCustomButtonOptions(
                    icon: const Icon(Icons.favorite),
                    onPressed: () {},
                  ),
                  QuillToolbarCustomButtonOptions(
                    icon: const Icon(Icons.add_circle),
                    onPressed: () {},
                  ),
                ]),
          ),

          Flexible(
            fit: FlexFit.tight,
            child: QuillEditor.basic(
              configurations: QuillEditorConfigurations(
                controller: quillEditorController,
                sharedConfigurations: const QuillSharedConfigurations(
                  locale: Locale('en'),
                ),
              ),
            ),
          ),
          UiSpacer.vSpace(),
          //done button
          CustomButton(
            title: "Done".tr(),
            onPressed: () async {
              FocusScope.of(context).unfocus();
              FocusScope.of(context).requestFocus(FocusNode());

              String htmlContent = quillEditorController.document.toPlainText();
              Navigator.pop(context, htmlContent);
            },
          ).wFull(context).safeArea(top: false),
        ],
      ).p20(),
    );
  }
}
