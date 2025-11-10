import 'package:app/core/navigation/routes.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'core/service_locator.dart';
import 'core/style/app_theme.dart';
import 'core/localization/app_localization.dart';
import 'core/cubit/location_cubit.dart';
import 'features/auth/presentation/bloc/authentication_bloc.dart';
import 'features/intro/presentation/bloc/intro_bloc.dart';
import 'features/news/presentation/bloc/news_bloc.dart';
import 'firebase_options.dart';
import '../core/services/firebase_messaging_service.dart';
import 'features/notifications/presentation/bloc/notification_bloc.dart';

// Background message handler - must be a top-level function
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // Initialize Firebase if not already initialized
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  debugPrint('Handling background message: ${message.messageId}');
  debugPrint('Title: ${message.notification?.title}');
  debugPrint('Body: ${message.notification?.body}');
  debugPrint('Data: ${message.data}');
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Register background message handler
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // Load environment variables
  await dotenv.load(fileName: ".env");
  // Initialize dependency injection
  await initServiceLocator();

  try {
    debugPrint('🔥 Starting Firebase Messaging Service initialization...');
    await sl<FirebaseMessagingService>().initialize();
    debugPrint('✅ Firebase Messaging Service initialization completed');
  } catch (e, stackTrace) {
    debugPrint('❌ Error initializing Firebase Messaging Service: $e');
    debugPrint('Stack trace: $stackTrace');
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => sl<AuthenticationBloc>()),
        BlocProvider(create: (context) => sl<IntroBloc>()),
        BlocProvider(create: (context) => sl<NewsBloc>()),
        BlocProvider(create: (context) => sl<NotificationBloc>()),
        BlocProvider(create: (context) => sl<LocationCubit>(), lazy: false),
        BlocProvider(
          create:
              (context) => sl<LocalizationCubit>()..initializeLocalization(),
          lazy: false,
        ),
      ],
      child: LocalizationProvider(
        child: MaterialApp.router(
          title: 'R.L. 126 C.T.',
          theme: AppTheme.lightTheme,
          themeMode: ThemeMode.light,
          routerConfig: routes,
        ),
      ),
    );
  }
}
