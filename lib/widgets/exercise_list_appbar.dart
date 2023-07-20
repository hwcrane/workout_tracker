import 'package:flutter/material.dart';

class ExerciseListAppBar extends StatelessWidget {
  const ExerciseListAppBar({
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
            SizedBox(
              width: double.infinity,
              height: 40,
              child: Center(
                child: TextField(
                  controller: searchController,
                  decoration: const InputDecoration(
                    hintText: 'Search',
                    prefixIcon: Icon(Icons.search),
                  ),
                ),
              ),
            ),
            Row(
              children: [
                const Spacer(),
                DropdownButton<String>(
                  value: selectedBodyPart,
                  onChanged: onChangedBodyPart,
                  items: bodyParts.map((String bodyPart) {
                    return DropdownMenuItem<String>(
                      value: bodyPart,
                      child: Text(bodyPart),
                    );
                  }).toList(),
                ),
                const Spacer(),
                DropdownButton<String>(
                  value: selectedEquipment,
                  onChanged: onChangedEquipment,
                  items: equipment.map((String eq) {
                    return DropdownMenuItem<String>(
                      value: eq,
                      child: Text(eq),
                    );
                  }).toList(),
                ),
                const Spacer(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
