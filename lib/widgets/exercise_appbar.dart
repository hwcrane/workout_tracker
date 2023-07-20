import 'package:flutter/material.dart';
import 'package:workout_tracker/widgets/search_bar.dart';
import 'package:workout_tracker/widgets/search_filter_dropdown.dart';

class ExerciseAppBar extends StatelessWidget {
  const ExerciseAppBar({
    super.key,
    required this.searchController,
    required this.bodyParts,
    required this.equipment,
    required this.selectedBodyPart,
    required this.selectedEquipment,
    required this.onChangedBodyPart,
    required this.onChangedEquipment,
  });

  final TextEditingController searchController;
  final List<String> bodyParts;
  final String? selectedBodyPart;
  final List<String> equipment;
  final String? selectedEquipment;
  final void Function(String?) onChangedBodyPart;
  final void Function(String?) onChangedEquipment;

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      floating: true,
      pinned: true,
      snap: false,
      title: const Text('Exercises'),
      bottom: AppBar(
        toolbarHeight: 100,
        title: Column(
          children: [
            ExerciseSearchBar(searchController: searchController),
            Row(
              children: [
                const Spacer(),
                SearchFilterDropdown(
                    selectedBodyPart: selectedBodyPart,
                    onChangedBodyPart: onChangedBodyPart,
                    bodyParts: bodyParts),
                const Spacer(),
                SearchFilterDropdown(
                    selectedBodyPart: selectedEquipment,
                    onChangedBodyPart: onChangedEquipment,
                    bodyParts: equipment),
                const Spacer(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
