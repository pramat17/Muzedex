import 'package:flutter/material.dart';
import 'package:muzedex_app/utils/colors.dart';

class HeaderMolecule extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool? hasBackButton;

  const HeaderMolecule({
    super.key,
    required this.title,
    this.hasBackButton,
  });

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(kToolbarHeight),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Image en bas du header (orangeGradient.png)
          Positioned(
            bottom: -kToolbarHeight - 30,
            left: 0,
            right: 0,
            child: Image.asset(
              'assets/images/orangeGradient.png',
              fit: BoxFit.cover,
            ),
          ),
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/woodtexture.png'),
                fit: BoxFit.cover,
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20.0),
                bottomRight: Radius.circular(20.0),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  offset: Offset(0, 2),
                  blurRadius: 6.0,
                ),
              ],
              // Bordures
              border: Border(
                bottom: BorderSide(
                  color: darkBrown,
                  width: 7.0,
                ),
                left: BorderSide(
                  color: darkBrown,
                  width: 7.0,
                ),
                right: BorderSide(
                  color: darkBrown,
                  width: 7.0,
                ),
              ),
            ),
          ),
          // Image en haut du header (leavestop.png)
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Image.asset(
              'assets/images/leavestop.png',
              fit: BoxFit.cover,
            ),
          ),
          AppBar(
            automaticallyImplyLeading: false,
            leading: hasBackButton == true
                ? IconButton(
                    icon: const Icon(Icons.arrow_back,
                        color: Colors.white, size: 30, weight: 900),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  )
                : null,
            title: Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontFamily: 'Belanosima',
                fontWeight: FontWeight.w600,
                letterSpacing: 1.3,
              ),
            ),
            centerTitle: true,
            backgroundColor: Colors.transparent,
            elevation: 0,
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
