import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:muzedex_app/utils/colors.dart';

class RiddleAtom extends StatelessWidget {
  final String? imageLink;
  final String type;
  final String? description;
  final double? size;

  const RiddleAtom({
    required this.type,
    this.imageLink,
    this.description,
    this.size,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    // Widget principal selon le type d'énigme
    Widget widgetToShow;

    if (type == 'Shadobject' && imageLink != null) {
      widgetToShow = ColorFiltered(
        colorFilter: const ColorFilter.mode(
          textBrown,
          BlendMode.srcIn,
        ),
        child: Image.file(
          File(imageLink!),
          width: size ?? 300,
          height: size ?? 300,
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) {
            return const Center(
              child: Text(
                'Erreur de chargement de l\'image',
                style: TextStyle(color: Colors.red),
              ),
            );
          },
        ),
      );
    } else if (type == 'FlouFou' && imageLink != null) {
      widgetToShow = ImageFiltered(
        imageFilter: ImageFilter.blur(
          sigmaX: 15,
          sigmaY: 15,
        ),
        child: Image.file(
          File(imageLink!),
          width: size ?? 300,
          height: size ?? 300,
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) {
            return const Center(
              child: Text(
                'Erreur de chargement de l\'image',
                style: TextStyle(color: Colors.red),
              ),
            );
          },
        ),
      );
    } else if (type == 'Qui-suis-je ?' && description != null) {
      widgetToShow = Padding(
        padding: const EdgeInsets.fromLTRB(16.0, 24.0, 16.0, 8.0),
        child: Text(
          description!,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.normal,
            color: textBrown,
            height: 1.4,
          ),
          textAlign: TextAlign.justify,
        ),
      );
    } else if (imageLink != null) {
      widgetToShow = Image.file(
        File(imageLink!),
        width: size ?? 300,
        height: size ?? 300,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) {
          return const Center(
            child: Text(
              'Erreur de chargement de l\'image',
              style: TextStyle(color: Colors.red),
            ),
          );
        },
      );
    } else {
      widgetToShow = const Center(
        child: Text(
          'Type d\'énigme non reconnu',
          style: TextStyle(color: Colors.red),
        ),
      );
    }

    return Align(
      alignment: Alignment.center,
      child: widgetToShow,
    );
  }
}
