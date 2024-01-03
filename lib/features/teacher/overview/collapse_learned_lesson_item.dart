import 'package:flutter/Material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/configs/color_configs.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/features/teacher/lecture/detail_lesson/detail_lesson_cubit.dart';
import 'package:internal_sakumi/utils/resizable.dart';

class CollapseLearnedLesson extends StatelessWidget {
  final String title, time, ignore;
  final int attend;
  final double? hw;
  const CollapseLearnedLesson(this.title, this.attend,this.hw,this.time, this.ignore, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
            flex: 6,
            child: Text(
                title,
                style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: Resizable.font(
                        context, 18)))),
        Expanded(
            flex: 8,
            child: Row(
              children: [
                Expanded(
                    flex:4,
                    child: Container(
                      alignment: Alignment.center,
                      constraints: BoxConstraints(
                          minWidth: Resizable.size(context, 100)
                      ),
                      decoration: BoxDecoration(
                          color: attend == 5 ? const Color(0xffF57F17) : attend == 6? const Color(0xffB71C1C) : attend == 0 ? const Color(0xff757575) : const Color(0xff33691E),
                          borderRadius:
                          BorderRadius.circular(
                              1000)),
                      margin: EdgeInsets.only(
                          right: Resizable.padding(
                              context, 20)),
                      padding: EdgeInsets.symmetric(
                          vertical: Resizable.padding(
                              context, 3)),
                      child: Text(
                          attend == 5 ? AppText.txtPermitted.text : attend == 6? AppText.txtAbsent.text : attend == 0 ? AppText.txtNoAttendance.text : AppText.txtPresent.text,
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight:
                              FontWeight.w700,
                              fontSize: Resizable.font(
                                  context, 16))),
                    )),
                Expanded(
                    flex:4,
                    child: Container(
                      alignment: Alignment.center,
                      constraints: BoxConstraints(
                          minWidth: Resizable.size(context, 100)
                      ),
                      decoration: BoxDecoration(
                          color: hw == -2 ? const Color(0xffB71C1C) : hw == -1 ? const Color(0xffF57F17) : hw == null ? const Color(0xff757575) : const Color(0xff33691E),
                          borderRadius:
                          BorderRadius.circular(
                              1000)),
                      margin: EdgeInsets.only(
                          right: Resizable.padding(
                              context, 20)),
                      padding: EdgeInsets.symmetric(
                          vertical: Resizable.padding(
                              context, 3)),
                      child: Text(
                          hw == -2 ? AppText.txtNotSubmit.text : hw == -1 ?  AppText.textNotMarked.text: hw == null ? AppText.txtNull.text : hw!.toStringAsFixed(2),
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight:
                              FontWeight.w700,
                              fontSize: Resizable.font(
                                  context, 16))),
                    )),
                Expanded(
                    flex:3,
                    child: Center(child: Text(time, style: TextStyle(
                        color: const Color(0xff757575),
                        fontWeight: FontWeight.w600,
                        fontSize: Resizable.font(context, 20))))),
                Expanded( flex:1,child: Container()),
                Expanded(
                    flex:2,
                    child: Text(ignore, style: TextStyle(
                        color: primaryColor,
                        fontWeight: FontWeight.w600,
                        fontSize: Resizable.font(context, 20)))),
                Expanded(
                    flex:1,
                    child: IconButton(
                        onPressed: () {
                          BlocProvider.of<
                              DropdownCubit>(context)
                              .update();
                        },
                        splashRadius:
                        Resizable.size(context, 15),
                        icon: Icon(
                          BlocProvider.of<
                              DropdownCubit>(context).state % 2 == 0
                              ? Icons
                              .keyboard_arrow_down
                              : Icons.keyboard_arrow_up,
                        )))
              ],
            ))
      ],
    );
  }
}