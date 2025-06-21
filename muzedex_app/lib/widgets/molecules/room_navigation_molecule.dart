import 'package:flutter/material.dart';
import 'package:muzedex_app/utils/colors.dart';
import 'package:text_scroll/text_scroll.dart';

class RoomNavigationMolecule extends StatelessWidget {
  final int activeRoomIndex;
  final String activeRoomName;
  final int activeRoomNumber;
  final int totalRooms;
  final VoidCallback? onPrevious;
  final VoidCallback? onNext;

  const RoomNavigationMolecule({
    required this.activeRoomIndex,
    required this.activeRoomNumber,
    required this.activeRoomName,
    required this.totalRooms,
    this.onPrevious,
    this.onNext,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 50,
      left: 0,
      right: 0,
      child: Container(
        decoration: BoxDecoration(
          color: primaryOrange,
          borderRadius: BorderRadius.circular(12.0),
          border: Border.all(
            color: lightBrown,
            width: 3,
          ),
        ),
        height: 45,
        margin: const EdgeInsets.symmetric(horizontal: 35),
        child: Row(
          mainAxisAlignment: totalRooms > 1
              ? MainAxisAlignment.spaceBetween
              : MainAxisAlignment.center,
          children: [
            if (totalRooms > 1)
              IconButton(
                onPressed: activeRoomIndex > 0 ? onPrevious : null,
                icon: const Icon(Icons.chevron_left),
                color: activeRoomIndex > 0 ? Colors.white : Colors.grey,
              ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  activeRoomNumber < 10
                      ? '0$activeRoomNumber'
                      : '$activeRoomNumber',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                    fontFamily: "Inter",
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 5),
                ConstrainedBox(
                  constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.45),
                  child: TextScroll(
                    activeRoomName,
                    mode: TextScrollMode.bouncing,
                    velocity: const Velocity(pixelsPerSecond: Offset(100, 0)),
                    delayBefore: const Duration(milliseconds: 500),
                    pauseBetween: const Duration(milliseconds: 2000),
                    pauseOnBounce: const Duration(milliseconds: 1000),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      fontFamily: "Belanosima",
                      color: Colors.white,
                    ),
                  ),
                )
              ],
            ),
            if (totalRooms > 1)
              IconButton(
                onPressed: activeRoomIndex < totalRooms - 1 ? onNext : null,
                icon: const Icon(Icons.chevron_right),
                color: activeRoomIndex < totalRooms - 1
                    ? Colors.white
                    : Colors.grey,
              ),
          ],
        ),
      ),
    );
  }
}
