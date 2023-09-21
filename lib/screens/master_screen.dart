import 'package:flutter/material.dart';
import 'package:internal_sakumi/configs/color_configs.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/utils/resizable.dart';

class MasterScreen extends StatelessWidget {
  const MasterScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(AppText.titleMaster.text),
      ),
      body: Stack(
        children: [
          Container(
            alignment: Alignment.bottomRight,
            margin: EdgeInsets.only(
                bottom: Resizable.padding(context, 20),
                right: Resizable.padding(context, 20)),
            child: Stack(
              children: [
                Container(
                    alignment: Alignment.center,
                    width: Resizable.size(context, 30),
                    height: Resizable.size(context, 30),
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: primaryColor,
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black38,
                              blurRadius: Resizable.size(context, 5))
                        ]),
                    child: Icon(
                      Icons.add,
                      size: Resizable.size(context, 20),
                      color: Colors.white,
                    )),
                Positioned.fill(
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                          borderRadius: BorderRadius.circular(1000),
                          onTap: () {}
                      ),
                    ))
              ],
            ),
          )
        ],
      )
    );
  }
}
