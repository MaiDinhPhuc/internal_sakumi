import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/configs/color_configs.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/model/teacher_model.dart';
import 'package:internal_sakumi/repository/admin_repository.dart';
import 'package:internal_sakumi/routes.dart';
import 'package:internal_sakumi/utils/resizable.dart';

class MasterScreen extends StatelessWidget {
  const MasterScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppText.titleMaster.text),
      ),
      body: BlocProvider<LoadListTeacherCubit>(
        create: (context) => LoadListTeacherCubit()..load(context),
        child: BlocBuilder<LoadListTeacherCubit, List<TeacherModel>>(
          builder: (c, list) {
            return Stack(
              children: [
                Container(
                  alignment: Alignment.bottomRight,
                  margin: EdgeInsets.only(
                      bottom: Resizable.padding(context, 20),
                      right: Resizable.padding(context, 20)),
                  child: Stack(
                    children: [
                      Container(
                          alignment: Alignment.center,
                          width: Resizable.size(context, 30),
                          height: Resizable.size(context, 30),
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: primaryColor,
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.black38,
                                    blurRadius: Resizable.size(context, 5))
                              ]),
                          child: Icon(
                            Icons.add,
                            size: Resizable.size(context, 20),
                            color: Colors.white,
                          )),
                      Positioned.fill(
                          child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(1000),
                          onTap: () =>
                              Navigator.pushNamed(context, Routes.addTeacher),
                        ),
                      ))
                    ],
                  ),
                )
              ],
            );
          },
        ),
      ),
    );
  }
}

class LoadListTeacherCubit extends Cubit<List<TeacherModel>> {
  LoadListTeacherCubit() : super([]);

  load(context) async {
    AdminRepository adminRepository = AdminRepository.fromContext(context);
    List<TeacherModel> list = await adminRepository.getAllTeacher();
    emit(list);
  }
}
