import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_tostudy/core/error/failures.dart';
import 'package:flutter_tostudy/core/usecases/usecase.dart';
import 'package:flutter_tostudy/core/util/input_converter.dart';
import 'package:flutter_tostudy/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:flutter_tostudy/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:flutter_tostudy/features/number_trivia/domain/usecases/get_random_number_trivia.dart';

part 'number_trivia_event.dart';
part 'number_trivia_state.dart';

const String SERVER_FAILURE_MESSAGE = 'Server Failure';
const String CACHE_FAILURE_MESSAGE = 'Cache Failure';
const String INVALID_INPUT_FAILURE_MESSAGE = 'Invalid Input Failure';

class NumberTriviaBloc extends Bloc<NumberTriviaEvent, NumberTriviaState> {
  final GetConcreteNumberTrivia getConcreteNumberTrivia;
  final GetRandomNumberTrivia getRandomNumberTrivia;
  final InputConverter inputConverter;

  NumberTriviaBloc(
      {required this.getConcreteNumberTrivia,
      required this.getRandomNumberTrivia,
      required this.inputConverter})
      : super(Empty()) {
    on<NumberTriviaEvent>(numberTriviaEventObserver);
  }

  Future<void> numberTriviaEventObserver(
      NumberTriviaEvent event, Emitter<NumberTriviaState> emit) async {
    if (event is GetTriviaForConcreteNumber) {
      await getTriviaForConcreteNumberStateChanges(event, emit);
    }
    else if(event is GetTriviaForRandomNumber){
      await getTriviaForRandomNumberStateChanges(emit);
    }
  }

  Future<void> getTriviaForRandomNumberStateChanges(Emitter<NumberTriviaState> emit) async {
    emit(Loading());
    final failureOrTrivia = await getRandomNumberTrivia(NoParams());
    failureOrTrivia.fold(
        (failure) => emit(Error(message: _mapFailureToMessage(failure))),
        (trivia) => emit(Loaded(trivia: trivia))
      );
  }

  Future<void> getTriviaForConcreteNumberStateChanges(GetTriviaForConcreteNumber event, Emitter<NumberTriviaState> emit) async {
    
    final inputEither = inputConverter.stringToUsignedInteger(event.numberString);
    
    await inputEither.fold(
        (failure) async {emit(const Error(message: INVALID_INPUT_FAILURE_MESSAGE));} ,
        (integer) async {
          emit(Loading());
          final failureOrTrivia = await getConcreteNumberTrivia(Params(number: integer));
          failureOrTrivia.fold(
              (failure) => emit(Error(message: _mapFailureToMessage(failure))),
              (trivia) => emit(Loaded(trivia: trivia))
            );
      });
  }

  String _mapFailureToMessage(Failure failure){
    switch (failure.runtimeType) {
      case ServerFailure:
        return SERVER_FAILURE_MESSAGE;
      case CacheFailure:
        return CACHE_FAILURE_MESSAGE;
      default:
        return 'Unexpected error';
    }
  }
}
