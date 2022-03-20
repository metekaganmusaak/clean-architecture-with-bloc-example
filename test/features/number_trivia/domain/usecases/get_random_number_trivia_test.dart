import 'package:clean_architecture/core/error/failures.dart';
import 'package:clean_architecture/core/usecases/usecase.dart';
import 'package:clean_architecture/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:clean_architecture/features/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'package:clean_architecture/features/number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'package:dartz/dartz.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';

class MockNumberTriviaRepository extends Mock
    implements NumberTriviaRepository {}

void main() {
  /// Buradaki instance'ları late olarak işaretlemeliyiz. Çünkü daha sonra initiliaze edeceğimizi
  /// bu şekilde bildirebiliyoruz. Burada bu iki instance değişmeyeceğinden ve setUp kısmında init
  /// edileceğinden late final olarak tanımladık.
  late final GetRandomNumberTrivia usecase;
  late final MockNumberTriviaRepository mockNumberTriviaRepository;

  /// Initiliaze edilecek kısım burası.
  setUp(() {
    mockNumberTriviaRepository = MockNumberTriviaRepository();
    usecase = GetRandomNumberTrivia(mockNumberTriviaRepository);
  });

  const testNumberTrivia = NumberTrivia(
    text: "This is just the test text.",
    number: 1,
  );

  test(
    'Should get trivia from the repository.',
    () async {
      // Arrange
      when(mockNumberTriviaRepository.getRandomNumberTrivia())
          .thenAnswer((_) async => const Right(testNumberTrivia));

      // Act
      // We called call method withoud writing it.
      final Either<Failures, NumberTrivia>? result = await usecase(NoParams());

      // Assert
      expect(result, const Right(testNumberTrivia));
      verify(mockNumberTriviaRepository.getRandomNumberTrivia());
      verifyNoMoreInteractions(mockNumberTriviaRepository);
    },
  );
}
