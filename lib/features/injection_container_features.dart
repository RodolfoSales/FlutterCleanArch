import 'package:flutter_tostudy/features/number_trivia/data/datasources/number_trivia_local_datasource.dart';
import 'package:flutter_tostudy/features/number_trivia/data/datasources/number_trivia_remote_datasource.dart';
import 'package:flutter_tostudy/features/number_trivia/data/repositories/number_trivia_repository_impl.dart';
import 'package:flutter_tostudy/features/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'package:flutter_tostudy/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:flutter_tostudy/features/number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'number_trivia/presentation/bloc/number_trivia_bloc.dart';

Future<void> initFeatures(GetIt sl) async {
  sl.registerFactory(() => NumberTriviaBloc(
      getConcreteNumberTrivia: sl(),
      inputConverter: sl(),
      getRandomNumberTrivia: sl()));
  sl.registerLazySingleton(() => GetConcreteNumberTrivia(sl()));
  sl.registerLazySingleton(() => GetRandomNumberTrivia(sl()));
  sl.registerLazySingleton<NumberTriviaRepository>(() =>
      NumberTriviaRepositoryImpl(
          localDataSource: sl(), remoteDataSource: sl(), networkInfo: sl()));
  sl.registerLazySingleton<NumberTriviaRemoteDataSource>(
      () => NumberTriviaRemoteDataSourceImpl(client: sl()));

  sl.registerLazySingletonAsync<SharedPreferences>(
    () => SharedPreferences.getInstance(),
  );
  await sl.isReady<SharedPreferences>();
  sl.registerLazySingleton<NumberTriviaLocalDataSource>(
      () => NumberTriviaLocalDataSourceImpl(sharedPreferences: sl()));
  sl.registerLazySingleton(() => http.Client());
}
