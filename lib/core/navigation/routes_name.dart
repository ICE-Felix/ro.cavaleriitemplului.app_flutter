enum AppRoutesNames {
  intro(name: 'intro', path: '/'),
  //Auth
  login(name: 'login', path: 'login'),
  register(name: 'register', path: 'register'),
  forgotPassword(name: 'forgot_password', path: 'forgot_password'),
  //News
  news(name: 'news', path: '/news'),
  savedArticles(name: 'save_articles', path: 'save_articles'),
  newsDetails(name: 'news_details', path: 'news_details'),
  //Shop
  shop(name: 'shop', path: '/shop'),
  products(name: 'products', path: 'products'),
  productDetails(name: 'product_details', path: 'product_details'),
  searchProducts(name: 'search_products', path: 'search_products'),
  cart(name: 'cart', path: '/cart'),
  checkout(name: 'checkout', path: 'checkout'),
  locations(name: 'locations', path: '/locations'),
  selectedLocationCategory(
    name: 'selected_location_category',
    path: '/locations',
  ),
  locationsDetails(name: 'locations_details', path: '/location'),

  //Events
  events(name: 'events', path: '/events'),
  eventDetails(name: 'event_details', path: 'event_details/:id'),

  //Profile
  profile(name: 'profile', path: '/profile'),

  paymentWebView(name: 'payment_webview', path: 'payment_webview');

  final String name;
  final String path;

  const AppRoutesNames({required this.name, required this.path});
}
