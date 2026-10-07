import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pmu_course/presentation/home_page/bloc/events.dart';
import 'package:pmu_course/presentation/home_page/bloc/state.dart';
import 'package:pmu_course/repositories/employee_repository.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final EmployeeRepository repo;

  HomeBloc(this.repo) : super(const HomeState()) {
    on<HomeLoadDataEvent>(_onLoadData);
  }

  void _onLoadData(HomeLoadDataEvent event, Emitter<HomeState> emit) async {
    if (event.nextPage == null) {
      emit(state.copyWith(isLoading: true));
    } else {
      emit(state.copyWith(isPaginationLoading: true));
    }

    String? error;

    final data = await repo.loadData(
      query: event.search,
      page: event.nextPage ?? 1,
      onError: (e) => error = e
    );

    if (event.nextPage != null) {
      data?.data?.insertAll(0, state.data?.data ?? []);
    }

    emit(state.copyWith(
      isLoading: false,
      isPaginationLoading: false,
      data: data,
      error: error
    ));
  }
}