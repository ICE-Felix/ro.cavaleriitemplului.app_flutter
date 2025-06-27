import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../core/widgets/custom_top_bar.dart';
import '../../../../core/style/app_colors.dart';
import '../../../../core/style/app_text_styles.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../bloc/news_bloc.dart';
import '../widgets/news_item_widget.dart';
import 'news_detail_page.dart';
import 'saved_articles_page.dart';

class NewsPage extends StatefulWidget {
  const NewsPage({super.key});

  @override
  State<NewsPage> createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  String? _selectedCategory;

  // Define the categories as shown in the image
  final List<String> _predefinedCategories = ['General', 'Oferte Speciale'];

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);

    // Load initial data
    context.read<NewsBloc>().add(LoadNewsRequested());
    context.read<NewsBloc>().add(LoadCategoriesRequested());
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      final state = context.read<NewsBloc>().state;
      if (state is NewsLoaded && state.hasMore) {
        context.read<NewsBloc>().add(LoadMoreNewsRequested());
      }
    }
  }

  void _onSearchChanged(String query) {
    if (query.isEmpty) {
      context.read<NewsBloc>().add(
        LoadNewsRequested(category: _selectedCategory, refresh: true),
      );
    } else {
      context.read<NewsBloc>().add(SearchNewsRequested(query: query));
    }
  }

  void _onCategorySelected(String? category) {
    setState(() {
      _selectedCategory = category;
    });
    _searchController.clear();
    context.read<NewsBloc>().add(
      LoadNewsRequested(category: category, refresh: true),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthUnauthenticated) {
          // Navigate back to intro page when user logs out
          Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
        }
      },
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        appBar: CustomTopBar(
          showSearchBar: true,
          showProfileButton: true,
          showNotificationButton: true,
          showLogo: true,
          logoHeight: 90,
          logoWidth: 140,
          logoPadding: const EdgeInsets.only(
            left: 20.0,
            top: 10.0,
            bottom: 10.0,
          ),
          notificationCount: 0,
          searchController: _searchController,
          onSearchChanged: _onSearchChanged,
          onProfileTap: () {
            // Handle profile tap - show logout dialog
            _showLogoutDialog(context);
          },
          onNotificationTap: () {
            // Handle notification tap
          },
          onLogoTap: () {
            print('Logo tapped!');
          },
          customActions: [
            // Saved articles button
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: IconButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const SavedArticlesPage(),
                    ),
                  );
                },
                icon: const FaIcon(FontAwesomeIcons.solidBookmark, size: 20),
                tooltip: 'Articole salvate',
              ),
            ),
          ],
        ),
        body: Column(
          children: [
            // Categories section
            Container(
              height: 56,
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: _predefinedCategories.length + 1,
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return _buildCategoryChip(
                      context,
                      'All',
                      _selectedCategory == null,
                    );
                  }
                  final category = _predefinedCategories[index - 1];
                  return _buildCategoryChip(
                    context,
                    category,
                    _selectedCategory == category,
                  );
                },
              ),
            ),

            // News content
            Expanded(
              child: BlocBuilder<NewsBloc, NewsState>(
                builder: (context, state) {
                  if (state is NewsLoading) {
                    return Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primary,
                      ),
                    );
                  }

                  if (state is NewsError) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          FaIcon(
                            FontAwesomeIcons.exclamationTriangle,
                            size: 48,
                            color: colorScheme.error,
                          ),
                          const SizedBox(height: 16),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 32),
                            child: Text(
                              state.message,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: colorScheme.error,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () {
                              context.read<NewsBloc>().add(
                                LoadNewsRequested(
                                  category: _selectedCategory,
                                  refresh: true,
                                ),
                              );
                            },
                            child: const Text('Încercați din nou'),
                          ),
                        ],
                      ),
                    );
                  }

                  if (state is NewsLoaded) {
                    if (state.news.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            FaIcon(
                              FontAwesomeIcons.newspaper,
                              size: 48,
                              color: AppColors.primary,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Nu sunt știri disponibile',
                              style: theme.textTheme.titleMedium?.copyWith(
                                color: colorScheme.onSurface,
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    return RefreshIndicator(
                      color: AppColors.primary,
                      onRefresh: () async {
                        context.read<NewsBloc>().add(
                          LoadNewsRequested(
                            category: _selectedCategory,
                            refresh: true,
                          ),
                        );
                      },
                      child: ListView.builder(
                        controller: _scrollController,
                        padding: const EdgeInsets.all(16),
                        itemCount: state.news.length + (state.hasMore ? 1 : 0),
                        itemBuilder: (context, index) {
                          if (index == state.news.length) {
                            return Center(
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: CircularProgressIndicator(
                                  color: AppColors.primary,
                                ),
                              ),
                            );
                          }

                          return NewsItemWidget(
                            news: state.news[index],
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder:
                                      (context) => NewsDetailPage(
                                        news: state.news[index],
                                      ),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    );
                  }

                  if (state is NewsSearchResults) {
                    if (state.results.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            FaIcon(
                              FontAwesomeIcons.magnifyingGlass,
                              size: 48,
                              color: AppColors.primary,
                            ),
                            const SizedBox(height: 16),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 32,
                              ),
                              child: Text(
                                'Nu au fost găsite rezultate pentru "${state.query}"',
                                style: theme.textTheme.titleMedium?.copyWith(
                                  color: colorScheme.onSurface,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    return ListView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.all(16),
                      itemCount: state.results.length,
                      itemBuilder: (context, index) {
                        return NewsItemWidget(
                          news: state.results[index],
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder:
                                    (context) => NewsDetailPage(
                                      news: state.results[index],
                                    ),
                              ),
                            );
                          },
                        );
                      },
                    );
                  }

                  return const SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Logout'),
          content: const Text('Are you sure you want to logout?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                // Trigger logout
                context.read<AuthBloc>().add(LogoutRequested());
              },
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text('Logout'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildCategoryChip(
    BuildContext context,
    String category,
    bool isSelected,
  ) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: () => _onCategorySelected(category == 'All' ? null : category),
      child: Container(
        margin: const EdgeInsets.only(right: 12),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.white,
          borderRadius: BorderRadius.circular(25),
          border: Border.all(
            color: isSelected ? AppColors.primary : Colors.grey[300]!,
            width: 1,
          ),
          boxShadow: [
            if (isSelected)
              BoxShadow(
                color: AppColors.primary.withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
          ],
        ),
        child: Text(
          category,
          style: theme.textTheme.labelMedium?.copyWith(
            color: isSelected ? Colors.white : Colors.grey[700],
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
