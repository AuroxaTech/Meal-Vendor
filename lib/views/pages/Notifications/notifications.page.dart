import 'package:flutter/material.dart';
import 'package:vendor/constants/app_colors.dart';
import 'package:vendor/utils/ui_spacer.dart';
import 'package:vendor/widgets/base.page.dart';
import 'package:stacked/stacked.dart';
import 'package:velocity_x/velocity_x.dart';
import '../../../constants/app_strings.dart';
import '../../../constants/app_text_styles.dart';
import '../../../utils/size_utils.dart';
import '../../../utils/utils.dart';
import '../../../view_models/notifications.vm.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage>
    with AutomaticKeepAliveClientMixin<NotificationsPage> {
  @override
  Widget build(BuildContext context) {
    SizeConfigs().init(context);
    super.build(context);
    return SafeArea(
      child: ViewModelBuilder<NotificationsViewModel>.reactive(
        viewModelBuilder: () => NotificationsViewModel(context),
        onViewModelReady: (model) => model.initialise(),
        builder: (context, model, child) {
          return BasePage(
            body: Container(
              padding: EdgeInsets.all(SizeConfigs.isTablet ? 20 : 10),
              child: VStack(
                [
                  Text('Notifications',
                      style: AppTextStyle.comicNeue64BoldTextStyle(
                          color: AppColor.appMainColor)),

                  //profile card
                  UiSpacer.vSpace(30),
                  Container(
                      padding: const EdgeInsets.fromLTRB(10, 2, 10, 2),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(
                              width: 3, color: AppColor.appMainColor)),
                      child: VStack(
                        [
                          //title
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Carla R.',
                                  style: AppTextStyle.comicNeue25BoldTextStyle(
                                      color: AppColor.appMainColor)),
                              UiSpacer.hSpace(5),
                              Text('Missing items',
                                  style: AppTextStyle.comicNeue20BoldTextStyle(
                                      color: AppColor.appMainColor)),
                              UiSpacer.hSpace(5),
                              Flexible(
                                  flex: 1,
                                  child: FittedBox(
                                      child: Text('Delivered 15 mins ago',
                                          maxLines: 3,
                                          style: AppTextStyle
                                              .comicNeue20BoldTextStyle(
                                                  color:
                                                      AppColor.appMainColor)))),
                            ],
                          ).py4(),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width: (MediaQuery.sizeOf(context).width -
                                            Utils.navRailWidth) /
                                        3,
                                    child: Text('1x Canned Drinks (355ml)',
                                        maxLines: 4,
                                        style: AppTextStyle
                                            .comicNeue20BoldTextStyle(
                                                color: AppColor.appMainColor)),
                                  ),
                                  Text('1x Breadsticks',
                                      style:
                                          AppTextStyle.comicNeue20BoldTextStyle(
                                              color: AppColor.appMainColor)),
                                  Text('(Click to expand)',
                                      style:
                                          AppTextStyle.comicNeue14BoldTextStyle(
                                              color: AppColor.appMainColor)),
                                ],
                              ),
                              Column(
                                children: [
                                  Text('Total',
                                      style:
                                          AppTextStyle.comicNeue25BoldTextStyle(
                                              color: AppColor.appMainColor)),
                                  Text('9.72\$',
                                      style:
                                          AppTextStyle.comicNeue25BoldTextStyle(
                                              color: AppColor.appMainColor)),
                                ],
                              ),
                              InkWell(
                                  onTap: () {},
                                  child: Container(
                                          margin: const EdgeInsets.symmetric(
                                              horizontal: 5),
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                              border: Border.all(
                                                  width: 3,
                                                  color:
                                                      AppColor.appMainColor)),
                                          child: Text(
                                                  'Resolve\n'
                                                  'Now',
                                                  textAlign: TextAlign.center,
                                                  style: AppTextStyle
                                                      .comicNeue20BoldTextStyle(
                                                          color: AppColor
                                                              .appMainColor))
                                              .px20()
                                              .py4())
                                      .onInkTap(() => openDialog())),
                            ],
                          ).py4(),

                          //time

                          //body
                        ],
                      ).py12()),

                  // CustomListView(
                  //   dataSet: model.notifications,
                  //   emptyWidget: EmptyState(
                  //     title: "No Notifications".tr(),
                  //     description:
                  //     "You dont' have notifications yet. When you get notifications, they will appear here"
                  //         .tr(),
                  //   ),
                  //   itemBuilder: (context, index) {
                  //     //
                  //     final notification = model.notifications[index];
                  //     return  Container(
                  //         padding: const EdgeInsets.fromLTRB(15,2,15,2),
                  //         decoration: BoxDecoration(
                  //             color: Colors.white,
                  //             borderRadius: BorderRadius.circular(25),
                  //             border: Border.all(
                  //                 width: 3,
                  //                 color: AppColor.appMainColor)),
                  //         child:  VStack(
                  //           [
                  //             //title
                  //             Row(
                  //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //               children: [
                  //                 Text('Carla R.',
                  //                     style: AppTextStyle.comicNeue25BoldTextStyle
                  //                       (color: AppColor.appMainColor)),
                  //                 UiSpacer.hSpace(10),
                  //                 Text('Missing items',
                  //                     style: AppTextStyle.comicNeue20BoldTextStyle
                  //                       (color: AppColor.appMainColor)),
                  //                 UiSpacer.hSpace(10),
                  //                 Flexible(flex: 1,
                  //                     child: FittedBox(
                  //                         child: Text('Delivered 15 mins ago',maxLines: 3,
                  //                             style: AppTextStyle.comicNeue20BoldTextStyle
                  //                               (color: AppColor.appMainColor)))),
                  //               ],
                  //             ).py4(),
                  //
                  //             Row(
                  //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //               children: [
                  //
                  //                 Column(
                  //                   crossAxisAlignment: CrossAxisAlignment.start,
                  //                   children: [
                  //                     SizedBox(
                  //                       width: (MediaQuery.sizeOf(context).width - Utils.navRailWidth ) /3,
                  //                       child:  Text('1x Canned Drinks (355ml)',
                  //                           maxLines: 4,
                  //                           style: AppTextStyle.comicNeue20BoldTextStyle
                  //                             (color: AppColor.appMainColor)),
                  //                     ),
                  //                     Text('1x Breadsticks',
                  //                         style: AppTextStyle.comicNeue20BoldTextStyle
                  //                           (color: AppColor.appMainColor)),
                  //                     Text('(Click to expand)',
                  //                         style: AppTextStyle.comicNeue14BoldTextStyle
                  //                           (color: AppColor.appMainColor)),
                  //                   ],
                  //                 ),
                  //                 Column(
                  //                   children: [
                  //
                  //                     Text('Total',
                  //                         style: AppTextStyle.comicNeue25BoldTextStyle
                  //                           (color: AppColor.appMainColor)),
                  //                     Text('9.72\$',
                  //                         style: AppTextStyle.comicNeue25BoldTextStyle
                  //                           (color: AppColor.appMainColor)),
                  //                   ],
                  //                 ),
                  //                 InkWell(
                  //                     onTap: (){},
                  //                     child: Container(
                  //                         alignment: Alignment.center,
                  //                         decoration: BoxDecoration(
                  //                             color: Colors.white,
                  //                             borderRadius: BorderRadius.circular(25),
                  //                             border: Border.all(
                  //                                 width: 3,
                  //                                 color: AppColor.appMainColor)),
                  //                         child: Text('Resolve\n'
                  //                             'Now', textAlign: TextAlign.center,
                  //                             style: AppTextStyle.comicNeue25BoldTextStyle
                  //                               (color: AppColor.appMainColor)).px20().py4().onInkTap(() => openDialog())
                  //                     )
                  //                 ) ,
                  //               ],
                  //             ).py12(),
                  //
                  //             //time
                  //
                  //             //body
                  //
                  //           ],
                  //         ).py12()
                  //     )
                  //     //   VStack(
                  //     //   [
                  //     //     //title
                  //     //     "${notification.title}".text.bold.make(),
                  //     //     //time
                  //     //     notification.formattedTimeStamp.text.medium
                  //     //         .color(Colors.grey)
                  //     //         .make()
                  //     //         .pOnly(bottom: 5),
                  //     //     //body
                  //     //     "${notification.body}"
                  //     //         .text
                  //     //         .maxLines(1)
                  //     //         .overflow(TextOverflow.ellipsis)
                  //     //         .make(),
                  //     //   ],
                  //     // )
                  //         .px20()
                  //         .py12()
                  //         .box
                  //         .color(notification.read
                  //         ? context.cardColor
                  //         : context.backgroundColor)
                  //         .make()
                  //         .onInkTap(() {
                  //       model.showNotificationDetails(notification);
                  //     });
                  //   },
                  //   separatorBuilder: (context, index) => UiSpacer.divider(),
                  // )
                ],
              ).scrollVertical(),
            ),
          );
        },
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;

  void openDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          insetPadding: EdgeInsets.zero,
          backgroundColor: Colors.transparent,
          content: Container(
            padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                border: Border.all(width: 4, color: AppColor.appMainColor)),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Carla D.\n#a6yy42',
                            style: AppTextStyle.comicNeue35BoldTextStyle(
                                color: AppColor.appMainColor))
                        .p8(),
                    Text('9.72${AppStrings.currencySymbol}',
                            style: AppTextStyle.comicNeue25BoldTextStyle(
                                color: AppColor.appMainColor))
                        .p8(),
                  ],
                ),
                Row(
                  children: [
                    Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(
                              width: 3, color: AppColor.appMainColor)),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12.0, vertical: 12.0),
                      child: Text('Refund',
                              style: AppTextStyle.comicNeue25BoldTextStyle(
                                  color: AppColor.appMainColor))
                          .p4(),
                    ).onInkTap(() => Navigator.pop(context)),
                    const SizedBox(
                      width: 10.0,
                    ),
                    Expanded(
                      child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(
                                width: 3, color: AppColor.appMainColor)),
                        child: Text('Credit\n(recommended)',
                                textAlign: TextAlign.center,
                                style: AppTextStyle.comicNeue25BoldTextStyle(
                                    color: AppColor.appMainColor))
                            .p4(),
                      ).onInkTap(() => Navigator.pop(context)),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10.0,
                ),
                Row(
                  children: [
                    Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(
                              width: 3, color: AppColor.appMainColor)),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12.0, vertical: 12.0),
                      child: Text('Chat',
                              style: AppTextStyle.comicNeue25BoldTextStyle(
                                  color: AppColor.appMainColor))
                          .p4(),
                    ).onInkTap(() => Navigator.pop(context)),
                    const SizedBox(
                      width: 10.0,
                    ),
                    Expanded(
                      child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(
                                width: 3, color: AppColor.appMainColor)),
                        child: Text('Redeliver\n(Not Recommended)',
                                textAlign: TextAlign.center,
                                style: AppTextStyle.comicNeue25BoldTextStyle(
                                    color: AppColor.appMainColor))
                            .p4(),
                      ).onInkTap(() => Navigator.pop(context)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
