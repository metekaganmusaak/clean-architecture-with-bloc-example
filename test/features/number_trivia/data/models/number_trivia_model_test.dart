import 'dart:convert';

import 'package:clean_architecture/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:clean_architecture/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  const testNumberTriviaModel = NumberTriviaModel(number: 1, text: "Test Text");

  test('Should be a sublass of NumberTrivia entity',
    () async {
      // assert
      expect(testNumberTriviaModel, isA<NumberTrivia>());
    },
  );

  group('fromJson =>', () {
    test(
      "Should return a valid model when the JSON number is an integer",
      () async {
        // arrange
        // this jsonMap mimics the real api
        final Map<String, dynamic> jsonMap =
            json.decode(fixture('trivia.json'));
        // act
        final result = NumberTriviaModel.fromJson(jsonMap);

        //assert
        expect(result, equals(testNumberTriviaModel));
      },
    );

    test(
      "Should return a valid model when the JSON number is regarded as a double",
      () async {
        // arrange
        // this jsonMap mimics the real api
        final Map<String, dynamic> jsonMap =
            json.decode(fixture('trivia_double.json'));
        // act
        final result = NumberTriviaModel.fromJson(jsonMap);

        //assert
        expect(result, equals(testNumberTriviaModel));
      },
    );
  });

  group('toJson =>', () {
    test(
      "Should return a JSON map containing the proper data.",
      () async {
        // act
        final result = testNumberTriviaModel.toJson();

        // assert
        final Map<String, dynamic> expectedMap = {
          "text": "Test Text",
          "number": 1,
        };
        expect(result, expectedMap);
      },
    );
  });
}
