import 'package:flutter/material.dart';
import 'package:vendor/constants/app_colors.dart';
import 'package:vendor/view_models/products.vm.dart';
import 'package:vendor/widgets/base.page.dart';
import 'package:vendor/widgets/custom_list_view.dart';
import 'package:vendor/widgets/list_items/manage_product.list_item.dart';
import 'package:stacked/stacked.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../../constants/app_images.dart';
import '../../../constants/app_text_styles.dart';
import '../../../models/vendor.dart';
import '../../../services/auth.service.dart';
import '../../../utils/size_utils.dart';
import '../../../utils/ui_spacer.dart';
import '../../../widgets/buttons/custom_button.dart';
import '../../../widgets/states/loading.shimmer.dart';

class ProductsPage extends StatefulWidget {
  const ProductsPage({super.key});

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage>
    with AutomaticKeepAliveClientMixin<ProductsPage> {
  @override
  Widget build(BuildContext context) {
    SizeConfigs().init(context);
    super.build(context);
    return SafeArea(
      child: ViewModelBuilder<ProductViewModel>.reactive(
        viewModelBuilder: () => ProductViewModel(context),
        onViewModelReady: (vm) => vm.initialise(),
        builder: (context, vm, child) {
          return BasePage(
            body: Container(
              padding: EdgeInsets.zero,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0, top: 20.0),
                    child: Text('Manage Menu',
                        style: AppTextStyle.comicNeue64BoldTextStyle(
                            color: AppColor.appMainColor)),
                  ),
                  Container(
                    padding: const EdgeInsets.only(top: 10, bottom: 5),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: <BoxShadow>[
                        BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            offset: const Offset(0, 4),
                            blurRadius: 0.5,
                            spreadRadius: 0.1)
                      ],
                    ),
                    child: Row(
                      children: [
                        Image.asset(
                          AppImages.search,
                          height: getShortestSide(30),
                          width: getShortestSide(30),
                        ).px12(),
                        if (null != vm.vendor)
                          CustomListView(
                            scrollDirection: Axis.horizontal,
                            dataSet: vm.vendor!.menus,
                            itemBuilder: (context, index) {
                              final status = vm.vendor!.menus[index];
                              return Container(
                                padding: EdgeInsets.zero,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(18),
                                    border: Border.all(
                                        width: status.id == vm.menuId
                                            ? 4
                                            : 2,
                                        color: status.id == vm.menuId
                                            ? AppColor.appMainColor
                                            : Colors.transparent)),
                                child: CustomButton(
                                    title: status.name
                                        .toLowerCase()
                                        .allWordsCapitilize(),
                                    count: '',
                                    onPressed: () =>
                                        vm.statusCategories(status.id),
                                    isSelected: status.id == vm.menuId,
                                    elevation: 0,
                                    shapeRadius: 18),
                              );
                            },
                          ).h(40).expand(),
                      ],
                    ),
                  ),
                  UiSpacer.vSpace(10),
                  vm.isBusy
                      ? const LoadingShimmer()
                      : GridView.builder(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            mainAxisExtent: getWidth(100),
                            mainAxisSpacing: 0.0,
                            crossAxisSpacing: 0.0,
                            crossAxisCount: SizeConfigs.isTablet ? 2 : 1,
                          ),
                          itemCount: vm.products.length,
                          itemBuilder: (BuildContext context, int index) {
                            final product = vm.products[index];
                            return ManageProductListItem(
                              product,
                              isLoading: vm.busy(product.id),
                              onPressed: vm.openProductDetails,
                              onEditPressed: vm.editProduct,
                              onToggleStatusPressed: vm.changeProductStatus,
                              onDeletePressed: vm.deleteProduct,
                              onUpdateProductAvailability:
                                  vm.onUpdateProductAvailability,
                            );
                          }).p4().expand(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
