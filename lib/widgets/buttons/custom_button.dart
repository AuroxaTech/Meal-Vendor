import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:vendor/constants/app_colors.dart';
import 'package:vendor/constants/app_text_styles.dart';
import 'package:vendor/utils/ui_spacer.dart';
import 'package:vendor/widgets/busy_indicator.dart';
import 'package:velocity_x/velocity_x.dart';

class CustomButton extends StatelessWidget {
  final String? title;
  final IconData? icon;
  final double? iconSize;
  final Widget? child;
  final TextStyle? titleStyle;
  final Function? onPressed;
  final OutlinedBorder? shape;
  final bool isFixedHeight;
  final double? height;
  final bool loading;
  final double shapeRadius;
  final Color? color;
  final Color? iconColor;
  final double? elevation;
  final bool? isSelected;
  final String? count;

  const CustomButton({
    this.title,
    this.icon,
    this.iconSize,
    this.iconColor,
    this.child,
    this.onPressed,
    this.shape,
    this.isFixedHeight = false,
    this.height,
    this.loading = false,
    this.shapeRadius = Vx.dp4,
    this.color,
    this.isSelected,
    this.titleStyle,
    this.elevation,
    this.count,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ButtonTheme(
      padding: EdgeInsets.zero,
      splashColor: Colors.white,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          elevation: elevation,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          backgroundColor: Colors.white,
          disabledBackgroundColor: loading ? Colors.white : null,
          shape: shape ??
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(shapeRadius),
              ),
        ),
        onPressed: (loading || onPressed == null)
            ? null
            : () {
                FocusScope.of(context).requestFocus(FocusNode());
                onPressed!();
              },
        child: loading
            ? const BusyIndicator(color: Colors.white)
            : Container(
                color: Colors.white,
                padding: EdgeInsets.zero,
                child: child ??
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        icon != null
                            ? Icon(icon,
                                    color: iconColor ?? Colors.white,
                                    size: iconSize ?? 20,
                                    textDirection:
                                        LocalizeAndTranslate.getLocale()
                                                    .languageCode ==
                                                "ar"
                                            ? TextDirection.rtl
                                            : TextDirection.ltr)
                                .pOnly(
                                right: LocalizeAndTranslate.getLocale()
                                            .languageCode ==
                                        "ar"
                                    ? Vx.dp0
                                    : Vx.dp5,
                                left: LocalizeAndTranslate.getLocale()
                                            .languageCode !=
                                        "ar"
                                    ? Vx.dp0
                                    : Vx.dp5,
                              )
                            : UiSpacer.emptySpace(),
                        title != null
                            ? Text(
                                count != null && count!.isNotEmpty
                                    ? "$title ($count)"
                                    : "$title",
                                textAlign: TextAlign.center,
                                style: titleStyle ??
                                    AppTextStyle.comicNeue25BoldTextStyle(
                                        color: AppColor.appMainColor),
                              ).centered()
                            : UiSpacer.emptySpace(),
                      ],
                    ),
              ),
      ),
    );
  }
}

class CustomOrderButton extends StatelessWidget {
  final String? title;
  final Widget? child;
  final TextStyle? titleStyle;
  final Function? onPressed;
  final OutlinedBorder? shape;
  final double? height;
  final bool loading;
  final double shapeRadius;
  final Color? color;
  final double? elevation;
  final bool? isSelected;
  final String? count;

  const CustomOrderButton({
    this.title,
    this.child,
    this.onPressed,
    this.shape,
    this.height,
    this.loading = false,
    this.shapeRadius = Vx.dp4,
    this.color,
    this.isSelected,
    this.titleStyle,
    this.elevation,
    this.count,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ButtonTheme(
      padding: EdgeInsets.zero,
      splashColor: Colors.white,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          elevation: elevation,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          backgroundColor: Colors.white,
          disabledBackgroundColor: loading ? Colors.white : null,
          shape: shape ??
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(shapeRadius),
              ),
        ),
        onPressed: (loading || onPressed == null)
            ? null
            : () {
                FocusScope.of(context).requestFocus(FocusNode());
                onPressed!();
              },
        child: loading
            ? const BusyIndicator(color: Colors.white)
            : Container(
                color: Colors.white,
                padding: EdgeInsets.zero,
                child: Text(
                  count != null && count!.isNotEmpty
                      ? "$title ($count)"
                      : "$title",
                  textAlign: TextAlign.center,
                  style: titleStyle ??
                      AppTextStyle.comicNeue25BoldTextStyle(
                          color: AppColor.appMainColor),
                ).centered()),
      ),
    );
  }
}
