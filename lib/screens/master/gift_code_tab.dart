import 'package:flutter/Material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/configs/color_configs.dart';
import 'package:internal_sakumi/features/master/manage_course/alert_add_new_course.dart';
import 'package:internal_sakumi/providers/firebase/firestore_db.dart';
import 'package:internal_sakumi/utils/resizable.dart';
import 'package:internal_sakumi/widget/custom_appbar.dart';

class GiftCodeTab extends StatelessWidget {
  const GiftCodeTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: [
            const MasterAppbar( s: 6),
            Expanded(
                child: Center(
                  child: BlocProvider(
                    create: (context) => SwitcherCubit(true)..loadGiftEnable(),
                    child: BlocBuilder<SwitcherCubit, bool>(
                      builder: (c, s) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Enable Gift Code",
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: Resizable.font(context, 18),
                                    color: const Color(0xff757575))),
                            Switch(
                                value: s,
                                activeColor: primaryColor,
                                onChanged: (bool value) async {
                                   BlocProvider.of<SwitcherCubit>(c).update();
                                   await FireStoreDb.instance
                                       .updateGiftEnable(value);
                                  // Update.updateCourseState(courseModel!, value);
                                  // cubit.loadAfterChangeStatus(courseModel!, value);
                                })
                          ],
                        );
                      },
                    ),
                  )
                ))
          ],
        ));
  }
}