import 'package:equatable/equatable.dart';
import 'package:pmu_course/domain/models/home.dart';

class HomeState extends Equatable {
  final HomeData? data;
  final bool isLoading;
  final bool isPaginationLoading;
  final String? error;

  const HomeState({
    this.data,
    this.isLoading = false,
    this.isPaginationLoading = false,
    this.error
  });

  HomeState copyWith({HomeData? data, bool? isLoading, bool? isPaginationLoading, String? error}) =>
    HomeState(
      data: data ?? this.data,
      isLoading: isLoading ?? this.isLoading,
      isPaginationLoading: isPaginationLoading ?? this.isPaginationLoading,
      error: error ?? this.error
    );

  @override
  List<Object?> get props => [data, isLoading, isPaginationLoading, error];
}