import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:muzedex_app/logics/cubits/room_cubit.dart';
import 'package:muzedex_app/logics/data/file_manager.dart';
import 'package:muzedex_app/logics/models/item_model.dart';
import 'package:muzedex_app/logics/models/room_model.dart';
import 'package:muzedex_app/logics/services/item_service.dart';
import 'package:muzedex_app/logics/services/room_service.dart';
import 'package:muzedex_app/widgets/molecules/details_room_molecule.dart';
import 'package:muzedex_app/widgets/molecules/details_subject_molecule.dart';
import 'package:muzedex_app/widgets/molecules/details_tag_list_molecule.dart';
import 'package:muzedex_app/widgets/organisms/details_card_organism.dart';

/// TestRoomService fournit une implémentation minimale pour le RoomCubit.
class TestRoomService implements RoomService {
  @override
  Future<List<Room>> fetchRooms(
          {required dynamic Function(double) onProgress}) async =>
      [];

  @override
  String get apiUrl => '';

  @override
  FileManager get fileManager => throw UnimplementedError();

  @override
  ItemService get itemService => throw UnimplementedError();
}

void main() {
  group('Details Page Tests', () {
    testWidgets('DetailsSubjectMolecule displays number and label',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: DetailsSubjectMolecule(
              number: '12',
              label: 'Girafe',
            ),
          ),
        ),
      );
      // Au lieu de pumpAndSettle, on attend une durée déterminée
      await tester.pump(const Duration(seconds: 2));
      expect(find.text('12'), findsOneWidget);
      expect(find.text('Girafe'), findsOneWidget);
    });

    testWidgets('DetailsRoom displays the room label',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: DetailsRoomMolecule(label: 'Animaux des marais'),
          ),
        ),
      );
      await tester.pump(const Duration(seconds: 2));
      expect(find.text('Animaux des marais'), findsOneWidget);
    });

    testWidgets('DetailsTagList displays tags correctly',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: DetailsTagListMolecule(tags: ['Test']),
          ),
        ),
      );
      await tester.pump(const Duration(seconds: 2));
      expect(find.text('Test'), findsOneWidget);
    });

    testWidgets('DetailsCard displays all details correctly',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            // Fourniture d'un RoomCubit via BlocProvider comme dans le test Footer.
            body: BlocProvider<RoomCubit>(
              create: (_) => RoomCubit(TestRoomService()),
              child: DetailsCard(
                item: Item(
                  id: 1,
                  name: "Girafe",
                  imageLink: "assets/images/girafe.png",
                  tags: ["Mammifère", "Savane"],
                  description: "Une girafe",
                  isFound: false,
                  isRevealed: false,
                  // Coordonnées au format correct
                  coordinates: "0.0,0.0",
                  clues: [],
                  whoAmI: "",
                ),
                itemNumber: 12,
                roomName: 'Animaux des marais',
              ),
            ),
          ),
        ),
      );
      await tester.pump(const Duration(seconds: 2));

      // Recherche par prédicat pour trouver les textes attendus.
      final girafeFinder = find.byWidgetPredicate((widget) =>
          widget is Text &&
          widget.data != null &&
          widget.data!.contains("Girafe"));
      expect(girafeFinder, findsOneWidget);

      final numberFinder = find.byWidgetPredicate((widget) =>
          widget is Text && widget.data != null && widget.data!.contains("12"));
      expect(numberFinder, findsOneWidget);

      final roomNameFinder = find.byWidgetPredicate((widget) =>
          widget is Text &&
          widget.data != null &&
          widget.data!.contains("Animaux des marais"));
      expect(roomNameFinder, findsOneWidget);

      final tagFinder = find.byWidgetPredicate((widget) =>
          widget is Text &&
          widget.data != null &&
          widget.data!.contains("Mammifère"));
      expect(tagFinder, findsOneWidget);

      final descFinder = find.byWidgetPredicate((widget) =>
          widget is Text &&
          widget.data != null &&
          widget.data!.contains("Une girafe"));
      expect(descFinder, findsOneWidget);
    });
  });
}
