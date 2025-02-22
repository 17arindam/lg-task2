import 'package:bloc/bloc.dart';
import 'package:lg_task_2/connections/ssh.dart';
import 'package:meta/meta.dart';

part 'connection_event.dart';
part 'connection_state.dart';

class ConnectionBloc extends Bloc<ConnectionEvent, LGConnectionState> {
  final SSH ssh; // Declare SSH instance at the class level

  ConnectionBloc({required this.ssh}) : super(ConnectionInitial()) {
    on<ConnectToLG>((event, emit) async {
      emit(Connecting());
      try {
        bool? isConnected = await ssh.connectToLG();
        if (isConnected == true) {
          emit(Connected());
        } else {
          emit(ConnectionError("Connection failed"));
        }
      } catch (e) {
        emit(ConnectionError(e.toString()));
      }
    });

    on<DisconnectFromLG>((event, emit) async {
      emit(Connecting());
      try {
        await ssh.disconnectFromLG();
        emit(Disconnected());
      } catch (e) {
        emit(ConnectionError(e.toString()));
      }
    });
  }
}
