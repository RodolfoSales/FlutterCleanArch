import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_tostudy/core/network/network_info.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'network_info_test.mocks.dart';

@GenerateNiceMocks([MockSpec<InternetConnectionChecker>()])

void main(){
  
  MockInternetConnectionChecker mockInternetConnectionChecker = MockInternetConnectionChecker();
  NetworkInfoImpl networInfoImpl = NetworkInfoImpl(mockInternetConnectionChecker);

  setUp(() {
    mockInternetConnectionChecker = MockInternetConnectionChecker();
    networInfoImpl  = NetworkInfoImpl(mockInternetConnectionChecker);
  });

  group('isConnected', () { 
    test('should forward the call to InternetConnectionChecker.hasConnetion', () async {
      final tHasConnectionFuture = Future.value(true);
      when(mockInternetConnectionChecker.hasConnection).thenAnswer((_) => tHasConnectionFuture);

      final result = networInfoImpl.isConnected;
      verify(mockInternetConnectionChecker.hasConnection);
      expect(result, tHasConnectionFuture);

    });
  });
}