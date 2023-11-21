import 'package:flutter/Material.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/features/admin/manage_general/small_avt.dart';
import 'package:internal_sakumi/model/class_model.dart';
import 'package:internal_sakumi/model/student_model.dart';
import 'package:internal_sakumi/model/teacher_model.dart';
import 'package:internal_sakumi/routes.dart';
import 'package:internal_sakumi/utils/resizable.dart';

class ItemSearch extends StatelessWidget {
  const ItemSearch(
      {super.key, this.teacherModel, this.studentModel,this.classModel, required this.type});
  final String type;
  final TeacherModel? teacherModel;
  final StudentModel? studentModel;
  final ClassModel? classModel;
  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: ()async{
          if(type == AppText.txtClass.text){
            await Navigator.pushNamed(context,
                "${Routes.admin}/overview/class=${classModel!.classId}");
          }
        },
        child: type != AppText.txtClass.text ? Padding(
          padding: EdgeInsets.all( Resizable.padding(context, 5)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: Resizable.padding(context, 5)),
                      child: SmallAvatar(type == AppText.txtStudent.text
                          ? studentModel!.url
                          : teacherModel!.url)),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                          type == AppText.txtStudent.text
                              ? studentModel!.name
                              : teacherModel!.name,
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: Resizable.size(context, 17),
                              fontWeight: FontWeight.w600)),
                      Text(
                          type == AppText.txtStudent.text
                              ? "${AppText.txtStudentCode.text}: ${studentModel!.studentCode}"
                              : "${AppText.txtTeacherCode.text}: ${teacherModel!.teacherCode}",
                          style: TextStyle(
                              color:const Color(0xFF757575),
                              fontSize: Resizable.size(context, 14),
                              fontWeight: FontWeight.w600))
                    ],
                  )
                ],
              ),
              Icon(Icons.arrow_forward_ios_outlined, size: Resizable.size(context, 17),color: const Color(0xFF757575))
            ],
          ),
        ) : Padding(
          padding: EdgeInsets.all( Resizable.padding(context, 5)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: Resizable.padding(context, 5)),
                      child:Container(
                        height: 30,
                        width: 30,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(1000),
                          boxShadow: [BoxShadow(blurRadius: 5, color:  getColor(classModel!.classStatus))],
                        ),
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(1000),
                            child: Tooltip(
                                padding: EdgeInsets.all(Resizable.padding(context, 10)),
                                decoration: BoxDecoration(
                                    color: Colors.black,
                                    border: Border.all(
                                        color: Colors.black, width: Resizable.size(context, 1)),
                                    borderRadius:
                                    BorderRadius.circular(Resizable.padding(context, 5))),
                                richMessage: WidgetSpan(
                                    alignment: PlaceholderAlignment.baseline,
                                    baseline: TextBaseline.alphabetic,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        RichText(
                                          text: TextSpan(
                                            text: vietnameseSubText(classModel!.classStatus),
                                            style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: Resizable.font(context, 18),
                                                color: Colors.white),
                                          ),
                                        ),
                                      ],
                                    )),
                                child: AspectRatio(
                                  aspectRatio: 1,
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: getColor(classModel!.classStatus),
                                        borderRadius: BorderRadius.circular(1000)),
                                    child: Center(
                                      child: Image.asset('assets/images/ic_${getIcon(classModel!.classStatus)}.png',scale: 50,),
                                    ),
                                  ),
                                ))
                        ),
                      )),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                          "${AppText.txtClassCode.text}: ${classModel!.classCode}",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: Resizable.size(context, 17),
                              fontWeight: FontWeight.w600)),
                      Text(
                          "${AppText.txtClassType.text}: ${classModel!.classType == 0 ? "Lớp Chung" : "Lớp 1-1"}",
                          style: TextStyle(
                              color:const Color(0xFF757575),
                              fontSize: Resizable.size(context, 14),
                              fontWeight: FontWeight.w600))
                    ],
                  )
                ],
              ),
              Icon(Icons.arrow_forward_ios_outlined, size: Resizable.size(context, 17),color: const Color(0xFF757575))
            ],
          ),
        ));
  }
  Color getColor(String status) {
    switch (status) {
      case 'InProgress':
        return const Color(0xff33691e);
      case 'Cancel':
        return const Color(0xffB71C1C);
      case 'Completed':
      case 'Preparing':
        return const Color(0xff757575);
      default:
        return const Color(0xff33691e);
    }
  }

  String getIcon(String status) {
    switch (status) {
      case 'InProgress':
      case 'Preparing':
        return "in_progress";
      case 'Cancel':
        return "dropped";
      case 'Completed':
        return "check";
      default:
        return "in_progress";
    }
  }
}
