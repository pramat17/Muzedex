import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:muzedex_app/logics/models/item_model.dart' as model;

class RiddleState extends Equatable {
  final model.Item item;
  final int revealedCluesCount;

  const RiddleState({
    required this.item,
    required this.revealedCluesCount,
  });

  // Nombre total d’indices disponibles
  int get totalClues => item.clues.length;

  // Nombre d’indices restants
  int get remainingClues => totalClues - revealedCluesCount;

  RiddleState copyWith({
    model.Item? item,
    int? revealedCluesCount,
  }) {
    return RiddleState(
      item: item ?? this.item,
      revealedCluesCount: revealedCluesCount ?? this.revealedCluesCount,
    );
  }

  @override
  List<Object?> get props => [item, revealedCluesCount];
}

class RiddleCubit extends Cubit<RiddleState> {
  RiddleCubit({required model.Item item})
      : super(RiddleState(item: item, revealedCluesCount: 1));

  /// Incrémente le nombre d’indices affichés, si on n’a pas atteint le max.
  void revealNextClue() {
    final currentCount = state.revealedCluesCount;
    final total = state.item.clues.length;
    if (currentCount < total) {
      emit(state.copyWith(revealedCluesCount: currentCount + 1));
    }
  }
}