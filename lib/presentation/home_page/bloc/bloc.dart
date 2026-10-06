import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pmu_course/presentation/home_page/bloc/events.dart';
import 'package:pmu_course/presentation/home_page/bloc/state.dart';
import 'package:pmu_course/repositories/employee_repository.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final EmployeeRepository repo;

  HomeBloc(this.repo) : super(const HomeState()) {
    on<HomeLoadDataEvent>(_onLoadData);
  }

  void _onLoadData(HomeLoadDataEvent event, Emitter<HomeState> emit) {
    emit(state.copyWith(data: repo.loadData()));
  }
}