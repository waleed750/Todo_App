import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/layout/todo_layout.dart';
import 'package:todo_app/shared/bloc_observer/bloc_observer.dart';

void main() {
  BlocOverrides.runZoned(() =>runApp(const MyApp()) ,
  blocObserver: AppBlocObserver()
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeLayout() ,
    );
  }
}




