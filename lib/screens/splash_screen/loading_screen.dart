import 'package:flutter/material.dart';
import 'dart:math' as math;

class LoadingScreen extends StatefulWidget {
  final String message;
  final Color primaryColor;
  final Color secondaryColor;
  final bool showPercentage;
  final double progress;

  const LoadingScreen({
    Key? key,
    this.message = "Loading your data...",
    this.primaryColor = const Color(0xFF4F46E5), // Indigo
    this.secondaryColor = const Color(0xFF10B981), // Emerald
    this.showPercentage = false,
    this.progress = 0.0,
  }) : super(key: key);

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> with TickerProviderStateMixin {
  late AnimationController _rotationController;
  late AnimationController _bounceController;
  late Animation<double> _bounceAnimation;
  late List<Animation<double>> _delayedBounceAnimations;

  @override
  void initState() {
    super.initState();
    // For rotating elements
    _rotationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();

    // For bouncing elements
    _bounceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    _bounceAnimation = Tween<double>(begin: 0, end: 10).animate(
      CurvedAnimation(
        parent: _bounceController,
        curve: Curves.easeInOut,
      ),
    );

    // Create delayed animations for staggered bouncing
    _delayedBounceAnimations = List.generate(
      3,
      (index) => Tween<double>(begin: 0, end: 10).animate(
        CurvedAnimation(
          parent: _bounceController,
          curve: Interval(
            0.2 * index,
            0.2 * index + 0.6,
            curve: Curves.easeInOut,
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _rotationController.dispose();
    _bounceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.white,
              widget.primaryColor.withOpacity(0.1),
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(flex: 2),
                // Animated loading graphic
                _buildLoadingAnimation(),
                const SizedBox(height: 40),
                // Loading message
                Text(
                  widget.message,
                  style: TextStyle(
                    color: widget.primaryColor,
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                // Progress indicator
                if (widget.showPercentage) ...[
                  _buildProgressBar(),
                  const SizedBox(height: 10),
                  Text(
                    "${(widget.progress * 100).toInt()}%",
                    style: TextStyle(
                      color: widget.primaryColor,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
                const Spacer(flex: 3),
                // Tip at bottom
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                  child: Text(
                    "Your data is being prepared. This might take a moment.",
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingAnimation() {
    return SizedBox(
      height: 120,
      width: 120,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Rotating ring
          AnimatedBuilder(
            animation: _rotationController,
            builder: (context, child) {
              return Transform.rotate(
                angle: _rotationController.value * 2 * math.pi,
                child: Container(
                  height: 100,
                  width: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: widget.secondaryColor.withOpacity(0.5),
                      width: 6,
                      strokeAlign: BorderSide.strokeAlignOutside,
                    ),
                    color: Colors.transparent,
                  ),
                ),
              );
            },
          ),
          // Rotating progress arc
          AnimatedBuilder(
            animation: _rotationController,
            builder: (context, child) {
              return Transform.rotate(
                angle: _rotationController.value * 2 * math.pi * -1,
                child: SizedBox(
                  height: 100,
                  width: 100,
                  child: CustomPaint(
                    painter: ArcPainter(
                      color: widget.primaryColor,
                      startAngle: 0,
                      sweepAngle: 120 * (math.pi / 180),
                      strokeWidth: 6,
                    ),
                  ),
                ),
              );
            },
          ),
          // Bouncing elements
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              3,
              (index) => AnimatedBuilder(
                animation: _bounceController,
                builder: (context, child) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Transform.translate(
                      offset: Offset(0, -_delayedBounceAnimations[index].value),
                      child: Container(
                        height: 12,
                        width: 12,
                        decoration: BoxDecoration(
                          color: widget.secondaryColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Container(
        height: 8,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.grey.withOpacity(0.2),
          borderRadius: BorderRadius.circular(4),
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Row(
              children: [
                Container(
                  height: 8,
                  width: constraints.maxWidth * widget.progress,
                  decoration: BoxDecoration(
                    color: widget.secondaryColor,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

// Custom painter for drawing arc
class ArcPainter extends CustomPainter {
  final Color color;
  final double startAngle;
  final double sweepAngle;
  final double strokeWidth;

  ArcPainter({
    required this.color,
    required this.startAngle,
    required this.sweepAngle,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromCircle(
      center: Offset(size.width / 2, size.height / 2),
      radius: size.width / 2,
    );

    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(rect, startAngle, sweepAngle, false, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}