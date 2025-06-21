import 'package:flutter/material.dart';
import '../../../../core/style/app_colors.dart';

class AnimatedBackground extends StatefulWidget {
  final bool isNetworkConnected;
  final VoidCallback? onAnimationComplete;

  const AnimatedBackground({
    super.key,
    required this.isNetworkConnected,
    this.onAnimationComplete,
  });

  @override
  State<AnimatedBackground> createState() => _AnimatedBackgroundState();
}

class _AnimatedBackgroundState extends State<AnimatedBackground>
    with TickerProviderStateMixin {
  late AnimationController _logoController;
  late AnimationController _backgroundController;
  late Animation<double> _logoOpacityAnimation;
  late Animation<Color?> _backgroundAnimation;

  @override
  void initState() {
    super.initState();

    // Logo animation controller (1.5 seconds)
    _logoController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    // Background animation controller (2 seconds)
    _backgroundController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    // Logo opacity animation: 0 to 1
    _logoOpacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.easeInOut),
    );

    // Background color animation: Light Background to Dark Purple
    _backgroundAnimation = ColorTween(
      begin: AppColors.lightBackground,
      end: AppColors.darkBackground,
    ).animate(
      CurvedAnimation(parent: _backgroundController, curve: Curves.easeInOut),
    );

    // Listen for logo animation completion to start background animation
    _logoController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _backgroundController.forward();
      }
    });

    // Listen for background animation completion, then wait before finishing
    _backgroundController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _waitThenComplete();
      }
    });

    // Start sequence if network is connected
    if (widget.isNetworkConnected) {
      _startAnimationSequence();
    }
  }

  void _startAnimationSequence() async {
    // Small delay, then start logo fade-in
    await Future.delayed(const Duration(milliseconds: 500));
    _logoController.forward();
  }

  void _waitThenComplete() async {
    // Wait 2 seconds after background fade completes
    await Future.delayed(const Duration(seconds: 2));
    widget.onAnimationComplete?.call();
  }

  @override
  void dispose() {
    _logoController.dispose();
    _backgroundController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([_logoController, _backgroundController]),
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            color: _backgroundAnimation.value ?? AppColors.lightBackground,
          ),
          child: Positioned(
            left: 0,
            right: 0,
            top: MediaQuery.of(context).size.height * 0.15,
            child: Opacity(
              opacity: _logoOpacityAnimation.value,
              child: Center(child: _buildLogo()),
            ),
          ),
        );
      },
    );
  }

  Widget _buildLogo() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Image.asset(
        'assets/images/logo/logo.png',
        width: 450,
        height: 200,
        fit: BoxFit.contain,
      ),
    );
  }
}
