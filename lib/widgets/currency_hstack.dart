import 'package:flutter/material.dart';
import 'package:vendor/utils/utils.dart';
import 'package:velocity_x/velocity_x.dart';

class CurrencyHStack extends StatelessWidget {
  const CurrencyHStack(
    this.children, {
    this.alignment,
    this.crossAlignment,
    this.axisSize,
    super.key,
  });

  final List<Widget> children;
  final MainAxisAlignment? alignment;
  final CrossAxisAlignment? crossAlignment;
  final MainAxisSize? axisSize;

  @override
  Widget build(BuildContext context) {
    return HStack(
      !Utils.currencyLeftSided ? children.reversed.toList() : children,
      alignment: alignment,
      crossAlignment: crossAlignment,
      axisSize: axisSize,
    );
  }
}
