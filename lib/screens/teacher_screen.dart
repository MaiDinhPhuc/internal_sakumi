import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/configs/color_configs.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/configs/user_configs.dart';
import 'package:internal_sakumi/model/teacher_class_model.dart';
import 'package:internal_sakumi/model/teacher_model.dart';
import 'package:internal_sakumi/repository/teacher_repository.dart';
import 'package:internal_sakumi/utils/resizable.dart';

class TeacherScreen extends StatelessWidget {
  final String name;
  const TeacherScreen(this.name, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var cubit = BlocProvider.of<TeacherCubit>(context);
    return Scaffold(
        body: Column(
      children: [
        Container(),
        Expanded(
            child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(
                    left: Resizable.padding(context, 70),
                    right: Resizable.padding(context, 70),
                    top: Resizable.padding(context, 20)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircleAvatar(
                          radius: Resizable.size(context, 25),
                          backgroundColor: greyColor.shade300,
                        ),
                        SizedBox(width: Resizable.size(context, 10)),
                        BlocBuilder<TeacherCubit, int>(
                            builder: (_, __) => cubit.state == 0
                                ? const CircularProgressIndicator()
                                : Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        AppText.txtHello.text,
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize:
                                                Resizable.font(context, 24)),
                                      ),
                                      Text(
                                          '${cubit.teacherProfile?.name} ${AppText.txtSensei.text}',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w800,
                                              fontSize:
                                                  Resizable.font(context, 40)))
                                    ],
                                  ))
                      ],
                    ),
                    Icon(
                      Icons.menu,
                      size: Resizable.size(context, 30),
                      color: Colors.black,
                    )
                  ],
                ),
              ),
              BlocBuilder<TeacherCubit, int>(
                  builder: (_, __) => cubit.listClass.isEmpty
                      ? const CircularProgressIndicator()
                      : Column(
                          children: [
                            ...cubit.listClass
                                .map((e) => Container(
                                      child: Text(e.date),
                                    ))
                                .toList()
                          ],
                        ))
            ],
          ),
        )),
      ],
    ));
  }
}

class TeacherCubit extends Cubit<int> {
  TeacherCubit() : super(0);

  TeacherModel? teacherProfile;
  List<TeacherClassModel> listClass = [];

  void init() async {
    loadProfileTeacher();
    loadListClassOfTeacher();
  }

  void loadProfileTeacher() async {
    teacherProfile = await TeacherRepository.getTeacher(UserConfigs.code);
    emit(state + 1);
  }

  void loadListClassOfTeacher() async {
    debugPrint("===========>======= listClass init${listClass.length}");
    listClass = listClass
      ..addAll(await TeacherRepository.getTeacherClassById(
          'user_id', UserConfigs.userId));
    debugPrint("===========>======= listClass ${listClass.length}");

    emit(state + 1);
  }
}
