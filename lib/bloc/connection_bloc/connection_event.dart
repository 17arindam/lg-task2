part of 'connection_bloc.dart';

@immutable
sealed class ConnectionEvent {}

class ConnectToLG extends ConnectionEvent {}

class DisconnectFromLG extends ConnectionEvent {}
