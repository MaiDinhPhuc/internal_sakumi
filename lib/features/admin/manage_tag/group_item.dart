import 'package:flutter/Material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:internal_sakumi/configs/color_configs.dart';
import 'package:internal_sakumi/utils/resizable.dart';

class GroupItem extends StatelessWidget {
  const GroupItem(
      {super.key,
      required this.isFocus,
      required this.title,
      required this.onDelete,
      required this.onClick, required this.onEdit});

  final bool isFocus;
  final String title;
  final Function()? onDelete;
  final Function() onClick;
  final Function()? onEdit;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: Resizable.size(context, 30),
      child: Row(
        children: [
          if (isFocus)
            Container(
              width: Resizable.size(context, 3),
              margin:
                  EdgeInsets.symmetric(vertical: Resizable.size(context, 1)),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: primaryColor,
              ),
            ),
          if (isFocus)
            SizedBox(
              width: Resizable.size(context, 5),
            ),
          Expanded(
            child: InkWell(
              onTap: onClick,
              borderRadius: BorderRadius.circular(10),
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(
                      color: !isFocus ? greyAccent : Colors.black,
                      width: 1,
                    )),
                child: Row(
                  children: [
                    SizedBox(
                      width: Resizable.size(context, 5),
                    ),
                    Expanded(
                        child: Text(
                      title.toUpperCase(),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: Resizable.font(context, 20)),
                    )),
                    Opacity(
                      opacity: onEdit == null ? 0 : 1,
                      child: IconButton(
                          onPressed: onEdit,
                          splashRadius: Resizable.size(context, 10),
                          iconSize: Resizable.size(context, 15),
                          icon: const Icon(Icons.edit, color: primaryColor,)),
                    ),
                    Opacity(
                      opacity: onDelete == null ? 0 : 1,
                      child: IconButton(
                          onPressed: onDelete,
                          splashRadius: Resizable.size(context, 10),
                          iconSize: Resizable.size(context, 15),
                          icon: Image.asset(
                            'assets/images/ic_trash.png',
                            scale: 2.5,
                          )),
                    )
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
