import 'dart:math' as math;
import 'package:flutter/material.dart';

class Wave extends StatefulWidget {
  final Color color;
  final double value;
  final Axis direction;

  const Wave({
    Key? key,
    required this.value,
    required this.color,
    required this.direction,
  }) : super(key: key);

  @override
  WaveState createState() => WaveState();
}

class WaveState extends State<Wave> with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _animationController.repeat();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
      builder: (context, child) => ClipPath(
        clipper: WaveClipper(
          animationValue: _animationController.value,
          direction: widget.direction,
          value: widget.value,
        ),
        child: Container(
          color: widget.color,
        ),
      ),
    );
  }
}

class WaveClipper extends CustomClipper<Path> {
  final double animationValue;
  final Axis direction;
  final double value;

  WaveClipper({
    required this.animationValue,
    required this.direction,
    required this.value,
  });

  @override
  Path getClip(Size size) {
    if (direction == Axis.horizontal) {
      Path path = Path()
        ..addPolygon(_generateHorizontalWavePath(size), false)
        ..lineTo(0.0, size.height)
        ..lineTo(0.0, 0.0)
        ..close();

      return path;
    }

    Path path = Path()
      ..addPolygon(_generateVerticalWavePath(size), false)
      ..lineTo(size.width, size.height)
      ..lineTo(0.0, size.height)
      ..close();

    return path;
  }

  List<Offset> _generateHorizontalWavePath(Size size) {
    final waveList = <Offset>[];

    for (int i = -2; i <= size.height.toInt() + 2; i++) {
      final waveHeight = (size.width / 20);
      final angle = (animationValue * 360 - i) % 360 * (math.pi / 180);
      final base = size.width * value;
      final dx = math.sin(angle) * waveHeight + base;
      waveList.add(Offset(dx, i.toDouble()));
    }

    return waveList;
  }

  List<Offset> _generateVerticalWavePath(Size size) {
    final waveList = <Offset>[];
    for (int i = -2; i <= size.width.toInt() + 2; i++) {
      final waveHeight = (size.height / 20);
      final angle = (animationValue * 360 - i) % 360 * (math.pi / 180);
      final base = size.height - size.height * value;
      final dy = math.sin(angle) * waveHeight + base;
      waveList.add(Offset(i.toDouble(), dy));
    }
    return waveList;
  }

  @override
  bool shouldReclip(WaveClipper oldClipper) {
    return animationValue != oldClipper.animationValue;
  }
}
