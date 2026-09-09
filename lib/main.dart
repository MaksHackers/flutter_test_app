import 'package:flutter/material.dart';

void main() async {
  final employees = [
    Employee(firstName: 'Петр', lastName: 'Петров', position: Position.developer, salary: 90000),
    Employee(firstName: 'Мария', lastName: 'Бикбаева', position: Position.designer, salary: 90000),
    Employee(firstName: 'Иван', lastName: 'Иванов', position: Position.manager, salary: 150000),
    Employee(firstName: 'Дмитрий', lastName: 'Смирнов', position: Position.director, salary: 250000),
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
    print('${emp.getFullName()} | ${emp.getPositionName()} | ${emp.salary} руб.${emp.isHighPaid() ? ' (высокая)' : ''}');
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
      theme: ThemeData(
        colorScheme: .fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

enum Position {
  developer,
  designer,
  manager,
  director
}

class EmployeeList<T> {
  final List<T> items;
  EmployeeList(this.items);

  int get count => items.length;

  void add(T item) => items.add(item);
}

class Employee {
  final String firstName;
  final String lastName;
  final Position position;
  final double salary;

  Employee({
    required this.firstName,
    required this.lastName,
    required this.position,
    required this.salary
  });

  String getFullName() => '$firstName $lastName';

  String getPositionName() {
    switch (position) {
      case Position.developer: return 'Разработчик';
      case Position.designer: return 'Дизайнер';
      case Position.director: return 'Директор';
      case Position.manager: return 'Менеджер';
    }
  }

  Future<void> addToSystem() async {
    await Future.delayed(Duration(milliseconds: 300));
    print('${getFullName()} добавлен в систему');
  }
}

extension EmployeeExtension on Employee {
  bool isHighPaid() => salary > 100000;
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('Дмитриев Максим Александрович - ПИбд-31', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: .center,
          children: [
            const Text('You have pushed the button this many times:'),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
