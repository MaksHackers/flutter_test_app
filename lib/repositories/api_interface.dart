import 'package:pmu_course/domain/models/cardEmployee.dart';

abstract class ApiInterface {
  Future<List<CardEmployeeData>?> loadData();
}