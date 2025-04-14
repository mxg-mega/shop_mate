import "package:flutter/material.dart";
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:shop_mate/core/utils/helpers.dart';
import 'package:shop_mate/features/responsive_design/layouts/responsive_layout.dart';
import 'package:shop_mate/providers/authentication_provider.dart';
import 'package:shop_mate/providers/theme_provider.dart';
import 'package:shop_mate/screens/login/sign_in_screen.dart';
import 'package:shop_mate/screens/login/sign_up_screen.dart';
import 'package:shop_mate/screens/login/utils/login_controller.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _controller = LoginController();
  final _pageController = PageController();

  void _toggleForm() {
    context.read<AuthenticationProvider>().signInToggle();
    _pageController.animateToPage(
      context.read<AuthenticationProvider>().showSignIn ? 0 : 1,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _pageController.dispose();
    super.dispose();
  }

  Widget _loginForms() {
    return PageView(
      controller: _pageController,
      children: [
        SignInPage(
          controller: _controller,
          onSwitch: () => _pageController.nextPage(
            curve: Curves.easeInOut,
            duration: Duration(milliseconds: 300),
          ),
        ),
        SignUpPage(
          controller: _controller,
          onSwitch: () => _pageController.previousPage(
            curve: Curves.easeInOut,
            duration: Duration(milliseconds: 300),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      mobile: Scaffold(body: _loginForms()),
      desktop: Scaffold(
        body: Row(
          children: [
            Expanded(
              flex: 3,
              child: Center(
                child: Icon(
                  LucideIcons.shoppingBag,
                  size: width(context, 0.1),
                ),
              ),
            ),
            ShadSeparator.vertical(),
            Expanded(
              flex: 2,
              child: _loginForms(),
            ),
          ],
        ),
      ),
    );
    // return ResponsiveLayout(
    //   desktop: Row(
    //     children: [
    //       Expanded(
    //         flex: 3,
    //         child: Center(
    //           child: Icon(
    //             Icons.shopping_bag_outlined,
    //             size: 64.w,
    //           ),
    //         ),
    //       ),
    //       Divider(
    //         thickness: 100,
    //         height: MediaQuery.of(context).size.height * 0.3,
    //       ),
    //       Expanded(
    //         flex: 2,
    //         child: Center(
    //           child: SingleChildScrollView(
    //             child: ShadCard(
    //               padding: EdgeInsets.all(24.w),
    //               child: Column(
    //                 mainAxisSize: MainAxisSize.min,
    //                 children: [
    //                   AnimatedSwitcher(
    //                     duration: const Duration(milliseconds: 300),
    //                     child: _showSignIn
    //                         ? const SignInScreen()
    //                         : const SignUpScreen(),
    //                   ),
    //                   SizedBox(height: 24.h),
    //                   _buildToggleButton(context),
    //                   authProv.isLoading
    //                       ? SizedBox(
    //                           width: 70.w,
    //                           child: const ShadProgress(
    //                             minHeight: 4,
    //                           ),
    //                         )
    //                       : const SizedBox(),
    //                 ],
    //               ),
    //             ),
    //           ),
    //         ),
    //       ),
    //     ],
    //   ),
    //   mobile: Scaffold(
    //     body: SingleChildScrollView(
    //       padding: EdgeInsets.symmetric(vertical: 40.h, horizontal: 24.w),
    //       child: Center(
    //         child: ConstrainedBox(
    //           constraints: BoxConstraints(
    //             maxWidth: 500.w,
    //           ),
    //           child: ShadCard(
    //             padding: EdgeInsets.all(24.w),
    //             child: Column(
    //               mainAxisSize: MainAxisSize.min,
    //               children: [
    //                 Icon(
    //                     // Icons.shopping_bag_outlined,
    //                     Icons.storefront,
    //                     size: 64.w,
    //                     color: ShadTheme.of(context).colorScheme.primary),
    //                 SizedBox(height: 32.h),
    //                 AnimatedSwitcher(
    //                   duration: const Duration(milliseconds: 300),
    //                   child: _showSignIn
    //                       ? const SignInScreen()
    //                       : const SignUpScreen(),
    //                 ),
    //                 SizedBox(height: 24.h),
    //                 _buildToggleButton(context),
    //                 // TextButton(
    //                 //   onPressed: () {
    //                 //     context.read<AuthenticationProvider>().signInToggle();
    //                 //   },
    //                 //   child: authProv.showSignIn
    //                 //       ? Row(
    //                 //           mainAxisAlignment: MainAxisAlignment.center,
    //                 //           mainAxisSize: MainAxisSize.min,
    //                 //           children: [
    //                 //             const Text("Don't have an account? "),
    //                 //             Text(
    //                 //               "Sign Up",
    //                 //               style: TextStyle(
    //                 //                   color: themeProv.isDarkTheme
    //                 //                       ? Colors.amber
    //                 //                       : Colors.blue),
    //                 //             )
    //                 //           ],
    //                 //         )
    //                 //       : Row(
    //                 //           mainAxisAlignment: MainAxisAlignment.center,
    //                 //           mainAxisSize: MainAxisSize.min,
    //                 //           children: [
    //                 //             const Text("Already have an account? "),
    //                 //             Text(
    //                 //               "Sign In",
    //                 //               style: TextStyle(
    //                 //                   color: themeProv.isDarkTheme
    //                 //                       ? Colors.amber
    //                 //                       : Colors.blue),
    //                 //             )
    //                 //           ],
    //                 //         ),
    //                 // ),
    //                 authProv.isLoading
    //                     ? SizedBox(
    //                         width: 70.w,
    //                         child: const ShadProgress(
    //                           minHeight: 4,
    //                         ),
    //                       )
    //                     : const SizedBox(),
    //               ],
    //             ),
    //           ),
    //         ),
    //       ),
    //     ),
    //   ),
    // );
  }

  Widget _buildToggleButton(BuildContext context) {
    final authProv = context.watch<AuthenticationProvider>();
    return TextButton(
      onPressed: _toggleForm,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            authProv.showSignIn
                ? "Don't have an account? "
                : "Already have an account? ",
            style: ShadTheme.of(context).textTheme.small,
          ),
          Text(
            authProv.showSignIn ? "Sign Up" : "Sign In",
            style: TextStyle(
              color: ShadTheme.of(context).colorScheme.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
