import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_mate/core/themes/provider/theme_provider.dart';
import 'package:shop_mate/screens/home/home_screen.dart';
import 'package:shop_mate/screens/login/login_screen.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<ThemeProvider>(
          create: (context) => ThemeProvider(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    // return MaterialApp(
    // debugShowCheckedModeBanner: false,
    // theme: themeProvider.lightTheme,
    // darkTheme: themeProvider.darkTheme,
    // themeMode: themeProvider.themeMode,
    // home: SafeArea(
    //   child: LoginScreen(),
    // ),
    // );
    return ShadApp.material(
      debugShowCheckedModeBanner: false,
      title: 'SnapInk - Take beautiful snaps for sharing',
      theme: ShadThemeData(
        brightness: Brightness.light,
        colorScheme: ShadSlateColorScheme.light(background: Colors.white, ),
      ),
      /*darkTheme: ShadThemeData(
        colorScheme: const ShadSlateColorScheme.light(),
        brightness: Brightness.dark,
      ),*/
      themeMode: themeProvider.themeMode,
      home: const SafeArea(
        child: HomeScreen(),
      ),
    );
  }
}
