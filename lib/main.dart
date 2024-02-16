import 'package:flutter/material.dart';
import 'package:flutter_tostudy/features/number_trivia/presentation/pages/number_trivia_page.dart';
import 'injection_container.dart' as di;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
     final ThemeData theme = ThemeData(appBarTheme: AppBarTheme(
            backgroundColor: Colors.green.shade800,
          ));
    return MaterialApp(
        title: 'Number Trivia',
        theme: theme.copyWith(colorScheme: theme.colorScheme.copyWith(secondary: Colors.green.shade600)),
        home: const NumberTriviaPage());
  }
}
