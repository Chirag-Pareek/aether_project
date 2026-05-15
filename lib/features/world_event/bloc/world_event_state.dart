part of 'world_event_bloc.dart';

enum WorldEventStatus { initial, loading, success, failure, full }

class WorldEventState {
  final WorldEventStatus status;
  final int slotsFilled;
  final int maxSlots;
  final bool hasJoined;
  final String? errorMessage;

  const WorldEventState({
    this.status = WorldEventStatus.initial,
    this.slotsFilled = 0,
    this.maxSlots = 15,
    this.hasJoined = false,
    this.errorMessage,
  });

  WorldEventState copyWith({
    WorldEventStatus? status,
    int? slotsFilled,
    int? maxSlots,
    bool? hasJoined,
    String? errorMessage,
  }) {
    return WorldEventState(
      status: status ?? this.status,
      slotsFilled: slotsFilled ?? this.slotsFilled,
      maxSlots: maxSlots ?? this.maxSlots,
      hasJoined: hasJoined ?? this.hasJoined,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
