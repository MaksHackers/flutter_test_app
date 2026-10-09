import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pmu_course/data/datasources/db.dart';
import 'package:pmu_course/presentation/home_page/like_bloc/like_event.dart';
import 'package:pmu_course/presentation/home_page/like_bloc/like_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String _likedPrefsKey = 'liked';

class LikeBloc extends Bloc<LikeEvent, LikeState> {
  final Db _db;

  LikeBloc({Db? db})
      : _db = db ?? Db(),
        super(const LikeState(likedIds: [])) {
    on<ChangeLikeEvent>(_onChangeLike);
    on<LoadLikesEvent>(_onLoadLikes);
  }

  Future<void> _onLoadLikes(LoadLikesEvent event, Emitter<LikeState> emit) async {
    try {
      final ids = await _db.loadLikes();
      emit(state.copyWith(likedIds: ids));
    } catch (e, st) {
      print('[LikeBloc] Ошибка загрузки лайков: $e\n$st');
    }
  }

  Future<void> _onChangeLike(ChangeLikeEvent event, Emitter<LikeState> emit) async {
    try {
      final isLiked = state.likedIds.contains(event.id);

      if (isLiked) {
        await _db.removeLike(event.id);
        final updated = List<String>.from(state.likedIds)..remove(event.id);
        emit(state.copyWith(likedIds: updated));
      } else {
        await _db.addLike(event.id);
        final updated = List<String>.from(state.likedIds)..add(event.id);
        emit(state.copyWith(likedIds: updated));
      }
    } catch (e, st) {
      print('[LikeBloc] Ошибка изменения лайка: $e\n$st');
    }
  }

  @override
  Future<void> close() async {
    await _db.close();
    return super.close();
  }
}