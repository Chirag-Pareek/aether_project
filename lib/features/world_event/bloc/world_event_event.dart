part of 'world_event_bloc.dart';

abstract class WorldEventEvent {}

class WorldEventSubscriptionRequested extends WorldEventEvent {}

class WorldEventJoinRequested extends WorldEventEvent {
  final String userId;
  WorldEventJoinRequested(this.userId);
}

class WorldEventDataUpdated extends WorldEventEvent {
  final int slotsFilled;
  final int maxSlots;
  WorldEventDataUpdated(this.slotsFilled, this.maxSlots);
}
