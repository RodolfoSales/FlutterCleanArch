import 'package:dartz/dartz.dart';
import 'package:flutter_tostudy/core/usecases/usecase.dart';
import 'package:flutter_tostudy/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:flutter_tostudy/features/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'package:flutter_tostudy/features/number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'package:mockito/annotations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'get_concrete_number_trivia_test.mocks.dart';

@GenerateNiceMocks([MockSpec<NumberTriviaRepository>()])
void main(){

    final mockNumberTriviaRepository = MockNumberTriviaRepository();
    final usecase = GetRandomNumberTrivia(mockNumberTriviaRepository);

    const tNumberTrivia = NumberTrivia(number: 1, text: 'test');

  test('should get trivia from the repository', () async {

    when(mockNumberTriviaRepository.getRandomNumberTrivia())
    .thenAnswer((_) async => const Right(tNumberTrivia));

    final result = await usecase(NoParams());

    expect(result, const Right(tNumberTrivia));
    verify(mockNumberTriviaRepository.getRandomNumberTrivia());
    verifyNoMoreInteractions(mockNumberTriviaRepository);
  });
}