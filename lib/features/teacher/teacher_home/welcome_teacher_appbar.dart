import 'package:flutter/Material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_network/image_network.dart';
import 'package:internal_sakumi/configs/app_configs.dart';
import 'package:internal_sakumi/configs/color_configs.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/features/admin/manage_bills/add_bill_button.dart';
import 'package:internal_sakumi/features/admin/manage_browse_download/manage_browse_download_button.dart';
import 'package:internal_sakumi/features/teacher/profile/teacher_profile/app_bar_info_teacher_cubit.dart';
import 'package:internal_sakumi/features/teacher/teacher_home/teacher_survey_cubit.dart';
import 'package:internal_sakumi/features/teacher/teacher_home/teacher_survey_dialog.dart';
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
            padding: EdgeInsets.only(top: Resizable.padding(context, 20)),
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
                                            : s.url,
                                        height: Resizable.size(context, 50),
                                        width: Resizable.size(context, 50),
                                        errorBuilder: (_, __, ___) =>
                                            Container(),
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    BlocProvider(
                        create: (context) => TeacherSurveyCubit(),
                        child: BlocBuilder<TeacherSurveyCubit, int>(
                            builder: (c, state) {
                          var cubit = BlocProvider.of<TeacherSurveyCubit>(c);
                          return InkWell(
                            onTap: () {
                              showDialog(
                                  context: context,
                                  builder: (context) =>
                                      TeacherSurveyDialog(
                                          cubit: cubit));
                            },
                            child: Container(
                              width: Resizable.size(context, 130),
                              height: Resizable.size(context, 30),
                              padding:
                                  EdgeInsets.all(Resizable.size(context, 5)),
                              decoration: ShapeDecoration(
                                color: Colors.white,
                                shape: RoundedRectangleBorder(
                                  side: const BorderSide(
                                    width: 1,
                                    strokeAlign: BorderSide.strokeAlignOutside,
                                    color: Color(0xFFDADADA),
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                shadows: const [
                                  BoxShadow(
                                    color: Color(0x3F000000),
                                    blurRadius: 2,
                                    offset: Offset(0, 2),
                                    spreadRadius: 0,
                                  )
                                ],
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    AppText.txtSurvey.text,
                                    style: TextStyle(
                                      color: darkPrimaryColor,
                                      fontSize: Resizable.font(context, 18),
                                      fontFamily: 'Montserrat',
                                      fontWeight: FontWeight.w700,
                                      height: 0,
                                    ),
                                  ),
                                  SizedBox(
                                      width: Resizable.padding(context, 5)),
                                  Container(
                                      height: Resizable.size(context, 17),
                                      width: Resizable.size(context, 20),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(100),
                                          color: primaryColor),
                                      child: Center(
                                        child: Text(
                                          cubit.count.toString(),
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize:
                                                Resizable.font(context, 17),
                                            fontFamily: 'Montserrat',
                                            fontWeight: FontWeight.w700,
                                            height: 0,
                                          ),
                                        ),
                                      ))
                                ],
                              ),
                            ),
                          );
                        })),
                    SizedBox(width: Resizable.padding(context, 10)),
                    AddButton(
                      onTap: () {
                        showDialog(
                            context: context,
                            builder: (context) => FeedBackDialog());
                      },
                      title: AppText.titleSendFeedback.text,
                    )
                  ],
                )
              ],
            ),
          );
        });
  }
}
