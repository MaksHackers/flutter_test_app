import 'package:dio/dio.dart';
import 'package:pmu_course/data/dtos/characters_dto.dart';
import 'package:pmu_course/data/mappers/characters_mapper.dart';
import 'package:pmu_course/domain/models/cardEmployee.dart';
import 'package:pmu_course/repositories/api_interface.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class EmployeeRepository extends ApiInterface {
  static final Dio _dio = Dio()
      ..interceptors.add(PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
      ));

  static const String _baseUrl = '';

  @override
  Future<List<CardEmployeeData>?> loadData({String? query}) async {
    try {
      const String url = '$_baseUrl/v1/characters';

      final Response<dynamic> response = await _dio.get<Map<dynamic, dynamic>>(url, queryParameters: {
        if (query != null && query.isNotEmpty) 'q': query,
      });

      final CharactersDto dto = CharactersDto.fromJson(response.data as Map<String, dynamic>);
      final List<CardEmployeeData>? data = dto.data?.map((e) => e.toDomain()).toList();

      return data;
    } on DioException catch (e) {
      print('DioException: ${e.type} | ${e.message} | ${e.response?.statusCode}');
      return null;
    } catch (e) {
      print('Unexpected error: $e');
      return null;
    }
  }
}