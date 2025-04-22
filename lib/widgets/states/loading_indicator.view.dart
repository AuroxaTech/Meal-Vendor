import 'package:flutter/material.dart';
import 'package:vendor/utils/ui_spacer.dart';
import 'package:vendor/widgets/busy_indicator.dart';
import 'package:velocity_x/velocity_x.dart';

class LoadingIndicator extends StatelessWidget {
  const LoadingIndicator({
    required this.child,
    this.loadingWidget,
    this.loading = false,
    super.key,
  });

  final bool loading;
  final Widget child;
  final Widget? loadingWidget;

  @override
  Widget build(BuildContext context) {
    return HStack(
      [
        child.expand(),
        loading
            ? (loadingWidget ?? const BusyIndicator().p12())
            : UiSpacer.emptySpace(),
      ],
    );
  }
}
