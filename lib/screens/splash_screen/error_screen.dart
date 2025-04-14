import 'package:flutter/material.dart';
import 'dart:math' as math;

class ErrorScreen extends StatefulWidget {
  final String message;
  final String title;
  final VoidCallback? onRetry;
  final VoidCallback? onHelp;
  final VoidCallback? onBack;
  final Color primaryColor;
  final Color secondaryColor;

  const ErrorScreen({
    super.key,
    required this.message,
    this.title = "Oops! Something went wrong",
    this.onRetry,
    this.onHelp,
    this.onBack,
    this.primaryColor = const Color(0xFF4F46E5), // Indigo
    this.secondaryColor = const Color(0xFFF43F5E), // Rose
  });

  @override
  State<ErrorScreen> createState() => _ErrorScreenState();
}

class _ErrorScreenState extends State<ErrorScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _shakeAnimation;
  late Animation<double> _bounceAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    // Animation for shaking the error icon
    _shakeAnimation = Tween<double>(begin: -1.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.4, curve: Curves.easeInOut),
      ),
    );

    // Animation for bouncing the error icon
    _bounceAnimation = Tween<double>(begin: 0.0, end: 15.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.5, 0.7, curve: Curves.easeInOut),
      ),
    );

    // Animation for fading in the content
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.3, 0.6, curve: Curves.easeIn),
      ),
    );

    _controller.forward();
    // Make the animation repeat but with a pause between repetitions
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Future.delayed(const Duration(seconds: 2), () {
          if (mounted) {
            _controller.reset();
            _controller.forward();
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.white,
              widget.secondaryColor.withOpacity(0.05),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Back button if provided
              if (widget.onBack != null)
                Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: widget.onBack,
                      color: widget.primaryColor,
                    ),
                  ),
                ),
              
              const Spacer(),
              
              // Error icon with animations
              AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return Transform.translate(
                    offset: Offset(_shakeAnimation.value * 10, -_bounceAnimation.value),
                    child: _buildErrorIcon(),
                  );
                },
              ),
              
              const SizedBox(height: 40),
              
              // Error title
              AnimatedBuilder(
                animation: _fadeAnimation,
                builder: (context, child) {
                  return Opacity(
                    opacity: _fadeAnimation.value,
                    child: Text(
                      widget.title,
                      style: TextStyle(
                        color: widget.secondaryColor,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  );
                },
              ),
              
              const SizedBox(height: 20),
              
              // Error message
              AnimatedBuilder(
                animation: _fadeAnimation,
                builder: (context, child) {
                  return Opacity(
                    opacity: _fadeAnimation.value,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32.0),
                      child: Text(
                        widget.message,
                        style: TextStyle(
                          color: Colors.grey[700],
                          fontSize: 16,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                },
              ),
              
              const SizedBox(height: 40),
              
              // Action buttons
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32.0),
                child: Column(
                  children: [
                    // Retry button if provided
                    if (widget.onRetry != null)
                      _buildButton(
                        label: "Try Again",
                        icon: Icons.refresh,
                        isPrimary: true,
                        onPressed: widget.onRetry!,
                      ),
                    
                    const SizedBox(height: 16),
                    
                    // Help button if provided
                    if (widget.onHelp != null)
                      _buildButton(
                        label: "Get Help",
                        icon: Icons.help_outline,
                        isPrimary: false,
                        onPressed: widget.onHelp!,
                      ),
                  ],
                ),
              ),
              
              const Spacer(flex: 2),
              
              // Error code
              Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: Text(
                  "Error Code: ${_generateErrorCode()}",
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildErrorIcon() {
    return Container(
      height: 120,
      width: 120,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: widget.secondaryColor.withOpacity(0.2),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Background circle
            Container(
              height: 80,
              width: 80,
              decoration: BoxDecoration(
                color: widget.secondaryColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
            ),
            // Exclamation mark
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 30,
                  width: 8,
                  decoration: BoxDecoration(
                    color: widget.secondaryColor,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  height: 8,
                  width: 8,
                  decoration: BoxDecoration(
                    color: widget.secondaryColor,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildButton({
    required String label,
    required IconData icon,
    required bool isPrimary,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: isPrimary ? widget.primaryColor : Colors.white,
          foregroundColor: isPrimary ? Colors.white : widget.primaryColor,
          elevation: isPrimary ? 3 : 1,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: isPrimary 
                ? BorderSide.none 
                : BorderSide(color: widget.primaryColor.withOpacity(0.5)),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 20),
            const SizedBox(width: 10),
            Text(
              label,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Generate a random error code for reference
  String _generateErrorCode() {
    final random = math.Random();
    final alphabet = 'ABCDEFGHJKLMNPQRSTUVWXYZ';
    final errorCode = '${alphabet[random.nextInt(alphabet.length)]}'
        '${alphabet[random.nextInt(alphabet.length)]}'
        '-${random.nextInt(9000) + 1000}';
    return errorCode;
  }
}