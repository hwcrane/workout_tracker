import 'package:flutter/material.dart';
import 'persistance.dart';
import 'exercise.dart';
import 'exercise_page.dart';

class ExerciseListPage extends StatefulWidget {
  const ExerciseListPage({super.key});

  @override
  State<ExerciseListPage> createState() => _ExerciseListPageState();
}

class _ExerciseListPageState extends State<ExerciseListPage> {
  List<Exercise> _exercises = [];
  List<Exercise> _filteredExercises = [];
  List<String> _bodyParts = [];
  List<String> _equipment = [];
  final TextEditingController _searchController = TextEditingController();
  String? _selectedBodyPart = 'Body Part';
  String? _selectedEquipment = "Equipment";

  void _refreshExercises() async {
    final data = await Persistance.getExercises();
    setState(() {
      _exercises = data;
      _bodyParts = _getUniqueBodyParts(data);
      _equipment = _getUniqueEquipment(data);
    });
  }

  List<String> _getUniqueBodyParts(List<Exercise> exercises) {
    Set<String> uniqueBodyParts = {};
    for (var exercise in exercises) {
      uniqueBodyParts.add(exercise.bodyPart);
    }
    return ['Body Part', ...uniqueBodyParts.toList()];
  }

  List<String> _getUniqueEquipment(List<Exercise> exercises) {
    Set<String> uniqueEquipment = {};
    for (var exercise in exercises) {
      uniqueEquipment.add(exercise.equipment);
    }
    return ['Equipment', ...uniqueEquipment.toList()];
  }

  @override
  void initState() {
    super.initState();
    _refreshExercises();
    _searchController.addListener(_filterExercises);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  /// Filters the Exercises Based on the Search bar and Body part dropdown
  void _filterExercises() {
    String filter = _searchController.text.toLowerCase();
    setState(() {
      _filteredExercises = _exercises.where((exercise) {
        bool nameContainsFilter = exercise.name.toLowerCase().contains(filter);
        bool bodyPartMatchesFilter = _selectedBodyPart == 'Body Part' ||
            exercise.bodyPart == _selectedBodyPart;
        bool equipmentMatchesFilter = _selectedEquipment == "Equipment" ||
            exercise.equipment == _selectedEquipment;
        return nameContainsFilter &&
            bodyPartMatchesFilter &&
            equipmentMatchesFilter;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          ExerciseListAppBar(
            searchController: _searchController,
            bodyParts: _bodyParts,
            equipment: _equipment,
            selectedEquipment: _selectedEquipment,
            selectedBodyPart: _selectedBodyPart,
            onChangedBodyPart: (value) {
              setState(() {
                _selectedBodyPart = value;
              });
              _filterExercises();
            },
            onChangedEquipment: (value) {
              setState(() {
                _selectedEquipment = value;
              });
              _filterExercises();
            },
          ),
          ExerciseList(
              exercises:
                  _filteredExercises.isEmpty ? _exercises : _filteredExercises),
        ],
      ),
    );
  }
}

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

class ExerciseList extends StatelessWidget {
  const ExerciseList({
    super.key,
    required List<Exercise> exercises,
  }) : _exercises = exercises;

  final List<Exercise> _exercises;

  @override
  Widget build(BuildContext context) {
    return SliverList.separated(
      itemCount: _exercises.length,
      separatorBuilder: (context, index) => const Divider(),
      itemBuilder: (context, index) {
        return ExerciseListItem(exercise: _exercises[index]);
      },
    );
  }
}

class ExerciseListItem extends StatelessWidget {
  const ExerciseListItem({
    super.key,
    required Exercise exercise,
  }) : _exercise = exercise;

  final Exercise _exercise;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(_exercise.name),
      dense: true,
      subtitle: Text(_exercise.bodyPart),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ExercisePage(
              exercise: _exercise,
            ),
          ),
        );
      },
    );
  }
}
