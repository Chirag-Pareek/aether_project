import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:aether_project/raid_service.dart';

part 'world_event_event.dart';
part 'world_event_state.dart';

class WorldEventBloc extends Bloc<WorldEventEvent, WorldEventState> {
  final RaidService raidService;
  StreamSubscription? _raidSubscription;

  WorldEventBloc({required this.raidService})
      : super(const WorldEventState()) {
    on<WorldEventSubscriptionRequested>(_onSubscriptionRequested);
    on<WorldEventDataUpdated>(_onDataUpdated);
    on<WorldEventJoinRequested>(_onJoinRequested);
  }

  Future<void> _onSubscriptionRequested(
    WorldEventSubscriptionRequested event,
    Emitter<WorldEventState> emit,
  ) async {
    await _raidSubscription?.cancel();
    
    // Subscribe to Firestore updates for real-time slot synchronization
    _raidSubscription = raidService.raidStream.listen((snapshot) {
      if (snapshot.exists) {
        final data = snapshot.data()!;
        add(WorldEventDataUpdated(
          (data['slots_filled'] as num?)?.toInt() ?? 0,
          (data['max_slots'] as num?)?.toInt() ?? 15,
        ));
      }
    });
  }

  void _onDataUpdated(
    WorldEventDataUpdated event,
    Emitter<WorldEventState> emit,
  ) {
    emit(state.copyWith(
      slotsFilled: event.slotsFilled,
      maxSlots: event.maxSlots,
    ));
  }

  Future<void> _onJoinRequested(
    WorldEventJoinRequested event,
    Emitter<WorldEventState> emit,
  ) async {
    if (state.hasJoined) return;
    
    emit(state.copyWith(status: WorldEventStatus.loading));
    
    final success = await raidService.joinRaid(userId: event.userId);
    
    if (success) {
      emit(state.copyWith(
        status: WorldEventStatus.success,
        hasJoined: true,
      ));
    } else {
      // Check if it failed because it's full
      if (state.slotsFilled >= state.maxSlots) {
        emit(state.copyWith(status: WorldEventStatus.full));
      } else {
        emit(state.copyWith(
          status: WorldEventStatus.failure,
          errorMessage: 'Join failed. Please try again.',
        ));
      }
    }
  }

  @override
  Future<void> close() {
    _raidSubscription?.cancel();
    return super.close();
  }
}
