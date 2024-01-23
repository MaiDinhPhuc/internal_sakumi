import 'package:flutter/Material.dart';
import 'package:internal_sakumi/configs/color_configs.dart';
import 'package:internal_sakumi/utils/resizable.dart';

import 'detail_survey_cubit.dart';

class QuestionSurveyView extends StatelessWidget {
  const QuestionSurveyView(
      {super.key,
      required this.index,
      required this.detailSurveyCubit,
      required this.number,
      required this.active});
  final int index, number;
  final DetailSurveyCubit detailSurveyCubit;
  final bool active;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          color: number == detailSurveyCubit.selector
              ? primaryColor
              : Colors.transparent,
          width: Resizable.size(context, 4),
          margin: EdgeInsets.only(
              right: Resizable.padding(context, 5),
              bottom: Resizable.padding(context, 10)),
        ),
        Expanded(
            child: Card(
                margin: EdgeInsets.only(
                    right: Resizable.padding(context, 10),
                    bottom: Resizable.padding(context, 10)),
                shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(Resizable.size(context, 5)),
                    side: BorderSide(
                        color: number == detailSurveyCubit.selector
                            ? Colors.black
                            : const Color(0xffE0E0E0),
                        width: Resizable.size(context, 1))),
                elevation: number == detailSurveyCubit.selector
                    ? Resizable.size(context, 2)
                    : 0,
                child: InkWell(
                    borderRadius:
                        BorderRadius.circular(Resizable.size(context, 5)),
                    onTap: () async {
                      await detailSurveyCubit.select(number);
                    },
                    child: Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: Resizable.padding(context, 10),
                            horizontal: Resizable.padding(context, 15)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Câu số ${index + 1}",
                              style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: Resizable.font(context, 17)),
                            ),
                            if (!active)
                              InkWell(
                                  borderRadius: BorderRadius.circular(
                                      Resizable.size(context, 100)),
                                  onTap: () {
                                    detailSurveyCubit.deleteQuestion(number);
                                  },
                                  child: Icon(Icons.delete,
                                      color: primaryColor,
                                      size: Resizable.size(context, 20)))
                          ],
                        )))))
      ],
    );
  }
}
