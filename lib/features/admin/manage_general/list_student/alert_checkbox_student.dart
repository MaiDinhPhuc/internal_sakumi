import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/configs/color_configs.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/features/admin/manage_general/list_student/alert_add_student_cubit.dart';
import 'package:internal_sakumi/features/admin/manage_general/manage_general_cubit.dart';
import 'package:internal_sakumi/model/student_class_model.dart';
import 'package:internal_sakumi/utils/resizable.dart';
import 'package:internal_sakumi/widget/dialog_button.dart';
import 'package:internal_sakumi/widget/submit_button.dart';
import 'package:internal_sakumi/widget/waiting_dialog.dart';
import 'package:intl/intl.dart';

void alertCheckBoxStudent(
    BuildContext context, ManageGeneralCubit manageGeneralCubit) {
  showDialog(
      context: context,
      builder: (_) {
        return BlocProvider(
            create: (context) => AlertAddStudentCubit()
              ..loadAllUser(manageGeneralCubit),
            child: BlocBuilder<AlertAddStudentCubit, int>(
              builder: (c, _) {
                var cubit = BlocProvider.of<AlertAddStudentCubit>(c);
                return cubit.listStd == null
                    ? const WaitingAlert()
                    : Dialog(
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width / 3,
                              child: Stack(
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
                                        decoration: const BoxDecoration(
                                            color: Colors.white,
                                        ),
                                        child: Text(
                                          AppText.btnAddStudent.text
                                              .toUpperCase(),
                                          style: TextStyle(
                                              fontWeight: FontWeight.w700,
                                              fontSize:
                                                  Resizable.font(context, 20)),
                                        ),
                                      ),
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
                                                  blurRadius: Resizable.padding(
                                                      context, 2),
                                                  offset: Offset(
                                                      0,
                                                      Resizable.size(
                                                          context, 1)))
                                            ]),
                                        child: Card(
                                          elevation: 5,
                                          shadowColor: primaryColor.withAlpha(100),
                                          shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(100),
                                              side: const BorderSide(color: primaryColor, width: 1)),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Container(
                                                width: 320,
                                                padding: const EdgeInsets.symmetric(horizontal: 10),
                                                child: TextFormField(
                                                  onChanged: (value){
                                                    cubit.search(value, manageGeneralCubit);
                                                  },
                                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                                                  decoration:  InputDecoration(
                                                    focusedBorder: InputBorder.none,
                                                    border: InputBorder.none,
                                                    disabledBorder: InputBorder.none,
                                                    enabledBorder: InputBorder.none,
                                                    errorBorder: InputBorder.none,
                                                    focusedErrorBorder: InputBorder.none,
                                                    hintText: AppText.txtSearch.text,
                                                    hintStyle: const TextStyle(
                                                      color: Color(0xff9a9a9a),
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Material(
                                                color: primaryColor,
                                                borderRadius:
                                                const BorderRadius.horizontal(right: Radius.circular(100)),
                                                child: InkWell(
                                                    borderRadius:
                                                    const BorderRadius.horizontal(right: Radius.circular(100)),
                                                    onTap: () {},
                                                    child: const Padding(
                                                      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 25),
                                                      child: Icon(
                                                        Icons.search,
                                                        color: Colors.white,
                                                        size: 30,
                                                      ),
                                                    )),
                                              )
                                            ],
                                          ),
                                        )
                                      ),
                                      Expanded(
                                          child: SingleChildScrollView(
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: Resizable.padding(
                                                  context, 0)),
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
                                                                contentPadding: EdgeInsets.symmetric(
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
                                                                  cubit
                                                                      .listSelectedStudent!
                                                                      .add(cubit
                                                                              .listStd![
                                                                          index]);
                                                                },
                                                                title: Text(
                                                                    "${cubit.listStd![index].name} ${cubit.listStd![index].studentCode}")),
                                                      ))).toList(),
                                              SizedBox(
                                                  height: Resizable.size(
                                                      context, 50))
                                            ],
                                          ),
                                        ),
                                      ))
                                    ],
                                  ),
                                  Container(
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
                                                  Resizable.size(context, -1)))
                                        ]),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Container(
                                          constraints: BoxConstraints(
                                              minWidth:
                                                  Resizable.size(context, 100)),
                                          margin: EdgeInsets.only(
                                              right: Resizable.padding(
                                                  context, 20)),
                                          child: DialogButton(
                                              AppText.textCancel.text
                                                  .toUpperCase(),
                                              onPressed: () =>
                                                  Navigator.pop(context)),
                                        ),
                                        Container(
                                          constraints: BoxConstraints(
                                              minWidth:
                                                  Resizable.size(context, 100)),
                                          child: SubmitButton(
                                              onPressed: () async {
                                                Navigator.pop(context);
                                                waitingDialog(context);
                                                for (var i in cubit
                                                    .listSelectedStudent!) {
                                                  await cubit.addStudentToClass(
                                                      context,
                                                      StudentClassModel(
                                                          id: cubit
                                                                  .studentClassCount! +
                                                              1,
                                                          classId:
                                                              manageGeneralCubit
                                                                  .selector,
                                                          activeStatus: 5,
                                                          learningStatus: 5,
                                                          moveTo: 0,
                                                          userId: cubit
                                                              .listSelectedStudent![cubit
                                                                  .listSelectedStudent!
                                                                  .indexOf(i)]
                                                              .userId,
                                                          classStatus: AppText
                                                              .statusInProgress
                                                              .text,
                                                          date: DateFormat(
                                                                  'dd/MM/yyyy')
                                                              .format(DateTime
                                                                  .now())));
                                                }
                                                if (context.mounted) {
                                                  Navigator.pop(context);
                                                  manageGeneralCubit
                                                      .loadStudentInClass(
                                                          manageGeneralCubit
                                                              .selector);
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
