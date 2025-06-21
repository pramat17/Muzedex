import 'package:flutter/material.dart';
import 'package:muzedex_app/utils/colors.dart';
import 'package:muzedex_app/widgets/atoms/text_atom.dart';

class ToastMessageMolecule {
  static SnackBar create({
    required String title,
    required String message,
  }) {
    return SnackBar(
      backgroundColor: lightSand,
      behavior: SnackBarBehavior.fixed,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16.0),
          topRight: Radius.circular(16.0),
        ),
      ),
      duration: const Duration(seconds: 3),
      content: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Texte à gauche
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                TextLabel(
                  text: title,
                  fontFamily: 'Belanosima',
                  fontWeight: FontWeight.w600,
                  fontSize: 20.0,
                  color: textBrown,
                ),
                const SizedBox(height: 8.0),
                TextLabel(
                  text: message,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.normal,
                  fontSize: 16.0,
                  color: textBrown.withAlpha(200),
                ),
              ],
            ),
          ),
          Image.asset(
            'assets/images/ppzarafa.png',
            height: 100.0,
            width: 100.0,
            fit: BoxFit.contain,
          ),
        ],
      ),
    );
  }
}
