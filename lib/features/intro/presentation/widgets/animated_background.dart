import 'package:flutter/material.dart';

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
  late AnimationController _splashController;
  late Animation<double> _logoOpacityAnimation;
  late Animation<double> _splashOpacityAnimation;

  @override
  void initState() {
    super.initState();

    // Logo animation controller (1.5 seconds)
    _logoController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    // Splash image animation controller (1 second)
    _splashController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    // Logo opacity animation: 0 to 1, then 1 to 0
    _logoOpacityAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.0, end: 1.0)
            .chain(CurveTween(curve: Curves.easeIn)),
        weight: 50,
      ),
      TweenSequenceItem(
        tween: ConstantTween<double>(1.0),
        weight: 50,
      ),
    ]).animate(_logoController);

    // Splash image opacity animation: 0 to 1
    _splashOpacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _splashController, curve: Curves.easeInOut),
    );

    // Listen for logo animation completion to start splash animation
    _logoController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _splashController.forward();
      }
    });

    // Listen for splash animation completion, then wait before finishing
    _splashController.addStatusListener((status) {
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
    // Wait 2 seconds after splash appears
    await Future.delayed(const Duration(seconds: 2));
    widget.onAnimationComplete?.call();
  }

  @override
  void dispose() {
    _logoController.dispose();
    _splashController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([_logoController, _splashController]),
      builder: (context, child) {
        // Determine which screen to show based on animation progress
        final showSplash = _splashOpacityAnimation.value > 0;

        return Container(
          width: double.infinity,
          height: double.infinity,
          color: Colors.white,
          child: Stack(
            children: [
              // Logo screen (fades in then out)
              if (!showSplash)
                Center(
                  child: Opacity(
                    opacity: _logoOpacityAnimation.value,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32),
                      child: Image.asset(
                        'assets/images/logo/logo.png',
                        width: double.infinity,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
              // Splash screen (full screen image with loading indicator)
              if (showSplash)
                Opacity(
                  opacity: _splashOpacityAnimation.value,
                  child: Stack(
                    children: [
                      // Full screen splash image
                      Positioned.fill(
                        child: Image.asset(
                          'assets/images/logo/splash.jpeg',
                          fit: BoxFit.contain,
                        ),
                      ),
                      // Loading indicator and text at bottom
                      Positioned(
                        bottom: 60,
                        left: 0,
                        right: 0,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const SizedBox(
                              width: 40,
                              height: 40,
                              child: CircularProgressIndicator(
                                strokeWidth: 4,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Color(0xFF8B0000), // Dark red from app colors
                                ),
                                backgroundColor: Color(0xFFE2DED3),
                              ),
                            ),
                            const SizedBox(height: 20),
                            Text(
                              'Se încarcă...',
                              style: TextStyle(
                                color: const Color(0xFF8B0000), // Dark red
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.5,
                                shadows: [
                                  Shadow(
                                    offset: const Offset(0, 1),
                                    blurRadius: 2,
                                    color: Colors.white.withValues(alpha: 0.8),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
