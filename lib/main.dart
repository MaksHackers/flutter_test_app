import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pmu_course/components/locale/l10n/app_locale.dart';
import 'package:pmu_course/data/datasources/db.dart';
import 'package:pmu_course/presentation/home_page/bloc/bloc.dart';
import 'package:pmu_course/presentation/home_page/home_page.dart';
import 'package:pmu_course/presentation/home_page/like_bloc/like_bloc.dart';
import 'package:pmu_course/presentation/home_page/locale_bloc/locale_bloc.dart';
import 'package:pmu_course/presentation/home_page/locale_bloc/locale_state.dart';
import 'package:pmu_course/repositories/employee_repository.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Db.init();
  } catch (e, st) {
    debugPrint('[DB] Ошибка инициализации: $e\n$st');
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<LocaleBloc>(
      lazy: false,
      create: (context) => LocaleBloc(Locale(Platform.localeName.split(RegExp(r'[-_]')).first)),
      child: BlocBuilder<LocaleBloc, LocaleState>(
        builder: (context, state) {
          return MaterialApp(
            title: 'Flutter Demo',
            locale: state.currentLocale,
            localizationsDelegates: AppLocale.localizationsDelegates,
            supportedLocales: AppLocale.supportedLocales,
            debugShowCheckedModeBanner: false,
            theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple)),
            home: RepositoryProvider<EmployeeRepository>(
              lazy: true,
              create: (_) => EmployeeRepository(),
              child: BlocProvider<LikeBloc>(
                lazy: false,
                create: (context) => LikeBloc(),
                child: BlocProvider<HomeBloc>(
                  lazy: false,
                  create: (context) => HomeBloc(context.read<EmployeeRepository>()),
                  child: const MyHomePage(title: 'Flutter Demo Home Page'),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
