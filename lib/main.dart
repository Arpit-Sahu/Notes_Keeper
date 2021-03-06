import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/MainScreen.dart';
import 'package:todo/bloc/firebase_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:todo/components.dart';
import 'Test.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await getConnectionStatus();

  // await FirebaseFirestore.instance.enablePersistence();

  FirebaseFirestore.instance.settings =
    Settings(persistenceEnabled: false);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {  
static late final isOnline;  
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => FirebaseBloc(),
      child: MaterialApp(home: MainScreen(),
      //  child: MaterialApp(home: Test(),
      ),
    );
  }
}
