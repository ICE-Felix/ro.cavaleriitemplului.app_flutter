import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get_it/get_it.dart';

import 'network/dio_client.dart';
import 'network/network_info.dart';
import 'network/supabase_client.dart';
import '../features/auth/data/datasources/auth_remote_data_source.dart';
import '../features/auth/data/repositories/auth_repository_impl.dart';
import '../features/auth/domain/repositories/auth_repository.dart';
import '../features/auth/domain/usecases/login_usecase.dart';
import '../features/auth/domain/usecases/register_usecase.dart';
import '../features/auth/domain/usecases/forgot_password_usecase.dart';
import '../features/auth/presentation/bloc/auth_bloc.dart';
// Intro feature imports
import '../features/intro/data/datasources/intro_local_data_source.dart';
import '../features/intro/data/repositories/intro_repository_impl.dart';
import '../features/intro/domain/repositories/intro_repository.dart';
import '../features/intro/domain/usecases/check_network_usecase.dart';
import '../features/intro/domain/usecases/complete_intro_usecase.dart';
import '../features/intro/presentation/bloc/intro_bloc.dart';

final sl = GetIt.instance;

Future<void> initServiceLocator() async {
  //! External dependencies (register first)
  sl.registerLazySingleton(() => Connectivity());

  //! Core
  sl.registerLazySingleton(() => DioClient());
  sl.registerLazySingleton(() => SupabaseAuthClient());
  sl.registerLazySingleton<NetworkInfo>(
    () => NetworkInfoImpl(sl<Connectivity>()),
  );

  // Initialize Supabase
  await SupabaseAuthClient.initialize();

  //! Data sources
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(supabaseClient: sl<SupabaseAuthClient>()),
  );

  // Intro data sources
  sl.registerLazySingleton<IntroLocalDataSource>(
    () => IntroLocalDataSourceImpl(),
  );

  //! Repositories
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      remoteDataSource: sl<AuthRemoteDataSource>(),
      networkInfo: sl<NetworkInfo>(),
    ),
  );

  // Intro repository
  sl.registerLazySingleton<IntroRepository>(
    () => IntroRepositoryImpl(
      networkInfo: sl<NetworkInfo>(),
      localDataSource: sl<IntroLocalDataSource>(),
    ),
  );

  //! Use cases
  sl.registerLazySingleton(
    () => LoginUseCase(repository: sl<AuthRepository>()),
  );
  sl.registerLazySingleton(
    () => RegisterUseCase(repository: sl<AuthRepository>()),
  );
  sl.registerLazySingleton(
    () => ForgotPasswordUseCase(repository: sl<AuthRepository>()),
  );

  // Intro use cases
  sl.registerLazySingleton(
    () => CheckNetworkUseCase(repository: sl<IntroRepository>()),
  );
  sl.registerLazySingleton(
    () => CompleteIntroUseCase(repository: sl<IntroRepository>()),
  );

  //! BLoCs
  sl.registerFactory(
    () => AuthBloc(
      loginUseCase: sl<LoginUseCase>(),
      registerUseCase: sl<RegisterUseCase>(),
      forgotPasswordUseCase: sl<ForgotPasswordUseCase>(),
    ),
  );

  // Intro BLoC
  sl.registerFactory(
    () => IntroBloc(
      checkNetworkUseCase: sl<CheckNetworkUseCase>(),
      completeIntroUseCase: sl<CompleteIntroUseCase>(),
    ),
  );
}
