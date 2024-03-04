import 'package:flutter/Material.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/features/admin/manage_general/small_avt.dart';
import 'package:internal_sakumi/routes.dart';
import 'package:internal_sakumi/utils/resizable.dart';

class ItemSearch extends StatelessWidget {
  const ItemSearch(
      {super.key,
      required this.type,
      required this.isLast, this.url, this.name, this.code, this.classStatus, this.classType,required this.id});
  final String type;
  final String? url, name, code, classStatus;
  final int? classType;
  final int id;
  final bool isLast;
  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () async {
          if (type == AppText.txtClass.text) {
            await Navigator.pushNamed(context,
                "${Routes.admin}/overview/class=$id");
          } else if (type == AppText.txtStudent.text) {
            await Navigator.pushNamed(context,
                "${Routes.admin}/studentInfo/student=$id");
          } else {
            await Navigator.pushNamed(context,
                "${Routes.admin}/teacherInfo/teacher=$id");
          }
        },
        child: type != AppText.txtClass.text
            ? Padding(
                padding: EdgeInsets.only(
                    top: Resizable.padding(context, 10),
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
                                child: SmallAvatar(
                                    url!)),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                    name!,
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: Resizable.size(context, 14),
                                        fontWeight: FontWeight.w600)),
                                SizedBox(height: Resizable.padding(context, 2)),
                                Text(
                                    type == AppText.txtStudent.text
                                        ? "${AppText.txtStudentCode.text}: ${code!}"
                                        : "${AppText.txtTeacherCode.text}: ${code!}",
                                    style: TextStyle(
                                        color: const Color(0xFF757575),
                                        fontSize: Resizable.size(context, 10),
                                        fontWeight: FontWeight.w600))
                              ],
                            )
                          ],
                        ),
                        Icon(Icons.arrow_forward_ios_outlined,
                            size: Resizable.size(context, 17),
                            color: const Color(0xFF757575))
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
                            color: const Color(0xffD9D9D9),
                          )
                  ],
                ),
              )
            : Padding(
                padding: EdgeInsets.only(
                    top: Resizable.padding(context, 10),
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
                                          blurRadius: 5,
                                          color:
                                              getColor(classStatus!))
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
                                                      text: vietnameseSubText(classStatus!),
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
                                                  color: getColor(
                                                      classStatus!),
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
                                Text(
                                    "${AppText.txtClassCode.text}: ${code!}",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: Resizable.size(context, 14),
                                        fontWeight: FontWeight.w600)),
                                Text(
                                    "${AppText.txtClassType.text}: ${classType! == 0 ? "Lớp Chung" : "Lớp 1-1"}",
                                    style: TextStyle(
                                        color: const Color(0xFF757575),
                                        fontSize: Resizable.size(context, 10),
                                        fontWeight: FontWeight.w600))
                              ],
                            )
                          ],
                        ),
                        Icon(Icons.arrow_forward_ios_outlined,
                            size: Resizable.size(context, 17),
                            color: const Color(0xFF757575))
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
                            color: const Color(0xffD9D9D9),
                          )
                  ],
                ),
              ));
  }

  Color getColor(String status) {
    switch (status) {
      case 'InProgress':
        return const Color(0xff33691e);
      case 'Cancel':
      case 'Remove':
        return const Color(0xffB71C1C);
      case 'Completed':
      case 'Preparing':
        return const Color(0xff757575);
      default:
        return const Color(0xff33691e);
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
}

class ItemSearchV2 extends StatelessWidget {
  const ItemSearchV2(
      {super.key,
        required this.type,
        required this.isLast, this.url, this.name, this.code, this.classStatus, this.classType,required this.id, required this.onTap});
  final String type;
  final String? url, name, code, classStatus;
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
              top: Resizable.padding(context, 10),
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
                          child: SmallAvatar(
                              url!)),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                              name!,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: Resizable.size(context, 14),
                                  fontWeight: FontWeight.w600)),
                          SizedBox(height: Resizable.padding(context, 2)),
                          Text(
                              type == AppText.txtStudent.text
                                  ? "${AppText.txtStudentCode.text}: ${code!}"
                                  : "${AppText.txtTeacherCode.text}: ${code!}",
                              style: TextStyle(
                                  color: const Color(0xFF757575),
                                  fontSize: Resizable.size(context, 10),
                                  fontWeight: FontWeight.w600))
                        ],
                      )
                    ],
                  ),
                  Icon(Icons.arrow_forward_ios_outlined,
                      size: Resizable.size(context, 17),
                      color: const Color(0xFF757575))
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
                color: const Color(0xffD9D9D9),
              )
            ],
          ),
        )
            : Padding(
          padding: EdgeInsets.only(
              top: Resizable.padding(context, 10),
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
                                    blurRadius: 5,
                                    color:
                                    getColor(classStatus!))
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
                                                text: vietnameseSubText(classStatus!),
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
                                            color: getColor(
                                                classStatus!),
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
                          Text(
                              "${AppText.txtClassCode.text}: ${code!}",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: Resizable.size(context, 14),
                                  fontWeight: FontWeight.w600)),
                          Text(
                              "${AppText.txtClassType.text}: ${classType! == 0 ? "Lớp Chung" : "Lớp 1-1"}",
                              style: TextStyle(
                                  color: const Color(0xFF757575),
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
                color: const Color(0xffD9D9D9),
              )
            ],
          ),
        ));
  }

  Color getColor(String status) {
    switch (status) {
      case 'InProgress':
        return const Color(0xff33691e);
      case 'Cancel':
        return const Color(0xffB71C1C);
      case 'Completed':
      case 'Preparing':
        return const Color(0xff757575);
      default:
        return const Color(0xff33691e);
    }
  }

  String getIcon(String status) {
    switch (status) {
      case 'InProgress':
      case 'Preparing':
        return "in_progress";
      case 'Cancel':
        return "dropped";
      case 'Completed':
        return "check";
      default:
        return "in_progress";
    }
  }
}



