import 'package:equatable/equatable.dart';
import 'package:pmu_course/domain/models/cardEmployee.dart';

class HomeState extends Equatable {
  final Future<List<CardEmployeeData>?>? data;

  const HomeState({this.data});

  HomeState copyWith({Future<List<CardEmployeeData>?>? data}) => HomeState(data: data ?? this.data);

  @override
  List<Object?> get props => [data];
}