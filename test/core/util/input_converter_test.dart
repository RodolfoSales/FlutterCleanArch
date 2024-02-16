import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_tostudy/core/error/failures.dart';
import 'package:flutter_tostudy/core/util/input_converter.dart';

void main(){
  InputConverter inputConverter = InputConverter();

  setUp(() {
    inputConverter = InputConverter();
  });

  group('stringToUnsignedInt', 
  () { 
    test('should return an integer when the string represents an unsigned integer', () async {
      const str = '123';

      final result = inputConverter.stringToUsignedInteger(str);

      expect(result, const Right(123));
    });

    test('should return a failure when the string is not an unsigned integer', () async {
      const str = 'abc';

      final result = inputConverter.stringToUsignedInteger(str);

      expect(result, Left(InvalidInputFailure()));
    });
    test('should return a failure when the string is a negative integer', () async {
      const str = '-123';

      final result = inputConverter.stringToUsignedInteger(str);

      expect(result, Left(InvalidInputFailure()));
    });
  });
}