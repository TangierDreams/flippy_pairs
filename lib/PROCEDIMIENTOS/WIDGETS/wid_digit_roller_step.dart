import 'dart:async';
import 'package:flutter/material.dart';

class WidDigitRollerStep extends StatefulWidget {
  final int value;
  final TextStyle? style;
  final Duration stepDuration;
  final Duration pause;
  final int maxSteps;

  const WidDigitRollerStep({
    super.key,
    required this.value,
    this.style,
    this.stepDuration = const Duration(milliseconds: 60),
    this.pause = const Duration(milliseconds: 100),
    this.maxSteps = 20,
  });

  @override
  State<WidDigitRollerStep> createState() => _WidDigitRollerStepState();
}

class _WidDigitRollerStepState extends State<WidDigitRollerStep> {
  late int _displayValue;
  bool _isIncreasing = true;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _displayValue = widget.value;
  }

  @override
  void didUpdateWidget(WidDigitRollerStep oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.value != oldWidget.value) {
      _timer?.cancel();
      _isIncreasing = widget.value > oldWidget.value;
      _startRollingAnimation(oldWidget.value, widget.value);
    }
  }

  void _startRollingAnimation(int oldValue, int newValue) async {
    final diff = newValue - oldValue;
    if (diff == 0) return;

    final direction = diff > 0 ? 1 : -1;
    final steps = diff.abs().clamp(1, widget.maxSteps);
    final int stepValue = (diff / steps).round();

    await Future.delayed(widget.pause);

    int current = oldValue;
    _timer = Timer.periodic(widget.stepDuration, (timer) {
      current += stepValue;

      if ((direction > 0 && current >= newValue) || (direction < 0 && current <= newValue)) {
        setState(() => _displayValue = newValue);
        timer.cancel();
      } else {
        setState(() => _displayValue = current);
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 600),
      transitionBuilder: (child, animation) {
        final offsetAnimation = Tween<Offset>(
          begin: _isIncreasing
              ? const Offset(0, -0.4) // de arriba a abajo
              : const Offset(0, 0.4), // de abajo a arriba
          end: Offset.zero,
        ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOutBack));

        return ClipRect(
          child: SlideTransition(position: offsetAnimation, child: child),
        );
      },
      child: Text('$_displayValue', key: ValueKey<int>(_displayValue), style: widget.style),
    );
  }
}
