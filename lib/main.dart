import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop/login/bloc.dart';
import 'package:shop/register/bloc.dart';
import 'package:shop/routes.dart';
import 'package:shop/screens/home/bloc.dart';
import 'create note/bloc.dart';
import 'firebase_options.dart';
import 'note_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<HomeBloc>(
          create: (context) => HomeBloc()),
        BlocProvider<LoginBloc>(
            create: (context) => LoginBloc()),
        BlocProvider<RegisterBloc>(
            create: (context) => RegisterBloc()),
        BlocProvider<CreateNoteBloc>(
            create: (context) => CreateNoteBloc( noteService: NoteService(),)),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Notes App',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.orange),
          useMaterial3: true,
        ),
        initialRoute: Routes.splash,
        onGenerateRoute: RouteGenerator.getRoute,
      ),
    );
  }
}
