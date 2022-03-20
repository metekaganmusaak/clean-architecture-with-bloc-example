// ignore_for_file: constant_identifier_names

import 'package:bloc/bloc.dart';
import 'package:clean_architecture/core/error/failures.dart';
import 'package:clean_architecture/core/usecases/usecase.dart';
import 'package:clean_architecture/core/utils/input_converter.dart';
import 'package:clean_architecture/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:clean_architecture/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:clean_architecture/features/number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

part 'number_trivia_event.dart';
part 'number_trivia_state.dart';

const String SERVER_FAILURE_MESSAGE = "Server Failure";
const String CACHE_FAILURE_MESSAGE = "Cache Failure";
const String INVALID_INPUT_FAILURE_MESSAGE = "Invalid Input";

class NumberTriviaBloc extends Bloc<NumberTriviaEvent, NumberTriviaState> {
  final GetConcreteNumberTrivia getConcreteNumberTrivia;
  final GetRandomNumberTrivia getRandomNumberTrivia;
  final InputConverter inputConverter;

  NumberTriviaBloc({
    required GetConcreteNumberTrivia concrete,
    required GetRandomNumberTrivia random,
    required this.inputConverter,
  })  : getConcreteNumberTrivia = concrete,
        getRandomNumberTrivia = random,
        super(Empty()) {
    on<NumberTriviaEvent>(
        (NumberTriviaEvent event, Emitter<NumberTriviaState> emit) async {
      if (event is GetTriviaForConcreteNumber) {
        final inputEither =
            inputConverter.stringToUnsignedInt(event.numberString);

        try {
          if (inputEither.isRight()) {
            emit(Loading());
            int number = 0;
            inputEither.fold((l) => null, (r) => number = r);
            final Either<Failures, NumberTrivia>? failureOrTrivia =
                await getConcreteNumberTrivia(Params(number: number));
            if (failureOrTrivia != null) {
              emit(_eitherLoadedOrErrorState(failureOrTrivia));
            }
          }
        } catch (e) {
          emit(const Error(errorMessage: INVALID_INPUT_FAILURE_MESSAGE));
        }
      } else if (event is GetTriviaForRandomNumber) {
        emit(Loading());
        final failureOrTrivia = await getRandomNumberTrivia(NoParams());
        if (failureOrTrivia != null) {
          emit(_eitherLoadedOrErrorState(failureOrTrivia));
        }
      }
    });
  }

  NumberTriviaState _eitherLoadedOrErrorState(
    Either<Failures, NumberTrivia>? failureOrTrivia,
  ) {
    if (failureOrTrivia != null) {
      return failureOrTrivia.fold((failure) {
        return Error(errorMessage: _mapFailureToMessage(failure));
      }, (trivia) {
        return Loaded(trivia: trivia);
      });
    } else {
      return Error(errorMessage: _mapFailureToMessage(ServerFailure()));
    }
  }

  String _mapFailureToMessage(Failures failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return SERVER_FAILURE_MESSAGE;
      case CacheFailure:
        return CACHE_FAILURE_MESSAGE;
      default:
        return 'Unexpected error';
    }
  }
}
