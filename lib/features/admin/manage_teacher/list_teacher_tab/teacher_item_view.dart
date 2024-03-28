import 'package:flutter/Material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/configs/color_configs.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/features/admin/manage_teacher/list_teacher_tab/teacher_detail_cubit.dart';
import 'package:internal_sakumi/features/admin/manage_teacher/list_teacher_tab/teacher_layout.dart';
import 'package:internal_sakumi/model/teacher_model.dart';
import 'package:internal_sakumi/utils/resizable.dart';
import 'package:internal_sakumi/widget/note_widget.dart';

class TeacherItemView extends StatelessWidget {
  const TeacherItemView({super.key, required this.teacherModel, required this.cubit});
  final TeacherModel teacherModel;
  final TeacherDetailCubit cubit;
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TeacherDetailCubit, int>(
        bloc: cubit,
        builder: (c,s){
          return TeacherItemLayout(
            widgetTeacherCode: Text(
                teacherModel.teacherCode,
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize:
                    Resizable.font(context, 20),
                    color: Colors.black)),
            widgetName: Text(teacherModel.name,
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize:
                    Resizable.font(context, 20),
                    color: Colors.black)),
            widgetPhone: Text(teacherModel.phone == "" ? AppText.txtNotFill.text : teacherModel.phone,
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize:
                    Resizable.font(context, 20),
                    color: Colors.black)),
            widgetRating: Container(
              padding: EdgeInsets.all(Resizable.padding(context, 5)),
              width: Resizable.size(context, 30),
              height: Resizable.size(context, 30),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: primaryColor,
                  borderRadius: BorderRadius.circular(Resizable.size(context, 5))),
              child: Text(cubit.isLoading ? "A" : cubit.getEvaluate(),
                  style: TextStyle(
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                      fontSize: Resizable.font(context, 30))),
            ),
            widgetStatus: TeacherStatusItem(teacherModel.status),
            widgetDropdown: Container(),
          );
        });
  }
}
