import 'package:flutter/Material.dart';
import 'package:internal_sakumi/configs/color_configs.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/providers/cache/filter_statistic_provider.dart';
import 'package:internal_sakumi/utils/resizable.dart';

class TotalStudentView extends StatelessWidget {
  const TotalStudentView({super.key, required this.filterController});
  final StatisticFilterCubit filterController;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
            flex: 1,
            child: Container(
              padding: EdgeInsets.all(Resizable.padding(context, 10)),
              margin: EdgeInsets.only(
                  top: Resizable.padding(context, 10),
                  bottom: Resizable.padding(context, 10),
                  right: Resizable.padding(context, 10)),
              decoration: BoxDecoration(
                border: Border.all(
                    width: 0.5, color: const Color(0xffE0E0E0)),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(AppText.txtTotalStudent.text,
                      style: TextStyle(
                          fontSize: Resizable.size(context, 20),
                          fontWeight: FontWeight.w700,
                          color: greyColor.shade600)),
                  Container(
                    height: Resizable.size(context, 1),
                    margin:
                    EdgeInsets.symmetric(vertical: Resizable.padding(context, 15)),
                    color: const Color(0xffD9D9D9),
                  ),
                  Text(filterController.studentStatisticCubit.totalStudent == null ? "0" :filterController.studentStatisticCubit.totalStudent!.toString(),
                      style: TextStyle(
                          fontSize: Resizable.size(context, 60),
                          fontWeight: FontWeight.w700,
                          color: primaryColor))
                ],
              ),
            )),
        Expanded(
            flex: 1,
            child: Container  (
              padding: EdgeInsets.all(Resizable.padding(context, 10)),
              margin: EdgeInsets.only(
                  bottom: Resizable.padding(context, 10),
                  right: Resizable.padding(context, 10)),
              decoration: BoxDecoration(
                border: Border.all(
                    width: 0.5, color: const Color(0xffE0E0E0)),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(AppText.txtTotalStudentLearning.text,
                      style: TextStyle(
                          fontSize: Resizable.size(context, 18),
                          fontWeight: FontWeight.w700,
                          color: greyColor.shade600)),
                  Container(
                    height: Resizable.size(context, 1),
                    margin:
                    EdgeInsets.symmetric(vertical: Resizable.padding(context, 15)),
                    color: const Color(0xffD9D9D9),
                  ),
                  Text(filterController.studentStatisticCubit.totalStudentLearning == null ? "0" :filterController.studentStatisticCubit.totalStudentLearning!.toString(),
                      style: TextStyle(
                          fontSize: Resizable.size(context, 60),
                          fontWeight: FontWeight.w700,
                          color: primaryColor))
                ],
              ),
            ))
      ],
    );
  }
}