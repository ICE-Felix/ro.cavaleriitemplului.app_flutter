import '../../domain/entities/intro_entity.dart';

class IntroModel extends IntroEntity {
  const IntroModel({
    required super.isNetworkConnected,
    required super.isIntroCompleted,
    super.errorMessage,
  });

  factory IntroModel.fromJson(Map<String, dynamic> json) {
    return IntroModel(
      isNetworkConnected: json['isNetworkConnected'] ?? false,
      isIntroCompleted: json['isIntroCompleted'] ?? false,
      errorMessage: json['errorMessage'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'isNetworkConnected': isNetworkConnected,
      'isIntroCompleted': isIntroCompleted,
      'errorMessage': errorMessage,
    };
  }

  IntroModel copyWith({
    bool? isNetworkConnected,
    bool? isIntroCompleted,
    String? errorMessage,
  }) {
    return IntroModel(
      isNetworkConnected: isNetworkConnected ?? this.isNetworkConnected,
      isIntroCompleted: isIntroCompleted ?? this.isIntroCompleted,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
