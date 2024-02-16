import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_tostudy/core/error/exceptions.dart';
import 'package:flutter_tostudy/features/number_trivia/data/datasources/number_trivia_remote_datasource.dart';
import 'package:flutter_tostudy/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../../core/fixtures/fixture_reader.dart';
import 'number_trivia_remote_data_source_test.mocks.dart';

@GenerateNiceMocks([MockSpec<http.Client>()])


void main(){
  
  MockClient mockHttpClient = MockClient();
  NumberTriviaRemoteDataSourceImpl dataSource = NumberTriviaRemoteDataSourceImpl(client: mockHttpClient);

  setUp(() {
    mockHttpClient = MockClient();
    dataSource = NumberTriviaRemoteDataSourceImpl(client: mockHttpClient);
  });

  void setUpMockHttpClientSuccess200(){
        when(mockHttpClient.get(any, headers: anyNamed('headers'))).thenAnswer(
      (_) async => http.Response(fixture('trivia.json'), 200),);
  }

  void setUpMockHttpClientFailure404(){
    when(mockHttpClient.get(any, headers: anyNamed('headers'))).thenAnswer(
    (_) async => http.Response('Server Error', 404),);
  }

  group('getConcreteNumberTrivia', () { 
    const tNumber = 1;
    final tNumberTriviaModel = NumberTriviaModel.fromJson(json.decode(fixture('trivia.json')));

    test('should perform a GET request on a URL with number being the endpoint and with application/json header', 
    () async {
      setUpMockHttpClientSuccess200();

      dataSource.getConcreteNumberTrivia(tNumber);

      verify(mockHttpClient.get(Uri(scheme:'http', host:'numbersapi.com', path:'/$tNumber/'), headers: {'Content-Type': 'application/json'}));
    });


    test('should return NumberTrivia when the response code is 200', 
    () async {
      setUpMockHttpClientSuccess200();

      final result = await dataSource.getConcreteNumberTrivia(tNumber);

      expect(result, equals(tNumberTriviaModel));
    });

    test('should throw a ServerException when the response code is 404 or other', 
    () async {

      setUpMockHttpClientFailure404();
      
      final call = dataSource.getConcreteNumberTrivia;

      expect(()=> call(tNumber), throwsA(isA<ServerException>()));
    });

  });

    group('getRandomNumberTrivia', () { 
    final tNumberTriviaModel = NumberTriviaModel.fromJson(json.decode(fixture('trivia.json')));

    test('should perform a GET request on a URL with number being the endpoint and with application/json header', 
    () async {
      setUpMockHttpClientSuccess200();

      dataSource.getRandomNumberTrivia();

      verify(mockHttpClient.get(Uri(scheme:'http', host:'numbersapi.com', path:'/random/'), headers: {'Content-Type': 'application/json'}));
    });


    test('should return NumberTrivia when the response code is 200', 
    () async {
      setUpMockHttpClientSuccess200();

      final result = await dataSource.getRandomNumberTrivia();

      expect(result, equals(tNumberTriviaModel));
    });

    test('should throw a ServerException when the response code is 404 or other', 
    () async {

      setUpMockHttpClientFailure404();
      
      final call = dataSource.getRandomNumberTrivia;

      expect(()=> call(), throwsA(isA<ServerException>()));
    });

  });
}