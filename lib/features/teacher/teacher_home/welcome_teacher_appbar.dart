import 'package:flutter/Material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_network/image_network.dart';
import 'package:internal_sakumi/configs/app_configs.dart';
import 'package:internal_sakumi/configs/color_configs.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/features/admin/manage_bills/add_bill_button.dart';
import 'package:internal_sakumi/features/teacher/profile/teacher_profile/app_bar_info_teacher_cubit.dart';
import 'package:internal_sakumi/model/teacher_model.dart';
import 'package:internal_sakumi/routes.dart';
import 'package:internal_sakumi/utils/resizable.dart';

import 'feedback_dialog.dart';

class WelComeTeacherAppBar extends StatelessWidget {
  const WelComeTeacherAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppBarInfoTeacherCubit, TeacherModel?>(
        bloc: context.read<AppBarInfoTeacherCubit>()..load(),
        builder: (context, s) {
          return Padding(
            padding: EdgeInsets.only(
                top: Resizable.padding(context, 20)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                        decoration: const BoxDecoration(
                          color: primaryColor,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(blurRadius: 5, color: Colors.black)
                          ],
                        ),
                        child: CircleAvatar(
                            radius: Resizable.size(context, 25),
                            backgroundColor: greyColor.shade300,
                            child: s == null
                                ? Container()
                                : GestureDetector(
                                    onTap: () {
                                      Navigator.pushNamed(
                                          context, '${Routes.teacher}/profile');
                                    },
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(1000),
                                      child: Image.network(
                                        key: Key(s.url),
                                        fit: BoxFit.fill,
                                        s.url.isEmpty
                                            ? AppConfigs.defaultImage
                                            : '${s.url}',
                                        height: Resizable.size(context, 50),
                                        width: Resizable.size(context, 50),
                                        errorBuilder: (_, __, ___) => Container(),
                                      ),
                                    ),
                                  ))),
                    SizedBox(width: Resizable.size(context, 10)),
                    s == null
                        ? Container()
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                AppText.txtHello.text,
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: Resizable.font(context, 24)),
                              ),
                              Text('${s.name} ${AppText.txtSensei.text}',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w800,
                                      fontSize: Resizable.font(context, 40)))
                            ],
                          )
                  ],
                ),
                AddButton(
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (context) => FeedBackDialog());
                  },
                  title: AppText.titleSendFeedback.text,
                )
              ],
            ),
          );
        });
  }
}
