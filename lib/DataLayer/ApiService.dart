import 'package:dio/dio.dart';
import 'package:islamiapp/Models/Sura.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Models/Reciter.dart';
import '../Helpers/constants.dart';

class ApiServices{
  static late Dio dio;
  static init(){
    dio = Dio();
  }

  static Future<List<Reciter>?> getReciter() async{
    Response response = await dio.get("https://www.mp3quran.net/api/v3/reciters?language=ar");
    List<Reciter>?reciters;
    if(response.statusCode==200) {
      List list = response.data["reciters"];
      reciters = list.map((e) => Reciter.fromJson(e)).toList();
    }
    return reciters;
  }

}