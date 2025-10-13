import 'package:flutter/material.dart';

class WidDigitRoller extends StatefulWidget {
  final int value;
  final TextStyle? style;
  final Duration duration;

  const WidDigitRoller({super.key, required this.value, this.style, this.duration = const Duration(milliseconds: 700)});

  @override
  State<WidDigitRoller> createState() => _WidDigitRollerState();
}

class _WidDigitRollerState extends State<WidDigitRoller> {
  late bool _isIncreasing;

  @override
  void initState() {
    super.initState();
    _isIncreasing = true;
  }

  @override
  void didUpdateWidget(WidDigitRoller oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      _isIncreasing = widget.value > oldWidget.value;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: widget.duration,
      transitionBuilder: (child, animation) {
        final offsetAnimation = Tween<Offset>(
          begin: _isIncreasing ? const Offset(0, -1) : const Offset(0, 1),
          end: Offset.zero,
        ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOutBack));

        return ClipRect(
          child: SlideTransition(position: offsetAnimation, child: child),
        );
      },
      child: Text('${widget.value}', key: ValueKey<int>(widget.value), style: widget.style),
    );
  }
}
