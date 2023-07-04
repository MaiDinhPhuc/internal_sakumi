import 'package:flutter/material.dart';
import 'package:internal_sakumi/configs/color_configs.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/screens/teacher_screen.dart';
import 'package:internal_sakumi/utils/resizable.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ListLessonScreen extends StatelessWidget {
  const ListLessonScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text('ahihi ${AppText.txtSensei.text}',
                  style: TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: Resizable.font(context, 40))),
              CircleAvatar(
                radius: Resizable.size(context, 25),
                backgroundColor: greyColor.shade300,
              ),
            ],
          ),
          SingleChildScrollView(
            child: Column(
              children: [],
            ),
          )
        ],
      ),
    );
  }
}
