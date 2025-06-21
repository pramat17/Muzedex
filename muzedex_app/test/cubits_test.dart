import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:muzedex_app/logics/cubits/dialogue_progress_cubit.dart';
import 'package:muzedex_app/logics/cubits/riddle_cubit.dart';
import 'package:muzedex_app/logics/models/clue_model.dart';
import 'package:muzedex_app/logics/models/item_model.dart';

void main() {
  group('DialogueProgressCubit', () {
    test('devrait initialiser avec la première étape d’introduction', () {
      final cubit = DialogueProgressCubit(dialogueType: 'intro');
      expect(cubit.state.index, 0);
      expect(
        cubit.state.text,
        "Je me présente : je suis Zarafa, la cheffe d'une équipe d'aventuriers et de chercheurs.",
      );
    });

    test('devrait initialiser avec la première étape du tutoriel', () {
      final cubit = DialogueProgressCubit(dialogueType: 'tuto');
      expect(cubit.state.index, 0);
      expect(cubit.state.title, 'Plan du musée');
    });

    blocTest<DialogueProgressCubit, DialogueProgressState>(
      'nextIntro() passe à l\'étape suivante',
      build: () => DialogueProgressCubit(dialogueType: 'intro'),
      act: (cubit) => cubit.nextIntro(),
      expect: () => [
        isA<DialogueProgressState>().having((s) => s.index, 'index', 1).having(
            (s) => s.text,
            'text',
            "Notre objectif est d'explorer et ramener des objets remplis d'histoires au Museum pour les présenter aux visiteurs !"),
      ],
    );

    blocTest<DialogueProgressCubit, DialogueProgressState>(
      'previousIntro() revient à l\'étape précédente',
      build: () {
        final cubit = DialogueProgressCubit(dialogueType: 'intro');
        cubit.nextIntro(); // Passe à l'étape 1
        return cubit;
      },
      act: (cubit) => cubit.previousIntro(),
      expect: () => [
        isA<DialogueProgressState>().having((s) => s.index, 'index', 0).having(
            (s) => s.text,
            'text',
            "Je me présente : je suis Zarafa, la cheffe d'une équipe d'aventuriers et de chercheurs."),
      ],
    );

    blocTest<DialogueProgressCubit, DialogueProgressState>(
      'nextTutorial() passe à l\'étape suivante',
      build: () => DialogueProgressCubit(dialogueType: 'tuto'),
      act: (cubit) => cubit.nextTutorial(),
      expect: () => [
        isA<DialogueProgressState>()
            .having((s) => s.index, 'index', 1)
            .having((s) => s.title, 'title', "Les objets")
            .having((s) => s.text, 'text',
                "Dans chaque salle, tu peux avoir des objets à trouver. Ils seront listés dans la popup déclenchée par ce type de bouton."),
      ],
    );

    blocTest<DialogueProgressCubit, DialogueProgressState>(
      'previousTutorial() revient à l\'étape précédente',
      build: () {
        final cubit = DialogueProgressCubit(dialogueType: 'tuto');
        cubit.nextTutorial(); // Passe à l'étape 1
        return cubit;
      },
      act: (cubit) => cubit.previousTutorial(),
      expect: () => [
        isA<DialogueProgressState>()
            .having((s) => s.index, 'index', 0)
            .having((s) => s.title, 'title', "Plan du musée")
            .having((s) => s.text, 'text',
                "Pour trouver les objets, tu devras naviguer dans les salles du musée, tu peux utiliser les flèches, les boutons d'étages ou cliquer sur les salles pour te déplacer."),
      ],
    );
  });

  group('RiddleCubit', () {
    late Item testItem;

    setUp(() {
      testItem = Item(
        id: 1,
        name: "Objet Test",
        description: "Un objet test",
        tags: ["test"],
        imageLink: "test.png",
        coordinates: "0,0",
        clues: [
          Clue(id: 1, text: "Indice 1", type: 'text'),
          Clue(id: 2, text: "Indice 2", type: 'text'),
          Clue(id: 3, text: "Indice 3", type: 'text'),
        ],
        isFound: false,
        isRevealed: false,
        whoAmI: "Je suis un test",
      );
    });

    test('devrait initialiser avec un seul indice révélé', () {
      final cubit = RiddleCubit(item: testItem);
      expect(cubit.state.revealedCluesCount, 1);
    });

    blocTest<RiddleCubit, RiddleState>(
      'revealNextClue() incrémente revealedCluesCount',
      build: () => RiddleCubit(item: testItem),
      act: (cubit) => cubit.revealNextClue(),
      expect: () => [
        isA<RiddleState>()
            .having((s) => s.revealedCluesCount, 'revealedCluesCount', 2),
      ],
    );

    blocTest<RiddleCubit, RiddleState>(
      'revealNextClue() ne dépasse pas le nombre total d\'indices',
      build: () => RiddleCubit(item: testItem),
      act: (cubit) {
        cubit.revealNextClue(); // passe de 1 à 2
        cubit.revealNextClue(); // passe de 2 à 3 (max, car clues.length == 3)
        cubit.revealNextClue(); // aucun changement attendu
      },
      expect: () => [
        isA<RiddleState>()
            .having((s) => s.revealedCluesCount, 'revealedCluesCount', 2),
        isA<RiddleState>()
            .having((s) => s.revealedCluesCount, 'revealedCluesCount', 3),
      ],
    );
  });
}
