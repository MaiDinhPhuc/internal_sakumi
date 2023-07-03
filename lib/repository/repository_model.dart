class RepositoryModel<Data, Error> {
  final bool isSuccess;
  final Data? data;
  final Error? error;

  RepositoryModel({required this.isSuccess, this.data, this.error});
}
