part of 'banners_cubit.dart';

class BannersState extends Equatable {
  const BannersState({
    this.primaryBanners = const [],
    this.secondaryBanners = const [],
    this.isLoading = false,
    this.isError = false,
    this.message = '',
    this.type = BannerPage.shop,
  });

  final List<BannerEntity> primaryBanners;
  final List<BannerEntity> secondaryBanners;
  final bool isLoading;
  final bool isError;
  final String message;
  final BannerPage type;

  BannersState copyWith({
    List<BannerEntity>? primaryBanners,
    List<BannerEntity>? secondaryBanners,
    bool? isLoading,
    bool? isError,
    String? message,
    BannerPage? type,
  }) {
    return BannersState(
      primaryBanners: primaryBanners ?? this.primaryBanners,
      secondaryBanners: secondaryBanners ?? this.secondaryBanners,
      isLoading: isLoading ?? this.isLoading,
      isError: isError ?? this.isError,
      message: message ?? this.message,
      type: type ?? this.type,
    );
  }

  @override
  List<Object> get props => [
    primaryBanners,
    secondaryBanners,
    isLoading,
    isError,
    message,
    type,
  ];
}
