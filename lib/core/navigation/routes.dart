import 'package:app/core/navigation/routes_name.dart';
import 'package:app/features/auth/presentation/pages/forgot_password_page.dart';
import 'package:app/features/auth/presentation/pages/signup_page.dart';
import 'package:app/features/news/presentation/pages/news_detail_page.dart';
import 'package:app/features/news/presentation/pages/saved_articles_page.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/intro/presentation/pages/intro_page.dart';
import '../../features/news/presentation/pages/news_page.dart';

final routes = GoRouter(
  initialLocation: AppRoutesNames.intro.path,
  routes: [
    GoRoute(
      path: AppRoutesNames.intro.path,
      name: AppRoutesNames.intro.name,
      builder: (context, state) => const IntroPage(),
      routes: [
        GoRoute(
          path: AppRoutesNames.login.path,
          name: AppRoutesNames.login.name,
          builder: (context, state) => const LoginPage(),
        ),
        GoRoute(
          path: AppRoutesNames.register.path,
          name: AppRoutesNames.register.name,
          builder: (context, state) => const SignupPage(),
        ),
        GoRoute(
          path: AppRoutesNames.forgotPassword.path,
          name: AppRoutesNames.forgotPassword.name,
          builder: (context, state) => const ForgotPasswordPage(),
        ),

        GoRoute(
          path: AppRoutesNames.news.path,
          name: AppRoutesNames.news.name,
          builder: (context, state) => const NewsPage(),
          routes: [
            GoRoute(
              path: AppRoutesNames.savedArticles.path,
              name: AppRoutesNames.savedArticles.name,
              builder: (context, state) => const SavedArticlesPage(),
            ),
            GoRoute(
              path: '${AppRoutesNames.newsDetails.path}/:id',
              name: AppRoutesNames.newsDetails.name,
              builder:
                  (context, state) =>
                      NewsDetailPage(id: state.pathParameters['id']!),
            ),
          ],
        ),
      ],
    ),
  ],
);
