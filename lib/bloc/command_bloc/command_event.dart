part of 'command_bloc.dart';

@immutable
sealed class CommandEvent {}

final class SendLogo extends CommandEvent {}

final class ClearLogo extends CommandEvent {}

final class SendKML1 extends CommandEvent {
  final BuildContext context;

  SendKML1(this.context);
}

final class SendKML2 extends CommandEvent {
  final BuildContext context;

  SendKML2(this.context);
}

final class ClearKML extends CommandEvent {}

final class RelaunchLG extends CommandEvent {}
