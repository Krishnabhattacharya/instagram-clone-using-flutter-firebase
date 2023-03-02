import 'package:flutter/material.dart';

class likeAni extends StatefulWidget {
  final Widget child;
  final bool isani;
  final durationtime;
  final VoidCallback? onEnd;
  final bool smallLike;
  const likeAni(
      {super.key,
      required this.child,
      required this.isani,
      this.durationtime = const Duration(milliseconds: 150),
      this.onEnd,
      this.smallLike = false});

  @override
  State<likeAni> createState() => _likeAniState();
}

class _likeAniState extends State<likeAni> with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> scale;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller = AnimationController(
        vsync: this,
        duration:
            Duration(milliseconds: widget.durationtime.inMilliseconds ~/ 2));
    scale = Tween<double>(begin: 1, end: 1.2).animate(controller);
  }

  @override
  void didUpdateWidget(covariant likeAni oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.isani != oldWidget.isani) {
      startAnimation();
    }
  }

  void startAnimation() async {
    if (widget.isani || widget.smallLike) {
      await controller.forward();
      await controller.reverse();
      await Future.delayed(Duration(milliseconds: 200));
      if (widget.onEnd != null) {
        widget.onEnd!();
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: scale,
      child: widget.child,
    );
  }
}
