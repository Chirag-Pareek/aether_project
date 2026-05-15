import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:aether_project/core/theme/app_colors.dart';
import 'package:aether_project/core/theme/app_spacing.dart';
import 'package:aether_project/core/theme/app_typography.dart';
import 'package:aether_project/features/world_event/bloc/world_event_bloc.dart';
import 'package:aether_project/features/world_event/presentation/widgets/countdown_timer.dart';
import 'package:aether_project/raid_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class WorldEventScreen extends StatelessWidget {
  const WorldEventScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Providing the Bloc at the top of the screen
    return BlocProvider(
      create: (context) => WorldEventBloc(
        raidService: RaidService(firestore: FirebaseFirestore.instance),
      )..add(WorldEventSubscriptionRequested()),
      child: const WorldEventView(),
    );
  }
}

class WorldEventView extends StatelessWidget {
  const WorldEventView({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    
    return Scaffold(
      backgroundColor: colors.canvas,
      body: BlocListener<WorldEventBloc, WorldEventState>(
        listener: (context, state) {
          if (state.status == WorldEventStatus.success) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('SLOT RESERVED! ATOMIC SYNC CONFIRMED.')),
            );
          } else if (state.status == WorldEventStatus.full) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('RAID FULL! ALL SLOTS CLAIMED.')),
            );
          }
        },
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                colors.canvas,
                colors.surfaceDark,
              ],
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header Area
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'AETHER',
                            style: AppTypography.displaySm.copyWith(
                              color: colors.primary,
                              letterSpacing: 2.0,
                            ),
                          ),
                          Text(
                            'WORLD EVENT MANAGER',
                            style: AppTypography.captionUppercase.copyWith(
                              color: colors.onDarkSoft,
                            ),
                          ),
                        ],
                      ),
                      Icon(Icons.radar_rounded, color: colors.primary, size: 32),
                    ],
                  ),
                  const Spacer(),
                  
                  // Hero Section with Countdown
                  Center(
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(AppSpacing.xxl),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: colors.hairlineSoft.withOpacity(0.1),
                              width: 1,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: colors.primary.withOpacity(0.05),
                                blurRadius: 50,
                                spreadRadius: 10,
                              ),
                            ],
                          ),
                          child: CountdownTimer(
                            // Fixed start time: exactly 5 minutes and 10 seconds from now
                            targetTime: DateTime.now().add(const Duration(minutes: 5, seconds: 10)),
                          ),
                        ),
                        const SizedBox(height: AppSpacing.xl),
                        Text(
                          'DRAGON RAID',
                          style: AppTypography.displayLg.copyWith(
                            color: colors.primary,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.xxs),
                        Text(
                          'EPIC WORLD BOSS • REGION: NORTH-GEO',
                          style: AppTypography.captionUppercase.copyWith(
                            color: colors.onDarkSoft,
                            letterSpacing: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  const Spacer(),
                  
                  // Action Area
                  Center(
                    child: Column(
                      children: [
                        BlocBuilder<WorldEventBloc, WorldEventState>(
                          builder: (context, state) {
                            final bool isFull = state.slotsFilled >= state.maxSlots;
                            final bool isLoading = state.status == WorldEventStatus.loading;
                            
                            return Column(
                              children: [
                                SizedBox(
                                  width: double.infinity,
                                  height: 56,
                                  child: FilledButton(
                                    onPressed: (state.hasJoined || isFull || isLoading) 
                                      ? null 
                                      : () {
                                          context.read<WorldEventBloc>().add(
                                            WorldEventJoinRequested('user_${DateTime.now().millisecondsSinceEpoch}'),
                                          );
                                        },
                                    style: FilledButton.styleFrom(
                                      backgroundColor: state.hasJoined ? colors.semanticSuccess : colors.primary,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(AppSpacing.roundedLg),
                                      ),
                                    ),
                                    child: isLoading 
                                      ? const SizedBox(
                                          height: 20, 
                                          width: 20, 
                                          child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)
                                        )
                                      : Text(
                                          state.hasJoined 
                                            ? 'SLOT SECURED' 
                                            : isFull ? 'RAID FULL' : 'JOIN RAID BATTLE',
                                          style: AppTypography.button.copyWith(
                                            color: colors.onPrimary,
                                            letterSpacing: 1.2,
                                          ),
                                        ),
                                  ),
                                ),
                                const SizedBox(height: AppSpacing.md),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      '${state.slotsFilled} / ${state.maxSlots}',
                                      style: AppTypography.titleSm.copyWith(
                                        color: colors.primary,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      'SLOTS OCCUPIED • ATOMIC SYNC',
                                      style: AppTypography.captionUppercase.copyWith(
                                        color: colors.onDarkSoft,
                                        fontSize: 10,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
