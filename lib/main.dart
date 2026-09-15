import 'package:cryptotrack/data/dataSource.dart';
import 'package:cryptotrack/presentation/Bloc/events.dart';
import 'package:cryptotrack/presentation/screens/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: BlocProvider(
          create: (_) => CryptoBloc(repository: CryptoRepoImpl()),
          child: Home(),
        ),
      ),
    );
  }
}
