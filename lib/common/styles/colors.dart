import 'package:flutter/material.dart';

Color get glAccentColor => const Color(0xFF310682); // Fresh green - Health & balance
Color get glShadeColor => const Color(0xFF37474F); // Slate grey - for depth
Color get glSuccessColor => const Color(0xFF81C784); // Light green - Positive feedback
Color get glErrorColor => const Color(0xFFD32F2F); // Red - Standard error
// Macros
Color get glCaloriesColor => const Color(0xFFFF6D3F); // Vivid orange - Energy source
Color get glCarbColor => const Color(0xFFFBC02D); // Golden amber - No yellow tone
Color get glProteinColor => const Color(0xFF4682B4); // Steel Blue – muscular & bold
Color get glFatColor => const Color(0xFFF4A261); // Soft caramel, creamy but rich
Color get glFiberColor => const Color(0xFF4CAF50); // Fresh green - Fiber
Color get glWaterColor => const Color(0xFF29B6F6); // Aqua blue - Hydration

// Secondary background tints (modernized)
Color get glSecondaryColor1 => const Color(0xFFE8F5E9); // Soft green tint
Color get glSecondaryColor2 => const Color(0xFFFCE4EC); // Soft pink
Color get glSecondaryColor3 => const Color(0xFFFFF3E0); // Creamy orange (replaces yellow)
Color get glSecondaryColor4 => const Color(0xFFFFE0B2); // Light amber (replaces light yellow)
Color get glSecondaryColor5 => const Color(0xFFFFF1E0); // Very light pastel orange
Color get glSecondaryColor6 => const Color(0xFFE0F7FA); // Light cyan
Color get glSecondaryColor7 => const Color(0xFFF1F8E9); // Minty green

List<Color> get glPrimaryGradient => [
      const Color(0xFF4CAF50), // Healthy green
      const Color(0xFF81C784), // Lighter green
    ];

List<Color> get glSecondaryGradient => [
      const Color(0xFFFCE4EC),
      const Color(0xFFE8F5E9),
    ];

Color get glLightestGrey => Colors.grey.shade100;
Color get glLightGrey => Colors.grey.shade200;

//Light Theme Setting
Color get glLightThemeColor => const Color(0xFF2E3D30); // White
Color get glLightPrimaryColor => const Color(0xFFF5F5F5); // Soft grey-white
Color get glLightTextColor => const Color(0xFF212121); // Almost black
Color get glLightIconColor => const Color(0xFF4CAF50); // Accent green
Color get glLightButtonBGColor => const Color(0xFF4CAF50); // Green
Color get glLightButtonTextColor => const Color(0xFFFFFFFF); // White
Color get glLightButtonIconColor => const Color(0xFFFFFFFF); // White
Color get glLightDividerColor => const Color(0xFFBDBDBD); // Light grey
Color get glLightBoxShadowColor => const Color(0xFFEEEEEE); // Light
Color get glLightHeadingColor => const Color(0xFF2E7D32); // Dark green
Color get glLightHintColor => const Color(0xFF9E9E9E); // Subtle grey

//Dark Theme Setting
Color get glDarkPrimaryColor => const Color(0xFF263238); // Blue-grey
Color get glDarkTextColor => const Color(0xFFFFFFFF); // White
Color get glDarkIconColor => const Color(0xFF81C784); // Accent green
Color get glDarkButtonBGColor => const Color(0xFF81C784); // Green
Color get glDarkButtonTextColor => const Color(0xFF000000); // Black
Color get glDarkButtonIconColor => const Color(0xFF000000); // Black
Color get glDarkDividerColor => const Color(0xFF455A64); // Muted blue-grey
Color get glDarkBoxShadowColor => const Color(0xFF37474F); // Dark
Color get glDarkHeadingColor => const Color(0xFFA5D6A7); // Muted green
Color get glDarkHintColor => const Color(0xFFB0BEC5); // Grey-blue hint

//Dashboard Theme Setting
Color get glDashboardPrimaryDarkColor => const Color(0xFF1B1F23);
Color get glDashboardDarkTextColor => const Color(0xFFFFFFFF);
Color get glDashboardDarkIconColor => const Color(0xFF4CAF50);
Color get glDashboardDarkButtonBGColor => const Color(0xFF4CAF50);
Color get glDashboardDarkButtonTextColor => const Color(0xFFFFFFFF);
Color get glDashboardDarkButtonIconColor => const Color(0xFFFFFFFF);
Color get glDashboardDarkDividerColor => const Color(0xFF424242);
Color get glDashboardDarkBoxShadowColor => const Color(0xFF212121);
Color get glDashboardDarkHeadingColor => const Color(0xFF81C784);
Color get glDashboardDarkHintColor => const Color(0xFFBDBDBD);
