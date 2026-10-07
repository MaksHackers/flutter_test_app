import 'package:equatable/equatable.dart';
import 'package:pmu_course/domain/models/cardEmployee.dart';

class HomeState extends Equatable {
  final List<CardEmployeeData>? data;
  final bool isLoading;

  const HomeState({
    this.data,
    this.isLoading = false
  });

  HomeState copyWith({List<CardEmployeeData>? data, bool? isLoading}) => HomeState(data: data ?? this.data, isLoading: isLoading ?? this.isLoading);

  @override
  List<Object?> get props => [data, isLoading];
}