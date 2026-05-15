import 'dart:async';
import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:aether_project/core/theme/app_colors.dart';
import 'package:aether_project/core/theme/app_typography.dart';

// @AETHER: ValueNotifier + ValueListenableBuilder = surgical repaints.
// setState here would rebuild the entire screen 10 times per second.
class CountdownTimer extends StatefulWidget {
  final DateTime targetTime;

  const CountdownTimer({
    super.key,
    required this.targetTime,
  });

  @override
  State<CountdownTimer> createState() => _CountdownTimerState();
}

class _CountdownTimerState extends State<CountdownTimer> {
  late final ValueNotifier<Duration> _remaining;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _remaining = ValueNotifier<Duration>(
      widget.targetTime.difference(DateTime.now()),
    );
    
    // @AETHER: High-frequency 100ms heartbeat for drift-free UI updates.
    _timer = Timer.periodic(
      const Duration(milliseconds: 100),
      (_) {
        final diff = widget.targetTime.difference(DateTime.now());
        _remaining.value = diff.isNegative ? Duration.zero : diff;
      },
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _remaining.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Pulse indicator proof
        _PulseIndicator(remaining: _remaining),
        const SizedBox(width: 12),
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'EVENT STARTS IN',
              style: AppTypography.captionUppercase.copyWith(
                color: colors.onDarkSoft,
                fontSize: 10,
              ),
            ),
            RepaintBoundary( // @AETHER: isolates high-frequency text repaints
              child: ValueListenableBuilder<Duration>(
                valueListenable: _remaining,
                builder: (_, dur, __) => Text(
                  _format(dur),
                  style: AppTypography.displayMd.copyWith(
                    color: colors.primary,
                    fontFeatures: const [FontFeature.tabularFigures()],
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  String _format(Duration d) {
    final h = d.inHours.toString().padLeft(2, '0');
    final m = (d.inMinutes % 60).toString().padLeft(2, '0');
    final s = (d.inSeconds % 60).toString().padLeft(2, '0');
    final ms = ((d.inMilliseconds % 1000) ~/ 100).toString();
    return '$h:$m:$s.$ms';
  }
}

class _PulseIndicator extends StatelessWidget {
  final ValueListenable<Duration> remaining;
  const _PulseIndicator({required this.remaining});

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    return ValueListenableBuilder<Duration>(
      valueListenable: remaining,
      builder: (context, duration, _) {
        final bool isOn = duration.inMilliseconds % 200 < 100;
        return Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isOn ? colors.primary : colors.primary.withOpacity(0.2),
            boxShadow: [
              if (isOn)
                BoxShadow(
                  color: colors.primary.withOpacity(0.5),
                  blurRadius: 10,
                ),
            ],
          ),
        );
      },
    );
  }
}
