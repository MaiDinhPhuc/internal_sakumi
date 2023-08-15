import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/features/admin/manage_general/alert_new_student_cubit.dart';
import 'package:internal_sakumi/features/admin/manage_general/manage_general_cubit.dart';
import 'package:internal_sakumi/model/student_class_model.dart';
import 'package:internal_sakumi/routes.dart';
import 'package:internal_sakumi/utils/resizable.dart';
import 'package:internal_sakumi/widget/dialog_button.dart';
import 'package:internal_sakumi/widget/submit_button.dart';
import 'package:intl/intl.dart';

void alertCheckBoxStudent(
    BuildContext context, ManageGeneralCubit manageGeneralCubit) {
  showDialog(
      context: context,
      builder: (_) {
        return BlocProvider(
            create: (context) => AlertNewStudentCubit()
              ..loadAllUser(context, manageGeneralCubit),
            child: BlocBuilder<AlertNewStudentCubit, int>(
              builder: (c, _) {
                var cubit = BlocProvider.of<AlertNewStudentCubit>(c);
                return Dialog(
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width / 3,
                    child: cubit.listStd == null
                        ? Transform.scale(
                            scale: 0.75,
                            child: const Center(
                              child: CircularProgressIndicator(),
                            ),
                          )
                        : Stack(
                            alignment: Alignment.bottomCenter,
                            children: [
                              Column(
                                children: [
                                  Container(
                                    alignment: Alignment.topLeft,
                                    padding: EdgeInsets.symmetric(
                                        horizontal:
                                            Resizable.padding(context, 20),
                                        vertical:
                                            Resizable.padding(context, 10)),
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        boxShadow: [
                                          BoxShadow(
                                              color: Colors.grey,
                                              blurRadius:
                                                  Resizable.padding(context, 2),
                                              offset: Offset(0,
                                                  Resizable.size(context, 1)))
                                        ]),
                                    child: Text(
                                      AppText.titleAddStudent.text
                                          .toUpperCase(),
                                      style: TextStyle(
                                          fontWeight: FontWeight.w700,
                                          fontSize:
                                              Resizable.font(context, 20)),
                                    ),
                                  ),
                                  Expanded(
                                      child: SingleChildScrollView(
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal:
                                              Resizable.padding(context, 0)),
                                      child: Column(
                                        children: [
                                          ...List.generate(
                                              cubit.listStd!.length,
                                              (index) => BlocProvider(
                                                  create: (c) =>
                                                      CheckBoxCubit(),
                                                  child: BlocBuilder<
                                                      CheckBoxCubit, bool>(
                                                    builder: (cc, state) =>
                                                        CheckboxListTile(
                                                            contentPadding:
                                                                EdgeInsets.symmetric(
                                                                    horizontal: Resizable
                                                                        .padding(
                                                                            context,
                                                                            30)),
                                                            controlAffinity:
                                                                ListTileControlAffinity
                                                                    .leading,
                                                            value: state,
                                                            onChanged: (v) {
                                                              BlocProvider.of<
                                                                      CheckBoxCubit>(cc)
                                                                  .update();
                                                              cubit.listSelectedStudent!.add(cubit.listStd![index]);
                                                            },
                                                            title: Text(
                                                                "${cubit.listStd![index].name} ${cubit.listStd![index].studentCode}")),
                                                  ))).toList(),
                                          SizedBox(
                                              height:
                                                  Resizable.size(context, 50))
                                        ],
                                      ),
                                    ),
                                  ))
                                ],
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: Resizable.padding(context, 20),
                                    vertical: Resizable.padding(context, 10)),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    boxShadow: [
                                      BoxShadow(
                                          color: Colors.grey,
                                          blurRadius:
                                              Resizable.padding(context, 2),
                                          offset: Offset(
                                              0, Resizable.size(context, -1)))
                                    ]),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Container(
                                      constraints: BoxConstraints(
                                          minWidth:
                                              Resizable.size(context, 100)),
                                      margin: EdgeInsets.only(
                                          right:
                                              Resizable.padding(context, 20)),
                                      child: DialogButton(
                                          AppText.textCancel.text.toUpperCase(),
                                          onPressed: () =>
                                              Navigator.pop(context)),
                                    ),
                                    Container(
                                      constraints: BoxConstraints(
                                          minWidth:
                                              Resizable.size(context, 100)),
                                      child: SubmitButton(
                                          onPressed: () async {
                                            debugPrint('=============>>>>>>>>>>>> ${cubit.listSelectedStudent!.length}');
                                            for(var i in cubit.listSelectedStudent!){
                                              await cubit.addStudentToClass(
                                                  context,
                                                  StudentClassModel(
                                                      id: cubit.listStudentClass!.length+1,
                                                      classId:
                                                      manageGeneralCubit.selector,
                                                      activeStatus:
                                                      5,
                                                      learningStatus:
                                                      5,
                                                      moveTo:
                                                      0,
                                                      userId:
                                                      cubit.listSelectedStudent![cubit.listSelectedStudent!.indexOf(i)].userId,
                                                      classStatus:
                                                      'progress',
                                                      date:
                                                      DateFormat('dd/MM/yyyy').format(DateTime.now())));
                                            }
                                          },
                                          title: AppText.btnAdd.text),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                  ),
                );
              },
            ));
      });
}

class CheckBoxCubit extends Cubit<bool> {
  CheckBoxCubit() : super(false);

  update() {
    emit(!state);
  }
}
