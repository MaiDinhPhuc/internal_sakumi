import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/features/admin/search/search_cubit.dart';
import 'package:internal_sakumi/providers/cache/filter_admin_provider.dart';
import 'package:internal_sakumi/providers/cache/filter_manage_bill_provider.dart';
import 'package:internal_sakumi/providers/cache/filter_statistic_provider.dart';
import 'package:internal_sakumi/providers/cache/filter_teacher_provider.dart';
import 'package:internal_sakumi/routes.dart';
import 'package:url_strategy/url_strategy.dart';
import 'package:timezone/data/latest.dart' as tz;

import 'configs/color_configs.dart';
import 'features/admin_v2/manage_class_v2/class_cubit_v2.dart';
import 'features/master/manage_course/manage_course_cubit.dart';
import 'features/master/manage_student_survey/manage_student_survey_cubit.dart';
import 'features/master/manage_teacher_survey/change_tab_cubit.dart';
import 'features/master/manage_teacher_survey/manage_assign_teacher_survey_cubit.dart';
import 'features/master/manage_teacher_survey/manage_teacher_survey_cubit.dart';
import 'features/teacher/profile/teacher_profile/app_bar_info_teacher_cubit.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  tz.initializeTimeZones();
  Routes.configureRoutes(Routes.router);
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  setPathUrlStrategy();
  runApp(const MyApp());
}



class MyApp extends StatelessWidget {
   const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => AppBarInfoTeacherCubit()),
          BlocProvider<ChangeTabManageTeacherSurveyCubit>(create: (context) => ChangeTabManageTeacherSurveyCubit()),
          BlocProvider<SearchCubit>(create: (context) => SearchCubit()),
          BlocProvider<ClassCubit>(create: (context) => ClassCubit()),
          BlocProvider<ManageTeacherSurveyCubit>(create: (context) => ManageTeacherSurveyCubit()),
          BlocProvider<ManageAssignTeacherSurveyCubit>(create: (context) => ManageAssignTeacherSurveyCubit()),
          BlocProvider<ManageStudentSurveyCubit>(create: (context) => ManageStudentSurveyCubit()),
          BlocProvider<AdminClassFilterCubit>(create: (context)=>AdminClassFilterCubit()),
          BlocProvider<BillFilterCubit>(create: (context)=>BillFilterCubit()),
          BlocProvider<TeacherClassFilterCubit>(create: (context)=>TeacherClassFilterCubit()),
          BlocProvider<StatisticFilterCubit>(create: (context)=>StatisticFilterCubit()),
          BlocProvider<ManageCourseCubit>(create: (context)=>ManageCourseCubit())
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Nội Bộ Sakumi',
          theme: ThemeData(
            primarySwatch: primaryColor,
            textTheme: Theme.of(context).textTheme.apply(
              fontSizeFactor: 1.0,
              fontFamily: "Montserrat",
            ),
            useMaterial3: false
          ),
          onGenerateRoute: Routes.router.generator,
        ));
  }
}
