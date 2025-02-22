import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'timeline_event.dart';
part 'timeline_state.dart';

class TimelineBloc extends Bloc<TimelineEvent, TimelineState> {
  TimelineBloc() : super(CurrentTimelineState(
    timelineSteps: [],
    currentStepIndex: -1,
  )) {
    on<AddTimelineStep>((event, emit) {
      final currentState = state as CurrentTimelineState;
      final updatedSteps = List<String>.from(currentState.timelineSteps)
        ..add(event.step);
      
      emit(CurrentTimelineState(
        timelineSteps: updatedSteps,
        currentStepIndex: updatedSteps.length - 1,
      ));
    });

    on<ResetTimeline>((event, emit) {
      emit(CurrentTimelineState(
        timelineSteps: [],
        currentStepIndex: -1,
      ));
    });
  }
}
