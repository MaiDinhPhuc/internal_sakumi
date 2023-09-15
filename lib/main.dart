import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/repository/admin_repository.dart';
import 'package:internal_sakumi/repository/teacher_repository.dart';
import 'package:internal_sakumi/repository/user_repository.dart';
import 'package:internal_sakumi/routes.dart';
import 'package:internal_sakumi/screens/login_screen.dart';
import 'package:internal_sakumi/screens/splash_screen.dart';
import 'package:url_strategy/url_strategy.dart';

import 'configs/color_configs.dart';
import 'features/teacher/profile/app_bar_info_teacher_cubit.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Routes.configureRoutes(Routes.router);
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  setPathUrlStrategy();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
        providers: [
          RepositoryProvider(create: (context) => AdminRepository()),
          RepositoryProvider(create: (context) => TeacherRepository()),
          RepositoryProvider(create: (context) => UserRepository())
        ],
        child: MultiBlocProvider(
            providers: [
              // BlocProvider(create: (context) => TeacherCubit()..init(context, AppText.optBoth.text)),
              BlocProvider(create: (context) => AppBarInfoTeacherCubit()),
            ],
            child: MaterialApp(
              debugShowCheckedModeBanner: false,
              home: const SplashScreen(),
              title: 'Nội Bộ Sakumi',
              theme: ThemeData(
                primarySwatch: primaryColor,
              ),
              onGenerateRoute: Routes.router.generator,
            )));
  }
}
