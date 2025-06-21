import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../auth/presentation/pages/login_page.dart';
import '../bloc/intro_bloc.dart';
import '../widgets/animated_background.dart';
import '../widgets/network_error_widget.dart';

class IntroPage extends StatelessWidget {
  const IntroPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Start the intro process when this page loads
    context.read<IntroBloc>().add(IntroStarted());
    return const IntroView();
  }
}

class IntroView extends StatelessWidget {
  const IntroView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<IntroBloc, IntroState>(
        listener: (context, state) {
          if (state is IntroNavigateToAuth) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => const LoginPage()),
            );
          }
        },
        builder: (context, state) {
          return AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: _buildContent(context, state),
          );
        },
      ),
    );
  }

  Widget _buildContent(BuildContext context, IntroState state) {
    return switch (state) {
      IntroLoading _ => const Center(child: CircularProgressIndicator()),

      IntroAnimating animatingState => AnimatedBackground(
        key: const ValueKey('animating'),
        isNetworkConnected: animatingState.isNetworkConnected,
        onAnimationComplete: () {
          context.read<IntroBloc>().add(IntroAnimationCompleted());
        },
      ),

      IntroNetworkError errorState => NetworkErrorWidget(
        key: const ValueKey('error'),
        message: errorState.message,
        onRetry: () {
          context.read<IntroBloc>().add(IntroNetworkCheckRequested());
        },
      ),

      _ => const Center(child: CircularProgressIndicator()),
    };
  }
}
