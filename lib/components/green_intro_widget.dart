import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:unisouq/utils/size_utils.dart';



Widget IntroWidgetWithoutLogos({String title = "", String? subtitle}) {
  return Padding(
    padding: EdgeInsets.symmetric(vertical: 15.v),
    child: Container(
      width: 500.v,
      decoration: const BoxDecoration(
        image: DecorationImage(
            image: AssetImage('assets/images/mask.png'),
            fit: BoxFit.fill,
            colorFilter: ColorFilter.linearToSrgbGamma()),
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
                  color: Colors.white),
            ),
            if (subtitle != null)
              Text(
                subtitle,
                style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: Colors.black),
              ),
          ],
        ),
      ),
    ),
  );
}
