import 'package:flutter/Material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/features/teacher/browse_download/request_browse_download_cubit.dart';
import 'package:internal_sakumi/features/teacher/browse_download/request_browse_download_view.dart';
import 'package:internal_sakumi/model/class_model.dart';
import 'package:internal_sakumi/model/lesson_model.dart';
import 'package:internal_sakumi/utils/resizable.dart';
import 'package:internal_sakumi/widget/dialog_button.dart';
import 'package:internal_sakumi/widget/waiting_dialog.dart';

class RequestBrowseDownloadDialog extends StatelessWidget {
  RequestBrowseDownloadDialog({super.key, required this.listLessons, required this.classModel})
      : cubit = RequestBrowseDownloadCubit(listLessons, classModel);

  final RequestBrowseDownloadCubit cubit;
  final List<LessonModel> listLessons;
  final ClassModel classModel;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RequestBrowseDownloadCubit, int>(
        bloc: cubit,
        builder: (c, s) {
          return cubit.loading
              ? const WaitingAlert()
              : Dialog(
                  backgroundColor: Colors.white,
                  insetPadding: EdgeInsets.all(Resizable.padding(context, 10)),
                  child: Container(
                    width: MediaQuery.of(context).size.width / 2,
                    height: MediaQuery.of(context).size.height * 0.8,
                    padding: EdgeInsets.all(Resizable.padding(context, 20)),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Expanded(
                            flex: 1,
                            child: Container(
                              alignment: Alignment.topLeft,
                              margin: EdgeInsets.only(
                                  bottom: Resizable.padding(context, 20)),
                              child: Text(
                                AppText.txtData.text.toUpperCase(),
                                style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: Resizable.font(context, 20)),
                              ),
                            )),
                        //InfoAddCustomLesson(cubit:cubit),
                        Expanded(
                            flex: 7,
                            child: RequestBrowseDownloadView(cubit: cubit)),
                        Expanded(
                            flex: 1,
                            child: Container(
                                margin: EdgeInsets.only(
                                    top: Resizable.padding(context, 20)),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Container(
                                      constraints: BoxConstraints(
                                          minWidth:
                                              Resizable.size(context, 100)),
                                      child: DialogButton(
                                          AppText.textCancel.text.toUpperCase(),
                                          onPressed: () =>
                                              Navigator.pop(context)),
                                    ),
                                  ],
                                )))
                      ],
                    ),
                  ));
        });
  }
}
