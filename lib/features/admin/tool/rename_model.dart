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