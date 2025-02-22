import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lg_task_2/bloc/command_bloc/command_bloc.dart';
import 'package:lg_task_2/bloc/connection_bloc/connection_bloc.dart';
import 'package:lg_task_2/bloc/timeline_bloc/timeline_bloc.dart';
import 'package:lg_task_2/connections/ssh.dart';
import 'package:lg_task_2/screens/home_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});
  final SSH sshInstance = SSH(); 

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ConnectionBloc>(
          create: (context) => ConnectionBloc(ssh: sshInstance),
        ),
        BlocProvider<TimelineBloc>(create: (_) => TimelineBloc()),
        BlocProvider<CommandBloc>(create: (_) => CommandBloc(ssh: sshInstance)),
      ],
      child: ScreenUtilInit(
        designSize: const Size(412, 915),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return MaterialApp(
            title: 'Arindam Liquid Galaxy',
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
              useMaterial3: true,
            ),
            debugShowCheckedModeBanner: false,
            home: const HomeScreen(),
          );
        },
      ),
    );
  }
}
