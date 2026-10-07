import 'package:pmu_course/domain/models/cardEmployee.dart';

class HomeData {
  final List<CardEmployeeData>? data;
  final int? nextPage;

  HomeData({this.data, this.nextPage});
}