import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/drive/v3.dart' as drive;
import 'package:internal_sakumi/configs/app_configs.dart';
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/features/admin/tool/auth_client.dart';
import 'package:internal_sakumi/features/admin/tool/rename_model.dart';
import "package:http/http.dart" as http;
import 'package:internal_sakumi/model/lesson_model.dart';
import 'package:internal_sakumi/model/lesson_result_model.dart';
import 'package:internal_sakumi/providers/firebase/firebase_provider.dart';
import 'package:internal_sakumi/widget/waiting_dialog.dart';
import 'package:intl/intl.dart';

GoogleSignIn _googleSignIn = GoogleSignIn(
  scopes: <String>[
    'email',
    'https://www.googleapis.com/auth/drive',
  ],
);

class RenameCubit extends Cubit<int> {
  RenameCubit() : super(0) {
    init();
  }

  GoogleSignInAccount? currentUser;
  List<drive.File> allDriveFiles = [];
  List<drive.File> folders = [];
  List<DriveModel> drives = [];
  List<LessonModel> lessons = [];
  List<int> classIds = [], lessonIds = [];
  List<SubmitModel> listSubmit = [];

  init() async {
    _googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount? account) {
      currentUser = account;
    });
    await _googleSignIn.signInSilently();
    buildUI();
  }

  handleSignIn() async {
    try {
      await _googleSignIn.signIn();
    } catch (error) {
      debugPrint('=========> error $error');
    }
  }

  handleSignOut() => _googleSignIn.disconnect();

  _queryDrive(String query, List<drive.File> docs) async {
    final client = http.Client();
    await Future.delayed(const Duration(milliseconds: 100));
    var header = await currentUser!.authHeaders;
    var authClient = AuthClient(client, header);
    var api = drive.DriveApi(authClient);
    String? pageToken;
    do {
      var fileList = await api.files.list(
          q: query,
          pageSize: 1000,
          pageToken: pageToken,
          $fields:
              "nextPageToken, files(id, name, mimeType, thumbnailLink, parents, createdTime)");
      pageToken = fileList.nextPageToken;

      docs.addAll(fileList.files?.toList() ?? []);
    } while (pageToken != null);
  }

  String _changeDateForFiles(String date) {
    List<String> temp1 = (date.split(' ').first).split('/');
    List<String> temp2 = [];
    for (var i in temp1) {
      if (i.length > 2) {
        temp2.add(i.substring(2, 4));
      } else {
        temp2.add(i);
      }
    }
    temp2.insert(1, temp2.removeAt(0));
    return temp2.join('.');
  }

  List<String> _splitDriveName(String input) {
    try {
      List<String> parts = [];
      final RegExp pattern = RegExp(r'(\(.*?\)|[^<()]+)');

      for (RegExpMatch match in pattern.allMatches(input)) {
        parts.add(match.group(0)!);
      }
      return [...parts];
    } catch (e) {
      return [input];
    }
  }

  String _split(String text) {
    List<String> source = _splitDriveName(text);
    return source.first;
  }

  _getAllFilesOnDrive() async {
    drives.clear();
    await _queryDrive(
        "mimeType='video/mp4' and '${AppConfigs.meetRecordingsId}' in parents",
        allDriveFiles);

    for (var file in allDriveFiles) {
      drives.add(DriveModel(file));
    }

    for (var i in drives) {
      int count = 0;
      for (var j in drives) {
        String temp1 = _split(i.file.name.toString());
        String temp2 = _split(j.file.name.toString());
        if (temp1 == temp2) {
          count++;
        }
      }
      if (count > 1) {
        i.error = 1;
      }
    }
  }

  _getFoldersName() async {
    classIds.clear();
    var allClass = await FireBaseProvider.instance.getAllClassInProgress();

    for (var drive in drives) {
      int count = 0;
      for (var i in allClass) {
        String temp = _split(drive.file.name.toString().trim());
        if (i.link.contains(temp.trim()) && drive.error == null) {
          count++;
          debugPrint(
              '==========> class ${i.link} -- ${i.classCode} -- ${i.classId} -- ${drive.file.name}');
          drives[drives.indexOf(drive)].classModel = i;
          drives[drives.indexOf(drive)].folder = i.classCode;

          if (i.classCode.contains('NS1')) {
            String temp0 = '';
            try {
              temp0 = (i.classCode.split('-').first.trim());
            } catch (err) {
              temp0 = i.classCode.trim();
              debugPrint('=========> error $err');
            }
            String temp1 = temp0.substring(0, 4);
            String temp2 = temp0.substring(4, temp0.length);
            drives[drives.indexOf(drive)].folder = '$temp1-$temp2';
          }
          classIds.add(i.classId);
        }
      }

      if (count > 1) {
        drives[drives.indexOf(drive)].error = 2;
      }
    }

    for (var drive in drives) {
      if (drive.classModel == null && drive.error == null) {
        drive.error = 3;
      }
    }
  }

  _getTitleLessons() async {
    lessons.clear();
    lessonIds.clear();
    listSubmit.clear();
    List<LessonResultModel> lessonResults = await FireBaseProvider.instance
        .getLessonsResultsByListClassIds(classIds);

    debugPrint(
        '==========> lesson ids ${lessonResults.length} -- ${drives.length}');

    for (var drive in drives) {
      if (drive.classModel != null) {
        int count = 0;
        int lessonId = 0;
        String? date;

        for (var i in lessonResults) {
          if (i.classId == drive.classModel!.classId) {
            DateTime last = drive.file.createdTime!;
            DateTime first =
                DateFormat('dd/MM/yyyy HH:mm:ss').parse(i.date.toString());
            Duration duration = last.difference(first);
            if (duration.inHours <= 17 && duration.inHours >= 0) {
              lessonId = i.lessonId;
              date = i.date;
              count++;
            }
          }
        }

        if (count == 1) {
          folders.clear();
          await _queryDrive(
              "mimeType='application/vnd.google-apps.folder' and name='${drive.folder}'",
              folders);
          if (folders == null || folders.isEmpty) {
            drive.error = 4;
          } else {
            lessonIds.add(lessonId);
            drive.lessonId = lessonId;
            String dateTime = _changeDateForFiles('$date');
            String name = '$dateTime-${drive.classModel!.classCode}';
            String fileId = '${drive.file.id}';
            String folderId = '${folders.first.id}';
            listSubmit.add(SubmitModel(name, fileId, folderId));
          }
        }

        if (count == 0) {
          drive.error = 5;
        }

        if (count > 1) {
          drive.error = 6;
        }
      }
    }

    lessons = await FireBaseProvider.instance.getLessonsByLessonId(lessonIds);

    debugPrint('=======> so sanh ${lessons.length} -- ${listSubmit.length}');
    debugPrint('=======> lesson ida $lessonIds');

    int ind = -1;

    for (var drive in drives) {
      for (var id in lessonIds) {
        List<LessonModel> list =
            lessons.fold([], (pre, e) => [...pre, if (e.lessonId == id) e]);
        if (list.isEmpty) {
          if (drive.error == null &&
              drive.classModel != null &&
              drive.classModel!.customLessons.isNotEmpty) {
            debugPrint('==========> class model ${drive.classModel!.classId}');
            for (var i in drive.classModel!.customLessons) {
              for (var id in lessonIds) {
                debugPrint(
                    '=========> custom lesson ${i['custom_lesson_id']} -- ${id}');
                if (id == i['custom_lesson_id']) {
                  ind++;
                  listSubmit[ind].name += '-${i['title']}';
                  drive.name = listSubmit[ind].name;
                  debugPrint('==========> ind 1 $ind -- ${drive.name}');
                  break;
                }
              }
            }
          }
        } else {
          for (var lesson in list) {
            if (drive.lessonId == lesson.lessonId && ind < listSubmit.length) {
              ind++;
              listSubmit[ind].name += '-${lesson.title}';
              drive.name = listSubmit[ind].name;
              debugPrint(
                  '========> oooooo =====> $ind ${drive.lessonId} -- ${listSubmit[ind].name}');
              break;
            }
          }
        }
      }
    }
  }

  submit(BuildContext context) async {
    waitingDialog(context);
    for (var i in listSubmit) {
      debugPrint(
          '===========> file file file ${i.name} == ${i.fileId} == ${i.folderId}');
      var fileMetadata = drive.File();
      fileMetadata.name = i.name;
      fileMetadata.mimeType = 'application/vnd.google-apps.folder';
      await drive.DriveApi(
              AuthClient(http.Client(), await currentUser!.authHeaders))
          .files
          .update(fileMetadata, i.fileId,
              removeParents: AppConfigs.meetRecordingsId,
              addParents: i.folderId);
    }
    if (context.mounted) {
      Navigator.pop(context);
      listSubmit.clear();
      // allDriveFiles.clear();
      for (var drive in drives) {
        if (drive.error == null) {
          drives.remove(drive);
        }
      }
      // drives.clear();
      buildUI();
      notificationDialog(
          context,
          drives.length == allDriveFiles.length
              ? AppText.txtSuccessfullyUpdateVideo.text
              : AppText.txtStillSomeErrorVideo.text);
    }
  }

  verify(BuildContext context) async {
    waitingDialog(context);
    await _getAllFilesOnDrive();
    await _getFoldersName();
    await _getTitleLessons();

    if (context.mounted) {
      Navigator.pop(context);
    }
    buildUI();
  }

  reload(BuildContext context) async {
    allDriveFiles.clear();
    drives.clear();
    listSubmit.clear();

    await verify(context);
  }

  buildUI() => emit(state + 1);
}
