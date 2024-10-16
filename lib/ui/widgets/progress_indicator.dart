import 'package:flutter/material.dart';
import 'package:youbloom/const/colors.dart';

class LightsaberLoadingIndicator extends StatefulWidget {
  final double width;
  final double height;
  final Color color;
  final Duration duration;

  const LightsaberLoadingIndicator({
    Key? key,
    this.width = 200,
    this.height = 5,
    this.color = AppColors.primaryColor,
    this.duration = const Duration(seconds: 4),
  }) : super(key: key);

  @override
  _LightsaberLoadingIndicatorState createState() => _LightsaberLoadingIndicatorState();
}

class _LightsaberLoadingIndicatorState extends State<LightsaberLoadingIndicator> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );
    _animation = Tween<double>(begin: 1, end: 0).animate(_controller);
    _controller.repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      height: widget.height,
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(widget.height / 2),
      ),
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: _animation.value,
            child: Container(
              decoration: BoxDecoration(
                color: widget.color,
                borderRadius: BorderRadius.circular(widget.height / 2),
                boxShadow: [
                  BoxShadow(
                    color: widget.color.withOpacity(0.7),
                    blurRadius: 8,
                    spreadRadius: 2,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}