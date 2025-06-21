import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_flavor/flutter_flavor.dart';
import 'package:muzedex_app/logics/cubits/room_cubit.dart';
import 'package:muzedex_app/logics/services/item_service.dart';
import 'package:muzedex_app/logics/services/room_service.dart';
import 'package:muzedex_app/pages/details_page.dart';
import 'package:muzedex_app/pages/diploma_page.dart';
import 'package:muzedex_app/pages/end_page.dart';
import 'package:muzedex_app/pages/home_page.dart';
import 'package:muzedex_app/pages/intro_page.dart';
import 'package:muzedex_app/pages/loading_page.dart';
import 'package:muzedex_app/pages/map_page.dart';
import 'package:muzedex_app/pages/muzedex_page.dart';
import 'package:muzedex_app/pages/riddle_page.dart';
import 'package:muzedex_app/pages/tutorial_end_page.dart';
import 'package:muzedex_app/pages/tutorial_page.dart';
import 'package:muzedex_app/utils/colors.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  Future<bool> _initializeApp(RoomCubit roomCubit) async {
    try {
      await roomCubit.fetchRooms();
      return true;
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final baseApiUrl = FlavorConfig.instance.variables["baseApiUrl"];
    final itemService = ItemService(baseApiUrl);
    final roomService = RoomService(baseApiUrl, itemService);

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => RoomCubit(roomService)..fetchRooms()),
      ],
      child: MaterialApp(
        title: 'Muzédex App',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: primaryBlue),
          useMaterial3: true,
          scaffoldBackgroundColor: sand,
        ),
        home: Builder(
          builder: (context) {
            final roomCubit = context.read<RoomCubit>();
            return FutureBuilder<bool>(
              future: _initializeApp(roomCubit),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const LoadingPage();
                } else if (snapshot.hasData && snapshot.data == false) {
                  return const LoadingPage(
                    hasConnectivity: false,
                  );
                } else {
                  return const HomePage();
                }
              },
            );
          },
        ),
        routes: {
          '/home': (context) => const HomePage(),
          '/intro': (context) => const IntroPage(),
          '/tuto': (context) => const TutorialPage(
                isFirstTime: true,
              ),
          '/tutoEnd': (context) => const TutorialEndPage(),
          '/plan': (context) => const MapPage(),
          '/muzedex': (context) => const MuzedexPage(),
          '/end': (context) => const EndPage(),
          '/riddle': (context) => const RiddlePage(),
          '/details': (context) => const DetailsPage(),
          '/diploma': (context) => DiplomaPage(),
        },
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
