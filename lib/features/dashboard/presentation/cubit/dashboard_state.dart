part of 'dashboard_cubit.dart';

class DashboardCardData extends Equatable {
  final String id;
  final String cardType;
  final String title;
  final String? description;
  final String icon;
  final String iconColor;
  final String route;
  final String? badge;
  final int sortOrder;
  final String? dynamicSource;
  final String? dynamicFallback;

  const DashboardCardData({
    required this.id,
    required this.cardType,
    required this.title,
    this.description,
    required this.icon,
    required this.iconColor,
    required this.route,
    this.badge,
    required this.sortOrder,
    this.dynamicSource,
    this.dynamicFallback,
  });

  factory DashboardCardData.fromJson(Map<String, dynamic> json) {
    return DashboardCardData(
      id: json['id'] as String,
      cardType: json['card_type'] as String,
      title: json['title'] as String,
      description: json['description'] as String?,
      icon: json['icon'] as String,
      iconColor: json['icon_color'] as String,
      route: json['route'] as String,
      badge: json['badge'] as String?,
      sortOrder: json['sort_order'] as int,
      dynamicSource: json['dynamic_source'] as String?,
      dynamicFallback: json['dynamic_fallback'] as String?,
    );
  }

  @override
  List<Object?> get props => [id, cardType, title, description, icon, iconColor, route, badge, sortOrder, dynamicSource, dynamicFallback];
}

class DashboardState extends Equatable {
  final bool isLoading;
  final String userName;
  final String nextEventTitle;
  final String nextEventDate;
  final String nextEventTime;
  final String nextEventLabel;
  final String latestNewsId;
  final String latestNewsTitle;
  final String latestNewsTime;
  final List<DashboardCardData> largeCards;
  final List<DashboardCardData> smallCards;
  final Map<String, String> settings;

  const DashboardState({
    this.isLoading = true,
    this.userName = '',
    this.nextEventTitle = '',
    this.nextEventDate = '',
    this.nextEventTime = '',
    this.nextEventLabel = '',
    this.latestNewsId = '',
    this.latestNewsTitle = '',
    this.latestNewsTime = '',
    this.largeCards = const [],
    this.smallCards = const [],
    this.settings = const {},
  });

  String setting(String key, [String fallback = '']) =>
      settings[key] ?? fallback;

  DashboardState copyWith({
    bool? isLoading,
    String? userName,
    String? nextEventTitle,
    String? nextEventDate,
    String? nextEventTime,
    String? nextEventLabel,
    String? latestNewsId,
    String? latestNewsTitle,
    String? latestNewsTime,
    List<DashboardCardData>? largeCards,
    List<DashboardCardData>? smallCards,
    Map<String, String>? settings,
  }) {
    return DashboardState(
      isLoading: isLoading ?? this.isLoading,
      userName: userName ?? this.userName,
      nextEventTitle: nextEventTitle ?? this.nextEventTitle,
      nextEventDate: nextEventDate ?? this.nextEventDate,
      nextEventTime: nextEventTime ?? this.nextEventTime,
      nextEventLabel: nextEventLabel ?? this.nextEventLabel,
      latestNewsId: latestNewsId ?? this.latestNewsId,
      latestNewsTitle: latestNewsTitle ?? this.latestNewsTitle,
      latestNewsTime: latestNewsTime ?? this.latestNewsTime,
      largeCards: largeCards ?? this.largeCards,
      smallCards: smallCards ?? this.smallCards,
      settings: settings ?? this.settings,
    );
  }

  @override
  List<Object?> get props => [
        isLoading,
        userName,
        nextEventTitle,
        nextEventDate,
        nextEventTime,
        nextEventLabel,
        latestNewsId,
        latestNewsTitle,
        latestNewsTime,
        largeCards,
        smallCards,
        settings,
      ];
}
