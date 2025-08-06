import 'package:app/core/navigation/routes_name.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/widgets/custom_top_bar.dart';
import '../../../../core/style/app_colors.dart';
import '../../../../core/localization/app_localization.dart';
import '../../../auth/presentation/bloc/authentication_bloc.dart';
import '../bloc/news_bloc.dart';
import '../widgets/news_item_widget.dart';
import 'news_detail_page.dart';
import 'saved_articles_page.dart';
import '../../data/models/category_model.dart';
import '../../domain/entities/news_entity.dart';

class NewsPage extends StatefulWidget {
  const NewsPage({super.key});

  @override
  State<NewsPage> createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  String? _selectedCategory;

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

    return BlocListener<AuthenticationBloc, AuthenticationState>(
      listener: (context, state) {
        if (state is AuthUnauthenticated) {
          // Navigate back to intro page when user logs out
          while (context.canPop()) {
            context.pop();
          }
          context.pushNamed(AppRoutesNames.intro.name);
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
            context.pushNamed(AppRoutesNames.cart.name);
          },
          onLogoTap: () {
            print('Logo tapped!');
          },
          customActions: [
            // Language switcher button
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: LanguageSwitcherWidget(isCompact: true),
            ),
            // Saved articles button
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: IconButton(
                onPressed: () {
                  context.pushNamed(AppRoutesNames.savedArticles.name);
                },
                icon: const FaIcon(FontAwesomeIcons.solidBookmark, size: 20),
                tooltip: context.getString(label: 'savedArticles'),
              ),
            ),
          ],
        ),
        body: Column(
          children: [
            // Categories section
            BlocBuilder<NewsBloc, NewsState>(
              buildWhen:
                  (previous, current) =>
                      current is NewsLoaded &&
                      (previous is! NewsLoaded ||
                          previous.categories != current.categories),
              builder: (context, state) {
                List<CategoryModel> categories = [];
                if (state is NewsLoaded) {
                  categories = state.categories;
                }

                return Container(
                  height: 56,
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: categories.length + 1,
                    itemBuilder: (context, index) {
                      if (index == 0) {
                        return _buildCategoryChip(
                          context,
                          context.getString(label: 'all'),
                          null,
                          _selectedCategory == null,
                        );
                      }
                      final category = categories[index - 1];
                      return _buildCategoryChip(
                        context,
                        category.name,
                        category.id,
                        _selectedCategory == category.id,
                      );
                    },
                  ),
                );
              },
            ),

            // News content
            Expanded(
              child: BlocBuilder<NewsBloc, NewsState>(
                builder: (context, state) {
                  final List<NewsEntity> newsToShow = [];
                  bool hasMore = false;
                  bool isLoading = state is NewsLoading;

                  // Get news from current or previous state
                  if (state is NewsLoaded) {
                    newsToShow.addAll(state.news);
                    hasMore = state.hasMore;
                  } else if (state is NewsSearchResults) {
                    newsToShow.addAll(state.results);
                    hasMore = state.hasMore;
                  } else if (state is NewsLoading &&
                      state.previousState != null) {
                    // Keep showing previous news during loading
                    final previousState = state.previousState;
                    if (previousState is NewsLoaded) {
                      newsToShow.addAll(previousState.news);
                      hasMore = previousState.hasMore;
                    } else if (previousState is NewsSearchResults) {
                      newsToShow.addAll(previousState.results);
                      hasMore = previousState.hasMore;
                    }
                  }

                  return Stack(
                    children: [
                      RefreshIndicator(
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
                          itemCount:
                              newsToShow.isEmpty
                                  ? 1
                                  : newsToShow.length + (hasMore ? 1 : 0),
                          itemBuilder: (context, index) {
                            if (newsToShow.isEmpty) {
                              return SizedBox(
                                height: MediaQuery.of(context).size.height / 2,
                                child: Center(
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
                                        isLoading
                                            ? context.getString(
                                              label: 'articlesLoading',
                                            )
                                            : context.getString(
                                              label: 'noArticlesAvailable',
                                            ),
                                        style: theme.textTheme.titleMedium
                                            ?.copyWith(
                                              color: colorScheme.onSurface,
                                            ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }

                            if (index == newsToShow.length) {
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
                              news: newsToShow[index],
                              onTap: () {
                                context.pushNamed(
                                  AppRoutesNames.newsDetails.name,
                                  pathParameters: {'id': newsToShow[index].id},
                                );
                              },
                            );
                          },
                        ),
                      ),
                      if (state is NewsLoading)
                        Positioned(
                          top: 0,
                          left: 0,
                          right: 0,
                          child: LinearProgressIndicator(
                            color: AppColors.primary,
                            backgroundColor: AppColors.primary.withOpacity(0.1),
                          ),
                        ),
                    ],
                  );
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
                context.pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                context.pop();
                // Trigger logout
                context.read<AuthenticationBloc>().add(LogoutRequested());
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
    String categoryName,
    String? categoryId,
    bool isSelected,
  ) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap:
          () => _onCategorySelected(categoryName == 'All' ? null : categoryId),
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
          categoryName,
          style: theme.textTheme.labelMedium?.copyWith(
            color: isSelected ? Colors.white : Colors.grey[700],
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
