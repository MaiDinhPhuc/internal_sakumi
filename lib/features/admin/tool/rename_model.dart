import 'package:googleapis/drive/v3.dart' as drive;
import 'package:internal_sakumi/configs/text_configs.dart';
import 'package:internal_sakumi/model/class_model.dart';

class RenameModel {
  String link;
  String name;
  String folder;
  int? invalid;

  RenameModel(this.link, this.name, this.folder, {this.invalid});
}

class SubmitModel {
  String name;
  String fileId;
  String folderId;

  SubmitModel(this.name, this.fileId, this.folderId);
}

class DriveModel {
  drive.File file;
  ClassModel? classModel;
  int? error, lessonId;
  String? name;

  String getErrorName() {
    switch (error) {
      case 1:
        return AppText.txtErrorDuplicateVideo.text;
      case 2:
        return AppText.txtDuplicateLinkBetweenClasses.text;
      case 3:
        return AppText.txtErrorNotFoundLinkGGMeetOnDB.text;
      case 4:
        return AppText.txtErrorNotFoundFolderOnDrive.text;
      default:
        return '';
    }
  }

  DriveModel(this.file,
      {this.error, this.classModel, this.lessonId, this.name});
}
