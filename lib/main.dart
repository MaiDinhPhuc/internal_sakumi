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
      theme: ThemeData(
        primarySwatch: primaryColor,
      ),
      debugShowCheckedModeBanner: false,
      home: AdminScreen(),
      routes: {
        Routes.master: (context) => const MasterScreen(),
        Routes.teacher: (context) => const TeacherScreen(),
        Routes.admin: (context) => const AdminScreen(),
        //
        Routes.addTeacher: (context) => AddTeacherScreen(),
        Routes.home: (context) => const HomeScreen(),
        Routes.login: (context) => LogInScreen(),

        Routes.addUserToClass: (context) {
          Map map = ModalRoute.of(context)!.settings.arguments as Map;
          return AddUserToClassScreen(
              isStudent: map['isStudent'], classId: map['classId']);
        },

        Routes.detailClass: (context) {
          Map map = ModalRoute.of(context)!.settings.arguments as Map;
          return DetailClassScreen(classModel: map['classModel']);
        },
        Routes.detailStudent: (context) {
          Map map = ModalRoute.of(context)!.settings.arguments as Map;
          return DetailStudentScreen(studentModel: map['studentModel']);
        },
        Routes.addClass: (context) {
          Map map = ModalRoute.of(context)!.settings.arguments as Map;
          return AddClassScreen(classModel: map['classModel']);
        },
        Routes.addStudent: (context) {
          Map map = ModalRoute.of(context)!.settings.arguments as Map;
          return AddStudentScreen(studentModel: map['studentModel']);
        },

        // Routes.classes: (context) => ListClassView(),
        //profile
        // Routes.profile: (context) => ProfileScreen(),
        // Routes.changePassword: (context) {
        //   Map map = ModalRoute.of(context)!.settings.arguments as Map;
        //   return ChangePasswordScreen(email: map['email']);
        // },
      },
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    debugPrint(
        "==================> ${MediaQuery.of(context).size.width} == ${MediaQuery.of(context).size.height} == ${Resizable.isTablet(context)}");
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text("Home",
                style: TextStyle(
                    fontSize: //20
                        Resizable.font(context, 20))),
            Text("Home", style: TextStyle(fontSize: 20))
          ],
        ),
      ),
      body: Center(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 100,
                  width: 100,
                  decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(20)),
                  child: const Text("Internal Sakumi",
                      style: TextStyle(fontSize: 16)),
                ),
                SizedBox(width: 10),
                Container(
                  height: Resizable.size(context, 100),
                  width: Resizable.size(context, 100),
                  decoration: BoxDecoration(
                      color: Colors.orange,
                      borderRadius:
                          BorderRadius.circular(Resizable.size(context, 20))),
                  child: Text("Internal Sakumi",
                      style: TextStyle(
                          fontSize: //16
                              Resizable.font(context, 16))),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
