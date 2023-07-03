import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/configs/color_configs.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/model/teacher_model.dart';
import 'package:internal_sakumi/repository/teacher_repository.dart';
import 'package:internal_sakumi/utils/resizable.dart';
import 'package:internal_sakumi/utils/text_utils.dart';

class TeacherScreen extends StatelessWidget {
  final String name;
  final LoadProfileTeacher cubit;
  TeacherScreen(this.name, {Key? key})
      : cubit = LoadProfileTeacher(),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [
        Container(),
        SingleChildScrollView(
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
                          radius: Resizable.size(context, 30),
                          backgroundColor: greyColor.shade300,
                        ),
                        SizedBox(width: Resizable.size(context, 10)),
                        BlocBuilder<LoadProfileTeacher, TeacherModel?>(
                            bloc: cubit,
                            builder: (c, s) => s == null
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
                                          '${s.name} ${AppText.txtSensei.text}',
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
                      size: 30,
                      color: Colors.black,
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    ));
  }
}

class LoadProfileTeacher extends Cubit<TeacherModel?> {
  LoadProfileTeacher() : super(null) {
    load();
  }
  load() async {
    emit(await TeacherRepository.getTeacher(TextUtils.getName()));
  }
}
