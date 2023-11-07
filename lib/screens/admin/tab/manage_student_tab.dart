import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/configs/color_configs.dart';
import 'package:internal_sakumi/configs/prefKey_configs.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/features/admin/manage_general/dotted_border_button.dart';
import 'package:internal_sakumi/features/admin/manage_general/list_student/alert_edit_student_profile.dart';
import 'package:internal_sakumi/features/admin/manage_student/student_item_row_layout.dart';
import 'package:internal_sakumi/features/teacher/lecture/detail_lesson/detail_lesson_cubit.dart';
import 'package:internal_sakumi/model/student_model.dart';
import 'package:internal_sakumi/providers/firebase/firebase_provider.dart';
import 'package:internal_sakumi/providers/firebase/firestore_db.dart';
import 'package:internal_sakumi/routes.dart';
import 'package:internal_sakumi/utils/resizable.dart';
import 'package:internal_sakumi/widget/custom_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ManageStudentTab extends StatelessWidget {
  const ManageStudentTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoadListStudentCubit()..loadFirst(),
      child: BlocBuilder<LoadListStudentCubit, int>(
          builder: (c, s) {
            var cubit = BlocProvider.of<LoadListStudentCubit>(c);
            return s == 0
                ? Transform.scale(
                    scale: 0.75,
                    child: const CircularProgressIndicator(),
                  )
                : SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: Resizable.padding(context, 150)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
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
                              cubit.listData.length,
                              (index) => Container(
                                    margin: EdgeInsets.symmetric(
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
                                                  child: AnimatedCrossFade(
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
                                                                cubit.listData[index]
                                                                        .name,
                                                                phone:
                                                                cubit.listData[index]
                                                                        .phone,
                                                                code: cubit.listData[
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
                                                                    name: cubit.listData[
                                                                            index]
                                                                        .name,
                                                                    phone: cubit.listData[
                                                                            index]
                                                                        .phone,
                                                                    code: cubit.listData[
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
                                                    onTap: () =>alertEditStudentProfile(c,cubit.listData[index], index),
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
                              AppText.btnManageStudent.text.toUpperCase(),
                              onPressed: () async {
                                SharedPreferences localData =
                                await SharedPreferences.getInstance();
                                if (c.mounted) {
                                  Navigator.pushNamed(context,
                                      '${Routes.admin}/${Routes.manageGeneral}');
                                }
                              }),
                          SizedBox(height: Resizable.size(context, 10)),
                          if(cubit.listData.length<cubit.totalCount!)
                            CustomButton(onPress: () {
                            cubit.loadMore();
                          }, bgColor: primaryColor, foreColor: Colors.white, text: AppText.txtLoadMore.text),
                          SizedBox(height: Resizable.size(context, 40)),
                        ],
                      ),
                    ),
                  );
          }),
    );
  }
}

class LoadListStudentCubit extends Cubit<int> {
  LoadListStudentCubit() : super(0);

  List<StudentModel> listData = [];

  int? totalCount;
  int? lastId;


  loadFirst() async {
    List<StudentModel> list = await FireBaseProvider.instance.get10StudentFirst();
    totalCount = (await FireStoreDb.instance.getCount("students")).count;
    listData.addAll(list);
    lastId = list.last.userId;
    emit(state+1);
  }

  loadMore() async{
    List<StudentModel> list = await FireBaseProvider.instance.get10Student(lastId!);
    listData.addAll(list);
    lastId = list.last.userId;
    emit(state+1);
  }

  update(int index, StudentModel student)async{
    listData[index] = student;
    emit(state+1);
  }
}
