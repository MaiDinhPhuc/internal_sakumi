import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/configs/prefKey_configs.dart';
import 'package:internal_sakumi/model/home_teacher/class_model.dart';
import 'package:internal_sakumi/model/user_model.dart';
import 'package:internal_sakumi/providers/firebase/firebase_provider.dart';
import 'package:internal_sakumi/routes.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
  runApp(MyApp());
}

class TeacherDataCubit extends Cubit<int> {
  List<ClassModel2>? classes;

  TeacherDataCubit() : super(0) {
    loadClass();
  }

  loadClass() async {



    SharedPreferences localData = await SharedPreferences.getInstance();
    var teaId = localData.getInt(PrefKeyConfigs.userId);
    if(teaId == null) return;

    var user = await FireBaseProvider.instance.getUserById(teaId);

    if(user.role != 'teacher') return;

    classes = await FireBaseProvider.instance.getClassByTeacherId(teaId);

    debugPrint("======================> loadClass");

    emit(state + 1);
  }
}

class MyApp extends StatelessWidget {
   MyApp({super.key}){


     debugPrint("=========================> new app");
   }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    debugPrint("=========================> build app");

    return MultiBlocProvider(
        providers: [
          // BlocProvider(create: (context) => TeacherCubit()..init(context, AppText.optBoth.text)),
          BlocProvider(create: (context) => AppBarInfoTeacherCubit()),
          BlocProvider<TeacherDataCubit>(create: (context) => TeacherDataCubit()),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          // home: const SplashScreen(),
          title: 'Nội Bộ Sakumi',
          theme: ThemeData(
            primarySwatch: primaryColor,
          ),
          onGenerateRoute: Routes.router.generator,
        ));
  }
}
