import 'package:flutter/material.dart';

class CountDownWidget extends StatefulWidget {
  final Duration duration;

  const CountDownWidget({
    super.key,
    required this.duration,
  });

  @override
  State<CountDownWidget> createState() => _CountDownWidgetState();
}

class _CountDownWidgetState extends State<CountDownWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  String get counterText {
    final Duration duration = _controller.duration! * _controller.value;
    return duration.inSeconds.toString();
  }

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );
    _controller.reverse(from: 1);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              height: 25,
              width: 25,
              child: CircularProgressIndicator(
                backgroundColor: Colors.transparent,
                color: Colors.white,
                value: _controller.value,
                strokeWidth: 2,
              ),
            ),
            Text(
              counterText,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        );
      },
    );
  }
}
