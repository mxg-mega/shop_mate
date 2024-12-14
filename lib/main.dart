import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_mate/providers/auth_provider.dart';
import 'package:shop_mate/providers/theme_provider.dart';
import 'package:shop_mate/firebase_options.dart';
import 'package:shop_mate/screens/home/home_screen.dart';
import 'package:shop_mate/screens/login/login_screen.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<ThemeProvider>(create: (_) => ThemeProvider()),
        ChangeNotifierProvider<AuthProvider>(create: (_) => AuthProvider()),
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
      theme: ShadThemeData(
        brightness: Brightness.light,
        colorScheme: const ShadSlateColorScheme.light(
          background: Colors.white,
        ),
      ),
      /*darkTheme: ShadThemeData(
        colorScheme: const ShadSlateColorScheme.light(),
        brightness: Brightness.dark,
      ),*/
      themeMode: themeProvider.themeMode,
      home: const SafeArea(
        child: LoginScreen(),
      ),
    );
  }
}
