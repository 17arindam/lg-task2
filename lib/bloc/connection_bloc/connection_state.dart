part of 'connection_bloc.dart';

@immutable
sealed class LGConnectionState {}

final class ConnectionInitial extends LGConnectionState {}

final class Connecting extends LGConnectionState {}

final class Connected extends LGConnectionState {}

final class Disconnected extends LGConnectionState {}

final class ConnectionError extends LGConnectionState {
  final String message;

  ConnectionError(this.message);
}