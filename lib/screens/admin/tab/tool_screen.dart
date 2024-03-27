import 'package:flutter/Material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/features/admin/app_bar/admin_appbar.dart';
import 'package:internal_sakumi/features/admin/tool/rename_cubit.dart';
import 'package:internal_sakumi/utils/resizable.dart';
import 'package:internal_sakumi/widget/submit_button.dart';

class ToolScreen extends StatelessWidget {
  final RenameCubit cubit;
  ToolScreen({super.key}) : cubit = RenameCubit();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          const AdminAppBar(index: 5),
          Expanded(
              child: BlocBuilder<RenameCubit, int>(
            bloc: cubit,
            builder: (c, s) {
              return Scaffold(
                  body: ConstrainedBox(
                constraints: const BoxConstraints.expand(),
                child: cubit.currentUser != null
                    ? Stack(
                        children: [
                          Container(
                            margin: EdgeInsets.only(
                              left: Resizable.padding(context, 30),
                              right: Resizable.padding(context, 30),
                              top: Resizable.padding(context, 20),
                            ),
                            decoration: BoxDecoration(
                                color: const Color(0xfff5f5f5),
                                borderRadius: BorderRadius.circular(
                                    Resizable.padding(context, 10))),
                            padding: EdgeInsets.only(
                                top: Resizable.padding(context, 20),
                                bottom: Resizable.padding(context, 20),
                                // right: Resizable.padding(context, 20),
                                left: Resizable.padding(context, 10)),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                    flex: 1,
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        ListTile(
                                          leading: GoogleUserCircleAvatar(
                                            identity: cubit.currentUser!,
                                          ),
                                          title: Text(
                                              cubit.currentUser!.displayName ??
                                                  ''),
                                          subtitle: Text(
                                              cubit.currentUser!.email ?? ''),
                                        ),
                                        Container(
                                            alignment: Alignment.center,
                                            margin: EdgeInsets.symmetric(
                                                vertical: Resizable.padding(
                                                    context, 20)),
                                            child: (cubit.drives.isEmpty)
                                                ? SubmitButton(
                                                    title:
                                                        AppText.btnVerify.text,
                                                    onPressed: () =>
                                                        cubit.verify(context))
                                                : IntrinsicWidth(
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .stretch,
                                                      children: [
                                                        SubmitButton(
                                                            isActive: cubit
                                                                .listSubmit
                                                                .isNotEmpty,
                                                            title: AppText
                                                                .btnRenameAndMove
                                                                .text,
                                                            onPressed: () =>
                                                                cubit.submit(
                                                                    context)),
                                                        SizedBox(
                                                            height: Resizable
                                                                .padding(
                                                                    context,
                                                                    10)),
                                                        SubmitButton(
                                                            title: AppText
                                                                .btnReVerify
                                                                .text,
                                                            onPressed: () =>
                                                                cubit.reload(
                                                                    context))
                                                      ],
                                                    ),
                                                  ))
                                      ],
                                    )),
                                Container(
                                  width: 0.5,
                                  color: const Color(0xffe0e0e0),
                                ),
                                Expanded(
                                    flex: 3,
                                    child: (cubit.allDriveFiles.isEmpty)
                                        ? Center(
                                            child: Text(AppText
                                                .txtInstructionTool.text))
                                        : Container(
                                            padding: EdgeInsets.only(
                                                left: Resizable.padding(
                                                    context, 20)),
                                            child: SingleChildScrollView(
                                              child: Column(children: [
                                                // ...cubit.listSubmit
                                                //     .map((e) => Text(e.name)),
                                                ...cubit.drives.map((e) => Row(
                                                      children: [
                                                        Expanded(
                                                            flex: 3,
                                                            child: Text(
                                                                '${e.file.name} ${e.error ?? 0}',
                                                                style: TextStyle(
                                                                    color: e.error !=
                                                                            null
                                                                        ? Colors
                                                                            .red
                                                                        : Colors
                                                                            .green))),
                                                        Expanded(
                                                            flex: 1,
                                                            child: Text(
                                                                e.classModel == null
                                                                    ? ''
                                                                    : e.folder ??
                                                                        e.classModel!
                                                                            .classCode,
                                                                style: TextStyle(
                                                                    color: e.error !=
                                                                            null
                                                                        ? Colors
                                                                            .red
                                                                        : Colors
                                                                            .green))),
                                                        Expanded(
                                                            flex: 4,
                                                            child: Text(
                                                                e.name != null
                                                                    ? (e.name!)
                                                                    : e
                                                                        .getErrorName(),
                                                                style: TextStyle(
                                                                    color: e.error !=
                                                                            null
                                                                        ? Colors
                                                                            .red
                                                                        : Colors
                                                                            .green))),
                                                      ],
                                                    )),
                                              ]),
                                            )))
                              ],
                            ),
                          ),
                        ],
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          Text(AppText.txtNotLoggedIn.text),
                          TextButton(
                            onPressed: cubit.handleSignIn,
                            child: Text(AppText.btnLogin.text.toUpperCase()),
                          ),
                        ],
                      ),
              ));
            },
          ))
        ],
      ),
    );
  }
}
