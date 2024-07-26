import 'package:flutter/Material.dart';
import 'package:internal_sakumi/configs/color_configs.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/features/admin/manage_general/small_avt.dart';
import 'package:internal_sakumi/utils/resizable.dart';

Color getColor(String status) {
  switch (status) {
    case 'InProgress':
      return greenColor;
    case 'Cancel':
    case 'Remove':
      return redColor;
    case 'Completed':
    case 'Preparing':
      return darkPrimaryColor;
    default:
      return greenColor;
  }
}

String getIcon(String status) {
  switch (status) {
    case 'InProgress':
    case 'Preparing':
      return "in_progress";
    case 'Cancel':
    case 'Remove':
      return "dropped";
    case 'Completed':
      return "check";
    default:
      return "in_progress";
  }
}

class ItemSearch extends StatelessWidget {
  const ItemSearch(
      {super.key,
      required this.type,
      required this.isLast,
      this.url,
      this.name,
      this.code,
      this.classStatus,
      this.classType,
      this.email,
      required this.id,
      required this.onTap});
  final String type;
  final String? url, name, code, classStatus, email;
  final int? classType;
  final int id;
  final bool isLast;
  final Function() onTap;
  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: onTap,
        child: type != AppText.txtClass.text
            ? Padding(
                padding: EdgeInsets.only(
                    top: Resizable.padding(context, 5),
                    left: Resizable.padding(context, 5),
                    right: Resizable.padding(context, 5)),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: Resizable.padding(context, 5)),
                                child: SmallAvatar(url!)),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(name!,
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: Resizable.size(context, 14),
                                        fontWeight: FontWeight.w600)),
                                SizedBox(height: Resizable.padding(context, 2)),
                                Row(
                                  children: [
                                    SizedBox(
                                        width: Resizable.padding(context, 150),
                                        child: Text(
                                            type == AppText.txtStudent.text
                                                ? "${AppText.txtStudentCode.text}: ${code!}"
                                                : "${AppText.txtTeacherCode.text}: ${code!}",
                                            style: TextStyle(
                                                color: darkPrimaryColor,
                                                fontSize: Resizable.size(context, 10),
                                                fontWeight: FontWeight.w600))),
                                    SizedBox(width: Resizable.padding(context, 10)),
                                    Text(
                                        "Email: ${email!}",
                                        style: TextStyle(
                                            color: darkPrimaryColor,
                                            fontSize: Resizable.size(context, 10),
                                            fontWeight: FontWeight.w600))
                                  ],
                                )
                              ],
                            )
                          ],
                        ),
                      ],
                    ),
                    isLast
                        ? Container(
                            margin: EdgeInsets.symmetric(
                                vertical: Resizable.padding(context, 5)))
                        : Container(
                            height: Resizable.size(context, 1),
                            margin: EdgeInsets.only(
                                left: Resizable.padding(context, 5),
                                right: Resizable.padding(context, 5),
                                top: Resizable.padding(context, 5)),
                            color: greyColor.shade300,
                          )
                  ],
                ),
              )
            : Padding(
                padding: EdgeInsets.only(
                    top: Resizable.padding(context, 5),
                    left: Resizable.padding(context, 5),
                    right: Resizable.padding(context, 5)),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: Resizable.padding(context, 5)),
                                child: Container(
                                  height: 30,
                                  width: 30,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(1000),
                                    boxShadow: [
                                      BoxShadow(
                                          color: getColor(classStatus!))
                                    ],
                                  ),
                                  child: ClipRRect(
                                      borderRadius: BorderRadius.circular(1000),
                                      child: Tooltip(
                                          padding: EdgeInsets.all(
                                              Resizable.padding(context, 10)),
                                          decoration: BoxDecoration(
                                              color: Colors.black,
                                              border: Border.all(
                                                  color: Colors.black,
                                                  width: Resizable.size(
                                                      context, 1)),
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      Resizable.padding(
                                                          context, 5))),
                                          richMessage: WidgetSpan(
                                              alignment:
                                                  PlaceholderAlignment.baseline,
                                              baseline: TextBaseline.alphabetic,
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  RichText(
                                                    text: TextSpan(
                                                      text: vietnameseSubText(
                                                          classStatus!),
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          fontSize:
                                                              Resizable.font(
                                                                  context, 18),
                                                          color: Colors.white),
                                                    ),
                                                  ),
                                                ],
                                              )),
                                          child: AspectRatio(
                                            aspectRatio: 1,
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  color: getColor(classStatus!),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          1000)),
                                              child: Center(
                                                child: Image.asset(
                                                  'assets/images/ic_${getIcon(classStatus!)}.png',
                                                  scale: 50,
                                                ),
                                              ),
                                            ),
                                          ))),
                                )),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("${AppText.txtClassCode.text}: ${code!}",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: Resizable.size(context, 14),
                                        fontWeight: FontWeight.w600)),
                                Text(
                                    "${AppText.txtClassType.text}: ${classType! == 0 ? "Lớp Chung" : "Lớp 1-1"}",
                                    style: TextStyle(
                                        color: darkPrimaryColor,
                                        fontSize: Resizable.size(context, 10),
                                        fontWeight: FontWeight.w600))
                              ],
                            )
                          ],
                        )
                      ],
                    ),
                    isLast
                        ? Container(
                            margin: EdgeInsets.symmetric(
                                vertical: Resizable.padding(context, 5)))
                        : Container(
                            height: Resizable.size(context, 1),
                            margin: EdgeInsets.only(
                                left: Resizable.padding(context, 5),
                                right: Resizable.padding(context, 5),
                                top: Resizable.padding(context, 5)),
                            color: greyColor.shade300,
                          )
                  ],
                ),
              ));
  }
}
