import 'dart:convert';

import 'package:flutter_tostudy/core/error/exceptions.dart';

import '../models/number_trivia_model.dart';
import 'package:http/http.dart' as http;

abstract class NumberTriviaRemoteDataSource {
  Future<NumberTriviaModel> getConcreteNumberTrivia(int number);
  Future<NumberTriviaModel> getRandomNumberTrivia();
}

class NumberTriviaRemoteDataSourceImpl implements NumberTriviaRemoteDataSource{
  final http.Client client;

  NumberTriviaRemoteDataSourceImpl({required this.client});

  Uri _getURL(String address, String path){
    return Uri(scheme:'http', host:address, path:path);
  }

  Future<NumberTriviaModel> _getTriviaFromURL(Uri uri) async{
    final response = await client.get(uri, headers: {'Content-Type': 'application/json'});

    if(response.statusCode!=200) throw ServerException();

    return NumberTriviaModel.fromJson(json.decode(response.body));
  }

  @override
  Future<NumberTriviaModel> getConcreteNumberTrivia(int number) => _getTriviaFromURL(_getURL('numbersapi.com','/$number/'));

  @override
  Future<NumberTriviaModel> getRandomNumberTrivia() => _getTriviaFromURL(_getURL('numbersapi.com','/random/'));

}