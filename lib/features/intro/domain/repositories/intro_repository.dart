import '../entities/intro_entity.dart';

abstract class IntroRepository {
  Future<IntroEntity> checkNetworkConnection();
  Future<void> completeIntro();
  Future<bool> isIntroCompleted();
}
