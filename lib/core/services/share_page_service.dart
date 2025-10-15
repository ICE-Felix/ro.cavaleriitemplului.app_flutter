import 'package:go_router/go_router.dart';

class SharePageService {
  final String appUrlSchema = 'mommyhai';
  final GoRouter _router;

  SharePageService(this._router);

  /// Get the current page deep link
  String getCurrentPageUrl() {
    final currentLocation =
        _router.routerDelegate.currentConfiguration.uri.toString();
    return _buildDeepLink(currentLocation);
  }

  String getUrlForNamedRoute({
    required String routeName,
    Map<String, String> pathParameters = const {},
    Map<String, dynamic> queryParameters = const {},
  }) {
    var namedLocationPath = _router.namedLocation(
      routeName,
      pathParameters: pathParameters,
      queryParameters: queryParameters,
    );

    return _buildDeepLink(namedLocationPath);
  }

  /// Build the deep link URL
  String _buildDeepLink(String path) {
    // Remove leading slash if present to avoid double slashes
    final cleanPath = path.startsWith('/') ? path.substring(1) : path;
    return '$appUrlSchema://$cleanPath';
  }
}
