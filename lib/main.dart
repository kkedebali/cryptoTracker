import 'package:cryptotrack/data/dataSource.dart';
import 'package:cryptotrack/domain/entities/favoritesEntity.dart';
import 'package:cryptotrack/presentation/Bloc/events.dart';
import 'package:cryptotrack/presentation/screens/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';


void main() async {
WidgetsFlutterBinding.ensureInitialized();

  // ----- Hive ----- //
  await Hive.initFlutter();
  Hive.registerAdapter(FavoritesEntityAdapter());
  await Hive.openBox<FavoritesEntity>('favorites_box');

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
