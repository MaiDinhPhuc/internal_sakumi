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

import 'configs/color_configs.dart';
import 'features/master/manage_survey/manage_survey_cubit.dart';
import 'features/teacher/profile/teacher_profile/app_bar_info_teacher_cubit.dart';
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

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => AppBarInfoTeacherCubit()),
          BlocProvider<SearchCubit>(create: (context) => SearchCubit()),
          BlocProvider<ManageSurveyCubit>(create: (context) => ManageSurveyCubit()),
          BlocProvider<AdminClassFilterCubit>(create: (context)=>AdminClassFilterCubit()),
          BlocProvider<BillFilterCubit>(create: (context)=>BillFilterCubit()),
          BlocProvider<TeacherClassFilterCubit>(create: (context)=>TeacherClassFilterCubit()),
          BlocProvider<StatisticFilterCubit>(create: (context)=>StatisticFilterCubit())
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
