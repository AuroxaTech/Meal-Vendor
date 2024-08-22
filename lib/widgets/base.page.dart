import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import 'package:velocity_x/velocity_x.dart';

import '../utils/ui_spacer.dart';

class BasePage extends StatefulWidget {
  final bool showAppBar;
  final bool showLeadingAction;
  final IconData? leadingIconData;
  final Widget? leading;
  final bool showCart;
  final bool extendBodyBehindAppBar;
  final Function? onBackPressed;
  final String title;
  final Widget body;
  final Widget? bottomSheet;
  final Widget? bottomNavigationBar;
  final Widget? fab;
  final bool isLoading;
  final List<Widget>? actions;

  final Color? appBarItemColor;
  final Color? backgroundColor;
  final double? elevation;

  const BasePage({
    this.showAppBar = false,
    this.showLeadingAction = false,
    this.leadingIconData,
    this.leading,
    this.extendBodyBehindAppBar = false,
    this.showCart = false,
    this.onBackPressed,
    this.title = "",
    required this.body,
    this.bottomSheet,
    this.bottomNavigationBar,
    this.fab,
    this.isLoading = false,
    this.actions,
    this.elevation,
    this.appBarItemColor,
    this.backgroundColor,
    super.key,
  });

  @override
  State<BasePage> createState() => _BasePageState();
}

class _BasePageState extends State<BasePage> {
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: LocalizeAndTranslate.getLocale().languageCode == "ar"
          ? TextDirection.rtl
          : TextDirection.ltr,
      child: Scaffold(
        extendBodyBehindAppBar: widget.extendBodyBehindAppBar,
        resizeToAvoidBottomInset: false,
        backgroundColor:
            widget.backgroundColor ?? Theme.of(context).colorScheme.background,
        appBar: widget.showAppBar
            ? AppBar(
                automaticallyImplyLeading: widget.showLeadingAction,
                elevation: widget.elevation,
                leading: widget.showLeadingAction
                    ? widget.leading ??
                        IconButton(
                          icon: Icon(
                            widget.leadingIconData ??
                                FlutterIcons.arrow_left_fea,
                          ),
                          onPressed: widget.onBackPressed != null
                              ? () => widget.onBackPressed!()
                              : () => Navigator.pop(context),
                        )
                    : null,
                title: Text(
                  widget.title,
                ),
                actions: widget.actions ?? [],
              )
            : null,
        body: VStack(
          [
            //
            widget.isLoading
                ? const LinearProgressIndicator()
                : UiSpacer.emptySpace(),

            //
            widget.body.expand(),
          ],
        ),
        bottomSheet: widget.bottomSheet,
        bottomNavigationBar: widget.bottomNavigationBar,
        floatingActionButton: widget.fab,
        // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      ),
    );
  }
}
