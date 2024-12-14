import 'package:damaz/controllers/navigation_controller.dart';
import 'package:damaz/pages/devices_page.dart';
import 'package:damaz/pages/home_page.dart';
import 'package:damaz/themes/color_schemes.dart';
import 'package:damaz/utils/font_manager.dart';
import 'package:damaz/utils/responsive_util.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


class MainScreen extends StatelessWidget {
  MainScreen({super.key});
  final NavigationController controller = Get.put(NavigationController());

  @override
  Widget build(BuildContext context) {
    ResponsiveUtil().init(context);
    final brightness = Theme.of(context).brightness;
    final isLightMode = brightness == Brightness.light;

    final primaryColor =
        isLightMode ? ColorSchemes.primaryLight : ColorSchemes.primaryDark;
    final secondaryColor =
        isLightMode ? ColorSchemes.secondaryLight : ColorSchemes.secondaryDark;
    final textColor =
        isLightMode ? ColorSchemes.textLight : ColorSchemes.textDark;

    return Scaffold(
      backgroundColor: primaryColor,
      body: Obx(() => IndexedStack(

            index: controller.currentIndex.value,
            children: [
              // home page of the food app
              HomePage(),

          
              // the home page of the sensors app

              DevicesPage(),
              // Settings(),
            ],
          )),
      bottomNavigationBar: Container(
        color: primaryColor,
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: ResponsiveUtil.safeBlockHorizontal * 3,
            vertical: ResponsiveUtil.blockSizeVertical * 2,
          ),
          child: GNav(
            backgroundColor: primaryColor,
            color: textColor,
            activeColor: textColor,
            tabBackgroundColor: secondaryColor,
            gap: ResponsiveUtil.safeBlockHorizontal * 0.5,
            padding: EdgeInsets.all(ResponsiveUtil.safeBlockHorizontal * 4),
            tabs: [
              GButton(
                  icon: Icons.home,
                  text: AppLocalizations.of(context)!.homeTextGButton,
                  textStyle: FontManager.bodyStyle.copyWith(color: textColor)),
              GButton(
                  icon: Icons.sensors_rounded,
                  text: AppLocalizations.of(context)!.sensorsTextGButton,
                  textStyle: FontManager.bodyStyle.copyWith(color: textColor)),
              // GButton(
              //     icon: Icons.settings,
              //     text: 'Settings',
              //     textStyle: FontManager.bodyStyle.copyWith(color: textColor)),
            ],
            selectedIndex: controller.currentIndex.value,
            onTabChange: (index) {
              controller.changePage(index);
            },
          ),
        ),
      ),
    );
  }
}