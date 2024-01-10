import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import "package:http/http.dart" as http;
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/drive/v3.dart' as drive;
import 'package:internal_sakumi/configs/app_configs.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/features/admin/tool/alert_input_field.dart';
import 'package:internal_sakumi/features/admin/tool/auth_client.dart';
import 'package:internal_sakumi/features/admin/tool/rename_model.dart';
import 'package:internal_sakumi/utils/resizable.dart';
import 'package:internal_sakumi/widget/waiting_dialog.dart';

GoogleSignIn _googleSignIn = GoogleSignIn(
  scopes: <String>[
    'email',
    'https://www.googleapis.com/auth/drive',
  ],
);

class SignInDemo extends StatefulWidget {
  const SignInDemo({super.key});

  @override
  State createState() => SignInDemoState();
}

class SignInDemoState extends State<SignInDemo> {
  GoogleSignInAccount? _currentUser;
  List<drive.File> documents = [];
  List<drive.File> folders = [];
  TextEditingController controller = TextEditingController();
  String editString = '';
  List<RenameModel> listRename = [];
  List<SubmitModel> listSubmit = [];
  RenameCubit cubit = RenameCubit();

  @override
  void initState() {
    super.initState();
    _googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount? account){
      setState(() {
        _currentUser = account;
      });
    });
    _googleSignIn.signInSilently();
    debugPrint('=============> current ${_currentUser?.email}');
  }

  List<RenameModel> splitString(String text) {
    List<String> list = text.split('\n');
    List<String> listTemp = list
        .map((string) =>
        string.replaceAllMapped(RegExp(r'^\s+|\s+$'), (match) => "*"))
        .toList();
    List<String> listString = [];
    for (var i in listTemp) {
      if (i != '*') {
        listString.add(i);
      }
    }

    for (var e in listString) {
      List<String> splitString = e.split('|');
      String link = splitString.first.trim().split('/').last;
      String name = splitString.last.trim();
      List<String> nameSplit = [];
      String folder = '';
      try{
        nameSplit = name.trim().split('-');
        folder = _getFolderName(
            nameSplit[1].toUpperCase().trim(), nameSplit[2].toUpperCase().trim());
      }
      catch(err){
        debugPrint('=========> error $err');
      }

      listRename.add(RenameModel(link, name, folder));
    }

    return listRename;
  }

  String _getFolderName(String textSource, String term) {
    String targetFolder = '';
    String text = textSource.replaceAll(' ', '');
    if (textSource.contains('NS')) {
      switch (text.substring(2, 3)) {
        case '1':
          {
            targetFolder =
                '${text.substring(0, 4)}-${text.substring(4, text.length)}';
            break;
          }
        case 'R':
          {
            if (text.substring(3, 4) == 'N') {
              targetFolder = text;
              break;
            } else {
              targetFolder = '$text-$term';
              break;
            }
          }
        case 'K':
          {
            targetFolder = text;
            break;
          }
        default:
          {
            targetFolder = '$text-$term';
            break;
          }
      }
    } else if (textSource.contains('LT')) {
      targetFolder =
          '${text.substring(0, 2)} ${text.substring(2, text.length)} - $term';
    } else {}
    debugPrint('============> target folder $targetFolder');
    return targetFolder;
  }

  _queryDrive(String query, List<drive.File> docs) async {
    final client = http.Client();
    var header = await _currentUser!.authHeaders;
    var authClient = AuthClient(client, header);
    var api = drive.DriveApi(authClient);

    String? pageToken;

    debugPrint('======> googleDriver4');
    do {
      debugPrint('======> googleDriver 000 ${docs.length}');
      var fileList = await api.files.list(
          q: query,
          pageSize: 1000,
          pageToken: pageToken,
          $fields:
              "nextPageToken, files(id, name, mimeType, thumbnailLink, parents)");
      pageToken = fileList.nextPageToken;

      docs.addAll(fileList.files?.toList() ?? []);
    } while (pageToken != null);
  }

  Future<void> _reCheckInvalid() async {
    Navigator.pop(context);

    for (var i in listRename) {
      int count = 0;
      for (var j in listRename) {
        if (i.link == j.link) {
          count++;
        }
      }
      if (count > 1) {
        i.invalid = 4;
      }
    }

    for (var r in listRename) {
      int count = 0;
      String fileName = r.name;
      String fileId = '';

      for (var f in documents) {
        if (f.name!.contains(r.link) && r.invalid == null) {
          count++;
          fileId = f.id.toString();
        }
      }
      if (count == 0) {
        r.invalid = 1;
      }
      if (count > 1) {
        r.invalid = 3;
      }
      if (r.invalid == null) {
        folders.clear();
        String nameOfFolder = r.folder.trim();
        await _queryDrive(
            "mimeType='application/vnd.google-apps.folder' and name='$nameOfFolder'",
            folders);
        debugPrint('=======> folder: $nameOfFolder');
        if (folders == null || folders.isEmpty) {
          r.invalid = 2;
        } else {
          for (var i in folders) {
            debugPrint('=======> folder ${i.name}');
          }
          String folderId = '${folders.first.id}';
          listSubmit.add(SubmitModel(fileName, fileId, folderId));
        }
      }
      cubit.buildUI();
    }
  }

  Future<void> _checkInvalid() async {
    Navigator.pop(context);
    waitingDialog(context);
    debugPrint('============> controller.text ${controller.text}');

    if (controller.text == null || controller.text.isEmpty) {
      Navigator.pop(context);
      notificationDialog(context, AppText.txtPleaseInput.text);
    } else {
      List<RenameModel> listRename = splitString(controller.text);

      documents!.clear();
      await _queryDrive(
          "mimeType='video/mp4' and '${AppConfigs.meetRecordingsId}' in parents",
          documents);

      debugPrint('======> googleDriver ${documents.length}');

      for (var i in listRename) {
        int count = 0;
        for (var j in listRename) {
          if (i.link == j.link) {
            count++;
          }
        }
        if (count > 1) {
          i.invalid = 4;
        }
      }

      for (var r in listRename) {
        int count = 0;
        String fileName = r.name;
        String fileId = '';
        for (var f in documents) {
          if (f.name!.contains(r.link) && r.invalid == null) {
            count++;
            fileId = f.id.toString();
          }
        }
        if (count == 0 && r.invalid == null) {
          r.invalid = 1;
        }
        if (count > 1) {
          r.invalid = 3;
        }
        if (r.invalid == null) {
          folders.clear();
          String nameOfFolder = r.folder.trim();
          await _queryDrive(
              "mimeType='application/vnd.google-apps.folder' and name='$nameOfFolder'",
              folders);
          debugPrint('=======> folder: $nameOfFolder');
          if (folders == null || folders.isEmpty) {
            r.invalid = 2;
          } else {
            for (var i in folders) {
              debugPrint('=======> folder ${i.name}');
            }
            String folderId = '${folders.first.id}';
            listSubmit.add(SubmitModel(fileName, fileId, folderId));
          }
        }
        // setState(() {});
        cubit.buildUI();
      }

      if (context.mounted) {
        Navigator.pop(context);
      }
    }
  }

  _delete() {
    controller.text = '';
    debugPrint('===========> delete ListSubmit before ${listSubmit.length}');
    listRename.removeRange(0, listRename.length);
    listSubmit.removeRange(0, listSubmit.length);
    debugPrint('===========> delete ListSubmit after ${listSubmit.length}');
    // setState(() {});
    cubit.buildUI();
  }

  Future<void> _submit() async {
    waitingDialog(context);

    for (var i in listSubmit) {
      debugPrint(
          '===========> file file file ${i.name} == ${i.fileId} == ${i.folderId}');
      var fileMetadata = drive.File();
      fileMetadata.name = i.name;
      fileMetadata.mimeType = 'application/vnd.google-apps.folder';
      await drive.DriveApi(
              AuthClient(http.Client(), await _currentUser!.authHeaders))
          .files
          .update(fileMetadata, i.fileId,
              removeParents: AppConfigs.meetRecordingsId,
              addParents: i.folderId);
    }
    if (context.mounted) {
      Navigator.pop(context);
      listSubmit.removeRange(0, listSubmit.length);
      // setState(() {});
      cubit.buildUI();
      notificationDialog(context, AppText.txtSuccessfullyUpdateVideo.text);
    }
  }

  Future<void> _handleSignIn() async {
    try {
      await _googleSignIn.signIn();
    } catch (error) {
      debugPrint('=========> error $error');
    }
  }

  Future<void> _handleSignOut() => _googleSignIn.disconnect();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => cubit,
      child: BlocBuilder<RenameCubit, int>(
        builder: (c, s) => Scaffold(
            body: ConstrainedBox(
          constraints: const BoxConstraints.expand(),
          child: _currentUser != null
              ? Stack(
                  children: [
                    SingleChildScrollView(
                      child: Column(
                        children: <Widget>[
                          ListTile(
                            leading: GoogleUserCircleAvatar(
                              identity: _currentUser!,
                            ),
                            title: Text(_currentUser!.displayName ?? ''),
                            subtitle: Text(_currentUser!.email ?? ''),
                          ),
                          if (controller.text != null &&
                              controller.text.isNotEmpty) ...[
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ...listRename
                                    .map((e) => InkWell(
                                          onTap: e.invalid == null
                                              ? null
                                              : e.invalid! > 2
                                                  ? () => notificationDialog(
                                                      context,
                                                      AppText
                                                          .txtDuplicateLinkOrVideo
                                                          .text)
                                                  : () {
                                                      alertEditField(
                                                          context,
                                                          e.invalid == 1
                                                              ? e.link
                                                              : e.name,
                                                          onPressed: () async {
                                                        List<String> nameSplit =
                                                            e.name
                                                                .trim()
                                                                .split('-');
                                                        e.folder = _getFolderName(
                                                            nameSplit[1]
                                                                .toUpperCase()
                                                                .trim(),
                                                            nameSplit[2]
                                                                .toUpperCase()
                                                                .trim());
                                                        e.invalid = null;
                                                        debugPrint(
                                                            '=========> invalid ${e.name} == ${e.link} == ${e.folder} == ${e.invalid}');
                                                        await _reCheckInvalid();
                                                      }, onChanged: (v) {
                                                        if (e.invalid == 1) {
                                                          e.link = v;
                                                        }
                                                        if (e.invalid == 2) {
                                                          e.name = v;
                                                        }
                                                      });
                                                    },
                                          child: Padding(
                                            padding: EdgeInsets.symmetric(
                                                vertical: Resizable.padding(
                                                    context, 5),
                                                horizontal: Resizable.padding(
                                                    context, 50)),
                                            child: Row(
                                              children: [
                                                Icon(
                                                    e.invalid == null
                                                        ? Icons
                                                            .check_box_outlined
                                                        : e.invalid == 2
                                                            ? Icons
                                                                .folder_copy_outlined
                                                            : Icons
                                                                .file_copy_outlined,
                                                    color: e.invalid == null
                                                        ? Colors.green
                                                        : Colors.red),
                                                SizedBox(
                                                    width: Resizable.size(
                                                        context, 10)),
                                                Expanded(
                                                    child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Padding(
                                                      padding: EdgeInsets.only(
                                                          bottom:
                                                              Resizable.padding(
                                                                  context,
                                                                  e.invalid !=
                                                                          null
                                                                      ? 5
                                                                      : 0)),
                                                      child: Row(
                                                        children: [
                                                          Expanded(
                                                              flex: 1,
                                                              child: Text(
                                                                e.link,
                                                                style: TextStyle(
                                                                    color: e.invalid ==
                                                                            null
                                                                        ? Colors
                                                                            .green
                                                                        : Colors
                                                                            .red),
                                                                maxLines: 1,
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                              )),
                                                          Expanded(
                                                              flex: 1,
                                                              child: Text(
                                                                e.folder,
                                                                style: TextStyle(
                                                                    color: e.invalid ==
                                                                            null
                                                                        ? Colors
                                                                            .green
                                                                        : Colors
                                                                            .red),
                                                                maxLines: 1,
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                              )),
                                                          Expanded(
                                                              flex: 8,
                                                              child: Text(
                                                                e.name,
                                                                style: TextStyle(
                                                                    color: e.invalid ==
                                                                            null
                                                                        ? Colors
                                                                            .green
                                                                        : Colors
                                                                            .red),
                                                                maxLines: 1,
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                              )),
                                                        ],
                                                      ),
                                                    ),
                                                    if (e.invalid != null)
                                                      Text(
                                                          e.invalid == 1
                                                              ? AppText
                                                                  .txtErrorInvalidFile
                                                                  .text
                                                              : e.invalid == 2
                                                                  ? AppText
                                                                      .txtErrorInvalidFolder
                                                                      .text
                                                                  : e.invalid ==
                                                                          3
                                                                      ? AppText
                                                                          .txtErrorDuplicateVideo
                                                                          .text
                                                                      : AppText
                                                                          .txtErrorDuplicateLink
                                                                          .text,
                                                          style:
                                                              const TextStyle(
                                                                  color: Colors
                                                                      .black54))
                                                  ],
                                                )),
                                              ],
                                            ),
                                          ),
                                        ))
                                    .toList(),
                                SizedBox(height: Resizable.padding(context, 70))
                              ],
                            )
                          ],
                          if (controller.text == null ||
                              controller.text.isEmpty)
                            TextButton(
                              onPressed: () => alertInputField(
                                  context, controller, _checkInvalid),
                              child: Text(AppText.btnInputLinkAndTitle.text
                                  .toUpperCase()),
                            )
                        ],
                      ),
                    ),
                    if (controller.text != null && controller.text.isNotEmpty)
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Card(
                          margin: EdgeInsets.zero,
                          shadowColor: Colors.black,
                          elevation: 10,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Expanded(
                                  child: TextButton(
                                onPressed: listSubmit.isEmpty
                                    ? null
                                    : () async {
                                        await _submit();
                                      },
                                style: ButtonStyle(
                                    padding: MaterialStateProperty.all(
                                        EdgeInsets.symmetric(
                                            vertical: Resizable.padding(
                                                context, 20)))),
                                child: Text(AppText.btnUpdate.text),
                              )),
                              Container(
                                width: Resizable.size(context, 1),
                                height: Resizable.size(context, 30),
                                color: Colors.black38,
                              ),
                              Expanded(
                                  child: TextButton(
                                onPressed: () => _delete(),
                                style: ButtonStyle(
                                    padding: MaterialStateProperty.all(
                                        EdgeInsets.symmetric(
                                            vertical: Resizable.padding(
                                                context, 20)))),
                                child: Text(AppText.btnRemove.text),
                              )),
                            ],
                          ),
                        ),
                      )
                  ],
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Text(AppText.txtNotLoggedIn.text),
                    TextButton(
                      onPressed: _handleSignIn,
                      child: Text(AppText.btnLogin.text.toUpperCase()),
                    ),
                  ],
                ),
        )),
      ),
    );
  }
}

class RenameCubit extends Cubit<int> {
  RenameCubit() : super(0);

  buildUI() => emit(state + 1);
}

