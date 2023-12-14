import 'package:flutter/Material.dart';
import 'package:internal_sakumi/model/test_model.dart';
import 'package:internal_sakumi/utils/resizable.dart';

import 'alert_new_test.dart';
import 'manage_course_cubit.dart';

class TestItem extends StatelessWidget {
  const TestItem(this.test,{super.key, required this.cubit});
  final TestModel test;
  final ManageCourseCubit cubit;
  @override
  Widget build(BuildContext context) {
    return Container(
        width: Resizable.size(context, 500),
        margin: EdgeInsets.only(bottom: Resizable.padding(context, 5)),
        padding: EdgeInsets.symmetric(
            horizontal: Resizable.padding(context, 20),
            vertical: Resizable.padding(context, 10)),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(Resizable.padding(context, 5)),
            color: Colors.white,
            border: Border.all(
                color: const Color(0xffE0E0E0),
                width: Resizable.size(context, 1))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
                flex: 6,
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("${test.id} - ${test.title}",
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: Resizable.font(context, 20),
                        color: Colors.black)),
                SizedBox(height: Resizable.padding(context, 3)),
                Text(test.description,
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: Resizable.font(context, 15),
                        color: const Color(0xff757575)))
              ],
            )),
            Expanded(
                flex: 1,
                child: InkWell(
                    borderRadius:
                    BorderRadius.circular(Resizable.size(context, 100)),
                    onTap: (){
                      alertAddNewTest(context,test,true, cubit);
                    },
                    child: Image.asset('assets/images/ic_edit.png',
                        height: Resizable.size(context, 20),
                        width: Resizable.size(context, 10))))
          ],
        )
    );
  }
}
