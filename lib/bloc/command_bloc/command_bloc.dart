import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:lg_task_2/connections/ssh.dart';
import 'package:lg_task_2/kml/kml1.dart';
import 'package:meta/meta.dart';

part 'command_event.dart';
part 'command_state.dart';

class CommandBloc extends Bloc<CommandEvent, CommandState> {
  final SSH ssh;
  CommandBloc({required this.ssh}) : super(CommandInitial()) {
    on<SendLogo>((event, emit) async {
      emit(CommandLoading());
      try {
        await ssh.setLogo();
        emit(CommandSuccess("Logo sent"));
      } catch (e) {
        emit(CommandError(e.toString()));
      }
    });
    on<ClearLogo>((event, emit) async {
      emit(CommandLoading());
      try {
        await ssh.clearLogo();
        emit(CommandSuccess("Logo cleared"));
      } catch (e) {
        emit(CommandError(e.toString()));
      }
    });
    on<SendKML1>((event, emit) async {
      emit(CommandLoading());
      try {
        if (ssh.client == null) {
          emit(CommandError("SSH client is not connected"));
          return;
        }
        await ssh.sendKML1(event.context, ssh.client!,KML1.kml);
        emit(CommandSuccess("Tour Completed"));
      } catch (e) {
        emit(CommandError(e.toString()));
      }
    });
    on<SendKML2>((event, emit) async {
      emit(CommandLoading());
      try {
        if (ssh.client == null) {
          emit(CommandError("SSH client is not connected"));
          return;
        }
        await ssh.sendKML2(event.context, ssh.client!);
        emit(CommandSuccess("Tour Completed"));
      } catch (e) {
        emit(CommandError(e.toString()));
      }
    });
    on<ClearKML>((event, emit) async {
      emit(CommandLoading());
      try {
        await ssh.clearKML();
        emit(CommandSuccess("KML cleared"));
      } catch (e) {
        emit(CommandError(e.toString()));
      }
    });
    on<RelaunchLG>((event, emit) async {
      emit(CommandLoading());
      try {
        await ssh.relaunchLG();
        emit(CommandSuccess("LG rebooted"));
      } catch (e) {
        emit(CommandError(e.toString()));
      }
    });
  }
}
