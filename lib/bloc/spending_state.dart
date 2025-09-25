part of 'spendings_bloc.dart';

sealed class SpendingState extends Equatable {
  const SpendingState();

  @override
  List<Object> get props => [];
}

final class SpendingInitial extends SpendingState {}

final class SpendingLoading extends SpendingState {}

final class SpendingLoaded extends SpendingState {
  final MonthlySummary summary;

  const SpendingLoaded(this.summary);

  @override
  List<Object> get props => [summary];
}

final class SpendingError extends SpendingState {
  final String error;

  const SpendingError(this.error);

  @override
  List<Object> get props => [error];
}
