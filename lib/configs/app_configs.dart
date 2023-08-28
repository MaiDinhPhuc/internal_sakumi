class AppConfigs{

  static const String endpoint = "http://173.199.127.90:3000";
  static const String btvnZipPassword = "Aa@12345";

  static String getBTVNUrl(String lessonId, String token){
    return "$endpoint/api/v1/mobile/static/get/?token=$token&name=btvn_$lessonId.zip";
  }

  static const bool endpointFirebaseDebug = false;

  static String dir = "";
  static String defaultImage = 'https://cdn3.iconfinder.com/data/icons/education-1-28/49/144-512.png';
}