import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/number_trivia.dart';
import '../repositories/number_trivia_repository.dart';

class GetConcreteNumberTrivia implements UseCase<NumberTrivia, Params> {
  final NumberTriviaRepository repository;

  // apiurl.com/42 ==> Concrete number trivia
  // apiurl.com/random ==> Random number trivia

  GetConcreteNumberTrivia(this.repository);

  @override
  Future<Either<Failures, NumberTrivia>?> call(Params params) async {
    return await repository.getConcreteNumberTrivia(params.number);
  }

  // Call method can be called with instance.call() or just instance()
}

class Params extends Equatable {
  
  final int number;
  const Params({required this.number}) : super();

  @override
  List<Object?> get props => [number];
}
