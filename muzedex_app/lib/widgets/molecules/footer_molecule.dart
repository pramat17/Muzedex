import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:muzedex_app/logics/cubits/room_cubit.dart';
import 'package:muzedex_app/logics/models/item_model.dart';
import 'package:muzedex_app/pages/map_page.dart';
import 'package:muzedex_app/pages/muzedex_page.dart';
import 'package:muzedex_app/pages/tutorial_page.dart';
import 'package:muzedex_app/widgets/atoms/footer_button_atom.dart';

import '../../utils/colors.dart';

class FooterMolecule extends StatelessWidget {
  final int currentIndex;
  final Item? itemJustFound;

  const FooterMolecule(
      {super.key, required this.currentIndex, this.itemJustFound});

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        // Positioned(
        //   top: -90,
        //   left: 0,
        //   right: 0,
        //   child: Image.asset(
        //     'assets/images/orangeGradientBottom.png',
        //     fit: BoxFit.cover,
        //   ),
        // ),
        Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/woodtexture.png'),
              fit: BoxFit.cover,
            ),
            border: Border(
              top: BorderSide(
                color: darkBrown,
                width: 7.0,
              ),
            ),
          ),
          padding: const EdgeInsets.only(top: 15.0, bottom: 15.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () => _navigateToPage(context, 0, noAnimation: true),
                child: FooterButtonAtom(
                  assetName: 'assets/icons/plan_icon.svg',
                  index: 0,
                  currentIndex: currentIndex,
                ),
              ),
              const SizedBox(width: 25),
              GestureDetector(
                onTap: () => _navigateToPage(context, 1,
                    noAnimation: true,
                    arguments: {'itemJustFound': itemJustFound}),
                child: FooterButtonAtom(
                  assetName: "assets/icons/muzedex_icon.svg",
                  index: 1,
                  currentIndex: currentIndex,
                  numberOfNotifications: BlocProvider.of<RoomCubit>(context).getNumberOfFoundButUnrevealedItems(),
                ),
              ),
              const SizedBox(width: 25),
              GestureDetector(
                onTap: () => _navigateToPage(context, 2, noAnimation: true),
                child: FooterButtonAtom(
                  assetName: "assets/icons/tutorial_icon.svg",
                  index: 2,
                  currentIndex: currentIndex,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _navigateToPage(BuildContext context, int index,
      {required bool noAnimation, Map<String, dynamic>? arguments}) {
    final route = ['/plan','/muzedex','/tuto'];
    if (ModalRoute.of(context)?.settings.name != route[index]) {
      if (noAnimation) {
        Navigator.of(context)
            .pushReplacement(_noAnimationRoute(route[index], arguments));
      } else {
        Navigator.of(context).pushReplacementNamed(route[index]);
      }
    }
  }

  PageRouteBuilder _noAnimationRoute(
      String routeName, Map<String, dynamic>? arguments) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) {

        final pages = {
          '/plan': const MapPage(),
          '/muzedex': const MuzedexPage(),
          '/tuto': const TutorialPage(isFirstTime: false,),
        };

        return pages[routeName] ?? const MapPage(); 
      },
      settings: RouteSettings(name: routeName, arguments: arguments),
      transitionDuration: const Duration(seconds: 0),
    );
  }
  
}


