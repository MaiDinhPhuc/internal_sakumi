import 'package:flutter/Material.dart';
import 'package:internal_sakumi/configs/color_configs.dart';
import 'package:internal_sakumi/utils/resizable.dart';

import 'cyclic_schedule_dialog.dart';
import 'manage_schedule_cubit.dart';

class ChangeDateView extends StatelessWidget {
  const ChangeDateView({super.key, required this.cubit});
  final ManageScheduleCubit cubit;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          margin:
          EdgeInsets.symmetric(vertical: Resizable.padding(context, 10)),
          width: Resizable.size(context, 250),
          decoration: BoxDecoration(
              border: Border.all(
                  width: Resizable.size(context, 1), color: greyColor.shade300),
              borderRadius: BorderRadius.circular(Resizable.size(context, 5))),
          child:
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            InkWell(
              onTap: () {
                cubit.previous();
              },
              child: Padding(
                  padding: EdgeInsets.all(Resizable.padding(context, 5)),
                  child: Icon(Icons.arrow_back_ios_new_sharp,
                      color: greyColor.shade600)),
            ),
            InkWell(
                child: Text(cubit.getRangeDate(),
                    style: TextStyle(
                        fontSize: Resizable.font(context, 20),
                        fontWeight: FontWeight.w700,
                        color: greyColor.shade600))),
            InkWell(
              onTap: () {
                cubit.next();
              },
              child: Padding(
                  padding: EdgeInsets.all(Resizable.padding(context, 5)),
                  child: Icon(Icons.arrow_forward_ios_sharp,
                      color: greyColor.shade600)),
            )
          ]),
        ),
        Padding(padding: EdgeInsets.only(right: Resizable.font(context, 5)),child: InkWell(
          onTap: (){
            showDialog(
                context: context,
                builder: (context) => CyclicScheduleDialog(cubit: cubit));
          },
          child: Container(
            width: Resizable.size(context, 120),
            height: Resizable.size(context, 30),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
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
            child: Center(
                child: Text(
                  "+THÊM CA DẠY",
                  style: TextStyle(
                    color: greyColor.shade600,
                    fontSize: Resizable.font(context, 16),
                    fontWeight: FontWeight.w700,
                  ),
                )),
          ),
        ))

      ],
    );
  }
}
