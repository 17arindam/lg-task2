part of 'command_bloc.dart';

@immutable
sealed class CommandState {}

final class CommandInitial extends CommandState {}

final class CommandLoading extends CommandState {}

final class CommandSuccess extends CommandState {
  final String message;

  CommandSuccess(this.message);
}

final class CommandError extends CommandState {
  final String message;

  CommandError(this.message);
}
