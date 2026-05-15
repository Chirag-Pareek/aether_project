import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:aether_project/core/theme/app_colors.dart';
import 'package:aether_project/core/theme/app_spacing.dart';
import 'package:aether_project/core/utils/bouncing_button.dart';
import 'package:aether_project/features/world_event/bloc/world_event_bloc.dart';
import 'package:aether_project/features/world_event/presentation/widgets/countdown_timer.dart';
import 'package:aether_project/features/world_event/presentation/widgets/chat_box.dart';
import 'package:aether_project/raid_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class WorldEventScreen extends StatelessWidget {
  const WorldEventScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => WorldEventBloc(
        raidService: RaidService(firestore: FirebaseFirestore.instance),
      )..add(WorldEventSubscriptionRequested()),
      child: const WorldEventView(),
    );
  }
}

class WorldEventView extends StatefulWidget {
  const WorldEventView({super.key});

  @override
  State<WorldEventView> createState() => _WorldEventViewState();
}

class _WorldEventViewState extends State<WorldEventView> with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _scaleAnimation;
  bool _isMuted = false;
  final GlobalKey _chatBoxKey = GlobalKey();
  final List<int> _slotCharacterIndices = [];
  final Random _random = Random();

  // The sprite sheet has front-facing characters in a grid.
  // Each character is 16x16 in a 256x256 sheet.
  // Bottom-right quadrant has standing poses: 8 cols x 7 rows = 56 characters
  // Starting at pixel (128, 128) in the sheet.
  static const int _spriteSize = 16;
  static const int _sheetSize = 256;
  static const int _gridStartX = 128; // start X of character grid
  static const int _gridStartY = 128; // start Y of character grid 
  static const int _gridCols = 8;
  static const int _totalCharacters = 56; // 8 * 7

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    // Scale 1.0 -> 1.5 -> 1.0
    _scaleAnimation = TweenSequence([
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.5), weight: 1),
      TweenSequenceItem(tween: Tween(begin: 1.5, end: 1.0), weight: 1),
    ]).animate(CurvedAnimation(parent: _animController, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  void _onDragonTap() {
    _animController.forward(from: 0.0);
    if (!_isMuted) {
      SystemSound.play(SystemSoundType.click);
    }
  }

  Widget _buildCharacterSprite(int charIndex) {
    final int col = charIndex % _gridCols;
    final int row = charIndex ~/ _gridCols;
    
    // Calculate the source rect position in the sprite sheet
    final double srcX = (_gridStartX + col * _spriteSize).toDouble();
    final double srcY = (_gridStartY + row * _spriteSize).toDouble();
    
    // Use FittedBox + ClipRect + Align to crop the exact character
    return ClipRect(
      child: SizedBox(
        width: 36,
        height: 36,
        child: FittedBox(
          fit: BoxFit.cover,
          child: Align(
            alignment: Alignment(
              // Map srcX to -1..1 range
              -1.0 + (2.0 * srcX / (_sheetSize - _spriteSize)),
              -1.0 + (2.0 * srcY / (_sheetSize - _spriteSize)),
            ),
            widthFactor: _spriteSize / _sheetSize,
            heightFactor: _spriteSize / _sheetSize,
            child: Image.asset(
              'assets/Characters.png',
              filterQuality: FilterQuality.none, // Keep pixel art crisp
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: Image.asset(
            'assets/background.png',
            fit: BoxFit.cover,
          ),
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          body: SafeArea(
            child: BlocListener<WorldEventBloc, WorldEventState>(
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
              child: SingleChildScrollView(
                physics: const ClampingScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: Column(
                    children: [
                      _buildMainCard(context),
                      const SizedBox(height: AppSpacing.lg),
                      _buildChatCard(context),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMainCard(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.panelBackground,
        border: Border.all(color: AppColors.panelBorder, width: 4),
        borderRadius: BorderRadius.circular(4),
        boxShadow: const [
          BoxShadow(color: Colors.black26, offset: Offset(2, 4), blurRadius: 0),
        ],
      ),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.panelInnerBorder, width: 2),
        ),
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          children: [
            // Header
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'AETHER',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                          letterSpacing: 1.2,
                        ),
                      ),
                      Text(
                        'World Event Manager',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.textPrimary.withValues(alpha: 0.8),
                        ),
                      ),
                    ],
                  ),
                ),
                BouncingButton(
                  onTap: () {
                    setState(() {
                      _isMuted = !_isMuted;
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    margin: const EdgeInsets.only(right: 8),
                    decoration: BoxDecoration(
                      color: AppColors.buttonBg,
                      border: Border.all(color: AppColors.buttonBorder, width: 2),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 200),
                      transitionBuilder: (Widget child, Animation<double> animation) {
                        return ScaleTransition(scale: animation, child: child);
                      },
                      child: Icon(
                        _isMuted ? LucideIcons.volumeX : LucideIcons.volume2,
                        key: ValueKey<bool>(_isMuted),
                        color: AppColors.textPrimary,
                        size: 20,
                      ),
                    ),
                  ),
                ),
                BouncingButton(
                  onTap: () {},
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: AppColors.buttonBg,
                      border: Border.all(color: AppColors.buttonBorder, width: 2),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Icon(
                      LucideIcons.settings,
                      color: AppColors.textPrimary,
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
            
            const Padding(
              padding: EdgeInsets.symmetric(vertical: AppSpacing.sm),
              child: Divider(color: AppColors.panelBorder, thickness: 2),
            ),
            
            // Dragon & Info
            Row(
              children: [
                GestureDetector(
                  onTap: _onDragonTap,
                  child: ScaleTransition(
                    scale: _scaleAnimation,
                    child: Image.asset(
                      'assets/dragon.png',
                      width: 100,
                      height: 100,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'DRAGON RAID',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Starts in',
                        style: TextStyle(fontSize: 12, color: AppColors.textPrimary),
                      ),
                      CountdownTimer(
                        targetTime: DateTime.now().add(const Duration(minutes: 3, seconds: 39)),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Region: Mumbai',
                        style: TextStyle(fontSize: 12, color: AppColors.textPrimary),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: AppSpacing.md),
            
            // Slots
            BlocBuilder<WorldEventBloc, WorldEventState>(
              builder: (context, state) {
                int visualSlots = state.maxSlots;
                int filledBoxes = state.slotsFilled;

                // Ensure we have enough random character indices
                while (_slotCharacterIndices.length < filledBoxes) {
                  _slotCharacterIndices.add(_random.nextInt(_totalCharacters));
                }

                return ConstrainedBox(
                  constraints: const BoxConstraints(maxHeight: 88),
                  child: SingleChildScrollView(
                    child: Wrap(
                      spacing: 8.0,
                      runSpacing: 8.0,
                      alignment: WrapAlignment.center,
                      children: List.generate(visualSlots, (index) {
                        final isFilled = index < filledBoxes;
                        return Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: AppColors.slotBg,
                            border: Border.all(color: AppColors.slotBorder, width: 2),
                          ),
                          child: isFilled
                              ? _buildCharacterSprite(_slotCharacterIndices[index])
                              : null,
                        );
                      }),
                    ),
                  ),
                );
              },
            ),
            
            const SizedBox(height: AppSpacing.lg),
            
            // Join Button
            BlocBuilder<WorldEventBloc, WorldEventState>(
              builder: (context, state) {
                final bool isFull = state.slotsFilled >= state.maxSlots;
                final bool isLoading = state.status == WorldEventStatus.loading;
                
                return Column(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: BouncingButton(
                        child: ElevatedButton.icon(
                          onPressed: (state.hasJoined || isFull || isLoading) 
                            ? null 
                            : () {
                                context.read<WorldEventBloc>().add(
                                  WorldEventJoinRequested('user_${DateTime.now().millisecondsSinceEpoch}'),
                                );
                              },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.buttonBg,
                            foregroundColor: AppColors.textPrimary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                            side: const BorderSide(color: AppColors.buttonBorder, width: 2),
                            elevation: 4,
                            shadowColor: AppColors.buttonShadow,
                          ),
                          icon: const Icon(LucideIcons.swords, size: 20),
                          label: Text(
                            state.hasJoined ? 'Joined' : (isFull ? 'Full' : 'Join Raid'),
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${state.slotsFilled} / ${state.maxSlots} slots occupied',
                      style: const TextStyle(fontSize: 12, color: AppColors.textPrimary),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChatCard(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.panelBackground,
        border: Border.all(color: AppColors.panelBorder, width: 4),
        borderRadius: BorderRadius.circular(4),
        boxShadow: const [
          BoxShadow(color: Colors.black26, offset: Offset(2, 4), blurRadius: 0),
        ],
      ),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.panelInnerBorder, width: 2),
        ),
        padding: const EdgeInsets.all(AppSpacing.md),
        child: ChatBox(
          key: _chatBoxKey,
          raidService: context.read<WorldEventBloc>().raidService,
          userId: 'Player',
        ),
      ),
    );
  }
}
