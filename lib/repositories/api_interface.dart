import 'package:pmu_course/domain/models/home.dart';

typedef OnErrorCallBack = void Function(dynamic error);

abstract class ApiInterface {
  Future<HomeData?> loadData({OnErrorCallBack? onError, String? query});
}