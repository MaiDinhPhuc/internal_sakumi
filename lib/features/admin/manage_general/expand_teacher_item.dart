import 'package:flutter/Material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/configs/color_configs.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/features/CRUD/update.dart';
import 'package:internal_sakumi/model/teacher_class_model.dart';
import 'package:internal_sakumi/model/teacher_model.dart';
import 'package:internal_sakumi/screens/class_info/detail_grading_screen_v2.dart';
import 'package:internal_sakumi/utils/resizable.dart';
import 'package:internal_sakumi/widget/custom_button.dart';

import 'list_teacher/alert_confirm_change_teacher_class_status.dart';
import 'manage_general_cubit.dart';

class ExpandTeacherItem extends StatelessWidget {
  const ExpandTeacherItem(
      {super.key, required this.cubit, required this.teacher});
  final ManageGeneralCubit cubit;
  final TeacherModel teacher;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(
            width: Resizable.size(context, 180),
            child: CheckboxListTile(
              controlAffinity: ListTileControlAffinity.leading,
              title: Text("Phụ trách chính",
                  style: TextStyle(fontSize: Resizable.font(context, 20))),
              value: cubit.getTeacherClass(teacher.userId).responsibility,
              onChanged: (newValue) {
                TeacherClassModel teacherClassModel = TeacherClassModel(
                    id: cubit.getTeacherClass(teacher.userId).id,
                    userId: cubit.getTeacherClass(teacher.userId).userId,
                    classId: cubit.getTeacherClass(teacher.userId).classId,
                    classStatus: cubit.getTeacherClass(teacher.userId).classStatus,
                    date: cubit.getTeacherClass(teacher.userId).date,
                    responsibility: newValue!);
                cubit.updateResponsibility(teacherClassModel);
                Update.updateResponsibility(teacherClassModel);
              },
            )),
        ElevatedButton(
          onPressed: () {
            showDialog(
                context: context,
                builder: (context) =>
                    ConfirmChangeTeacherStatus(
                        "Remove",
                        cubit.getTeacherClass(
                            teacher
                                .userId),
                        teacher,
                        cubit));
          },
          style: ButtonStyle(
            animationDuration: const Duration(milliseconds: 500),
            shape: MaterialStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            padding: MaterialStateProperty.all( EdgeInsets.symmetric(
                horizontal: Resizable.padding(context, 20) ,
                vertical: Resizable.padding(context, 10))),
            //elevation: MaterialStateProperty.all(10),
            foregroundColor: MaterialStateProperty.all(Colors.white),
            backgroundColor: MaterialStateProperty.all(primaryColor.shade500),
            overlayColor: MaterialStateProperty.all(
                Colors.black.withOpacity(0.3)
            ),
          ),
          child:  Text(AppText.btnRemove.text),
        )
      ],
    );
  }
}
