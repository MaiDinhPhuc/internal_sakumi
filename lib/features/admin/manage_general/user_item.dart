import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_network/image_network.dart';
import 'package:internal_sakumi/configs/color_configs.dart';
import 'package:internal_sakumi/model/student_model.dart';
import 'package:internal_sakumi/screens/teacher/detail_grading_screen.dart';
import 'package:internal_sakumi/utils/resizable.dart';
import 'package:screenshot/screenshot.dart';

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
              return CircleAvatar(
                radius: Resizable.size(context, 10),
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(1000),
                    child: PopupMenuButton(itemBuilder: (context) => [
                      ...cubit.listMenu.map((e) => PopupMenuItem(
                          padding: EdgeInsets.zero,
                          child: BlocProvider(create: (context)=>CheckBoxFilterCubit(cubit.getStudentClass(student.userId).status == e),child: BlocBuilder<CheckBoxFilterCubit,bool>(builder: (c,state){
                            return CheckboxListTile(
                              controlAffinity: ListTileControlAffinity.leading,
                              title: Text(e),
                              value: state,
                              onChanged: (newValue) {
                                if(newValue == true){
                                  FirebaseFirestore.instance
                                      .collection('student_class')
                                      .doc('student_${student.userId}_class_${cubit.getStudentClass(student.userId).classId}')
                                      .update({
                                    'class_status': e
                                  }).whenComplete(() {
                                    cubit.getStudentClass(student.userId).status = e;
                                    popupCubit.update();
                                    Navigator.pop(context);
                                  });
                                }else{
                                  Navigator.pop(context);
                                }
                              },
                            );
                          }))
                      ))
                    ],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(Resizable.size(context, 10)),
                          ),
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                              color: cubit.getStudentClass(student.userId).color,
                              borderRadius: BorderRadius.circular(1000)),
                          child: Center(
                            child: Image.asset('assets/images/ic_${cubit.getStudentClass(student.userId).icon}.png',scale: 50,),
                          ),
                        )
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
