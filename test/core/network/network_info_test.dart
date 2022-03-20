import 'package:clean_architecture/core/network/network_info.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';

class MockDataConnectionChecker extends Mock
    implements InternetConnectionChecker {}

void main() {
  late final NetworkInfoImpl networkInfoImpl;
  late final MockDataConnectionChecker mockDataConnectionChecker;

  setUpAll(() {
    mockDataConnectionChecker = MockDataConnectionChecker();
    networkInfoImpl = NetworkInfoImpl(mockDataConnectionChecker);
  });

  group('is Connected', () {
    test(
      'should forward the call to connectivity checker has connectivity.',
      () async {
        // arrange
        Future<bool>? hasConnection = mockDataConnectionChecker.hasConnection;
        final testHasConnectionFuture = Future.value(true);
        when(hasConnection).thenAnswer((_) async => testHasConnectionFuture);

        // act
        final result = networkInfoImpl.isConnected;

        // assert
        verify(mockDataConnectionChecker.hasConnection);
        expect(result, testHasConnectionFuture);
      },
    );
  });
}
