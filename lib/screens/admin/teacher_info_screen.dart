import 'package:flutter/Material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_network/image_network.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/features/admin/app_bar/admin_appbar.dart';
import 'package:internal_sakumi/features/admin/manage_teacher/list_info_teacher.dart';
import 'package:internal_sakumi/features/admin/manage_teacher/teacher_info_cubit.dart';
import 'package:internal_sakumi/model/teacher_model.dart';
import 'package:internal_sakumi/providers/firebase/firebase_provider.dart';
import 'package:internal_sakumi/utils/resizable.dart';
import 'package:internal_sakumi/utils/text_utils.dart';
import 'package:internal_sakumi/widget/submit_button.dart';
import 'package:internal_sakumi/widget/waiting_dialog.dart';

class TeacherInfoScreen extends StatelessWidget {
  TeacherInfoScreen({super.key}): cubit = TeacherInfoCubit();

  final TeacherInfoCubit cubit;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const DetailAppBar(),
          Expanded(
              child: BlocBuilder(
                bloc: cubit..loadStudent(int.parse(TextUtils.getName())),
                builder: (c, s) {
                  return cubit.teacher == null || cubit.user == null
                      ? const Center(
                    child: CircularProgressIndicator(),
                  )
                      : SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: EdgeInsets.symmetric(
                              vertical: Resizable.padding(context, 30),
                              horizontal: Resizable.padding(context, 250)),
                          padding: EdgeInsets.symmetric(
                              vertical: Resizable.padding(context, 15),
                              horizontal: Resizable.padding(context, 5)),
                          decoration: BoxDecoration(
                            border: Border.all(
                              width: 0.5,
                              color: const Color(0xffE0E0E0),
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              cubit.teacher!.url == ''
                                  ? Image.asset("assets/images/ic_avt.png")
                                  : ImageNetwork(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(1000)),
                                  image: cubit.teacher!.url,
                                  height: Resizable.size(context, 100),
                                  width: Resizable.size(context, 100),
                                  onError: Container(),
                                  onLoading: Transform.scale(
                                    scale: 0.5,
                                    child:
                                    const CircularProgressIndicator(),
                                  )),
                              Padding(
                                  padding: EdgeInsets.all(
                                      Resizable.padding(context, 5)),
                                  child: TeacherInfo(cubit: cubit)),
                              Row(
                                mainAxisAlignment:
                                MainAxisAlignment.end,
                                children: [
                                  SubmitButton(
                                    onPressed: () async {
                                      waitingDialog(context);
                                      await FireBaseProvider.instance
                                          .updateProfileTeacher(
                                          TextUtils.getName(),
                                          TeacherModel(
                                              name: cubit.name,
                                              url: cubit.teacher!.url,
                                              note: cubit.note,
                                              userId:
                                              cubit.teacher!.userId,
                                              phone: cubit.phone,
                                              status:
                                              cubit.teacher!.status, teacherCode: cubit.teacherCode));
                                      Navigator.pop(context);
                                      notificationDialog(context,
                                          AppText.txtUpdateTeacherDone.text);
                                    },
                                    title: AppText.txtUpdate.text,
                                  )
                                ],
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  );
                },
              ))
        ],
      ),
    );
  }
}