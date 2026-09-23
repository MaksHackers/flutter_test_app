import 'package:pmu_course/domain/models/cardEmployee.dart';
import 'package:pmu_course/repositories/api_interface.dart';

class MockRepository extends ApiInterface{
  @override
  Future<List<CardEmployeeData>?> loadData({String? query}) async {
    final employees = [
      CardEmployeeData(
        text: 'Петр Петров',
        descriptionText: 'Разработчик\n90000 руб.',
        imageUrl: 'assets/images/avatar1.png',
      ),
      CardEmployeeData(
        text: 'Мария Бикбаева',
        descriptionText: 'Дизайнер\n90000 руб.',
        imageUrl: 'assets/images/avatar2.png',
      ),
      CardEmployeeData(
        text: 'Иван Иванов',
        descriptionText: 'Менеджер\n150000 руб.',
        imageUrl: 'assets/images/avatar3.png',
      ),
      CardEmployeeData(
        text: 'Дмитрий Смирнов',
        descriptionText: 'Директор\n250000 руб.',
        imageUrl: 'assets/images/avatar4.png',
      ),
      CardEmployeeData(
        text: 'Анна Морозова',
        descriptionText: 'Разработчик\n110000 руб.',
        imageUrl: 'assets/images/avatar5.png',
      ),
    ];

    final q = query?.trim().toLowerCase() ?? '';
    if (q.isEmpty) return employees;

    return employees.where((e) =>
      e.text.toLowerCase().contains(q) ||
      e.descriptionText.toLowerCase().contains(q),
    ).toList();
  }
}