import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/configs/color_configs.dart';
import 'package:internal_sakumi/configs/prefKey_configs.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/features/admin/manage_general/dotted_border_button.dart';
import 'package:internal_sakumi/features/admin/manage_student/student_item_row_layout.dart';
import 'package:internal_sakumi/features/teacher/lecture/detail_lesson_cubit.dart';
import 'package:internal_sakumi/model/student_model.dart';
import 'package:internal_sakumi/repository/admin_repository.dart';
import 'package:internal_sakumi/routes.dart';
import 'package:internal_sakumi/utils/resizable.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ManageStudentTab extends StatelessWidget {
  const ManageStudentTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoadListStudentCubit()..load(context),
      child: BlocBuilder<LoadListStudentCubit, List<StudentModel>>(
          key: Key("${LoadListStudentCubit().state.length}"),
          builder: (c, list) {
            return list.isEmpty
                ? Transform.scale(
                    scale: 0.75,
                    child: const CircularProgressIndicator(),
                  )
                : SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: Resizable.padding(context, 150)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            alignment: Alignment.center,
                            margin: EdgeInsets.symmetric(
                                vertical: Resizable.padding(context, 20)),
                            child: Text(
                                AppText.titleListStudent.text.toUpperCase(),
                                style: TextStyle(
                                  fontSize: Resizable.font(context, 30),
                                  fontWeight: FontWeight.w800,
                                )),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: Resizable.padding(context, 20),
                                vertical: Resizable.padding(context, 10)),
                            child: StudentItemRowLayout(
                                isHeader: true,
                                name: AppText.txtName.text,
                                phone: AppText.txtPhone.text,
                                code: AppText.txtStudentCode.text),
                          ),
                          ...List.generate(
                              list.length,
                              (index) => Container(
                                    margin: EdgeInsets.symmetric(
                                        // horizontal: Resizable.padding(
                                        //     context, 150),
                                        vertical:
                                            Resizable.padding(context, 5)),
                                    child: BlocProvider(
                                        create: (context) => DropdownCubit(),
                                        child: BlocBuilder<DropdownCubit, int>(
                                          builder: (c, state) => Stack(
                                            children: [
                                              Container(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  decoration: BoxDecoration(
                                                      border: Border.all(
                                                          width: Resizable.size(
                                                              context, 1),
                                                          color: state % 2 == 0
                                                              ? greyColor
                                                                  .shade100
                                                              : Colors.black),
                                                      borderRadius: BorderRadius.circular(
                                                          Resizable.size(
                                                              context, 5))),
                                                  child: list == null
                                                      ? Transform.scale(
                                                          scale: 0.75,
                                                          child:
                                                              const CircularProgressIndicator(),
                                                        )
                                                      : AnimatedCrossFade(
                                                          firstChild: Padding(
                                                            padding: EdgeInsets.symmetric(
                                                                horizontal: Resizable
                                                                    .padding(
                                                                        context,
                                                                        20),
                                                                vertical: Resizable
                                                                    .padding(
                                                                        context,
                                                                        15)),
                                                            child: StudentItemRowLayout(
                                                                name:
                                                                    list[index]
                                                                        .name,
                                                                phone:
                                                                    list[index]
                                                                        .phone,
                                                                code: list[
                                                                        index]
                                                                    .studentCode),
                                                          ),
                                                          secondChild: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Padding(
                                                                padding: EdgeInsets.symmetric(
                                                                    horizontal:
                                                                        Resizable.padding(
                                                                            context,
                                                                            20),
                                                                    vertical: Resizable
                                                                        .padding(
                                                                            context,
                                                                            15)),
                                                                child: StudentItemRowLayout(
                                                                    name: list[
                                                                            index]
                                                                        .name,
                                                                    phone: list[
                                                                            index]
                                                                        .phone,
                                                                    code: list[
                                                                            index]
                                                                        .studentCode),
                                                              ),
                                                              Text('kkkkkkk')
                                                            ],
                                                          ),
                                                          crossFadeState: state % 2 == 1
                                                              ? CrossFadeState
                                                                  .showSecond
                                                              : CrossFadeState
                                                                  .showFirst,
                                                          duration: const Duration(
                                                              milliseconds: 100))),
                                              Positioned.fill(
                                                  child: Material(
                                                color: Colors.transparent,
                                                child: InkWell(
                                                    onTap: () {},
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            Resizable.size(
                                                                context, 5))),
                                              )),
                                              Container(
                                                margin: EdgeInsets.only(
                                                    right: Resizable.padding(
                                                        context, 10),
                                                    top: Resizable.padding(
                                                        context, 8)),
                                                alignment:
                                                    Alignment.centerRight,
                                                child: IconButton(
                                                    onPressed: () => BlocProvider
                                                            .of<DropdownCubit>(
                                                                c)
                                                        .update(),
                                                    splashRadius:
                                                        Resizable.size(
                                                            context, 15),
                                                    icon: Icon(
                                                      state % 2 == 0
                                                          ? Icons
                                                              .keyboard_arrow_down
                                                          : Icons
                                                              .keyboard_arrow_up,
                                                    )),
                                              )
                                            ],
                                          ),
                                        )),
                                  )).toList(),
                          SizedBox(height: Resizable.size(context, 5)),
                          DottedBorderButton(
                              AppText.btnAddNewStudent.text.toUpperCase(),
                              onPressed: () async {
                                SharedPreferences localData =
                                await SharedPreferences.getInstance();
                                if (c.mounted) {
                                  Navigator.pushNamed(context,
                                      '${Routes.admin}?name=${localData.getString(PrefKeyConfigs.code)!}/${Routes.manageGeneral}');
                                }
                              }),
                          SizedBox(height: Resizable.size(context, 50)),
                        ],
                      ),
                    ),
                  );
          }),
    );
  }
}

class LoadListStudentCubit extends Cubit<List<StudentModel>> {
  LoadListStudentCubit() : super([]);

  load(context) async {
    AdminRepository adminRepository = AdminRepository.fromContext(context);
    List<StudentModel> list = await adminRepository.getAllStudent();
    emit(list);
  }
}
