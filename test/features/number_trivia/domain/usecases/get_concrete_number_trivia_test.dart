import 'package:dartz/dartz.dart';
import 'package:flutter_tostudy/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:flutter_tostudy/features/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'package:flutter_tostudy/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:mockito/annotations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'get_concrete_number_trivia_test.mocks.dart';

@GenerateNiceMocks([MockSpec<NumberTriviaRepository>()])
void main(){

    final mockNumberTriviaRepository = MockNumberTriviaRepository();
    final usecase = GetConcreteNumberTrivia(mockNumberTriviaRepository);
    const tNumber = 1;
    const tNumberTrivia = NumberTrivia(number: 1, text: 'test');

  test('should get trivia for the number from the repository', () async {

    when(mockNumberTriviaRepository.getConcreteNumberTrivia(any))
    .thenAnswer((_) async => const Right(tNumberTrivia));

    final result = await usecase(const Params(number: tNumber));

    expect(result, const Right(tNumberTrivia));
    verify(mockNumberTriviaRepository.getConcreteNumberTrivia(tNumber));
    verifyNoMoreInteractions(mockNumberTriviaRepository);
  });
}