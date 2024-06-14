class AppConfigs{

  static const String endPoint = "http://173.199.127.90:3000";

  static const bool endpointFirebaseDebug = false;

  static const bool isRunningDebug = false;

  static bool demoDatabase = false;


  static String getDataUrl(String file, String token){
    return "https://noibo.sakumi.edu.vn/files/$token/$file";
  }

  static String getDownloadUrl(String fileToken, String token){
    return 'http://173.199.127.90:3000/api/v1/mobile/static/get/?token=$token&name=$fileToken';
  }

  static String defaultImage = 'https://cdn3.iconfinder.com/data/icons/education-1-28/49/144-512.png';

  static const meetRecordingsId = '1IAcWu52mBEBMiOySR6M8IGb1DZYzma50';
}