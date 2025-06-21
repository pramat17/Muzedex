import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:muzedex_app/logics/cubits/room_cubit.dart';
import 'package:muzedex_app/logics/data/file_manager.dart';
import 'package:muzedex_app/logics/models/room_model.dart';
import 'package:muzedex_app/logics/services/item_service.dart';
import 'package:muzedex_app/logics/services/room_service.dart';
import 'package:muzedex_app/pages/muzedex_page.dart';
import 'package:muzedex_app/utils/colors.dart';
import 'package:muzedex_app/widgets/atoms/footer_button_atom.dart';
import 'package:muzedex_app/widgets/molecules/footer_molecule.dart';
import 'package:muzedex_app/widgets/molecules/header_molecule.dart';

/// TestRoomService fournit une liste d'une salle de test pour une intégration plus proche du fonctionnement réel.
class TestRoomService implements RoomService {
  @override
  Future<List<Room>> fetchRooms({required Function(double) onProgress}) async {
    return [
      Room(
        id: 1,
        name: 'Test Room',
        number: 1,
        floor: 1,
        items: [],
        position: '',
      )
    ];
  }

  @override
  String get apiUrl => throw UnimplementedError();

  @override
  FileManager get fileManager => throw UnimplementedError();

  @override
  ItemService get itemService => throw UnimplementedError();
}

void main() {
  group('Footer Basic Rendering and Navigation Tests', () {
    // Création d'un widget testable avec le RoomCubit utilisant TestRoomService.
    Widget createTestableWidget(int currentIndex) {
      return MaterialApp(
        home: BlocProvider<RoomCubit>(
          create: (_) => RoomCubit(TestRoomService()),
          child: Scaffold(
            appBar: HeaderMolecule(
              title: currentIndex == 0 ? 'Plan' : 'Muzedex',
            ),
            bottomNavigationBar: FooterMolecule(currentIndex: currentIndex),
          ),
        ),
        routes: {
          '/plan': (context) => const MaterialApp(),
          '/muzedex': (context) => const MuzedexPage(),
        },
      );
    }

    // TEST: Vérifie que le Footer rend correctement les icônes et labels
    testWidgets('Footer renders icons and labels', (WidgetTester tester) async {
      await tester.pumpWidget(createTestableWidget(0));
      await tester.pumpAndSettle();

      expect(find.byType(SvgPicture), findsNWidgets(3));
      expect(find.byType(FooterButtonAtom), findsNWidgets(3));

      final highlightedIcon = find.byWidgetPredicate((widget) {
        if (widget is Container) {
          return widget.decoration is BoxDecoration &&
              (widget.decoration as BoxDecoration).color == primaryOrange;
        }
        return false;
      });
      expect(highlightedIcon, findsOneWidget);
    });

    // TEST: Vérifie que l'icône active change en fonction du currentIndex
    testWidgets('Footer highlights the active icon based on currentIndex',
        (WidgetTester tester) async {
      await tester.pumpWidget(createTestableWidget(0));
      await tester.pumpAndSettle();
      expect(find.byWidgetPredicate((widget) {
        if (widget is Container) {
          return widget.decoration is BoxDecoration &&
              (widget.decoration as BoxDecoration).color == primaryOrange;
        }
        return false;
      }), findsOneWidget);

      await tester.pumpWidget(createTestableWidget(1));
      await tester.pumpAndSettle();
      expect(find.byWidgetPredicate((widget) {
        if (widget is Container) {
          return widget.decoration is BoxDecoration &&
              (widget.decoration as BoxDecoration).color == primaryOrange;
        }
        return false;
      }), findsOneWidget);
    });
  });
}
