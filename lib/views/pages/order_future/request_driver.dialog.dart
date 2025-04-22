import 'package:flutter/material.dart';
import 'package:vendor/constants/app_colors.dart';
import 'package:velocity_x/velocity_x.dart';
import '../../../constants/app_text_styles.dart';
import '../../../utils/size_utils.dart';
import '../../../view_models/ordersFuture.vm.dart';

class RequestDriverDialog extends StatelessWidget {
  const RequestDriverDialog({
    required this.viewModel,
    super.key,
  });

  final OrdersFutureViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    bool checkedValue = false;
    return StatefulBuilder(builder:
        (BuildContext context, void Function(void Function()) newState) {
      return Container(
        constraints: BoxConstraints(minWidth: 300.0, maxWidth: 600.0),
        padding: const EdgeInsets.fromLTRB(10, 15, 5, 15),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(width: 4, color: AppColor.appMainColor)),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.only(right: getWidth(5)),
                    alignment: Alignment.centerLeft,
                    child: Text('When:',
                        style: AppTextStyle.comicNeue45BoldTextStyle(
                            color: AppColor.appMainColor)),
                  ),
                  Container(
                    padding: EdgeInsets.zero,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      border:
                          Border.all(width: 2, color: AppColor.appMainColor),
                    ),
                    child: Text('ASAP',
                            style: AppTextStyle.comicNeue35BoldTextStyle(
                                color: AppColor.appMainColor))
                        .px20()
                        .py8(),
                  ).px20(),
                ],
              ).py4(),
              Container(
                alignment: Alignment.centerLeft,
                child: Text('Name',
                    style: AppTextStyle.comicNeue25BoldTextStyle(
                        color: AppColor.appMainColor)),
              ).px8().py4(),
              Container(
                padding: EdgeInsets.zero,
                height: 55,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(width: 2, color: AppColor.appMainColor),
                ),
                child: TextField(
                  style: AppTextStyle.comicNeue30BoldTextStyle(
                      color: AppColor.appMainColor),
                  decoration: InputDecoration(
                    hintText: " ",
                    hintStyle: AppTextStyle.comicNeue30BoldTextStyle(
                        color: AppColor.appMainColor),
                    border: const OutlineInputBorder(
                      borderSide: BorderSide.none,
                    ),
                  ),
                  onChanged: (value) {},
                ),
              ).px8().py4(),
              Container(
                alignment: Alignment.centerLeft,
                child: Text('Phone Number',
                    style: AppTextStyle.comicNeue25BoldTextStyle(
                        color: AppColor.appMainColor)),
              ).px8().py4(),
              Container(
                padding: EdgeInsets.zero,
                height: 55,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(width: 2, color: AppColor.appMainColor),
                ),
                child: TextField(
                  style: AppTextStyle.comicNeue30BoldTextStyle(
                      color: AppColor.appMainColor),
                  decoration: InputDecoration(
                    hintText: " ",
                    hintStyle: AppTextStyle.comicNeue30BoldTextStyle(
                        color: AppColor.appMainColor),
                    border: const OutlineInputBorder(
                      borderSide: BorderSide.none,
                    ),
                  ),
                  onChanged: (value) {},
                ),
              ).px8().py4(),
              Container(
                alignment: Alignment.centerLeft,
                child: Text('Address',
                    style: AppTextStyle.comicNeue25BoldTextStyle(
                        color: AppColor.appMainColor)),
              ).px8().py4(),
              Container(
                padding: EdgeInsets.zero,
                height: 55,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(width: 2, color: AppColor.appMainColor),
                ),
                child: TextField(
                  style: AppTextStyle.comicNeue30BoldTextStyle(
                      color: AppColor.appMainColor),
                  decoration: InputDecoration(
                    hintText: " ",
                    hintStyle: AppTextStyle.comicNeue30BoldTextStyle(
                        color: AppColor.appMainColor),
                    border: const OutlineInputBorder(
                      borderSide: BorderSide.none,
                    ),
                  ),
                  onChanged: (value) {},
                ),
              ).px8().py4(),
              Container(
                alignment: Alignment.centerLeft,
                child: Text('Tips Amount',
                    style: AppTextStyle.comicNeue25BoldTextStyle(
                        color: AppColor.appMainColor)),
              ).px8().py4(),
              Container(
                padding: EdgeInsets.zero,
                height: 55,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(width: 2, color: AppColor.appMainColor),
                ),
                child: TextField(
                  style: AppTextStyle.comicNeue30BoldTextStyle(
                      color: AppColor.appMainColor),
                  decoration: InputDecoration(
                    hintText: " ",
                    hintStyle: AppTextStyle.comicNeue30BoldTextStyle(
                        color: AppColor.appMainColor),
                    border: const OutlineInputBorder(
                      borderSide: BorderSide.none,
                    ),
                  ),
                  onChanged: (value) {},
                ),
              ).px8().py4(),
              CheckboxListTile(
                contentPadding: EdgeInsets.zero,
                visualDensity: VisualDensity.compact,
                activeColor: AppColor.appMainColor,
                title: Text("Food Made Wrong",
                    style: AppTextStyle.comicNeue20BoldTextStyle(
                        color: AppColor.appMainColor)),
                value: checkedValue,
                onChanged: (newValue) {
                  checkedValue = newValue!;
                  newState(() {});
                },
                side: BorderSide(
                  color: AppColor.appMainColor,
                  width: 3,
                ),
                controlAffinity:
                    ListTileControlAffinity.leading, //  <-- leading Checkbox
              ),
              Container(
                alignment: Alignment.center,
                width: MediaQuery.sizeOf(context).width,
                padding: EdgeInsets.zero,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(width: 2, color: AppColor.appMainColor),
                ),
                child: Text('Submit Order',
                        style: AppTextStyle.comicNeue40BoldTextStyle(
                            color: AppColor.appMainColor))
                    .p12(),
              ).px8(),
            ],
          ),
        ),
      );
    });
  }
}
