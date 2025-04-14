import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  final String appName;
  final String tagline;
  final Color primaryColor;
  final Color secondaryColor;
  final Duration duration;
  final VoidCallback onComplete;

  const SplashScreen({
    super.key,
    required this.appName,
    required this.tagline,
    required this.primaryColor,
    required this.secondaryColor,
    required this.duration,
    required this.onComplete,
  });

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    )..forward().whenComplete(() {
        if (mounted) {
          widget.onComplete();
        }
      });

    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FadeTransition(
          opacity: _animation,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Your splash screen content here
              Text(
                widget.appName,
                style: TextStyle(
                  color: widget.primaryColor,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                widget.tagline,
                style: TextStyle(
                  color: widget.secondaryColor,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
