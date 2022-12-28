import 'package:flutter/material.dart';
import 'package:flutter_upgrader/flutter_upgrader_wave.dart';

class LiquidProgressIndicator extends ProgressIndicator {
  final Axis direction;
  final Color? borderColor;
  final double? borderWidth;
  final double? borderRadius;
  final Widget? center;

  const LiquidProgressIndicator({
    Key? key,
    double value = 0.5,
    Color? backgroundColor,
    Animation<Color>? valueColor,
    this.direction = Axis.horizontal,
    this.borderWidth,
    this.borderColor,
    this.borderRadius,
    this.center,
  }) : super(
          key: key,
          value: value,
          valueColor: valueColor,
          backgroundColor: backgroundColor,
        );

  Color getBackgroundColor(BuildContext context) {
    return backgroundColor ?? const Color(0x0000BFFF);
  }

  Color getValueColor(BuildContext context) {
    return valueColor?.value ?? const Color(0x6600BFFF);
  }

  @override
  LiquidProgressIndicatorState createState() => LiquidProgressIndicatorState();
}

class LiquidProgressIndicatorState extends State<LiquidProgressIndicator> {
  @override
  Widget build(BuildContext context) {
    final useBorderColor = widget.borderColor != null;
    final useBorderWidth = widget.borderWidth != null;

    return ClipPath(
      clipper: LinearClipper(
        radius: widget.borderRadius,
      ),
      child: CustomPaint(
        painter: LinearPainter(
          color: widget.getBackgroundColor(context),
          radius: widget.borderRadius,
        ),
        foregroundPainter: useBorderColor && useBorderWidth
            ? LinearBorderPainter(
                color: widget.borderColor!,
                width: widget.borderWidth!,
                radius: widget.borderRadius,
              )
            : null,
        child: Stack(
          children: <Widget>[
            Wave(
              value: widget.value!,
              color: widget.getValueColor(context),
              direction: widget.direction,
            ),
            widget.center != null ? Center(child: widget.center) : Container(),
          ],
        ),
      ),
    );
  }
}

class LinearClipper extends CustomClipper<Path> {
  final double? radius;

  LinearClipper({this.radius});

  @override
  Path getClip(Size size) {
    return Path()
      ..addRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(0, 0, size.width, size.height),
          Radius.circular(radius ?? 0),
        ),
      );
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class LinearBorderPainter extends CustomPainter {
  final Color color;
  final double width;
  final double? radius;

  LinearBorderPainter({
    required this.color,
    required this.width,
    this.radius,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = width;

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(
          width / 2,
          width / 2,
          size.width - width,
          size.height - width,
        ),
        Radius.circular(radius != null ? radius! - width : 0),
      ),
      paint,
    );
  }

  @override
  bool shouldRepaint(LinearBorderPainter oldDelegate) {
    if (color != oldDelegate.color) {
      return true;
    }

    if (width != oldDelegate.width) {
      return true;
    }

    if (radius != oldDelegate.radius) {
      return true;
    }

    return false;
  }
}

class LinearPainter extends CustomPainter {
  final Color color;
  final double? radius;

  LinearPainter({required this.color, this.radius});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(0, 0, size.width, size.height),
        Radius.circular(radius ?? 0),
      ),
      paint,
    );
  }

  @override
  bool shouldRepaint(LinearPainter oldDelegate) {
    return color != oldDelegate.color;
  }
}
