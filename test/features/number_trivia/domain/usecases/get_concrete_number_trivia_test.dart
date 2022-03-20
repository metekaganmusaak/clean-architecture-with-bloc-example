import 'package:clean_architecture/core/error/failures.dart';
import 'package:clean_architecture/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:clean_architecture/features/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'package:clean_architecture/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:dartz/dartz.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';

class MockNumberTriviaRepository extends Mock
    implements NumberTriviaRepository {}

void main() {
  /// Buradaki instance'ları late olarak işaretlemeliyiz. Çünkü daha sonra initiliaze edeceğimizi
  /// bu şekilde bildirebiliyoruz. Burada bu iki instance değişmeyeceğinden ve setUp kısmında init
  /// edileceğinden late final olarak tanımladık.
  late GetConcreteNumberTrivia usecase;
  late MockNumberTriviaRepository mockNumberTriviaRepository;

  /// Initiliaze edilecek kısım burası.
  setUp(() {
    mockNumberTriviaRepository = MockNumberTriviaRepository();
    usecase = GetConcreteNumberTrivia(mockNumberTriviaRepository);
  });

  const testNumber = 1;
  const testNumberTrivia = NumberTrivia(
    text: "This is just the test text.",
    number: testNumber,
  );

  test(
    'Should get trivia for the number from the repository.',
    () async {

      // Arrange
      when(mockNumberTriviaRepository.getConcreteNumberTrivia(any)).thenAnswer((_) async => const Right(testNumberTrivia));

      // Act
      // We called call method withoud writing it. 
      final Either<Failures, NumberTrivia>? result = await usecase.call(const Params(number: testNumber));

      // Assert
      expect(result, const Right(testNumberTrivia));
      verify(mockNumberTriviaRepository.getConcreteNumberTrivia(any));
      verifyNoMoreInteractions(mockNumberTriviaRepository);
    },
  );
}
