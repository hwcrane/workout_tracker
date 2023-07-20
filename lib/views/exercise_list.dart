import 'package:flutter/material.dart';
import 'package:workout_tracker/data/dao/exercise_dao.dart';
import 'package:workout_tracker/widgets/exercise_list.dart';
import 'package:workout_tracker/widgets/exercise_appbar.dart';
import '../models/exercise_model.dart';

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
    final data = await ExerciseDAO.getAll();
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
          ExerciseAppBar(
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
