part of 'timeline_bloc.dart';

@immutable
abstract class TimelineState {}

class CurrentTimelineState extends TimelineState {
  final List<String> timelineSteps;
  final int currentStepIndex;

  CurrentTimelineState({
    required this.timelineSteps,
    required this.currentStepIndex,
  });

  double get progress => timelineSteps.isEmpty ? 
    0.0 : (currentStepIndex + 1) / timelineSteps.length;
}
