import 'package:flutter/material.dart';
import 'package:vendor/constants/app_colors.dart';
import 'package:vendor/widgets/base.page.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:velocity_x/velocity_x.dart';
import '../../../constants/app_images.dart';
import '../../../constants/app_text_styles.dart';
import '../../../utils/size_utils.dart';
import '../../../utils/utils.dart';

class SupportPage extends StatefulWidget {
  const SupportPage({super.key});

  @override
  State<SupportPage> createState() => _SupportPageState();
}

class _SupportPageState extends State<SupportPage>
    with AutomaticKeepAliveClientMixin<SupportPage> {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    SizeConfigs().init(context);

    Widget titleWidget = Text('Support',
            style: AppTextStyle.comicNeue64BoldTextStyle(
                color: AppColor.appMainColor))
        .p(10);
    Widget imageWidget = Image.asset(
      AppImages.supportDesk,
      width: context.percentWidth * 50,
      // height: context.percentWidth * 50,
    ).centered();

    Widget needHelpWidget = Text('Need Help?',
            style: AppTextStyle.comicNeue64BoldTextStyle(
                color: AppColor.appMainColor))
        .p(10);

    Widget helpContentWidget = Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Image.asset(
          AppImages.supportClock,
          width: context.percentWidth * 10,
          // height: context.percentWidth * 50,
        ).pOnly(right: 10),
        Flexible(
            flex: 1,
            child: FittedBox(
                child: RichText(
              maxLines: 5,
              textAlign: TextAlign.end,
              text: TextSpan(
                children: [
                  TextSpan(
                      text: '2 mins Response time',
                      style: AppTextStyle.comicNeue50BoldTextStyle(
                          color: AppColor.appMainColor)),
                  TextSpan(
                      text: ' \nUpdated 5 mins ago',
                      style: AppTextStyle.comicNeue30BoldTextStyle(
                          color: AppColor.appMainColor)),
                ],
              ),
            ).pOnly(right: 5))),
      ],
    ).p(10);
    Widget callWidget = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32.0),
      child: InkWell(
        onTap: () async {
          String url = "tel:${Utils.supportNumber}";
          if (await canLaunch(url)) {
            await launch(url);
          } else {
            throw 'Could not launch $url';
          }
        },
        child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(width: 3, color: AppColor.appMainColor)),
                child: Text('Request a Call',
                        textAlign: TextAlign.center,
                        style:  AppTextStyle.comicNeue30BoldTextStyle(
                                color: AppColor.appMainColor))
                    .p(getWidth(8)))
            .centered(),
      ),
    );

    return SafeArea(
      child: BasePage(
        body: SizeConfigs.isTablet
            ? Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        titleWidget,
                        Expanded(child: imageWidget),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        needHelpWidget,
                        helpContentWidget,
                        const Expanded(child: SizedBox.shrink()),
                        callWidget,
                        const Expanded(child: SizedBox.shrink()),
                      ],
                    ),
                  ),
                ],
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //  "Orders".tr().text.xl2.bold.color(AppColor.appMainColor).make().p20(),
                  titleWidget,
                  imageWidget,
                  needHelpWidget,
                  helpContentWidget,
                  const Expanded(child: SizedBox.shrink()),
                  callWidget,
                  const Expanded(child: SizedBox.shrink()),
                  const Expanded(child: SizedBox.shrink()),
                ],
              ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
