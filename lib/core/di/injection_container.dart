import 'package:get_it/get_it.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../data/repositories/content_repository_impl.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/repositories/content_repository.dart';
import '../../domain/usecases/auth/sign_in.dart';
import '../../domain/usecases/content/get_recent_content.dart';
import '../../domain/usecases/content/get_upcoming_events.dart';
import '../../presentation/bloc/auth/auth_bloc.dart';
import '../../presentation/bloc/home/home_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  //! Features - Auth
  // Bloc
  sl.registerFactory(
    () => AuthBloc(signIn: sl()),
  );

  // Use cases
  sl.registerLazySingleton(() => SignIn(sl()));

  //! Features - Home
  // Bloc
  sl.registerFactory(
    () => HomeBloc(
      getRecentContent: sl(),
      getUpcomingEvents: sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => GetRecentContent(sl()));
  sl.registerLazySingleton(() => GetUpcomingEvents(sl()));

  //! Core
  // Repository
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(),
  );

  sl.registerLazySingleton<ContentRepository>(
    () => ContentRepositoryImpl(),
  );
}