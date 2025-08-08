import 'package:app/core/navigation/routes_name.dart';
import 'package:app/core/navigation/widgets/navigation_menu.dart';
import 'package:app/features/auth/presentation/pages/forgot_password_page.dart';
import 'package:app/features/auth/presentation/pages/signup_page.dart';
import 'package:app/features/news/presentation/pages/news_detail_page.dart';
import 'package:app/features/news/presentation/pages/saved_articles_page.dart';
import 'package:app/features/shop/domain/entities/product_category_entity.dart';
import 'package:app/features/shop/domain/entities/product_entity.dart';
import 'package:app/features/shop/presentation/pages/categories_page.dart';
import 'package:app/features/shop/presentation/pages/products_page.dart';
import 'package:app/features/shop/presentation/pages/product_detail_page.dart';
import 'package:app/features/shop/presentation/pages/search_products_page.dart';
import 'package:app/features/cart/presentation/pages/cart_page.dart';
import 'package:app/features/checkout/presentation/pages/checkout_page.dart';
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
      ],
    ),

    ShellRoute(
      pageBuilder: (context, state, child) {
        return NoTransitionPage(
          child: NavigationMenu(
            currentLocation: state.fullPath ?? state.matchedLocation,
            parentContext: context,
            child: child,
          ),
        );
      },
      routes: [
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
        GoRoute(
          path: AppRoutesNames.shop.path,
          name: AppRoutesNames.shop.name,
          builder: (context, state) => const CategoriesPage(),
          routes: [
            GoRoute(
              path: AppRoutesNames.products.path,
              name: AppRoutesNames.products.name,
              builder:
                  (context, state) => ProductsPage(
                    category: state.extra as ProductCategoryEntity,
                  ),
            ),
            GoRoute(
              path: AppRoutesNames.productDetails.path,
              name: AppRoutesNames.productDetails.name,
              builder:
                  (context, state) =>
                      ProductDetailPage(product: state.extra as ProductEntity),
            ),
            GoRoute(
              path: AppRoutesNames.searchProducts.path,
              name: AppRoutesNames.searchProducts.name,
              builder: (context, state) => const SearchProductsPage(),
            ),
            GoRoute(
              path: AppRoutesNames.cart.path,
              name: AppRoutesNames.cart.name,
              builder: (context, state) => const CartPage(),
            ),
            GoRoute(
              path: AppRoutesNames.checkout.path,
              name: AppRoutesNames.checkout.name,
              builder: (context, state) => const CheckoutPage(),
            ),
          ],
        ),
      ],
    ),
  ],
);
