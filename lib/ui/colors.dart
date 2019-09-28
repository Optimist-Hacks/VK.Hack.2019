import 'package:flutter/material.dart';

class GoColors {
  // main
  final Color backgroundColor;

  // card
  final Color cardTextColor = Colors.white;
  final Color placeGradientStart = Color(0x00000000);
  final Color placeGradientEnd = Color(0x82000000);

  // placePage
  final Color placeInfoTextColor;
  final Color buyTicketBackgroundColor;
  final Color buyTextColor;
  final Color buyGradientStart;
  final Color buyGradientEnd;

  final airplane = Color(0xFFEF7340);

  final shareBackground = Color(0x1AFFFFFF);

  GoColors(bool darkMode)
      : backgroundColor = darkMode ? Colors.black : Colors.white,
        placeInfoTextColor = darkMode ? Colors.white : Color(0xFF1B2038),
        buyTicketBackgroundColor = darkMode ? Colors.white : Color(0xFF1B2038),
        buyTextColor = darkMode ? Color(0xFF1B2038) : Colors.white,
        buyGradientStart = darkMode ? Color(0x00000000) : Color(0x00FFFFFF),
        buyGradientEnd = darkMode ? Color(0xFF000000) : Color(0xFFFFFFFF);
}
