import 'package:flutter/material.dart';
import 'package:muzedex_app/utils/colors.dart';

class HandAnimationAtom extends StatefulWidget {
  const HandAnimationAtom({super.key});

  @override
  HandAnimationAtomState createState() => HandAnimationAtomState();
}

class HandAnimationAtomState extends State<HandAnimationAtom> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 0, end: 20).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _animation.value),
          child: child,
        );
      },
      child: const Icon(
        Icons.touch_app,
        size: 100,
        color: lightBrown,
      ),
    );
  }
}
