import 'package:flutter/Material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/configs/color_configs.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/features/admin/app_bar/admin_appbar.dart';
import 'package:internal_sakumi/features/admin/manage_advise/list_advise_view.dart';
import 'package:internal_sakumi/features/admin/manage_advise/manage_advise_cubit.dart';
import 'package:internal_sakumi/features/admin/manage_bills/add_bill_button.dart';
import 'package:internal_sakumi/features/admin/manage_feedback/feedback_navigation_item.dart';
import 'package:internal_sakumi/features/admin/manage_student/alert_add_new_std_account.dart';
import 'package:internal_sakumi/model/navigation/feedback_navigation.dart';
import 'package:internal_sakumi/utils/resizable.dart';
import 'package:internal_sakumi/widget/title_widget.dart';

class ManageAdvisesScreen extends StatelessWidget {
  ManageAdvisesScreen({super.key}) : cubit =ManageAdviseCubit();
  final ManageAdviseCubit cubit;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          const AdminAppBar(index: 9),
          Expanded(
              child: Center(
                child: Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: Resizable.padding(context, 70)),
                    child: Column(
                      children: [
                        Container(
                          margin: EdgeInsets.symmetric(
                              vertical: Resizable.padding(context, 15)),
                          child: Text(
                              AppText.txtListAdvise.text.toUpperCase(),
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w800,
                                  fontSize: Resizable.font(context, 30))),
                        ),
                        Expanded(
                            child: BlocBuilder<ManageAdviseCubit, int>(
                              bloc: cubit,
                              builder: (c, s) {
                                return cubit.listAdvise == null
                                    ? const Center(
                                  child: CircularProgressIndicator(
                                      color: primaryColor),
                                )
                                    : Row(
                                  children: [
                                    Expanded(
                                        flex: 1,
                                        child: Column(
                                          children: [
                                            TitleWidget(AppText
                                                .titleListFeedBack.text
                                                .toUpperCase()),
                                            Expanded(
                                                child: SingleChildScrollView(
                                                  child: Column(
                                                    children: [
                                                      ...listAdvise.map((e) =>
                                                          FeedBackNavigationItem(
                                                            number:
                                                            cubit.getCount(
                                                                e.type),
                                                            navigation: e,
                                                            type: cubit.type,
                                                            onTap: () {
                                                              cubit.changeType(e.type);
                                                            },
                                                          ))
                                                    ],
                                                  ),
                                                ))
                                          ],
                                        )),
                                    Expanded(
                                        flex: 2,
                                        child: ListAdviseView(
                                            cubit: cubit))
                                  ],
                                );
                              },
                            ))
                      ],
                    )),
              ))
        ],
      ),
    );
  }
}
List<FeedBackNavigationModel> listAdvise = [
  FeedBackNavigationModel(0, AppText.txtAdviseCourse.text, "course"),
  FeedBackNavigationModel(
      1, AppText.txtAdviseBanner.text, "banner"),
];