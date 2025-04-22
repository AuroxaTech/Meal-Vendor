import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../utils/size_utils.dart';

class AppTextStyle {
  //Text Sized
  static TextStyle headerTitleTextStyle({
    Color color = Colors.black,
    FontWeight fontWeight = FontWeight.w800,
  }) {
    return GoogleFonts.nunito(
      fontSize: 38,
      fontWeight: fontWeight,
      color: color,
    );
  }

  static TextStyle subTitleTitleTextStyle({
    Color color = Colors.black,
    FontWeight fontWeight = FontWeight.w800,
  }) {
    return GoogleFonts.nunito(
      fontSize: 28,
      fontWeight: fontWeight,
      color: color,
    );
  }

  static TextStyle h0TitleTextStyle({
    Color color = Colors.black,
    FontWeight fontWeight = FontWeight.w800,
  }) {
    return GoogleFonts.nunito(
      fontSize: 30,
      fontWeight: fontWeight,
      color: color,
    );
  }

  static TextStyle h1TitleTextStyle({
    Color color = Colors.black,
    FontWeight fontWeight = FontWeight.w600,
  }) {
    return GoogleFonts.nunito(
      fontSize: 24,
      fontWeight: fontWeight,
      color: color,
    );
  }

  static TextStyle h2TitleTextStyle({
    Color color = Colors.black,
    FontWeight fontWeight = FontWeight.w600,
  }) {
    return GoogleFonts.nunito(
        fontSize: 22, fontWeight: fontWeight, color: color);
  }

  static TextStyle h3TitleTextStyle({
    Color color = Colors.black,
    FontWeight fontWeight = FontWeight.w500,
  }) {
    return GoogleFonts.nunito(
      fontSize: 18,
      fontWeight: fontWeight,
      color: color,
    );
  }

  static TextStyle h4TitleTextStyle({
    Color color = Colors.black,
    FontWeight fontWeight = FontWeight.w500,
  }) {
    return GoogleFonts.nunito(
        fontSize: 15, fontWeight: fontWeight, color: color);
  }

  static TextStyle h5TitleTextStyle(
      {Color color = Colors.black, FontWeight fontWeight = FontWeight.w400}) {
    return GoogleFonts.nunito(
        fontSize: 13, fontWeight: fontWeight, color: color);
  }

  static TextStyle h6TitleTextStyle(
      {Color color = Colors.black, FontWeight fontWeight = FontWeight.w300}) {
    return GoogleFonts.nunito(
        fontSize: 11, fontWeight: fontWeight, color: color);
  }

  static TextStyle comicNeue64BoldTextStyle(
      {Color color = Colors.black, FontWeight fontWeight = FontWeight.w600}) {
    return GoogleFonts.comicNeue(
        fontSize: SizeConfigs.isTablet ? 64 : 38,
        fontWeight: fontWeight,
        color: color);
  }

  static TextStyle comicNeue55BoldTextStyle(
      {Color color = Colors.black, FontWeight fontWeight = FontWeight.w600}) {
    return GoogleFonts.comicNeue(
        fontSize: SizeConfigs.isTablet ? 55 : 33,
        fontWeight: fontWeight,
        color: color);
  }

  static TextStyle comicNeue50BoldTextStyle(
      {Color color = Colors.black, FontWeight fontWeight = FontWeight.w600}) {
    return GoogleFonts.comicNeue(
        fontSize: SizeConfigs.isTablet ? 50 : 30,
        fontWeight: fontWeight,
        color: color);
  }

  static TextStyle comicNeue45BoldTextStyle(
      {Color color = Colors.black, FontWeight fontWeight = FontWeight.w600}) {
    return GoogleFonts.comicNeue(
        fontSize: SizeConfigs.isTablet ? 45 : 26,
        fontWeight: fontWeight,
        color: color);
  }

  static TextStyle comicNeue40BoldTextStyle(
      {Color color = Colors.black, FontWeight fontWeight = FontWeight.w600}) {
    return GoogleFonts.comicNeue(
        fontSize: SizeConfigs.isTablet ? 40 : 30,
        fontWeight: fontWeight,
        color: color);
  }

  static TextStyle comicNeue35BoldTextStyle(
      {Color color = Colors.black, FontWeight fontWeight = FontWeight.w600}) {
    return GoogleFonts.comicNeue(
        fontSize: SizeConfigs.isTablet ? 35 : 25,
        fontWeight: fontWeight,
        color: color);
  }

  static TextStyle comicNeue30BoldTextStyle(
      {Color color = Colors.black, FontWeight fontWeight = FontWeight.w600}) {
    return GoogleFonts.comicNeue(
        fontSize: SizeConfigs.isTablet ? 30 : 20,
        fontWeight: fontWeight,
        color: color);
  }

  static TextStyle comicNeue27BoldTextStyle(
      {Color color = Colors.black, FontWeight fontWeight = FontWeight.w600}) {
    return GoogleFonts.comicNeue(
        fontSize: SizeConfigs.isTablet ? 27 : 18,
        fontWeight: fontWeight,
        color: color);
  }

  static TextStyle comicNeue25BoldTextStyle(
      {Color color = Colors.black, FontWeight fontWeight = FontWeight.w600}) {
    return GoogleFonts.comicNeue(
        fontSize: SizeConfigs.isTablet ? 25 : 15,
        fontWeight: fontWeight,
        color: color);
  }

  static TextStyle comicNeue20BoldTextStyle(
      {Color color = Colors.black, FontWeight fontWeight = FontWeight.w600}) {
    return GoogleFonts.comicNeue(
        fontSize: SizeConfigs.isTablet ? 20 : 14,
        fontWeight: fontWeight,
        color: color);
  }

  static TextStyle comicNeue18BoldTextStyle(
      {Color color = Colors.black, FontWeight fontWeight = FontWeight.w600}) {
    return GoogleFonts.comicNeue(
        fontSize: SizeConfigs.isTablet ? 18 : 12,
        fontWeight: fontWeight,
        color: color);
  }

  static TextStyle comicNeue16BoldTextStyle(
      {Color color = Colors.black, FontWeight fontWeight = FontWeight.w600}) {
    return GoogleFonts.comicNeue(
        fontSize: SizeConfigs.isTablet ? 16 : 10,
        fontWeight: fontWeight,
        color: color);
  }

  static TextStyle comicNeue14BoldTextStyle(
      {Color color = Colors.black, FontWeight fontWeight = FontWeight.w600}) {
    return GoogleFonts.comicNeue(
        fontSize: SizeConfigs.isTablet ? 14 : 9,
        fontWeight: fontWeight,
        color: color);
  }
}
