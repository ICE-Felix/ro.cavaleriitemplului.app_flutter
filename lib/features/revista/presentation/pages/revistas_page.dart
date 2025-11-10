import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/navigation/routes_name.dart';
import '../../../../core/widgets/custom_top_bar.dart';
import '../../../../core/widgets/app_search_bar_v2.dart';
import '../../../../core/style/app_colors.dart';
import '../../../../core/localization/app_localization.dart';
import '../../../auth/presentation/bloc/authentication_bloc.dart';
import '../bloc/revista_bloc.dart';
import '../widgets/revista_item_widget.dart';
import '../../domain/entities/revista_entity.dart';

class RevistasPage extends StatefulWidget {
  const RevistasPage({super.key});

  @override
  State<RevistasPage> createState() => _RevistasPageState();
}

class _RevistasPageState extends State<RevistasPage> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);

    // Load initial data
    context.read<RevistaBloc>().add(LoadRevistasRequested());
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
      final state = context.read<RevistaBloc>().state;
      if (state is RevistaLoaded && state.hasMore) {
        context.read<RevistaBloc>().add(LoadMoreRevistasRequested());
      }
    }
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
        appBar: CustomTopBar.withCart(
          context: context,
          showLogo: true,
          logoHeight: 90,
          logoWidth: 140,
          logoPadding: const EdgeInsets.only(
            left: 20.0,
            top: 10.0,
            bottom: 10.0,
          ),
          showNotificationButton: true,
          onNotificationTap: () {
            // Handle notification tap
          },
          onLogoTap: () {
            context.pushNamed(AppRoutesNames.dashboard.name);
          },
          customActions: [
            // Language switcher button
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: LanguageSwitcherWidget(isCompact: true),
            ),
          ],
        ),
        body: Column(
          children: [
            // Search bar
            AppSearchBarV2(
              controller: _searchController,
              hintText: 'Caută în reviste...',
              margin: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              onChanged: (value) {
                // Implement revista search functionality
                // This could filter the revistas list
              },
              onSubmitted: () {
                if (_searchController.text.isNotEmpty) {
                  // Trigger search
                }
              },
              onClear: () {
                setState(() {});
              },
            ),

            // Header section
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColors.primary,
                    AppColors.primary.withValues(alpha: 0.8),
                  ],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const FaIcon(
                        FontAwesomeIcons.bookOpen,
                        color: Colors.white,
                        size: 28,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          context.getString(label: 'revista'),
                          style: theme.textTheme.headlineSmall?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    context.getString(label: 'revistaDescription'),
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: Colors.white.withValues(alpha: 0.9),
                    ),
                  ),
                ],
              ),
            ),

            // Revistas list
            Expanded(
              child: BlocBuilder<RevistaBloc, RevistaState>(
                builder: (context, state) {
                  final List<RevistaEntity> revistasToShow = [];
                  bool hasMore = false;
                  bool isLoading = state is RevistaLoading;

                  // Get revistas from current or previous state
                  if (state is RevistaLoaded) {
                    revistasToShow.addAll(state.revistas);
                    hasMore = state.hasMore;
                  } else if (state is RevistaLoading &&
                      state.previousState != null) {
                    // Keep showing previous revistas during loading
                    final previousState = state.previousState;
                    if (previousState is RevistaLoaded) {
                      revistasToShow.addAll(previousState.revistas);
                      hasMore = previousState.hasMore;
                    }
                  }

                  return Stack(
                    children: [
                      RefreshIndicator(
                        color: AppColors.primary,
                        onRefresh: () async {
                          context.read<RevistaBloc>().add(
                                LoadRevistasRequested(refresh: true),
                              );
                        },
                        child: ListView.builder(
                          controller: _scrollController,
                          padding: const EdgeInsets.all(16),
                          itemCount: revistasToShow.isEmpty
                              ? 1
                              : revistasToShow.length + (hasMore ? 1 : 0),
                          itemBuilder: (context, index) {
                            if (revistasToShow.isEmpty) {
                              return SizedBox(
                                height: MediaQuery.of(context).size.height / 2,
                                child: Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      FaIcon(
                                        FontAwesomeIcons.bookOpen,
                                        size: 48,
                                        color: AppColors.primary,
                                      ),
                                      const SizedBox(height: 16),
                                      Text(
                                        isLoading
                                            ? context.getString(
                                                label: 'revistasLoading',
                                              )
                                            : context.getString(
                                                label: 'noRevistasAvailable',
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

                            if (index == revistasToShow.length) {
                              return Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: CircularProgressIndicator(
                                    color: AppColors.primary,
                                  ),
                                ),
                              );
                            }

                            return RevistaItemWidget(
                              revista: revistasToShow[index],
                              onTap: () {
                                context.pushNamed(
                                  AppRoutesNames.revistaDetails.name,
                                  pathParameters: {
                                    'id': revistasToShow[index].id
                                  },
                                );
                              },
                            );
                          },
                        ),
                      ),
                      if (state is RevistaLoading)
                        Positioned(
                          top: 0,
                          left: 0,
                          right: 0,
                          child: LinearProgressIndicator(
                            color: AppColors.primary,
                            backgroundColor:
                                AppColors.primary.withValues(alpha: 0.1),
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
}
