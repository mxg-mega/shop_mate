import "package:flutter/material.dart";
import 'package:provider/provider.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:shop_mate/core/themes/provider/theme_provider.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController? emailController;
    TextEditingController? pwController;

    var themeProv = Provider.of<ThemeProvider>(context);

    return Scaffold(
      backgroundColor: ShadTheme.of(context).colorScheme.background,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              Icons.shop_2_outlined,
              size: 80,
              color: ShadTheme.of(context).colorScheme.primary,
            ),
            Container(
                child: OutlinedButton(
                    onPressed: () {
                      themeProv.toggleTheme();
                    },
                    child: Icon(
                      Icons.toggle_on,
                      size: 20,
                    ))),
            const SizedBox(height: 18),
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 320),
              child: ShadInput(
                placeholder: const Text('Email'),
                keyboardType: TextInputType.emailAddress,
                decoration: ShadDecoration(shadows: ShadShadows.md, color: themeProv.themeMode == ThemeMode.dark ? Colors.white30 : null),
                controller: emailController,
                obscuringCharacter: "*",
              ),
            ),
            const SizedBox(height: 2),
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 320),
              child: ShadInput(
                placeholder: const Text('Password'),
                keyboardType: TextInputType.visiblePassword,
                decoration: ShadDecoration(shadows: ShadShadows.md, color: themeProv.themeMode == ThemeMode.dark ? Colors.white30 : null),
                controller: pwController,
                obscureText: true,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
