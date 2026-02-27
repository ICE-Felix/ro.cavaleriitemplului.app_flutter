import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../../core/service_locator.dart';
import '../../../../core/style/app_colors.dart';
import '../../../../core/widgets/custom_top_bar/custom_top_bar.dart';
import '../../../../core/widgets/app_search_bar_v2.dart';
import '../bloc/members_bloc.dart';
import '../bloc/members_event.dart';
import '../bloc/members_state.dart';
import '../widgets/member_card.dart';

class MembersPage extends StatefulWidget {
  const MembersPage({super.key});

  @override
  State<MembersPage> createState() => _MembersPageState();
}

class _MembersPageState extends State<MembersPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(BuildContext blocContext, String query) {
    if (query.isEmpty) {
      setState(() => _isSearching = false);
      _reloadCurrentTab(blocContext);
    } else {
      setState(() => _isSearching = true);
      blocContext.read<MembersBloc>().add(SearchMembers(query));
    }
  }

  void _reloadCurrentTab(BuildContext blocContext) {
    final index = _tabController.index;
    if (index == 0) {
      blocContext.read<MembersBloc>().add(const LoadImportantMembers());
    } else if (index == 1) {
      blocContext.read<MembersBloc>().add(const LoadAllMembers());
    } else {
      blocContext.read<MembersBloc>().add(const LoadFavoriteMembers());
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<MembersBloc>()..add(const LoadImportantMembers()),
      child: Builder(
        builder: (context) => Scaffold(
          backgroundColor: AppColors.background,
          appBar: CustomTopBar.withCart(
            context: context,
            showLogo: true,
            showBackButton: true,
            logoHeight: 200,
            logoWidth: 0,
            centerTitle: false,
            showNotificationButton: true,
          ),
          body: Column(
            children: [
              // Tab Bar
              if (!_isSearching)
                Container(
                  color: AppColors.surface,
                  child: TabBar(
                    controller: _tabController,
                    labelColor: AppColors.primary,
                    unselectedLabelColor:
                        AppColors.onBackground.withValues(alpha: 0.6),
                    indicatorColor: AppColors.primary,
                    indicatorWeight: 3,
                    labelStyle: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                    unselectedLabelStyle:
                        Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.normal,
                            ),
                    onTap: (index) {
                      if (index == 0) {
                        context
                            .read<MembersBloc>()
                            .add(const LoadImportantMembers());
                      } else if (index == 1) {
                        context.read<MembersBloc>().add(const LoadAllMembers());
                      } else {
                        context
                            .read<MembersBloc>()
                            .add(const LoadFavoriteMembers());
                      }
                    },
                    tabs: const [
                      Tab(
                        icon: FaIcon(FontAwesomeIcons.star, size: 16),
                        text: 'Important Members',
                      ),
                      Tab(
                        icon: FaIcon(FontAwesomeIcons.users, size: 16),
                        text: 'Members',
                      ),
                      Tab(
                        icon: FaIcon(FontAwesomeIcons.heart, size: 16),
                        text: 'Favorites',
                      ),
                    ],
                  ),
                ),
              // Search bar
              AppSearchBarV2(
                controller: _searchController,
                hintText: 'Caută membri...',
                margin: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                onChanged: (query) => _onSearchChanged(context, query),
                onSubmitted: () {
                  if (_searchController.text.isNotEmpty) {
                    _onSearchChanged(context, _searchController.text);
                  }
                },
                onClear: () {
                  _onSearchChanged(context, '');
                  setState(() {});
                },
              ),
              // Content
              Expanded(
                child: _isSearching
                    ? _MembersContentView(
                        onRefresh: () => _reloadCurrentTab(context),
                      )
                    : TabBarView(
                        controller: _tabController,
                        children: [
                          _MembersContentView(
                            onRefresh: () => context
                                .read<MembersBloc>()
                                .add(const LoadImportantMembers()),
                          ),
                          _MembersContentView(
                            onRefresh: () => context
                                .read<MembersBloc>()
                                .add(const LoadAllMembers()),
                          ),
                          _MembersContentView(
                            onRefresh: () => context
                                .read<MembersBloc>()
                                .add(const LoadFavoriteMembers()),
                          ),
                        ],
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MembersContentView extends StatelessWidget {
  final VoidCallback? onRefresh;

  const _MembersContentView({this.onRefresh});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MembersBloc, MembersState>(
      builder: (context, state) {
        if (state is MembersLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is MembersLoaded) {
          if (state.members.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FaIcon(
                    FontAwesomeIcons.users,
                    size: 64,
                    color: AppColors.onBackground.withValues(alpha: 0.3),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No members found',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: AppColors.onBackground.withValues(alpha: 0.6),
                        ),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              onRefresh?.call();
            },
            child: ListView.separated(
              padding: const EdgeInsets.all(16.0),
              itemCount: state.members.length,
              separatorBuilder: (context, index) => const SizedBox(height: 16),
              itemBuilder: (context, index) {
                final member = state.members[index];
                final isFavorite = state.favoriteIds.contains(member.id);
                return MemberCard(
                  member: member,
                  isFavorite: isFavorite,
                  onTap: () {
                    // Navigate to member details if needed
                  },
                  onFavoriteTap: () {
                    context
                        .read<MembersBloc>()
                        .add(ToggleFavorite(member.id));
                  },
                );
              },
            ),
          );
        } else if (state is MembersError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FaIcon(
                  FontAwesomeIcons.triangleExclamation,
                  size: 64,
                  color: AppColors.error,
                ),
                const SizedBox(height: 16),
                Text(
                  'Error loading members',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: AppColors.error,
                      ),
                ),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32.0),
                  child: Text(
                    state.message,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.onBackground.withValues(alpha: 0.6),
                        ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: () {
                    onRefresh?.call();
                  },
                  icon: const FaIcon(FontAwesomeIcons.arrowsRotate, size: 16),
                  label: const Text('Retry'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}
