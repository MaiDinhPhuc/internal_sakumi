import 'package:flutter/Material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/utils/resizable.dart';
import 'package:internal_sakumi/widget/dialog_button.dart';
import 'package:internal_sakumi/widget/waiting_dialog.dart';

import 'browse_download_view.dart';
import 'manage_browse_download_cubit.dart';

class ManageBrowseDownloadDialog extends StatelessWidget {
  const ManageBrowseDownloadDialog({super.key, required this.cubit});

  final ManageBrowseDownloadCubit cubit;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ManageBrowseDownloadCubit, int>(
        bloc: cubit..loadData(),
        builder: (c, s) {
          return cubit.listBrowseDownload == null
              ? const WaitingAlert()
              : Dialog(
              backgroundColor: Colors.white,
              insetPadding: EdgeInsets.all(Resizable.padding(context, 10)),
              child: Container(
                width: MediaQuery.of(context).size.width ,
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
                    Expanded(
                        flex: 7,
                        child: BrowseDownloadView(cubit: cubit)),
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
