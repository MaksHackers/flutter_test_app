// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_locale.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocaleRu extends AppLocale {
  AppLocaleRu([String locale = 'ru']) : super(locale);

  @override
  String get search => 'Search';

  @override
  String get liked => 'в любимых!';

  @override
  String get disliked => 'не в любимых!';

  @override
  String get arbEnding => '';
}
