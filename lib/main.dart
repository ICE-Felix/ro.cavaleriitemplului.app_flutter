import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'app_initializer.dart';
import 'core/service_locator.dart';
import 'core/style/app_theme.dart';
import 'core/localization/app_localization.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/intro/presentation/bloc/intro_bloc.dart';
import 'features/news/presentation/bloc/news_bloc.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Load environment variables
  await dotenv.load(fileName: ".env");
  // Initialize dependency injection
  await initServiceLocator();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => sl<AuthBloc>()),
        BlocProvider(create: (context) => sl<IntroBloc>()),
        BlocProvider(create: (context) => sl<NewsBloc>()),
        BlocProvider(
          create:
              (context) => sl<LocalizationCubit>()..initializeLocalization(),
        ),
      ],
      child: LocalizationProvider(
        child: MaterialApp(
          title: 'Mommy HAI',
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: ThemeMode.system,
          home: const AppInitializer(),
        ),
      ),
    );
  }
}
