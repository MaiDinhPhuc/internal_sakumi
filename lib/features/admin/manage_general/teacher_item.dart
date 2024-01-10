import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/configs/color_configs.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/features/admin/manage_general/small_avt.dart';
import 'package:internal_sakumi/model/teacher_model.dart';
import 'package:internal_sakumi/screens/class_info/detail_grading_screen_v2.dart';
import 'package:internal_sakumi/utils/resizable.dart';
import 'list_teacher/alert_confirm_change_teacher_class_status.dart';
import 'manage_general_cubit.dart';

class TeacherItem extends StatelessWidget {
  final TeacherModel teacher;
  const TeacherItem({Key? key, required this.cubit, required this.teacher}) : super(key: key);
  final ManageGeneralCubit cubit;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: Resizable.padding(context, 5)),
      padding: EdgeInsets.symmetric(
          horizontal: Resizable.padding(context, 20),
          vertical: Resizable.padding(context, 10)),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Resizable.padding(context, 5)),
          color: Colors.white,
          border: Border.all(
              color: const Color(0xffE0E0E0),
              width: Resizable.size(context, 1))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              SmallAvatar(teacher.url),
              SizedBox(width: Resizable.padding(context, 20)),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(teacher.name,
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: Resizable.font(context, 16),
                          color: Colors.black)),
                  SizedBox(height: Resizable.padding(context, 3)),
                  Text(teacher.teacherCode,
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: Resizable.font(context, 13),
                          color: const Color(0xff757575)))
                ],
              )
            ],
          ),
          BlocProvider(create: (context)=>MenuPopupCubit(),
            child: BlocBuilder<MenuPopupCubit, int>(
              builder: (cc, s){
                var popupCubit = BlocProvider.of<MenuPopupCubit>(cc);
                return Container(
                  height: 30,
                  width: 30,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(1000),
                    boxShadow: const [BoxShadow(blurRadius: 5, color:  Color(0xff33691e))],
                  ),
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(1000),
                      child: PopupMenuButton(itemBuilder: (context) => [
                        ...cubit.listTeacherClassStatus.map((e) => PopupMenuItem(
                            padding: EdgeInsets.zero,
                            child: BlocProvider(create: (context)=>CheckBoxFilterCubit(cubit.getTeacherClass(teacher.userId).classStatus == e),child: BlocBuilder<CheckBoxFilterCubit,bool>(builder: (c,state){
                              return InkWell(
                                onTap: (){
                                  Navigator.pop(context);
                                  if(cubit.getTeacherClass(teacher.userId).classStatus != e){
                                    showDialog(
                                        context: context,
                                        builder: (context) => ConfirmChangeTeacherStatus(e,cubit.getTeacherClass(teacher.userId),teacher,cubit,popupCubit));
                                  }
                                },
                                child: Container(
                                    height: Resizable.size(
                                        context, 33),
                                    decoration: BoxDecoration(
                                        color: state? primaryColor: Colors.white
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(horizontal: Resizable.padding(
                                          context, 10)),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(vietnameseSubText(e), style: TextStyle(fontSize: Resizable.font(
                                              context, 15),color:state? Colors.white : Colors.black)),
                                          if(state)
                                            const Icon(Icons.check, color: Colors.white,)
                                        ],
                                      ),
                                    )
                                ),
                              );

                            }))
                        ))
                      ],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(Resizable.size(context, 10)),
                            ),
                          ),
                          child:
                          Tooltip(
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
                                          text: "Đang dạy",
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
                                      color: const Color(0xff33691e),
                                      borderRadius: BorderRadius.circular(1000)),
                                  child: Center(
                                    child: Image.asset('assets/images/ic_in_progress.png',scale: 50,),
                                  ),
                                ),
                              ))
                      )
                  ),
                );
              },
            ),)
        ],
      ),
    );
  }
}



