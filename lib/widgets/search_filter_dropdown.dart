import 'package:flutter/material.dart';

class SearchFilterDropdown extends StatelessWidget {
  const SearchFilterDropdown({
    super.key,
    required this.selectedBodyPart,
    required this.onChangedBodyPart,
    required this.bodyParts,
  });

  final String? selectedBodyPart;
  final void Function(String? p1) onChangedBodyPart;
  final List<String> bodyParts;

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      isDense: true,
      value: selectedBodyPart,
      onChanged: onChangedBodyPart,
      items: bodyParts.map((String bodyPart) {
        return DropdownMenuItem<String>(
          value: bodyPart,
          child: Text(bodyPart),
        );
      }).toList(),
    );
  }
}
