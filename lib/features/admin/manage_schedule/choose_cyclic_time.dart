import 'package:flutter/Material.dart';
import 'package:flutter/cupertino.dart';
import 'package:internal_sakumi/configs/color_configs.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/utils/resizable.dart';

import 'add_schedule_cubit.dart';
import 'choose_time_dialog.dart';

class ChooseCyclicTime extends StatelessWidget {
  const ChooseCyclicTime({super.key, required this.addCubit});
  final AddScheduleCubit addCubit;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: Resizable.size(context, 275),
      width: MediaQuery.of(context).size.width / 2,
      decoration: BoxDecoration(
          border: Border.all(
              width: Resizable.size(context, 1), color: greyColor.shade300),
          borderRadius: BorderRadius.circular(Resizable.size(context, 5))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.all(Resizable.size(context, 10)),
            height: Resizable.size(context, 250),
            width: MediaQuery.of(context).size.width / 4,
            decoration: BoxDecoration(
                border: Border.all(
                    width: Resizable.size(context, 1),
                    color: greyColor.shade300),
                borderRadius:
                    BorderRadius.circular(Resizable.size(context, 5))),
            child: Column(
              children: [
                ...addCubit.listDay.map((e) => CheckboxListTile(
                      controlAffinity: ListTileControlAffinity.leading,
                      title: Text("$e  ${addCubit.listCheckTime[addCubit.listDay.indexOf(e)]}",
                          style:
                              TextStyle(fontSize: Resizable.font(context, 20))),
                      value: addCubit.listCheckDay[addCubit.listDay.indexOf(e)],
                      onChanged: (newValue) {
                        var index = addCubit.listDay.indexOf(e);
                        if(addCubit.listCheckDay[index] == true) {
                          addCubit.chooseDay(index);
                        }else{
                          showDialog(
                              context: context,
                              builder: (_) => ChooseTimeDialog(addCubit: addCubit, index: index));
                        }
                      },
                    ))
              ],
            ),
          ),
        ],
      ),
    );
  }
}
