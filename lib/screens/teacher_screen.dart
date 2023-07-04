import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/configs/color_configs.dart';
import 'package:internal_sakumi/configs/prefKey_configs.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/model/class_model.dart';
import 'package:internal_sakumi/model/lesson_result_model.dart';
import 'package:internal_sakumi/model/teacher_class_model.dart';
import 'package:internal_sakumi/model/teacher_model.dart';
import 'package:internal_sakumi/repository/admin_repository.dart';
import 'package:internal_sakumi/repository/teacher_repository.dart';
import 'package:internal_sakumi/routes.dart';
import 'package:internal_sakumi/utils/resizable.dart';
import 'package:internal_sakumi/utils/text_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
              Container(
                margin: EdgeInsets.symmetric(
                    vertical: Resizable.padding(context, 20)),
                child: Text(AppText.titleListClass.text,
                    style: TextStyle(
                        fontSize: Resizable.font(context, 30),
                        fontWeight: FontWeight.w800)),
              ),
              BlocBuilder<TeacherCubit, int>(
                  builder: (_, __) => cubit.listClass == null
                      ? const Center(
                          child: CircularProgressIndicator(),
                        )
                      : cubit.listClass!.isEmpty
                          ? Center(
                              child: Text(AppText.txtNoClass.text),
                            )
                          : Container(
                              margin: EdgeInsets.symmetric(
                                  horizontal: Resizable.padding(context, 200)),
                              child: Column(
                                children: [
                                  ...cubit.listClass!
                                      .map((e) => Stack(
                                            children: [
                                              Container(
                                                constraints: BoxConstraints(
                                                    maxHeight: Resizable.size(
                                                        context, 35)),
                                                alignment: Alignment.centerLeft,
                                                padding: EdgeInsets.symmetric(
                                                    horizontal:
                                                        Resizable.padding(
                                                            context, 20),
                                                    vertical: Resizable.padding(
                                                        context, 8)),
                                                decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    boxShadow: [
                                                      BoxShadow(
                                                          color: Colors.black12,
                                                          offset: Offset(
                                                              0,
                                                              Resizable.size(
                                                                  context, 2)),
                                                          blurRadius:
                                                              Resizable.size(
                                                                  context, 1))
                                                    ],
                                                    border: Border.all(
                                                        color: Colors.black),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            1000)),
                                                child: Text(e.classCode),
                                              ),
                                              Positioned.fill(
                                                  child: Material(
                                                color: Colors.transparent,
                                                child: InkWell(
                                                  onTap: () async {
                                                    await Navigator.pushNamed(
                                                        context,
                                                        "${Routes.teacher}?name=${TextUtils.getName().trim()}/class?id=${e.classId}");
                                                  },
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          1000),
                                                ),
                                              ))
                                            ],
                                          ))
                                      .toList(),
                                ],
                              ),
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
  List<ClassModel>? listClass;
  List<LessonResultModel>? list;

  void init() {
    loadProfileTeacher();
    loadListClassOfTeacher();
    //load();
  }

  void loadProfileTeacher() async {
    SharedPreferences localData = await SharedPreferences.getInstance();
    teacherProfile = await TeacherRepository.getTeacher(
        localData.getString(PrefKeyConfigs.code)!);
    emit(state + 1);
  }

  void loadListClassOfTeacher() async {
    List<TeacherClassModel> listTeacherClass = [];
    List<ClassModel> listAllClass = [];
    SharedPreferences localData = await SharedPreferences.getInstance();

    listTeacherClass = await TeacherRepository.getTeacherClassById(
        'user_id', localData.getInt(PrefKeyConfigs.userId)!);

    listAllClass = await AdminRepository.getListClass();

    listClass = [];
    for (var i in listTeacherClass) {
      for (var j in listAllClass) {
        if (i.classId == j.classId) {
          listClass!.add(j);
          break;
        }
      }
    }

    emit(state + 1);
  }

  // load() async {
  //   list = await TeacherRepository.getLessonResultByClassId(0);
  //   emit(state + 1);
  // }
}
