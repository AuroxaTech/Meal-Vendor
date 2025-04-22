import 'package:flutter/material.dart';
import 'package:vendor/utils/ui_spacer.dart';
import 'package:vendor/widgets/states/empty.state.dart';
import 'package:vendor/widgets/states/loading.shimmer.dart';
import 'package:velocity_x/velocity_x.dart';

class CustomGridView extends StatelessWidget {
  final Widget? title;
  final Widget? loadingWidget;
  final Widget? errorWidget;
  final Widget? emptyWidget;
  final List<dynamic> dataSet;
  final bool isLoading;
  final bool hasError;
  final bool justList;
  final bool reversed;
  final bool noScrollPhysics;
  final Axis scrollDirection;
  final EdgeInsets? padding;
  final Widget Function(BuildContext, int) itemBuilder;
  final Widget Function(BuildContext, int)? separatorBuilder;
  final int crossAxisCount;
  final double childAspectRatio;
  final double crossAxisSpacing;
  final double mainAxisSpacing;
  final Future<void> Function()? onRefresh;
  final Function? onLoading;

  const CustomGridView({
    required this.dataSet,
    this.title,
    this.loadingWidget,
    this.errorWidget,
    this.emptyWidget,
    this.isLoading = false,
    this.hasError = false,
    this.justList = true,
    this.reversed = false,
    this.noScrollPhysics = false,
    this.scrollDirection = Axis.vertical,
    required this.itemBuilder,
    this.separatorBuilder,
    this.padding,
    this.crossAxisCount = 2,
    this.childAspectRatio = 1.0,
    this.crossAxisSpacing = 2,
    this.mainAxisSpacing = 2,
    this.onRefresh,
    this.onLoading,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return justList
        ? _getBody()
        : VStack(
            [
              title ?? UiSpacer.emptySpace(),
              _getBody(),
            ],
            crossAlignment: CrossAxisAlignment.start,
          );
  }

  Widget _getBody() {
    return isLoading
        ? loadingWidget ?? const LoadingShimmer()
        : hasError
            ? errorWidget ?? const EmptyState()
            : justList
                ? dataSet.isEmpty
                    ? emptyWidget ?? UiSpacer.emptySpace()
                    : _getBodyList()
                : Expanded(
                    child: _getBodyList(),
                  );
  }

  Widget _getBodyList() {
    return (null != onRefresh)
        ? RefreshIndicator(
            onRefresh: onRefresh!,
            child: _getListView(),
          )
        : _getListView();
  }

  Widget _getListView() {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        childAspectRatio: childAspectRatio,
        crossAxisSpacing: crossAxisSpacing,
        mainAxisSpacing: mainAxisSpacing,
      ),
      padding: padding,
      physics: noScrollPhysics ? const NeverScrollableScrollPhysics() : null,
      shrinkWrap: true,
      itemBuilder: itemBuilder,
      itemCount: dataSet.length,
      reverse: reversed,
      scrollDirection: scrollDirection,
    );
  }
}
