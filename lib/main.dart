import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:shop_mate/providers/authentication_provider.dart';
import 'package:shop_mate/providers/home_screen_provider.dart';
import 'package:shop_mate/providers/session_provider.dart';
import 'package:shop_mate/providers/theme_provider.dart';
import 'package:shop_mate/firebase_options.dart';
import 'package:shop_mate/screens/auth_screen.dart';
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
        ChangeNotifierProvider<AuthenticationProvider>(
            create: (_) => AuthenticationProvider()),
        ChangeNotifierProvider<SessionProvider>(
            create: (_) => SessionProvider()),
        ChangeNotifierProvider<HomeScreenProvider>(
            create: (_) => HomeScreenProvider()),
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
    ScreenUtil.init(context);

    return ShadApp.material(
      debugShowCheckedModeBanner: false,
      theme: ShadThemeData(
        brightness: Brightness.light,
        colorScheme: const ShadSlateColorScheme.light(
          background: Colors.white,
        ),
      ),
      darkTheme: ShadThemeData(
        colorScheme: const ShadSlateColorScheme.dark(
          background: Color.fromARGB(255, 12, 48, 77),
        ),
        brightness: Brightness.dark,
      ),
      themeMode: themeProvider.themeMode,
      home: const SafeArea(
        child: AuthScreen(),
      ),
    );
  }
}
