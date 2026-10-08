import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pmu_course/presentation/home_page/bloc/bloc.dart';
import 'package:pmu_course/presentation/home_page/home_page.dart';
import 'package:pmu_course/repositories/employee_repository.dart';

void main() async {
  final employees = [
    Employee(firstName: 'Петр', lastName: 'Петров', position: Position.developer, salary: 90000),
    Employee(firstName: 'Мария', lastName: 'Бикбаева', position: Position.designer, salary: 90000),
    Employee(firstName: 'Иван', lastName: 'Иванов', position: Position.manager, salary: 150000),
    Employee(
      firstName: 'Дмитрий',
      lastName: 'Смирнов',
      position: Position.director,
      salary: 250000,
    ),
    Employee(firstName: 'Анна', lastName: 'Морозова', position: Position.developer, salary: 110000),
  ];

  final highPaid = employees.where((e) => e.isHighPaid()).toList();
  final devs = employees.where((e) => e.position == Position.developer).toList();

  double total = 0;
  for (var e in employees) {
    total += e.salary;
  }
  double average = total / employees.length;

  final nameList = EmployeeList<String>(['Иван', 'Мария']);
  nameList.add('Сергей');

  print('===== ЛАБОРАТОРНАЯ №2 =====');
  print('Всего сотрудников: ${employees.length}');
  print('С высокой зарплатой (>100к): ${highPaid.length}');
  print('Разработчиков: ${devs.length}');
  print('Средняя зарплата: ${average.toStringAsFixed(0)} руб.');
  print('Список имён (Generics): ${nameList.items.join(", ")}');
  print('Сотрудники: ');
  for (var emp in employees) {
    print(
      '${emp.getFullName()} | ${emp.getPositionName()} | ${emp.salary} руб.${emp.isHighPaid() ? ' (высокая)' : ''}',
    );
  }

  await employees[0].addToSystem();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorScheme: .fromSeed(seedColor: Colors.deepPurple)),
      home: RepositoryProvider<EmployeeRepository>(
        lazy: true,
        create: (_) => EmployeeRepository(),
        child: BlocProvider<HomeBloc>(
          lazy: false,
          create: (context) => HomeBloc(context.read<EmployeeRepository>()),
          child: const MyHomePage(title: 'Flutter Demo Home Page'),
        ),
      ),
    );
  }
}
