import 'package:dartz/dartz.dart';
import 'package:flutter_tostudy/core/error/failures.dart';

class InputConverter{
  Either<Failure, int> stringToUsignedInteger(String str){
    final result = int.tryParse(str);
    if(result==null || result<0) return Left(InvalidInputFailure());
    return Right(result);
  }
}

