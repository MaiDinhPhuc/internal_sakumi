import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/configs/color_configs.dart';
import 'package:internal_sakumi/features/list_student_view.dart';
import 'package:internal_sakumi/firebase_options.dart';
import 'package:internal_sakumi/routes.dart';
import 'package:internal_sakumi/screens/add_class_screen.dart';
import 'package:internal_sakumi/screens/add_student_screen.dart';
import 'package:internal_sakumi/screens/add_teacher_screen.dart';
import 'package:internal_sakumi/screens/add_user_to_class_screen.dart';
import 'package:internal_sakumi/screens/admin_screen.dart';
import 'package:internal_sakumi/screens/detail_class_screen.dart';
import 'package:internal_sakumi/screens/detail_student_screen.dart';
import 'package:internal_sakumi/screens/login_screen.dart';
import 'package:internal_sakumi/screens/master_screen.dart';
import 'package:internal_sakumi/screens/teacher_screen.dart';
import 'package:internal_sakumi/utils/resizable.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Routes.configureRoutes(Routes.router);
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LogInScreen(),
      title: 'Internal Sakumi',
      theme: ThemeData(
        primarySwatch: primaryColor,
      ),
      onGenerateRoute: Routes.router.generator,
    );
    // return MaterialApp(
    //   theme: ThemeData(
    //     primarySwatch: primaryColor,
    //   ),
    //   debugShowCheckedModeBanner: false,
    //   home: LogInScreen(),
    //   onGenerateRoute: Routes.router.generator,
    //   //routes: {
    //   // Routes.master: (context) => const MasterScreen(),
    //   // Routes.teacher: (context) => const TeacherScreen(),
    //   // Routes.admin: (context) => const AdminScreen(),
    //   // //
    //   // Routes.addTeacher: (context) => AddTeacherScreen(),
    //   // Routes.home: (context) => const HomeScreen(),
    //   // Routes.login: (context) => LogInScreen(),
    //   //
    //   // Routes.addUserToClass: (context) {
    //   //   Map map = ModalRoute.of(context)!.settings.arguments as Map;
    //   //   return AddUserToClassScreen(
    //   //       isStudent: map['isStudent'], classId: map['classId']);
    //   // },
    //   //
    //   // Routes.detailClass: (context) {
    //   //   Map map = ModalRoute.of(context)!.settings.arguments as Map;
    //   //   return DetailClassScreen(classModel: map['classModel']);
    //   // },
    //   // Routes.detailStudent: (context) {
    //   //   Map map = ModalRoute.of(context)!.settings.arguments as Map;
    //   //   return DetailStudentScreen(studentModel: map['studentModel']);
    //   // },
    //   // Routes.addClass: (context) {
    //   //   Map map = ModalRoute.of(context)!.settings.arguments as Map;
    //   //   return AddClassScreen(classModel: map['classModel']);
    //   // },
    //   // Routes.addStudent: (context) {
    //   //   Map map = ModalRoute.of(context)!.settings.arguments as Map;
    //   //   return AddStudentScreen(studentModel: map['studentModel']);
    //   // },
    //   //},
    // );
  }
}
