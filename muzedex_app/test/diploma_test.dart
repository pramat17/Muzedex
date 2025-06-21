import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:muzedex_app/logics/cubits/room_cubit.dart';
import 'package:muzedex_app/logics/models/item_model.dart';
import 'package:muzedex_app/logics/services/room_service.dart';
import 'package:muzedex_app/widgets/organisms/diploma_organism.dart';
import 'package:muzedex_app/widgets/organisms/muzedex_organism.dart';

import 'mocks.dart';

void main() {
  late RoomService roomService;
  late RoomCubit roomCubit;
  late MockPdfManager pdfManager;

  setUp(() {
    roomService = MockRoomService();
    roomCubit = RoomCubit(roomService);
    pdfManager = MockPdfManager();

    when(() => pdfManager.getDiplomaPath()).thenAnswer((_) async => 'path');
  });

  group('DiplomaPage access tests', () {
    testWidgets('Access Diploma Page from Muzedex when all items are found',
        (WidgetTester tester) async {
      final items = [
        Item(
          id: 1,
          name: 'Python',
          description:
              'Un grand serpent souvent trouvé dans les régions tropicales.',
          tags: ['animal', 'serpent'],
          imageLink: 'assets/images/python.png',
          coordinates: '54:54',
          clues: [],
          isFound: true,
          isRevealed: true,
          whoAmI: "",
        ),
        Item(
          id: 2,
          name: 'Lièvre',
          description: 'Un petit mammifère rapide et agile.',
          tags: ['animal', 'mammifère'],
          imageLink: 'assets/images/lievre.png',
          coordinates: '93:23',
          clues: [],
          isFound: true,
          isRevealed: true,
          whoAmI: "",
        ),
      ];

      await tester.pumpWidget(
        BlocProvider<RoomCubit>.value(
          value: roomCubit,
          child: MaterialApp(
            onGenerateRoute: (settings) {
              if (settings.name == '/diploma') {
                return MaterialPageRoute(
                  builder: (context) => Scaffold(
                    body: DiplomaOrganism(pdfManager: pdfManager),
                  ),
                );
              }
              return null;
            },
            home: Scaffold(
              body: MuzedexOrganism(items: items),
            ),
          ),
        ),
      );
      expect(find.byType(MuzedexOrganism), findsOneWidget);
      expect(
          find.ancestor(
              of: find.byType(SvgPicture),
              matching: find.byType(ElevatedButton)),
          findsOneWidget);

      await tester.tap(find.ancestor(
          of: find.byType(SvgPicture), matching: find.byType(ElevatedButton)));
      await tester.pumpAndSettle();

      expect(find.byType(MuzedexOrganism), findsNothing);
      expect(find.byType(DiplomaOrganism), findsOneWidget);
    });

    testWidgets(
        'No access to Diploma Page from Muzedex when items were not all found',
        (WidgetTester tester) async {
      final items = [
        Item(
          id: 1,
          name: 'Python',
          description:
              'Un grand serpent souvent trouvé dans les régions tropicales.',
          tags: ['animal', 'serpent'],
          imageLink: 'assets/images/python.png',
          coordinates: '54:54',
          clues: [],
          isFound: true,
          isRevealed: true,
          whoAmI: "",
        ),
        Item(
          id: 2,
          name: 'Lièvre',
          description: 'Un petit mammifère rapide et agile.',
          tags: ['animal', 'mammifère'],
          imageLink: 'assets/images/lievre.png',
          coordinates: '93:23',
          clues: [],
          isFound: false,
          isRevealed: false,
          whoAmI: "",
        ),
      ];

      await tester.pumpWidget(
        BlocProvider<RoomCubit>.value(
          value: roomCubit,
          child: MaterialApp(
            onGenerateRoute: (settings) {
              if (settings.name == '/diploma') {
                return MaterialPageRoute(
                  builder: (context) => Scaffold(
                    body: DiplomaOrganism(pdfManager: pdfManager),
                  ),
                );
              }
              return null;
            },
            home: Scaffold(
              body: MuzedexOrganism(items: items),
            ),
          ),
        ),
      );
      expect(find.byType(MuzedexOrganism), findsOneWidget);
      expect(
          find.ancestor(
              of: find.byType(SvgPicture),
              matching: find.byType(ElevatedButton)),
          findsNothing);
    });
  });
}
