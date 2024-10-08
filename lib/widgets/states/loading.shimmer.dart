import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

class LoadingShimmer extends StatelessWidget {
  const LoadingShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return VxBox(
      child: "".text.make(),
    )
        .height(context.percentHeight * 10)
        .width(context.percentWidth * 100)
        .roundedFull
        .clip(Clip.antiAlias)
        .make()
        .backgroundColor(
          Colors.grey[900],
        )
        .shimmer(
          primaryColor: context.theme.colorScheme.background,
          secondaryColor: context.theme.highlightColor,
        );
  }
}
