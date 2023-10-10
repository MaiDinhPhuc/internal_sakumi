import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_network/image_network.dart';
import 'package:internal_sakumi/configs/color_configs.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/model/student_model.dart';
import 'package:internal_sakumi/screens/teacher/detail_grading_screen.dart';
import 'package:internal_sakumi/utils/resizable.dart';

import 'list_student/alert_confirm_change_student_status.dart';
import 'manage_general_cubit.dart';

class UserItem extends StatelessWidget {
  final String name, info, url;
  const UserItem(this.name, this.info, this.url, {Key? key}) : super(key: key);

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
        children: [
          SmallAvatar(url),
          SizedBox(width: Resizable.padding(context, 20)),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(name,
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: Resizable.font(context, 20),
                      color: Colors.black)),
              SizedBox(height: Resizable.padding(context, 3)),
              Text(info,
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: Resizable.font(context, 15),
                      color: const Color(0xff757575)))
            ],
          )
        ],
      ),
    );
  }
}

class StudentItem extends StatelessWidget {
  const StudentItem({super.key, required this.student, required this.cubit});

  final StudentModel student;
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
              SmallAvatar(student.url),
              SizedBox(width: Resizable.padding(context, 20)),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(student.name,
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: Resizable.font(context, 20),
                          color: Colors.black)),
                  SizedBox(height: Resizable.padding(context, 3)),
                  Text(student.phone,
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: Resizable.font(context, 15),
                          color: const Color(0xff757575)))
                ],
              ),
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
                  boxShadow: [BoxShadow(blurRadius: 5, color: cubit.getStudentClass(student.userId).color)],
                ),
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(1000),
                    child: PopupMenuButton(itemBuilder: (context) => [
                      ...cubit.listStudentStatusMenu.map((e) => PopupMenuItem(
                          padding: EdgeInsets.zero,
                          child: BlocProvider(create: (context)=>CheckBoxFilterCubit(cubit.getStudentClass(student.userId).status == e),child: BlocBuilder<CheckBoxFilterCubit,bool>(builder: (c,state){
                            return InkWell(
                              onTap: (){
                                Navigator.pop(context);
                                if(cubit.getStudentClass(student.userId).status != e){
                                  showDialog(
                                      context: context,
                                      builder: (context) => ConfirmChangeStudentStatus(e,cubit.getStudentClass(student.userId),student,cubit,popupCubit));
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
                                        text: vietnameseSubText(cubit.getStudentClass(student.userId).status),
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
                                    color: cubit.getStudentClass(student.userId).color,
                                    borderRadius: BorderRadius.circular(1000)),
                                child: Center(
                                  child: Image.asset('assets/images/ic_${cubit.getStudentClass(student.userId).icon}.png',scale: 50,),
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


class SmallAvatar extends StatelessWidget {
  final String url;
  const SmallAvatar(this.url, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: Resizable.size(context, 16),
      backgroundColor: const Color(0xffD9D9D9),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(1000),
        child: url == '' ? Container(): ImageNetwork(
            image: url,
            height: Resizable.size(context, 32),
            width: Resizable.size(context, 32),
            onError: Container(),
            onLoading: Transform.scale(
              scale: 0.5,
              child: const CircularProgressIndicator(),
            )),
      ),
    );
  }
}
