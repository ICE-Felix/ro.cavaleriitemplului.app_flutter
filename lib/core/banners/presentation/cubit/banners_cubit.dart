import 'dart:math';

import 'package:app/core/banners/domain/entities/banner_entity.dart';
import 'package:app/core/banners/domain/repositories/banners_repository.dart';
import 'package:app/core/banners/domain/usecases/get_banners_usecase.dart';
import 'package:app/core/banners/domain/usecases/increment_banner_clicks_usecase.dart';
import 'package:app/core/banners/domain/usecases/increment_banner_displays_usecase.dart';
import 'package:app/core/error/exceptions.dart';
import 'package:app/core/service_locator.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'banners_state.dart';

class BannersCubit extends Cubit<BannersState> {
  BannersCubit() : super(const BannersState());

  Future<void> loadBanners({required BannerPage page}) async {
    emit(state.copyWith(isLoading: true, isError: false, message: ''));
    try {
      final banners =
          await GetBannersUseCase(repository: sl<BannersRepository>()).call();
      final filteredByPage =
          banners.where((banner) => banner.page == page).toList();
      final primaryBanners =
          filteredByPage
              .where((banner) => banner.type == BannerType.primary)
              .toList();
      final secondaryBanners =
          filteredByPage
              .where((banner) => banner.type == BannerType.secondary)
              .toList();
      emit(
        state.copyWith(
          primaryBanners: primaryBanners,
          secondaryBanners: secondaryBanners,
          isLoading: false,
          type: page,
        ),
      );
    } on ServerException catch (e) {
      emit(state.copyWith(isError: true, isLoading: false, message: e.message));
    } on AuthException catch (e) {
      emit(state.copyWith(isError: true, isLoading: false, message: e.message));
    } catch (e) {
      emit(
        state.copyWith(
          isError: true,
          type: page,
          isLoading: false,
          message: 'Failed to load banners: ${e.toString()}',
        ),
      );
    }
  }

  BannerEntity? getRandomPrimaryBanner() {
    if (state.primaryBanners.isEmpty) {
      return null;
    }
    final random = Random();
    final index = random.nextInt(state.primaryBanners.length);
    return state.primaryBanners[index];
  }

  BannerEntity? getRandomSecondaryBanner() {
    if (state.secondaryBanners.isEmpty) {
      return null;
    }
    final random = Random();
    final index = random.nextInt(state.secondaryBanners.length);
    return state.secondaryBanners[index];
  }

  Future<void> incrementDisplays(String bannerId) async {
    try {
      await IncrementBannerDisplaysUseCase(
        repository: sl<BannersRepository>(),
      ).call(bannerId);
    } catch (e) {
      // Silently fail to not disrupt user experience
    }
  }

  Future<void> incrementClicks(String bannerId) async {
    try {
      await IncrementBannerClicksUseCase(
        repository: sl<BannersRepository>(),
      ).call(bannerId);
    } catch (e) {
      // Silently fail to not disrupt user experience
    }
  }
}
