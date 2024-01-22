import 'package:flutter/Material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/features/teacher/lecture/detail_lesson/dropdown_cubit.dart';
import 'package:internal_sakumi/utils/resizable.dart';

class StatusClassItem extends StatelessWidget {
  const StatusClassItem(
      {super.key,
      required this.status,
      required this.color,
      required this.icon});
  final String status;
  final Color color;
  final String icon;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
        decoration: BoxDecoration(
            color: Colors.black,
            border: Border.all(
                color: Colors.black, width: Resizable.size(context, 1)),
            borderRadius: BorderRadius.circular(Resizable.size(context, 5))),
        richMessage: WidgetSpan(
            alignment: PlaceholderAlignment.baseline,
            baseline: TextBaseline.alphabetic,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                    text: vietnameseSubText(status),
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: Resizable.font(context, 18),
                        color: Colors.white),
                  ),
                ),
              ],
            )),
        child: AspectRatio(
          aspectRatio: 1,
          child: Container(
            height: Resizable.size(context, 20),
            width: Resizable.size(context, 20),
            padding: EdgeInsets.all(Resizable.padding(context, 10)),
            decoration: BoxDecoration(
                color: color,
                borderRadius: BlocProvider.of<DropdownCubit>(context).state %
                            2 ==
                        0
                    ? BorderRadius.horizontal(
                        left: Radius.circular(Resizable.padding(context, 5)))
                    : BorderRadius.only(
                        topLeft:
                            Radius.circular(Resizable.padding(context, 5)))),
            child: Image.asset('assets/images/ic_$icon.png'),
          ),
        ));
  }
}
