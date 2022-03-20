import 'dart:convert';

import 'package:clean_architecture/features/number_trivia/data/datasources/number_trivia_remote_data_source.dart';
import 'package:clean_architecture/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockHttpClient extends Mock implements http.Client {}

void main() {
  late final NumberTriviaRemoteDataSourceImpl dataSourceImpl;
  late final MockHttpClient mockHttpClient;

  setUpAll(() {
    mockHttpClient = MockHttpClient();
    dataSourceImpl = NumberTriviaRemoteDataSourceImpl(client: mockHttpClient);
  });

  group('get concrete number trivia =>', () {
    const testNumber = 1;
    final testNumberTriviaModel = NumberTriviaModel.fromJson(json.decode(fixture('trivia.json')));
    test(
      'should perform a GET request on a URL with number being the endpoint and with application/json header.',
      () async {
        when(mockHttpClient.get(Uri.parse("numbersapi.com"),
                headers: anyNamed('headers')))
            .thenAnswer(
                (_) async => http.Response(fixture('trivia.json'), 200));

        // act
        dataSourceImpl.getConcreteNumberTrivia(testNumber);
        // assert
        verify(mockHttpClient
            .get(Uri.parse('http://numbersapi.com/$testNumber'), headers: {
          'Content-Type': 'application/json',
        }));
      },
    );

    test(
      'should return NumberTrivia when the response code is 200.',
      () async {
        when(mockHttpClient.get(Uri.parse("numbersapi.com"),
                headers: anyNamed('headers')))
            .thenAnswer(
                (_) async => http.Response(fixture('trivia.json'), 200));

        // act
        final result = await dataSourceImpl.getConcreteNumberTrivia(testNumber);
        // assert
        expect(result, equals(testNumberTriviaModel));

      },
    );
  });
}
