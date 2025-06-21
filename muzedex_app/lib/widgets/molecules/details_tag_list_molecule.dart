import 'package:flutter/material.dart';
import 'package:muzedex_app/widgets/atoms/tag_atom.dart';

class DetailsTagListMolecule extends StatelessWidget {
  final List<String> tags;

  const DetailsTagListMolecule({required this.tags, super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Wrap(
        spacing: 8.0,
        runSpacing: 4.0,
        alignment: WrapAlignment.center,
        children: tags.map((tag) => TextLabel(text: tag)).toList(),
      ),
    );
  }
}
