import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomColorSchemes {
  static ThemeData get lightTheme => FlexThemeData.light(
        scheme: FlexScheme.mandyRed, // Replace with your desired scheme
        surfaceMode: FlexSurfaceMode.levelSurfacesLowScaffold,
        blendLevel: 15,
        appBarOpacity: 0.95,
        appBarStyle: FlexAppBarStyle.material,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        useMaterial3: true, // Opt-in for Material 3
      );

  static ThemeData get darkTheme => FlexThemeData.dark(
        scheme: FlexScheme.mandyRed, // Replace with your desired scheme
        surfaceMode: FlexSurfaceMode.highScaffoldLowSurface,
        blendLevel: 20,
        appBarOpacity: 0.90,
        appBarStyle: FlexAppBarStyle.material,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        useMaterial3: true, // Opt-in for Material 3
      );
}



/// The [AppTheme] defines light and dark themes for the app.
///
/// Theme setup for FlexColorScheme package v8.
/// Use same major flex_color_scheme package version. If you use a
/// lower minor version, some properties may not be supported.
/// In that case, remove them after copying this theme to your
/// app or upgrade package to version 8.0.2.
///
/// Use in [MaterialApp] like this:
///
/// MaterialApp(
///  theme: AppTheme.light,
///  darkTheme: AppTheme.dark,
///  :
/// );
sealed class AppTheme {
  // The defined light theme.
  static ThemeData light = FlexThemeData.light(
  scheme: FlexScheme.greenM3,
  surfaceMode: FlexSurfaceMode.highBackgroundLowScaffold,
  blendLevel: 1,
  appBarStyle: FlexAppBarStyle.background,
  bottomAppBarElevation: 2.0,
  subThemesData: const FlexSubThemesData(
    interactionEffects: true,
    tintedDisabledControls: true,
    blendOnLevel: 6,
    useM2StyleDividerInM3: true,
    adaptiveElevationShadowsBack: FlexAdaptive.excludeWebAndroidFuchsia(),
    adaptiveAppBarScrollUnderOff: FlexAdaptive.excludeWebAndroidFuchsia(),
    adaptiveRadius: FlexAdaptive.excludeWebAndroidFuchsia(),
    defaultRadiusAdaptive: 10.0,
    elevatedButtonSchemeColor: SchemeColor.onPrimaryContainer,
    elevatedButtonSecondarySchemeColor: SchemeColor.primaryContainer,
    outlinedButtonOutlineSchemeColor: SchemeColor.primary,
    toggleButtonsBorderSchemeColor: SchemeColor.primary,
    segmentedButtonSchemeColor: SchemeColor.primary,
    segmentedButtonBorderSchemeColor: SchemeColor.primary,
    unselectedToggleIsColored: true,
    sliderValueTinted: true,
    inputDecoratorSchemeColor: SchemeColor.primary,
    inputDecoratorIsFilled: true,
    inputDecoratorBackgroundAlpha: 19,
    inputDecoratorBorderType: FlexInputBorderType.outline,
    inputDecoratorUnfocusedHasBorder: false,
    inputDecoratorFocusedBorderWidth: 1.0,
    inputDecoratorPrefixIconSchemeColor: SchemeColor.primary,
    fabUseShape: true,
    fabAlwaysCircular: true,
    fabSchemeColor: SchemeColor.tertiary,
    cardRadius: 14.0,
    popupMenuRadius: 6.0,
    popupMenuElevation: 3.0,
    alignedDropdown: true,
    dialogRadius: 18.0,
    appBarScrolledUnderElevation: 1.0,
    drawerElevation: 1.0,
    drawerIndicatorSchemeColor: SchemeColor.primary,
    bottomSheetRadius: 18.0,
    bottomSheetElevation: 2.0,
    bottomSheetModalElevation: 4.0,
    bottomNavigationBarMutedUnselectedLabel: false,
    bottomNavigationBarMutedUnselectedIcon: false,
    menuRadius: 6.0,
    menuElevation: 3.0,
    menuBarRadius: 0.0,
    menuBarElevation: 1.0,
    menuBarShadowColor: Color(0x00000000),
    searchBarElevation: 4.0,
    searchViewElevation: 4.0,
    searchUseGlobalShape: true,
    navigationBarSelectedLabelSchemeColor: SchemeColor.primary,
    navigationBarSelectedIconSchemeColor: SchemeColor.onPrimary,
    navigationBarIndicatorSchemeColor: SchemeColor.primary,
    navigationBarElevation: 1.0,
    navigationRailSelectedLabelSchemeColor: SchemeColor.primary,
    navigationRailSelectedIconSchemeColor: SchemeColor.onPrimary,
    navigationRailUseIndicator: true,
    navigationRailIndicatorSchemeColor: SchemeColor.primary,
    navigationRailIndicatorOpacity: 1.00,
    navigationRailBackgroundSchemeColor: SchemeColor.surface,
    navigationRailLabelType: NavigationRailLabelType.all,
  ),
  visualDensity: FlexColorScheme.comfortablePlatformDensity,
  cupertinoOverrideTheme: const CupertinoThemeData(applyThemeToAll: true),
  );
  // The defined dark theme.
  static ThemeData dark = FlexThemeData.dark(
  scheme: FlexScheme.greenM3,
  surfaceMode: FlexSurfaceMode.highBackgroundLowScaffold,
  blendLevel: 2,
  appBarStyle: FlexAppBarStyle.background,
  bottomAppBarElevation: 2.0,
  subThemesData: const FlexSubThemesData(
    interactionEffects: true,
    tintedDisabledControls: true,
    blendOnLevel: 8,
    blendOnColors: true,
    useM2StyleDividerInM3: true,
    adaptiveElevationShadowsBack: FlexAdaptive.all(),
    adaptiveAppBarScrollUnderOff: FlexAdaptive.excludeWebAndroidFuchsia(),
    adaptiveRadius: FlexAdaptive.excludeWebAndroidFuchsia(),
    defaultRadiusAdaptive: 10.0,
    elevatedButtonSchemeColor: SchemeColor.onPrimaryContainer,
    elevatedButtonSecondarySchemeColor: SchemeColor.primaryContainer,
    outlinedButtonOutlineSchemeColor: SchemeColor.primary,
    toggleButtonsBorderSchemeColor: SchemeColor.primary,
    segmentedButtonSchemeColor: SchemeColor.primary,
    segmentedButtonBorderSchemeColor: SchemeColor.primary,
    unselectedToggleIsColored: true,
    sliderValueTinted: true,
    inputDecoratorSchemeColor: SchemeColor.primary,
    inputDecoratorIsFilled: true,
    inputDecoratorBackgroundAlpha: 22,
    inputDecoratorBorderType: FlexInputBorderType.outline,
    inputDecoratorUnfocusedHasBorder: false,
    inputDecoratorFocusedBorderWidth: 1.0,
    inputDecoratorPrefixIconSchemeColor: SchemeColor.primary,
    fabUseShape: true,
    fabAlwaysCircular: true,
    fabSchemeColor: SchemeColor.tertiary,
    cardRadius: 14.0,
    popupMenuRadius: 6.0,
    popupMenuElevation: 3.0,
    alignedDropdown: true,
    dialogRadius: 18.0,
    appBarScrolledUnderElevation: 3.0,
    drawerElevation: 1.0,
    drawerIndicatorSchemeColor: SchemeColor.primary,
    bottomSheetRadius: 18.0,
    bottomSheetElevation: 2.0,
    bottomSheetModalElevation: 4.0,
    bottomNavigationBarMutedUnselectedLabel: false,
    bottomNavigationBarMutedUnselectedIcon: false,
    menuRadius: 6.0,
    menuElevation: 3.0,
    menuBarRadius: 0.0,
    menuBarElevation: 1.0,
    menuBarShadowColor: Color(0x00000000),
    searchBarElevation: 4.0,
    searchViewElevation: 4.0,
    searchUseGlobalShape: true,
    navigationBarSelectedLabelSchemeColor: SchemeColor.primary,
    navigationBarSelectedIconSchemeColor: SchemeColor.onPrimary,
    navigationBarIndicatorSchemeColor: SchemeColor.primary,
    navigationBarElevation: 1.0,
    navigationRailSelectedLabelSchemeColor: SchemeColor.primary,
    navigationRailSelectedIconSchemeColor: SchemeColor.onPrimary,
    navigationRailUseIndicator: true,
    navigationRailIndicatorSchemeColor: SchemeColor.primary,
    navigationRailIndicatorOpacity: 1.00,
    navigationRailBackgroundSchemeColor: SchemeColor.surface,
    navigationRailLabelType: NavigationRailLabelType.all,
  ),
  visualDensity: FlexColorScheme.comfortablePlatformDensity,
  cupertinoOverrideTheme: const CupertinoThemeData(applyThemeToAll: true),
  );
}

