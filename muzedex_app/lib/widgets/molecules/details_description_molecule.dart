import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:muzedex_app/logics/cubits/room_cubit.dart';
import 'package:muzedex_app/utils/colors.dart';
import 'package:muzedex_app/widgets/atoms/hand_animation_atom.dart';
import 'package:reveal_text/reveal_text.dart';

class DetailsDescriptionMolecule extends StatefulWidget {
  final bool isRevealed;
  final String description;
  final int itemId;

  const DetailsDescriptionMolecule({
    super.key,
    required this.isRevealed,
    required this.description,
    required this.itemId,
  });

  @override
  DetailsDescriptionMoleculeState createState() =>
      DetailsDescriptionMoleculeState();
}

class DetailsDescriptionMoleculeState
    extends State<DetailsDescriptionMolecule> {
  bool _isRevealed = false;

  @override
  void initState() {
    super.initState();
    _isRevealed = widget.isRevealed;
  }

  void _handleReveal() {
    if (!_isRevealed) {
      BlocProvider.of<RoomCubit>(context).revealItem(widget.itemId);
      setState(() {
        _isRevealed = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleReveal,
      child: Container(
        padding: const EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          color: white,
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: _isRevealed
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset(
                    'assets/images/zarafa_image.png',
                    height: 50,
                  ),
                  const SizedBox(height: 5),
                  RevealText(
                    text: widget.description,
                    textStyle: const TextStyle(
                      color: textBrown,
                      fontSize: 14,
                      fontFamily: 'Inter',
                    ),
                    animateBy: AnimationType.words,
                    delay: const Duration(milliseconds: 35),
                  ),
                ],
              )
            : Stack(
                alignment: Alignment.topCenter,
                clipBehavior: Clip.none,
                children: [
                  ImageFiltered(
                    imageFilter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Image.asset(
                          'assets/images/zarafa_image.png',
                          height: 50,
                        ),
                        const SizedBox(height: 5),
                        SingleChildScrollView(
                          child: Text(
                            widget.description,
                            style: const TextStyle(
                              color: textBrown,
                              fontSize: 14,
                              fontFamily: 'Inter',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const HandAnimationAtom()
                ],
              ),
      ),
    );
  }
}
