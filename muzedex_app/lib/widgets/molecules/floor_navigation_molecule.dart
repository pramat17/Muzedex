import 'package:flutter/material.dart';
import 'package:muzedex_app/utils/colors.dart';

class FloorNavigationMolecule extends StatelessWidget {
  final int currentFloor;
  final int floorsCount;
  final Function(int) setCurrentFloor;

  const FloorNavigationMolecule({
    required this.currentFloor,
    required this.floorsCount,
    required this.setCurrentFloor,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: MediaQuery.of(context).size.height * 0.25,
      right: 20,
      child: Column(
        verticalDirection: VerticalDirection.up,
        mainAxisSize: MainAxisSize.min,
        children: List.generate(floorsCount, (index) {
          return Padding(
              padding: const EdgeInsets.only(
                  bottom: 12.5), // Espacement entre les boutons
              child: ElevatedButton(
                  onPressed: () => setCurrentFloor(index),
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        currentFloor == index ? lightBrown : primaryOrange,
                    foregroundColor: Colors.white,
                    shape: const CircleBorder(
                      side: BorderSide(color: lightBrown, width: 2),
                    ),
                    fixedSize: const Size(40, 40),
                  ),
                  child: Text(
                    '$index',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      fontFamily: "Belanosima",
                    ),
                  )));
        }),
      ),
    );
  }
}
