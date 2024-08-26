import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:vendor/constants/app_colors.dart';
import 'package:vendor/models/vendor.dart';
import 'package:map_launcher/map_launcher.dart';
import 'package:velocity_x/velocity_x.dart';

class RouteButton extends StatelessWidget {
  const RouteButton(this.vendor, {super.key});

  final Vendor vendor;
  @override
  Widget build(BuildContext context) {
    return const Icon(
      FlutterIcons.navigation_fea,
      size: 24,
      color: Colors.white,
    ).p8().box.color(AppColor.primaryColor).roundedSM.make().onInkTap(
      () async {
        //
        if (await MapLauncher.isMapAvailable(MapType.google) ?? false) {
          await MapLauncher.showDirections(
            mapType: MapType.google,
            destination: Coords(
              double.parse(vendor.latitude ?? "0"),
              double.parse(vendor.longitude ?? "0"),
            ),
            destinationTitle: vendor.name,
          );
        }
      },
    );
  }
}