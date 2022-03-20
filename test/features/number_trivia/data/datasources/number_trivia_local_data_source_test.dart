import 'dart:convert';

import 'package:clean_architecture/core/error/exceptions.dart';
import 'package:clean_architecture/features/number_trivia/data/datasources/number_trivia_local_data_source.dart';
import 'package:clean_architecture/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  late final NumberTriviaLocalDataSourceImpl dataSourceImpl;
  late final MockSharedPreferences mockSharedPreferences;

  setUpAll(() {
    mockSharedPreferences = MockSharedPreferences();
    dataSourceImpl = NumberTriviaLocalDataSourceImpl(
      sharedPreferences: mockSharedPreferences,
    );
  });

  group('get last number trivia =>', () {
    final testNumberTriviaModel =
        NumberTriviaModel.fromJson(json.decode(fixture('trivia_cached.json')));
    test(
      'should return NumberTrivia from SharedPreferenes when there is one in the cache.',
      () async {
        // arrange
        when(mockSharedPreferences.getString('CACHED_NUMBER_TRIVIA'))
            .thenReturn(fixture('trivia_cached.json'));
        // act
        final result = await dataSourceImpl.getLastNumberTrivia();
        // assert
        verify(mockSharedPreferences.getString('CACHED_NUMBER_TRIVIA'));
        expect(result, equals(testNumberTriviaModel));
      },
    );

    test(
      'should throw a CacheException when there is not a cached value.',
      () async {
        // arrange
        when(mockSharedPreferences.getString(CACHED_NUMBER_TRIVIA))
            .thenReturn(null);
        // act
        final call = dataSourceImpl.getLastNumberTrivia; // assert
        expect(() => call(), throwsA(const TypeMatcher<CacheException>()));
      },
    );
  });

  group('cache number trivia =>', () {
    const testNumberTriviaModel = NumberTriviaModel(text: "Test Trivia", number: 1);
    test(
      'should call SharedPreferences to cache the data.',
      () async {
        // act
        dataSourceImpl.cacheNumberTrivia(testNumberTriviaModel);
        // assert
        final String expectedJsonString = json.encode(testNumberTriviaModel.toJson());
        verify(mockSharedPreferences.setString(CACHED_NUMBER_TRIVIA, expectedJsonString));
      },
    );
  });
}
