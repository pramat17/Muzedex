import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:muzedex_app/utils/colors.dart';

class ButtonAtom extends StatelessWidget {
  final String? text;
  final String? iconPath;
  final Color color;
  final Color textColor;
  final VoidCallback? onPressed;
  final bool isFixed;
  final TextStyle textStyle;
  final double iconSize;
  final OutlinedBorder? border;
  final EdgeInsets? textPadding;

  const ButtonAtom({
    super.key,
    this.text,
    this.iconPath,
    required this.color,
    this.onPressed,
    this.isFixed = false,
    this.textColor = white,
    this.iconSize = 20.0,
    this.textStyle = const TextStyle(fontWeight: FontWeight.w700),
    this.border,
    this.textPadding,
  });

  @override
  Widget build(BuildContext context) {
    final hasText = text != null && text!.isNotEmpty;
    final button = ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: textColor,
        disabledBackgroundColor: color,
        disabledForegroundColor: textColor,
        padding: hasText ? textPadding : EdgeInsets.zero,
        minimumSize: hasText ? const Size(64, 36) : Size.zero,
        shape: hasText ? border : const CircleBorder(),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (text != null)
            Text(
              text!,
              style: textStyle,
            ),
          if (iconPath != null && text != null) const SizedBox(width: 8),
          if (iconPath != null) _buildIcon(iconPath!),
        ],
      ),
    );

    if (isFixed) {
      return Stack(
        children: [
          Positioned(child: button),
        ],
      );
    } else {
      return Stack(
        children: [
          button,
        ],
      );
    }
  }

  Widget _buildIcon(String iconPath) {
    final isSvg = iconPath.endsWith('.svg');
    return isSvg
        ? SvgPicture.asset(
            iconPath,
            width: iconSize,
            height: iconSize,
          )
        : Image.asset(
            iconPath,
            width: iconSize,
            height: iconSize,
          );
  }
}
