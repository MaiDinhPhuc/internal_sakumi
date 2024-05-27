import 'package:flutter/Material.dart';
import 'package:internal_sakumi/configs/color_configs.dart';
import 'package:internal_sakumi/utils/resizable.dart';

class ManageBrowseDownloadButton extends StatelessWidget {
  const ManageBrowseDownloadButton(
      {super.key,
      required this.onTap,
      required this.title,
      required this.count});
  final Function() onTap;
  final String title;
  final int count;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: Resizable.size(context, 130),
        height: Resizable.size(context, 30),
        padding: EdgeInsets.all(Resizable.size(context, 5)),
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
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style: TextStyle(
                color: darkPrimaryColor,
                fontSize: Resizable.font(context, 18),
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.w700,
                height: 0,
              ),
            ),
            SizedBox(width: Resizable.padding(context, 5)),
            Container(
                height: Resizable.size(context, 17),
                width:  Resizable.size(context, 20),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    color: primaryColor),
                child: Center(
                  child: Text(
                    count.toString(),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: Resizable.font(context, 17),
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w700,
                      height: 0,
                    ),
                  ),
                ))
          ],
        ),
      ),
    );
  }
}
