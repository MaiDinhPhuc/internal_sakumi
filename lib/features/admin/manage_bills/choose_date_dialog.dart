import 'package:flutter/Material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/configs/color_configs.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/utils/resizable.dart';
import 'package:internal_sakumi/widget/dialog_button.dart';
import 'package:internal_sakumi/widget/submit_button.dart';

import 'date_choose_cubit.dart';

class ChooseDateDialog extends StatelessWidget {
  const ChooseDateDialog({super.key, required this.dateChooseCubit, required this.onSubmit, required this.onChooseCustom, required this.type});
  final DateChooseCubit dateChooseCubit;
  final Function() onSubmit;
  final Function() onChooseCustom;
  final int type;
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DateChooseCubit, int>(
        bloc: dateChooseCubit,
        builder: (c,s){
          return Dialog(
            backgroundColor: Colors.white,
            insetPadding: EdgeInsets.all( Resizable.padding(context, 5)),
            child: Container(
                width: Resizable.size(context, 240),
                height: Resizable.size(context, 150),
                padding: EdgeInsets.all(Resizable.padding(context, 10)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                      AppText.txtFilterDate.text,
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: Resizable.font(
                              context, 17),
                          color: greyColor.shade600)),
                  SizedBox(height: Resizable.size(
                      context, 5)),
                  Wrap(
                    runSpacing: Resizable.size(
                        context, 5),
                    spacing: Resizable.size(
                        context, 10),
                    children: [
                      ...dateChooseCubit.listTime.map((e) => GestureDetector(
                        onTap: (){
                          if(type == 1){
                            dateChooseCubit.chooseDate(e);
                          }else{
                            dateChooseCubit.chooseDateV2(e);
                          }
                        },
                        child: Container(
                            padding: EdgeInsets.all(Resizable.size(
                                context, 5)),
                            decoration: BoxDecoration(
                              color: dateChooseCubit.choose == e ? primaryColor : Colors.white,
                              border: Border.all(
                                  width: 0.5,
                                  color: primaryColor
                              ),
                              borderRadius: BorderRadius.circular(Resizable.size(
                                  context, 20)),
                            ),
                            child: Text(
                                '$e tháng',
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: Resizable.font(context, 17),
                                    color: dateChooseCubit.choose != e ? primaryColor : Colors.white))
                        )
                      )),
                      GestureDetector(
                          onTap: onChooseCustom,
                          child: Container(
                              padding: EdgeInsets.all(Resizable.size(
                                  context, 5)),
                              decoration: BoxDecoration(
                                color: dateChooseCubit.choose == 0 ? primaryColor : Colors.white,
                                border: Border.all(
                                    width: 0.5,
                                    color: primaryColor
                                ),
                                borderRadius: BorderRadius.circular(Resizable.size(
                                    context, 20)),
                              ),
                              child: Text(
                                  'Tuỳ chỉnh',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: Resizable.font(context, 17),
                                      color: dateChooseCubit.choose != 0 ? primaryColor : Colors.white))
                          )
                      )
                    ],
                  ),
                  Padding(padding: EdgeInsets.symmetric(vertical: Resizable.padding(context, 5)),child: Text(
                      dateChooseCubit.getDate(),
                      style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: Resizable.font(context, 19),
                          color: dateChooseCubit.startDate != null && dateChooseCubit.endDate != null? primaryColor : Colors.black))),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      DialogButton(
                          AppText.textCancel.text.toUpperCase(),
                          onPressed: (){
                            dateChooseCubit.clear();
                            Navigator.pop(context);
                          }),
                      SizedBox(width: Resizable.size(
                          context, 10)),
                      SubmitButton(
                          isActive: dateChooseCubit.startDate != null && dateChooseCubit.endDate != null,
                          onPressed: onSubmit, title: 'Lọc')
                    ]
                  )
                ],
              )
            ),
          );
        });
  }
}
