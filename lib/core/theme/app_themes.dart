import 'package:flutter/material.dart';enum ThemeType {  light,  dark,}class AppTheme {  static ThemeType defaultTheme = ThemeType.light;  //Theme Colors  bool isDark;  Color txt;  Color primary;  Color primary1;  Color secondary;  Color accentTxt;  Color bg1;  Color surface;  Color error;  //Extra Colors  Color bgGray;  Color gray;  Color darkGray;  Color lightGray;  Color borderGray;  Color green;  Color white;  /// Default constructor  AppTheme({    required this.isDark,    required this.txt,    required this.primary,    required this.primary1,    required this.secondary,    required this.accentTxt,    required this.bg1,    required this.surface,    required this.error,    //Extra    required this.bgGray,    required this.gray,    required this.darkGray,    required this.lightGray,    required this.borderGray,    required this.green,    required this.white,  });  /// fromType factory constructor  factory AppTheme.fromType(ThemeType t) {    switch (t) {      case ThemeType.light:        return AppTheme(          isDark: false,          txt: const Color(0xFF001928),          primary: const Color(0xFF3DC2C7),          primary1: const Color(0xFF001F40),          secondary: const Color(0xFF001F40),          accentTxt: const Color(0xFF001928),          bg1: Colors.white,          surface: Colors.white,          error: const Color(0xFFd32f2f),          //Extra          bgGray: const Color(0xFFF0F8FD),          gray: const Color(0xFF999999),          darkGray: const Color(0xFF666666),          lightGray: const Color(0xFFDFDFDF),          borderGray: const Color(0xFFE6E8EA),          green: const Color(0xFF5CB85C),          white: Colors.white,        );      case ThemeType.dark:        return AppTheme(          isDark: true,          txt: Colors.white,          primary: const Color(0xFF3DC2C7),          primary1: const Color(0xFF001F40),          secondary: const Color(0xFF6EBAE7),          accentTxt: const Color(0xFF001928),          bg1: const Color(0xFF151A1E),          surface: const Color(0xFF151A1E),          error: const Color(0xFFd32f2f),          //Extra          bgGray: const Color(0xFF262F36),          gray: const Color(0xFF999999),          darkGray: const Color(0xFF999999),          lightGray: const Color(0xFF999999),          borderGray: const Color(0xFF353C41),          green: const Color(0xFF5CB85C),          white: Colors.white,        );    }  }  ThemeData get themeData {    var t = ThemeData.from(      textTheme: (isDark ? ThemeData.dark() : ThemeData.light()).textTheme,      colorScheme: ColorScheme(        brightness: isDark ? Brightness.dark : Brightness.light,        primary: primary,        secondary: secondary,        background: bg1,        surface: surface,        onBackground: txt,        onSurface: txt,        onError: txt,        onPrimary: accentTxt,        onSecondary: accentTxt,        error: error,      ),    );    return t.copyWith(      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,      textSelectionTheme: TextSelectionThemeData(        selectionColor: borderGray,        selectionHandleColor: Colors.transparent,        cursorColor: primary,      ),      highlightColor: primary,      toggleableActiveColor: primary,    );  }}