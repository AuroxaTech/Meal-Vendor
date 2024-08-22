import 'package:flutter/material.dart';
import 'package:vendor/utils/ui_spacer.dart';
import 'package:vendor/widgets/states/empty.state.dart';
import 'package:vendor/widgets/states/loading.shimmer.dart';
import 'package:masonry_grid/masonry_grid.dart';
import 'package:velocity_x/velocity_x.dart';

class CustomMasonryGridView extends StatelessWidget {
  final Widget? title;
  final Widget? loadingWidget;
  final Widget? errorWidget;
  final Widget? emptyWidget;
  final List<Widget> items;
  final bool isLoading;
  final bool hasError;
  final bool justList;
  final int crossAxisCount;
  final double childAspectRatio;
  final double crossAxisSpacing;
  final double mainAxisSpacing;

  final Future<void> Function()? onRefresh;
  final Function? onLoading;

  const CustomMasonryGridView({
    this.title,
    this.loadingWidget,
    this.errorWidget,
    this.emptyWidget,
    this.isLoading = false,
    this.hasError = false,
    this.justList = true,
    required this.items,
    this.crossAxisCount = 2,
    this.childAspectRatio = 1.0,
    this.crossAxisSpacing = 2,
    this.mainAxisSpacing = 0,
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
                ? items.isEmpty
                    ? emptyWidget ?? UiSpacer.emptySpace()
                    : _getBodyList()
                : Expanded(
                    child: _getBodyList(),
                  );
  }

  //
  Widget _getBodyList() {
    return (null != onRefresh)
        ? RefreshIndicator(
            onRefresh: onRefresh!,
            child: _getListView(),
          )
        : _getListView();
  }

  //get listview
  Widget _getListView() {
    return MasonryGrid(
      column: crossAxisCount,
      crossAxisSpacing: crossAxisSpacing,
      mainAxisSpacing: mainAxisSpacing,
      children: items,
    );
  }
}
