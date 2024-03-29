import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_tostudy/core/error/exceptions.dart';
import 'package:flutter_tostudy/features/number_trivia/data/datasources/number_trivia_local_datasource.dart';
import 'package:flutter_tostudy/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/fixtures/fixture_reader.dart';
import 'number_trivia_local_data_source_test.mocks.dart';

@GenerateNiceMocks([MockSpec<SharedPreferences>()])
void main(){
  
  MockSharedPreferences mockSharedPreferences = MockSharedPreferences();
  NumberTriviaLocalDataSourceImpl dataSource = NumberTriviaLocalDataSourceImpl(sharedPreferences: mockSharedPreferences);

  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    dataSource = NumberTriviaLocalDataSourceImpl(sharedPreferences: mockSharedPreferences);
  });

  group('getLastNumberTrivia', () { 
    final tNumberTriviaModel = NumberTriviaModel.fromJson(json.decode(fixture('trivia_cached.json')));
    test('should return NumberTrivia from SharedPreferences when there is one in the cache', 
    () async{
      when(mockSharedPreferences.getString(any)).thenReturn(fixture('trivia_cached.json'));

      final result = await dataSource.getLastNumberTrivia();

      verify(mockSharedPreferences.getString(CACHED_NUMBER_TRIVIA));
      expect(result, equals(tNumberTriviaModel));
    } );

    test('should throw a CacheException when there is not a cached value', 
    () async{
      when(mockSharedPreferences.getString(any)).thenReturn(null);

      final call = dataSource.getLastNumberTrivia;

      expect(() => call(), throwsA( isA<CacheException>()));
    } );

  });

  group('cacheNumberTrivia', () { 
    const tNumberTriviaModel = NumberTriviaModel(number: 1, text: 'test trivia');
    test('should call SharedPreferences to cache the data', 
    () async{

      dataSource.cacheNumberTrivia(tNumberTriviaModel);

      final expectedJsonString = json.encode(tNumberTriviaModel.toJson());

      verify(mockSharedPreferences.setString(CACHED_NUMBER_TRIVIA, expectedJsonString));
    } );

  });
}