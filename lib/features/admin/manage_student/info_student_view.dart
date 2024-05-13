import 'package:flutter/Material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/configs/color_configs.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/features/CRUD/update.dart';
import 'package:internal_sakumi/features/admin/manage_student/student_info_cubit.dart';
import 'package:internal_sakumi/model/student_model.dart';
import 'package:internal_sakumi/providers/cache/cached_data_provider.dart';
import 'package:internal_sakumi/utils/resizable.dart';
import 'package:internal_sakumi/widget/dialog_button.dart';
import 'package:internal_sakumi/widget/submit_button.dart';
import 'package:internal_sakumi/widget/tag_info.dart';
import 'package:internal_sakumi/widget/waiting_dialog.dart';

import 'list_info_student.dart';

class InfoStudentView extends StatelessWidget {
  const InfoStudentView({super.key, required this.cubit});
  final StudentInfoCubit cubit;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        right: Resizable.padding(context, 30),
      ),
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
          cubit.student!.url == ''
              ? Image.asset(
                  "assets/images/ic_avt.png",
                  height: Resizable.size(context, 80),
                  width: Resizable.size(context, 80),
                )
              : ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(100)),
                  child: Image.network(
                    cubit.student!.url,
                    height: Resizable.size(context, 80),
                    width: Resizable.size(context, 80),
                    errorBuilder: (_, __, ___) => Container(),
                  ),
                ),
          Padding(
            padding: EdgeInsets.symmetric(
              vertical: Resizable.padding(context, 10),
              horizontal: Resizable.padding(context, 20),
            ),
            child: TagInfo(type: 2, ownId: cubit.student!.userId),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(
                onTap: () {
                  cubit.updateCheck();
                },
                child: cubit.inJapan == true
                    ? const Icon(
                        Icons.check_box,
                        color: primaryColor,
                      )
                    : const Icon(Icons.check_box_outline_blank),
              ),
              Padding(
                padding: EdgeInsets.only(
                    left: Resizable.padding(context, 5),
                    right: Resizable.padding(context, 10)),
                child: Text(AppText.txtStudentInJapan.text,
                    style: TextStyle(
                        color: const Color(0xff757575),
                        fontWeight: FontWeight.w500,
                        fontSize: Resizable.font(context, 18))),
              )
            ],
          ),
          Padding(
              padding: EdgeInsets.all(Resizable.padding(context, 5)),
              child: ListInfoStudent(cubit: cubit)),
          Padding(padding: EdgeInsets.symmetric(horizontal: Resizable.padding(context, 5)),child:   Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                  flex: 4,
                  child: ResetPassButton(AppText.txtReloadPass.text,
                      onPressed: () {
                        waitingDialog(context);
                        cubit.resetPassword();
                        Navigator.pop(context);
                        notificationDialog(
                            context, AppText.txtSendReloadPassDone.text);
                      })),
              Expanded(flex: 1, child: Container()),
              Expanded(
                  flex: 4,
                  child: UpdateProfileButton(AppText.txtUpdate.text,
                    onPressed: () async {
                      waitingDialog(context);
                      var student = StudentModel(
                          name: cubit.name,
                          url: cubit.student!.url,
                          note: cubit.note,
                          userId: cubit.student!.userId,
                          inJapan: cubit.inJapan,
                          phone: cubit.phone,
                          studentCode: cubit.stdCode,
                          status: cubit.student!.status,
                          email: cubit.student!.email);
                      Update.updateProfileStudent(student);
                      //FireBaseProvider.instance.updateProfileStudent(student);
                      Navigator.pop(context);
                      DataProvider.updateStudentInfo(
                          cubit.student!.userId, student);
                      notificationDialog(
                          context, AppText.txtUpdateStudentDone.text);
                    },
                  ))
            ],
          ))
        ],
      ),
    );
  }
}
