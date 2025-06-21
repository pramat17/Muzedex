import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../utils/colors.dart';
import 'animated_badge_atom.dart';

class FooterButtonAtom extends StatelessWidget {
  final String assetName;
  final int index;
  final int currentIndex;
  final int numberOfNotifications;

  const FooterButtonAtom({
    super.key,
    required this.assetName,
    required this.index,
    required this.currentIndex,
    this.numberOfNotifications = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.0),
            color: currentIndex == index ? primaryOrange : Colors.transparent,
            border: Border.all(
              color: currentIndex == index ? lightBrown : Colors.transparent,
              width: 3.0,
            ),
          ),
          padding: const EdgeInsets.all(10.0),
          child: SvgPicture.asset(
            assetName,
            colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
            width: 25,
            height: 25,
          ),
        ),
        if (numberOfNotifications > 0 && currentIndex != index)
          AnimatedBadgeAtom(text: numberOfNotifications.toString()),
      ],
    );
  }
}
