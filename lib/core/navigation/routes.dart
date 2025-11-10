import 'package:app/core/navigation/routes_name.dart';
import 'package:app/core/navigation/widgets/navigation_menu.dart';
import 'package:app/features/auth/presentation/pages/forgot_password_page.dart';
import 'package:app/features/auth/presentation/pages/signup_page.dart';
import 'package:app/features/events/presentation/events.dart';
import 'package:app/features/events/presentation/events_details.dart';
import 'package:app/features/locations/presentations/pages/locations_categories_page.dart';
import 'package:app/features/locations/presentations/pages/locations_details_page.dart';
import 'package:app/features/locations/presentations/pages/search_locations_page.dart';
import 'package:app/features/locations/presentations/pages/selected_location_category_page.dart';
import 'package:app/features/news/presentation/pages/news_detail_page.dart';
import 'package:app/features/news/presentation/pages/saved_articles_page.dart';
import 'package:app/features/revista/presentation/pages/revistas_page.dart';
import 'package:app/features/revista/presentation/pages/revista_details_page.dart';
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
import '../../features/profile/presentation/pages/profile_page.dart';
import '../../features/dashboard/presentation/pages/dashboard_page.dart';
import '../../features/history/presentation/pages/history_page.dart';
import '../../features/members/presentation/pages/members_page.dart';
import '../../features/support/presentation/pages/support_page.dart';

final routes = GoRouter(
  initialLocation: AppRoutesNames.intro.path,
  restorationScopeId: 'app',
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
        // Dashboard route
        GoRoute(
          path: AppRoutesNames.dashboard.path,
          name: AppRoutesNames.dashboard.name,
          pageBuilder:
              (context, state) => NoTransitionPage(
                key: state.pageKey,
                restorationId: 'dashboard_page',
                child: const DashboardPage(),
              ),
        ),

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

        // Locations route
        GoRoute(
          path: AppRoutesNames.locations.path,
          name: AppRoutesNames.locations.name,
          pageBuilder:
              (context, state) => NoTransitionPage(
                key: state.pageKey,
                child: const LocationsCategoriesPage(),
              ),
          routes: [
            GoRoute(
              path: AppRoutesNames.searchLocations.path,
              name: AppRoutesNames.searchLocations.name,
              pageBuilder:
                  (context, state) => NoTransitionPage(
                    key: state.pageKey,
                    child: const SearchLocationsPage(),
                  ),
            ),
          ],
        ),
        GoRoute(
          path: '${AppRoutesNames.selectedLocationCategory.path}/:id',
          name: AppRoutesNames.selectedLocationCategory.name,
          pageBuilder:
              (context, state) => NoTransitionPage(
                key: state.pageKey,
                child: SelectedLocationCategoryPage(
                  categoryId: state.pathParameters['id']!,
                ),
              ),
        ),

        GoRoute(
          path: '${AppRoutesNames.locationsDetails.path}/:id',
          name: AppRoutesNames.locationsDetails.name,
          pageBuilder:
              (context, state) => NoTransitionPage(
                key: state.pageKey,
                child: LocationsDetailsPage(
                  locationId: state.pathParameters['id']!,
                ),
              ),
        ),

        // Events route
        GoRoute(
          path: AppRoutesNames.events.path,
          name: AppRoutesNames.events.name,
          pageBuilder:
              (context, state) => NoTransitionPage(
                key: state.pageKey,
                child: const EventsPage(),
              ),
          routes: [
            GoRoute(
              path: AppRoutesNames.eventDetails.path,
              name: AppRoutesNames.eventDetails.name,
              pageBuilder:
                  (context, state) => NoTransitionPage(
                    key: state.pageKey,
                    child: EventDetailPage(id: state.pathParameters['id']!),
                  ),
            ),
          ],
        ),

        // Revista route
        GoRoute(
          path: AppRoutesNames.revistas.path,
          name: AppRoutesNames.revistas.name,
          pageBuilder:
              (context, state) => NoTransitionPage(
                key: state.pageKey,
                restorationId: 'revistas_page',
                child: const RevistasPage(),
              ),
          routes: [
            GoRoute(
              path: AppRoutesNames.revistaDetails.path,
              name: AppRoutesNames.revistaDetails.name,
              pageBuilder:
                  (context, state) => NoTransitionPage(
                    key: state.pageKey,
                    restorationId: 'revista_details_page',
                    child: RevistaDetailsPage(
                      revistaId: state.pathParameters['id']!,
                    ),
                  ),
            ),
          ],
        ),

        // Profile route
        GoRoute(
          path: AppRoutesNames.profile.path,
          name: AppRoutesNames.profile.name,
          pageBuilder:
              (context, state) => NoTransitionPage(
                key: state.pageKey,
                restorationId: 'profile_page',
                child: const ProfilePage(),
              ),
        ),

        // History route
        GoRoute(
          path: AppRoutesNames.history.path,
          name: AppRoutesNames.history.name,
          pageBuilder:
              (context, state) => NoTransitionPage(
                key: state.pageKey,
                restorationId: 'history_page',
                child: const HistoryPage(),
              ),
        ),

        // Members route
        GoRoute(
          path: AppRoutesNames.members.path,
          name: AppRoutesNames.members.name,
          pageBuilder:
              (context, state) => NoTransitionPage(
                key: state.pageKey,
                restorationId: 'members_page',
                child: const MembersPage(),
              ),
        ),

        // Support route
        GoRoute(
          path: AppRoutesNames.support.path,
          name: AppRoutesNames.support.name,
          pageBuilder:
              (context, state) => NoTransitionPage(
                key: state.pageKey,
                restorationId: 'support_page',
                child: const SupportPage(),
              ),
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
              builder: (context, state) => const CheckoutPage(),
            ),
          ],
        ),
      ],
    ),
  ],
);
