import 'package:dartz/dartz.dart';
import 'package:flutter_tostudy/core/error/exceptions.dart';
import 'package:flutter_tostudy/core/error/failures.dart';
import 'package:flutter_tostudy/core/network/network_info.dart';
import 'package:flutter_tostudy/features/number_trivia/data/datasources/number_trivia_local_datasource.dart';
import 'package:flutter_tostudy/features/number_trivia/data/datasources/number_trivia_remote_datasource.dart';
import 'package:flutter_tostudy/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:flutter_tostudy/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:flutter_tostudy/features/number_trivia/domain/repositories/number_trivia_repository.dart';

typedef _ConcreteOrRandomChooser = Future<NumberTrivia> Function();

class NumberTriviaRepositoryImpl implements NumberTriviaRepository{
  final NumberTriviaLocalDataSource localDataSource;
  final NumberTriviaRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  const NumberTriviaRepositoryImpl({required this.localDataSource, required this.remoteDataSource, required this.networkInfo});

  @override
  Future<Either<Failure, NumberTrivia>> getConcreteNumberTrivia(int number) async {

    return await _getTrivia(() {
      return remoteDataSource.getConcreteNumberTrivia(number);
    });

  }

  @override
  Future<Either<Failure, NumberTrivia>> getRandomNumberTrivia() async {
    return await _getTrivia(() {
      return remoteDataSource.getRandomNumberTrivia();
    });
  }

  Future<Either<Failure, NumberTrivia>> _getTrivia(_ConcreteOrRandomChooser getConcreteOrRandom) async {
    if(await networkInfo.isConnected){
      try {
        final remoteTrivia = await getConcreteOrRandom();
        localDataSource.cacheNumberTrivia(remoteTrivia as NumberTriviaModel);
        return Right(remoteTrivia);
      } 
      on ServerException {
        return Left(ServerFailure());
      }
    }
    else{
      try {
        final localTrivia = await localDataSource.getLastNumberTrivia();
        return Right(localTrivia);
      } 
      on CacheException {
        return Left(CacheFailure());
      }
    }
  }
  
}