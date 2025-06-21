import 'package:flutter_bloc/flutter_bloc.dart';

// Etat de l'avancement du dialogue (introduction ou tutoriel)
class DialogueProgressState {
  final int index; // Etape dans le dialogue (introduction ou tutoriel)
  final String? title; // Titre du dialogue (tutoriel)
  final String? imageUrl; // Image du dialogue (tutoriel)
  final String text; // Texte du dialogue (introduction ou tutoriel)

  DialogueProgressState({
    required this.index,
    this.title,
    this.imageUrl,
    required this.text,
  });

  DialogueProgressState copyWith({
    int? index,
    String? title,
    String? imageUrl,
    String? text,
  }) {
    return DialogueProgressState(
      index: index ?? this.index,
      title: title ?? this.title,
      imageUrl: imageUrl ?? this.imageUrl,
      text: text ?? this.text,
    );
  }
}

// State de gestion de la progression de l'introduction et du tutoriel
class DialogueProgressCubit extends Cubit<DialogueProgressState> {
  // Liste des étapes de l'introduction
  static final List<DialogueProgressState> _intros = [
    DialogueProgressState(
      index: 0,
      text:
          "Je me présente : je suis Zarafa, la cheffe d'une équipe d'aventuriers et de chercheurs.",
    ),
    DialogueProgressState(
      index: 1,
      text:
          "Notre objectif est d'explorer et ramener des objets remplis d'histoires au Museum pour les présenter aux visiteurs !",
    ),
    DialogueProgressState(
      index: 2,
      text:
          "Il se trouve que je cherche un nouveau membre à ajouter à mon équipe, et mon petit doigt me dit que tu as toutes les qualités nécessaires !",
    ),
    DialogueProgressState(
      index: 3,
      text:
          "Pour rejoindre mon équipe, je te propose une épreuve de recherche à travers le musée.\nSi tu y parviens, tu feras officiellement partie de mon équipe de recherche !",
    ),
    DialogueProgressState(
      index: 4,
      text:
          "L'épreuve consiste à chercher des objets dans le Museum et compléter ton Muzédex. Le Muzédex, c'est la collection d'objet que tu découvriras à travers ta visite.\nJe vais t’expliquer les bases de cette épreuve.",
    ),
  ];

  // Liste des étapes du tutoriel
  static final List<DialogueProgressState> _tutorials = [
    DialogueProgressState(
        index: 0,
        title: 'Plan du musée',
        imageUrl: 'assets/images/tuto_jeu_0.png',
        text:
            'Pour trouver les objets, tu devras naviguer dans les salles du musée, tu peux utiliser les flèches, les boutons d\'étages ou cliquer sur les salles pour te déplacer.'),
    DialogueProgressState(
        index: 1,
        title: 'Les objets',
        imageUrl: 'assets/images/tuto_jeu_1.png',
        text:
            'Dans chaque salle, tu peux avoir des objets à trouver. Ils seront listés dans la popup déclenchée par ce type de bouton.'),
    DialogueProgressState(
        index: 2,
        title: 'Les énigmes',
        imageUrl: 'assets/images/tuto_jeu_2.png',
        text:
            'Tu trouveras les réponses aux énigmes en cherchant les objets et en explorant le musée.\nCliques sur "Répondre" quand tu penses avoir la réponse !'),
    DialogueProgressState(
        index: 3,
        title: 'Les indices',
        imageUrl: 'assets/images/tuto_jeu_3.png',
        text:
            'Si tu ne parviens pas à trouver la réponse, tu peux demander un indice.\nTu as un nombre limité d\'indices, alors réfléchis-bien !'),
    DialogueProgressState(
        index: 4,
        title: 'Le Muzédex',
        imageUrl: 'assets/images/tuto_jeu_4.png',
        text:
            'Une fois l\'énigme résolue, l\'objet est ajouté à ton Muzédex.\nTu peux consulter ses informations en cliquant sur sa carte. Puis révéler la description de Zarafa !'),
    // Ajoutez plus d'étapes ici
  ];

  // Dialogue sélectionné (prend la valeur de _intros ou _tutorials)
  late List<DialogueProgressState> selectedDialogue;

  // Constructeur du cubit, ou on choisit le type de dialogue que l'on veut utiliser
  DialogueProgressCubit({required String dialogueType})
      : super(_getInitialDialogue(dialogueType)[0]) {
    selectedDialogue = _getInitialDialogue(dialogueType);
  }

  // Fonction statique permettant de déterminer le dialogue choisi
  static List<DialogueProgressState> _getInitialDialogue(String dialogueType) {
    switch (dialogueType) {
      case 'intro':
        return _intros;
      case 'tuto':
        return _tutorials;
      default:
        throw ArgumentError('Invalid dialogue type: $dialogueType');
    }
  }

  // Permet de changer la liste active
  void setDialogue(List<DialogueProgressState> dialogue) {
    if (dialogue == _intros) {
      selectedDialogue = _tutorials;
    } else if (dialogue == _tutorials) {
      selectedDialogue = _intros;
    }
    // Envoie la première étape du dialogue sélectionné
    emit(selectedDialogue[0]);
  }

  // Récupère l'index maximal de la liste selectionnée
  int getMaxIndex() {
    return selectedDialogue.length - 1;
  }

  // Renvoie le texte suivant de l'introduction
  void nextIntro() {
    if (state.index < _intros.length - 1) {
      emit(_intros[state.index + 1]);
    }
  }

  // Renvoie le texte précédent de l'introduction
  void previousIntro() {
    if (state.index > 0) {
      emit(_intros[state.index - 1]);
    }
  }

  // Renvoie le partie suivante du tutoriel
  void nextTutorial() {
    if (state.index < _tutorials.length - 1) {
      emit(_tutorials[state.index + 1]);
    }
  }

  // Renvoie le partie précédente du tutoriel
  void previousTutorial() {
    if (state.index > 0) {
      emit(_tutorials[state.index - 1]);
    }
  }
}
