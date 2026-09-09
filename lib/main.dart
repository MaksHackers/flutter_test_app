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
  final String? imagePath;

  Employee({
    required this.firstName,
    required this.lastName,
    required this.position,
    required this.salary,
    this.imagePath
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
  final Color _color = Colors.orangeAccent;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('Дмитриев Максим Александрович - ПИбд-31', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
      ),
      body: const MyWidget(),
    );
  }
}

class _CardEmployeeData {
  final String text;
  final String descriptionText;
  final String? imageUrl;

  new({required this.text, required this.descriptionText, this.imageUrl});
}

class MyWidget extends StatelessWidget {
  const MyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final employees = [
      _CardEmployeeData(
        text: 'Петр Петров',
        descriptionText: 'Разработчик\n90000 руб.',
        imageUrl: 'assets/images/avatar1.png',
      ),
      _CardEmployeeData(
        text: 'Мария Бикбаева',
        descriptionText: 'Дизайнер\n90000 руб.',
        imageUrl: 'assets/images/avatar2.png',
      ),
      _CardEmployeeData(
        text: 'Иван Иванов',
        descriptionText: 'Менеджер\n150000 руб.',
        imageUrl: 'assets/images/avatar3.png',
      ),
      _CardEmployeeData(
        text: 'Дмитрий Смирнов',
        descriptionText: 'Директор\n250000 руб.',
        imageUrl: 'assets/images/avatar4.png',
      ),
      _CardEmployeeData(
        text: 'Анна Морозова',
        descriptionText: 'Разработчик\n110000 руб.',
        imageUrl: 'assets/images/avatar5.png',
      ),
    ];

    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: employees.map((emp) => _Card.fromData(emp)).toList(),
        ),
      ),
    );
  }
}

class _Card extends StatelessWidget {
  final String text;
  final String descriptionText;
  final String? imageUrl;

  const _Card(this.text, this.descriptionText, this.imageUrl);

  factory _Card.fromData(_CardEmployeeData data) => _Card(data.text, data.descriptionText, data.imageUrl);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              colorScheme.primary,
              colorScheme.primaryContainer,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.grey,
          width: 2,
        ),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(.5) ,spreadRadius: 4, offset: const Offset(0, 5), blurRadius: 8)]
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: SizedBox(
                height: 150,
                width: 150,
                child: Image.asset(
                  imageUrl ?? '',
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => const Placeholder(),
                ),
              ),
            ),
            Flexible(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      text,
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: colorScheme.onPrimary,
                          fontWeight: FontWeight.bold,
                          fontSize: 25,
                          shadows: [
                            Shadow(
                              color: Colors.black,
                              offset: Offset(2, 0),
                            ),
                            Shadow(
                              color: Colors.black,
                              offset: Offset(-2, 0),
                            ),
                            Shadow(
                              color: Colors.black,
                              offset: Offset(0, 2),
                            ),
                            Shadow(
                              color: Colors.black,
                              offset: Offset(0, -2),
                            ),
                          ],
                        ),
                    ),
                    Text(
                      descriptionText,
                      style: Theme.of(context).textTheme.bodyLarge,
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
