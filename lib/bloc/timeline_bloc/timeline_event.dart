part of 'timeline_bloc.dart';

@immutable
abstract class TimelineEvent {}

class AddTimelineStep extends TimelineEvent {
  final String step;

  AddTimelineStep({required this.step});
}

class ResetTimeline extends TimelineEvent {}