import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:shop_mate/core/themes/shadcn_themes.dart';
import 'package:shop_mate/data/datasource/local/business_storage.dart';
import 'package:shop_mate/data/datasource/local/user_storage.dart';
import 'package:shop_mate/firebase_options.dart';
import 'package:shop_mate/providers/authentication_provider.dart';
import 'package:shop_mate/providers/inventory_provider.dart';
import 'package:shop_mate/providers/navigation_provider.dart';
import 'package:shop_mate/providers/product_provider.dart';
import 'package:shop_mate/providers/theme_provider.dart';
import 'package:shop_mate/providers/transaction_provider.dart';
import 'package:shop_mate/screens/auth_screen.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  FirebaseFirestore.instance.settings = const Settings(
    persistenceEnabled: true,
    cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
  );

  await UserStorage.initSharedPreferences();
  await BusinessStorage.initSharedPreferences();

  if (!kIsWeb && Platform.isWindows) {
    try {
      debugPrint("Firestore cache Clearing...");
      await FirebaseFirestore.instance.clearPersistence();
      debugPrint("Firestore cache Cleared");
    } catch (e) {
      debugPrint("Failed to clear firestore cache for windows");
    }
  }

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<ThemeProvider>(create: (_) => ThemeProvider()),
        ChangeNotifierProvider<AuthenticationProvider>(
            create: (_) => AuthenticationProvider()),
        // ChangeNotifierProvider<SessionProvider>(
        //     // create: (_) => SessionProvider()..listenToAuthChanges()),
        //     create: (_) => SessionProvider()),
        ChangeNotifierProvider<NavigationProvider>(
            create: (_) => NavigationProvider()),
        ChangeNotifierProvider<InventoryProvider>(
            create: (_) => InventoryProvider()),
        ChangeNotifierProvider<ProductProvider>(
          create: (_) => ProductProvider(),
        ),
        ChangeNotifierProvider<TransactionProvider>(
          create: (_) => TransactionProvider(),
        ),
      ],
      child: MyApp(),
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
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      theme: ShadThemeData(
        brightness: Brightness.light,
        colorScheme: const ShadSlateColorScheme.light(),
      ),
      // darkTheme: ShadThemeData(
      //   colorScheme: const ShadSlateColorScheme.dark(),
      //   brightness: Brightness.dark,
      // ),
      darkTheme: ShadThemeData(
        colorScheme: darkColorScheme,
        brightness: Brightness.dark,
      ),
      themeMode: themeProvider.themeMode,
      home: SafeArea(
        child: AuthScreen(),
      ),
    );
  }
}
