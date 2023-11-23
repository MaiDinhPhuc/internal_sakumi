import 'package:flutter/Material.dart';
import 'package:internal_sakumi/configs/color_configs.dart';
import 'package:internal_sakumi/model/navigation/feedback_navigation.dart';
import 'package:internal_sakumi/utils/resizable.dart';

class FeedBackNavigationItem extends StatelessWidget {
  const FeedBackNavigationItem(
      {super.key,
      required this.number,
      required this.navigation,
      required this.type,
      required this.onTap});
  final FeedBackNavigationModel navigation;
  final String type;
  final Function() onTap;
  final int number;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
            child: Card(
                margin: EdgeInsets.only(
                    right: Resizable.padding(context, 10),
                    bottom: Resizable.padding(context, 10)),
                shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(Resizable.size(context, 5)),
                    side: BorderSide(
                        color: type == navigation.type
                            ? Colors.black
                            : const Color(0xffE0E0E0),
                        width: Resizable.size(context, 1))),
                elevation:
                    type == navigation.type ? 0 : Resizable.size(context, 2),
                child: InkWell(
                  onTap: onTap,
                  borderRadius:
                      BorderRadius.circular(Resizable.size(context, 5)),
                  child: Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: Resizable.padding(context, 10),
                          horizontal: Resizable.padding(context, 15)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(navigation.title,
                              style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: Resizable.font(context, 20))),
                          if (number != 0)
                            Container(
                                padding: EdgeInsets.symmetric(
                                    vertical: Resizable.padding(context, 4),
                                    horizontal: Resizable.padding(context, 10)),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10000),
                                    color: primaryColor),
                                child: Text(
                                  number.toString(),
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: Resizable.font(context, 17),
                                      fontWeight: FontWeight.w800),
                                ))
                        ],
                      )),
                )))
      ],
    );
  }
}
