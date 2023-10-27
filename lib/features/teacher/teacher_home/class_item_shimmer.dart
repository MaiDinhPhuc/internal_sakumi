import 'package:flutter/Material.dart';
import 'package:internal_sakumi/utils/resizable.dart';

class ClassItemShimmer extends StatelessWidget {
  const ClassItemShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(
            bottom: Resizable.padding(context, 10)),
        child: Card(
            margin: EdgeInsets.zero,
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(Resizable.size(context, 5)),
              ),
              side: const BorderSide(
                color: Color(0xffB0B0B0),
                width: 0.5,
              ),
            ),
            elevation: 3,
            child: SizedBox(
              height: Resizable.size(context, 50),
              child: Column(
                children: [
                  SizedBox(
                    height: Resizable.padding(context, 50),
                    child: const Row(
                      children: [
                        Text('hhhhh'),
                      ],
                    ),
                  ),
                ],
              ),
            )));
  }
}