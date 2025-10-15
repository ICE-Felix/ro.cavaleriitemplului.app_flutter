import 'package:app/core/navigation/routes_name.dart';
import 'package:app/core/service_locator.dart';
import 'package:app/features/cart/presentation/cubit/cart_cubit.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PaymentWebView extends StatefulWidget {
  final String url;

  const PaymentWebView({super.key, required this.url});

  @override
  State<PaymentWebView> createState() => _PaymentWebViewState();
}

class _PaymentWebViewState extends State<PaymentWebView> {
  late final WebViewController _controller;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _controller =
        WebViewController()
          ..setJavaScriptMode(JavaScriptMode.unrestricted)
          ..setNavigationDelegate(
            NavigationDelegate(
              onProgress: (int progress) {
                // Update loading bar based on WebView loading progress
              },
              onPageStarted: (String url) {
                setState(() {
                  _isLoading = true;
                });
                _checkOrderStatus(url);
              },
              onPageFinished: (String url) {
                _checkOrderStatus(url);
                setState(() {
                  _isLoading = false;
                });
              },
              onWebResourceError: (WebResourceError error) {
                // Handle web resource errors
              },
            ),
          )
          ..loadRequest(Uri.parse(widget.url));
  }

  void _checkOrderStatus(String url) {
    final uri = Uri.parse(url);
    if (uri.pathSegments.contains('order-received')) {
      // Check if the order is cash on delivery and netopia
      if (uri.queryParameters['key'] != null &&
          uri.queryParameters['pay_for_order'] == null) {
        sl<CartCubit>().clearCart();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Order placed successfully!'),
            backgroundColor: Colors.green,
          ),
        );
        context.goNamed(AppRoutesNames.news.name);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.goNamed(AppRoutesNames.checkout.name),
        ),
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: _controller),
          if (_isLoading) const Center(child: CircularProgressIndicator()),
        ],
      ),
    );
  }
}
