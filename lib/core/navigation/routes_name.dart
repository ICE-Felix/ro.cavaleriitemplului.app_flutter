enum AppRoutesNames {
  intro(name: 'intro', path: '/'),
  //Auth
  login(name: 'login', path: 'login'),
  register(name: 'register', path: 'register'),
  forgotPassword(name: 'forgot_password', path: 'forgot_password'),
  //News
  news(name: 'news', path: 'news'),
  savedArticles(name: 'save_articles', path: 'save_articles'),
  newsDetails(name: 'news_details', path: 'news_details');

  final String name;
  final String path;

  const AppRoutesNames({required this.name, required this.path});
}
