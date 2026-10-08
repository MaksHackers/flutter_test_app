import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pmu_course/common/svg_objects.dart';
import 'package:pmu_course/components/extensions/context_x.dart';
import 'package:pmu_course/components/utils/debounce.dart';
import 'package:pmu_course/domain/models/cardEmployee.dart';
import 'package:pmu_course/presentation/details_page/details_page.dart';
import 'package:pmu_course/presentation/home_page/bloc/bloc.dart';
import 'package:pmu_course/presentation/home_page/bloc/events.dart';
import 'package:pmu_course/presentation/home_page/bloc/state.dart';
import 'package:pmu_course/presentation/home_page/locale_bloc/locale_bloc.dart';
import 'package:pmu_course/presentation/home_page/locale_bloc/locale_events.dart';
import 'package:pmu_course/presentation/home_page/locale_bloc/locale_state.dart';

part 'card.dart';

enum Position { developer, designer, manager, director }

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
    this.imagePath,
  });

  String getFullName() => '$firstName $lastName';

  String getPositionName() {
    switch (position) {
      case Position.developer:
        return 'Разработчик';
      case Position.designer:
        return 'Дизайнер';
      case Position.director:
        return 'Директор';
      case Position.manager:
        return 'Менеджер';
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
        title: Text(
          'Дмитриев Максим Александрович - ПИбд-31',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
      body: const _Body(),
    );
  }
}

class _Body extends StatefulWidget {
  const _Body({super.key});

  @override
  State<_Body> createState() => _BodyState();
}

class _BodyState extends State<_Body> {
  final searchController = TextEditingController();
  final scrollController = ScrollController();

  @override
  void initState() {
    SvgObjects.init();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HomeBloc>().add(const HomeLoadDataEvent());
    });

    scrollController.addListener(_onNextPageListener);

    super.initState();
  }

  void _onNextPageListener() {
    if (scrollController.offset >= scrollController.position.maxScrollExtent) {
      final bloc = context.read<HomeBloc>();
      if (!bloc.state.isPaginationLoading && bloc.state.data?.nextPage != null) {
        bloc.add(
          HomeLoadDataEvent(search: searchController.text, nextPage: bloc.state.data?.nextPage),
        );
      }
    }
  }

  @override
  void dispose() {
    searchController.dispose();
    scrollController.dispose();
    super.dispose();
  }

  Future<void> _onRefresh() {
    context.read<HomeBloc>().add(HomeLoadDataEvent(search: searchController.text));
    return Future.value(null);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
      child: StatefulBuilder(
        builder: (context, setState) => Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: CupertinoSearchTextField(
                      controller: searchController,
                      placeholder: context.locale.search,
                      onChanged: (search) {
                        Debounce.run(
                          () => context.read<HomeBloc>().add(HomeLoadDataEvent(search: search)),
                        );
                      },
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () => context.read<LocaleBloc>().add(const ChangeLocaleEvent()),
                  child: SizedBox.square(
                    dimension: 50,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 12),
                      child: BlocBuilder<LocaleBloc, LocaleState>(
                          builder: (context, state) {
                            return state.currentLocale.languageCode == 'ru'
                                ? const SvgRu()
                                : const SvgUk();
                          }
                      ),
                    ),
                  ),
                )
              ],
            ),
            BlocBuilder<HomeBloc, HomeState>(
              builder: (context, state) => state.error != null
                  ? Text(
                      state.error ?? '',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: Colors.red),
                    )
                  : state.isLoading
                  ? const CircularProgressIndicator()
                  : Expanded(
                      child: RefreshIndicator(
                        onRefresh: _onRefresh,
                        child: ListView.builder(
                          controller: scrollController,
                          padding: EdgeInsets.zero,
                          itemCount: state.data?.data?.length ?? 0,
                          itemBuilder: (context, index) {
                            final data = state.data?.data?[index];
                            return data != null
                                ? _Card.fromData(
                                    data,
                                    ((title, isLiked) => _showSnackBar(context, title, isLiked)),
                                    () => _navToDetails(context, data),
                                  )
                                : const SizedBox.shrink();
                          },
                        ),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  void _navToDetails(BuildContext context, CardEmployeeData data) {
    Navigator.push(context, CupertinoPageRoute(builder: (context) => DetailsPage(data)));
  }

  void _showSnackBar(BuildContext context, String title, bool isLiked) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final colorScheme = Theme.of(context).colorScheme;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '$title ${isLiked ? context.locale.liked : context.locale.disliked}!',
            style: Theme.of(context).textTheme.bodyLarge
                ?.copyWith(color: colorScheme.primary, fontWeight: FontWeight.bold),
          ),
          backgroundColor: colorScheme.primaryContainer,
          duration: const Duration(seconds: 2),
        ),
      );
    });
  }
}
