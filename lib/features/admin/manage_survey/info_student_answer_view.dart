import 'package:flutter/Material.dart';
import 'package:internal_sakumi/features/admin/manage_general/small_avt.dart';
import 'package:internal_sakumi/utils/resizable.dart';

import 'detail_survey_admin_cubit.dart';

void alertStudentInfo(
    BuildContext context, DetailSurveyAdminCubit cubit, int id, String answer) {
  showDialog(
      context: context,
      builder: (_) {
        return Dialog(
          child: Container(
              width: Resizable.size(context, 150),
              padding: EdgeInsets.all(Resizable.padding(context, 10)),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    ...cubit
                        .getInfo(id, answer)
                        .map((e) => Row(
                              children: [
                                SmallAvatar(e["avt"]),
                                SizedBox(width: Resizable.padding(context, 10)),
                                Text(e['name'],
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        color: const Color(0xff131111),
                                        fontSize: Resizable.font(context, 17)))
                              ],
                            ))
                        .toList()
                  ],
                ),
              )),
        );
      });
}

void alertStudentInfoWithAnotherAnswer(
    BuildContext context, DetailSurveyAdminCubit cubit, int id) {
  showDialog(
      context: context,
      builder: (_) {
        return Dialog(
          child: Container(
              width: Resizable.size(context, 300),
              padding: EdgeInsets.all(Resizable.padding(context, 10)),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    ...cubit
                        .getInfoWithAnotherAnswer(id)
                        .map((e) => Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    SmallAvatar(e["avt"]),
                                    SizedBox(
                                        width: Resizable.padding(context, 10)),
                                    Text(e['name'],
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            color: const Color(0xff131111),
                                            fontSize:
                                                Resizable.font(context, 17))),
                                  ],
                                ),
                                Text("- ${e["answer"]}",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        color: const Color(0xff131111),
                                        fontSize: Resizable.font(context, 17)))
                              ],
                            ))
                        .toList()
                  ],
                ),
              )),
        );
      });
}
