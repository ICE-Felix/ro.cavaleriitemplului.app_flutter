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
import 'package:app/features/checkout/presentation/pages/payment_webview.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/intro/presentation/pages/intro_page.dart';
import '../../features/news/presentation/pages/news_page.dart';

final routes = GoRouter(
  initialLocation: AppRoutesNames.intro.path,
  restorationScopeId: 'app',
  redirect: (context, state) {
    // If we're at the root and not authenticated, stay at intro
    if (state.matchedLocation == AppRoutesNames.intro.path) {
      return null;
    }

    // If we're navigating to main sections, ensure proper routing
    if (state.matchedLocation == '/') {
      return AppRoutesNames.news.path;
    }

    return null;
  },
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
          path: '${AppRoutesNames.paymentWebView.path}/:url',
          name: AppRoutesNames.paymentWebView.name,
          builder:
              (context, state) => PaymentWebView(
                url: Uri.decodeComponent(state.pathParameters['url']!),
              ),
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
        // News route
        GoRoute(
          path: AppRoutesNames.news.path,
          name: AppRoutesNames.news.name,
          pageBuilder:
              (context, state) => NoTransitionPage(
                key: state.pageKey,
                restorationId: 'news_page',
                child: const NewsPage(),
              ),
          routes: [
            GoRoute(
              path: AppRoutesNames.savedArticles.path,
              name: AppRoutesNames.savedArticles.name,
              pageBuilder:
                  (context, state) => NoTransitionPage(
                    key: state.pageKey,
                    restorationId: 'news_page',
                    child: const SavedArticlesPage(),
                  ),
            ),
            GoRoute(
              path: '${AppRoutesNames.newsDetails.path}/:id',
              name: AppRoutesNames.newsDetails.name,
              pageBuilder:
                  (context, state) => NoTransitionPage(
                    key: state.pageKey,
                    restorationId: 'news_page',
                    child: NewsDetailPage(id: state.pathParameters['id']!),
                  ),
            ),
          ],
        ),

        // Shop route
        GoRoute(
          path: AppRoutesNames.shop.path,
          name: AppRoutesNames.shop.name,
          pageBuilder:
              (context, state) => NoTransitionPage(
                key: state.pageKey,
                restorationId: 'shop_page',
                child: const CategoriesPage(),
              ),
          routes: [
            GoRoute(
              path: AppRoutesNames.products.path,
              name: AppRoutesNames.products.name,
              pageBuilder:
                  (context, state) => NoTransitionPage(
                    key: state.pageKey,
                    restorationId: 'shop_page',
                    child: ProductsPage(
                      category: state.extra as ProductCategoryEntity,
                    ),
                  ),
            ),
            GoRoute(
              path: AppRoutesNames.productDetails.path,
              name: AppRoutesNames.productDetails.name,
              pageBuilder:
                  (context, state) => NoTransitionPage(
                    key: state.pageKey,
                    restorationId: 'shop_page',
                    child: ProductDetailPage(
                      product: state.extra as ProductEntity,
                    ),
                  ),
            ),
            GoRoute(
              path: AppRoutesNames.searchProducts.path,
              name: AppRoutesNames.searchProducts.name,
              pageBuilder:
                  (context, state) => NoTransitionPage(
                    key: state.pageKey,
                    restorationId: 'shop_page',
                    child: const SearchProductsPage(),
                  ),
            ),
          ],
        ),

        // Cart route
        GoRoute(
          path: AppRoutesNames.cart.path,
          name: AppRoutesNames.cart.name,
          pageBuilder:
              (context, state) => NoTransitionPage(
                key: state.pageKey,
                restorationId: 'cart_page',
                child: const CartPage(),
              ),
          routes: [
            GoRoute(
              path: AppRoutesNames.checkout.path,
              name: AppRoutesNames.checkout.name,
              pageBuilder:
                  (context, state) => NoTransitionPage(
                    key: state.pageKey,
                    restorationId: 'cart_page',
                    child: const CheckoutPage(),
                  ),
            ),
          ],
        ),
      ],
    ),
  ],
);
