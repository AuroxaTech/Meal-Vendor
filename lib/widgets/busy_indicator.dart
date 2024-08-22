import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

class BusyIndicator extends StatelessWidget {
  const BusyIndicator({
    this.color,
    super.key,
  });

  final Color? color;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 20,
      width: 20,
      child: CircularProgressIndicator(
        strokeWidth: 2,
        valueColor: AlwaysStoppedAnimation<Color>(
          color ?? context.theme.textTheme.bodyLarge!.color!,
        ),
      ),
    );
  }
}
