import '../../../../core/network/network_info.dart';
import '../../domain/entities/intro_entity.dart';
import '../../domain/repositories/intro_repository.dart';
import '../datasources/intro_local_data_source.dart';
import '../models/intro_model.dart';

class IntroRepositoryImpl implements IntroRepository {
  final NetworkInfo networkInfo;
  final IntroLocalDataSource localDataSource;

  IntroRepositoryImpl({
    required this.networkInfo,
    required this.localDataSource,
  });

  @override
  Future<IntroEntity> checkNetworkConnection() async {
    try {
      final isConnected = await networkInfo.isConnected;
      final isCompleted = await localDataSource.getIntroCompletionStatus();

      if (!isConnected) {
        return IntroModel(
          isNetworkConnected: false,
          isIntroCompleted: isCompleted,
          errorMessage:
              'No internet connection detected. Please check your network settings.',
        );
      }

      return IntroModel(
        isNetworkConnected: true,
        isIntroCompleted: isCompleted,
      );
    } catch (e) {
      return IntroModel(
        isNetworkConnected: false,
        isIntroCompleted: false,
        errorMessage: 'Failed to check network connection: ${e.toString()}',
      );
    }
  }

  @override
  Future<void> completeIntro() async {
    try {
      await localDataSource.cacheIntroCompletion();
    } catch (e) {
      throw Exception('Failed to complete intro: $e');
    }
  }

  @override
  Future<bool> isIntroCompleted() async {
    try {
      return await localDataSource.getIntroCompletionStatus();
    } catch (e) {
      return false;
    }
  }
}
