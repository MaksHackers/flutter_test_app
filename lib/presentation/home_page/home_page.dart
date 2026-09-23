import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pmu_course/domain/models/cardEmployee.dart';
import 'package:pmu_course/presentation/details_page/details_page.dart';
import 'package:pmu_course/repositories/employee_repository.dart';
import 'package:pmu_course/repositories/mock_repository.dart';

part 'card.dart';

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
      body: const Body(),
    );
  }
}

class Body extends StatelessWidget {
  const Body({super.key});

  @override
  Widget build(BuildContext context) {
    final employees = EmployeeRepository().loadData();

    return
      Padding(
        padding: const EdgeInsets.only(top: MediaQuery.of(context).padding.top),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12),
              child: CupertinoSearchTextField(
                controller: searchController,
                onChanged: (search) {
                  setState(() {
                    data = repo.loadData(q: search);
                  });
                },
              ),
            ),
            Expanded(
              child: Center(
                child: FutureBuilder<List<CardEmployeeData>?>(
                  future: employees,
                  builder: (context, snapshot) => SingleChildScrollView(
                    child: snapshot.hasData
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: snapshot.data?.map((emp) {
                            return _Card.fromData(
                              emp,
                              (title, isLiked) => _showSnackBar(context, title, isLiked),
                              () => _navToDetails(context, emp),);
                            }
                        ).toList() ??
                        [],
                      )
                    : const CircularProgressIndicator()
                  ),
                ),
              ),
            ),
          ],
        ),
      );
}

void _navToDetails(BuildContext context, CardEmployeeData data) {
    Navigator.push(context, CupertinoPageRoute(builder: (context) => DetailsPage(data)));
}

void _showSnackBar(BuildContext context, String title, bool isLiked) {
  WidgetsBinding.instance.addPostFrameCallback((_) {
    final colorScheme = Theme.of(context).colorScheme;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
        'Теперь $title у вас в ${isLiked ? 'любимых' : 'не любимых'}!',
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
          color: colorScheme.primary,
          fontWeight: FontWeight.bold,
        ),
      ),
      backgroundColor: colorScheme.primaryContainer,
      duration: const Duration(seconds: 2),
    ));
  });
}
}
