import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:aether_project/core/theme/app_colors.dart';
import 'package:aether_project/core/theme/app_typography.dart';

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
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Flexible(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'EVENT STARTS IN',
                style: AppTypography.captionUppercase.copyWith(
                  color: AppColors.onDarkSoft,
                  fontSize: 10,
                ),
              ),
              RepaintBoundary(
                child: ValueListenableBuilder<Duration>(
                  valueListenable: _remaining,
                  builder: (context, dur, child) => FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerLeft,
                    child: Text(
                      _format(dur),
                      style: AppTypography.displayMd.copyWith(
                        color: AppColors.textAccent,
                        fontFeatures: const [FontFeature.tabularFigures()],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        _PulseIndicator(remaining: _remaining),
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
    return ValueListenableBuilder<Duration>(
      valueListenable: remaining,
      builder: (context, duration, _) {
        final bool isOn = duration.inMilliseconds % 200 < 100;
        return Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isOn ? AppColors.textAccent : AppColors.textAccent.withValues(alpha: 0.2),
            boxShadow: [
              if (isOn)
                BoxShadow(
                  color: AppColors.textAccent.withValues(alpha: 0.5),
                  blurRadius: 10,
                ),
            ],
          ),
        );
      },
    );
  }
}
