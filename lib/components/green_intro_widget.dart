import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:unisouq/utils/size_utils.dart';

Widget IntroWidgetWithoutLogos({
  required BuildContext context,
  String title = "",
  String? subtitle,
}) {
  return Column(
    children: [
      Padding(
        padding: EdgeInsets.symmetric(vertical: 0.v),
        child: Container(
          width: 500.v,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: const AssetImage('assets/images/mask.png'),
              fit: BoxFit.fill,
              colorFilter: ColorFilter.mode(
                Theme.of(context).primaryColor,
                BlendMode.overlay,
              ),
            ),
          ),
          height: 100.h,
          child: Container(
            height: 50.h,
            width: 50.v,
            margin: EdgeInsets.only(bottom: 5.h),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                if (subtitle != null)
                  Text(
                    subtitle,
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: Colors.black,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          IconButton(
            icon: const Icon(Icons.close_fullscreen_rounded),
            onPressed: () {
              // Handle cancel action here
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    ],
  );
}
