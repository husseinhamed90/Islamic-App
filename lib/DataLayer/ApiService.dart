
import 'package:dio/dio.dart';

import '../Models/Reciter.dart';

class ApiServices{
  static late Dio dio;
  static init(){
    dio = Dio();
  }

  static Future<List<String>> getSawrFromApi(String url) async {
    List<String>audiosNames=[];
        Response response =  await dio.get(url,options: Options(receiveDataWhenStatusError: true));
        response.data.toString().split("<body>")[1].split("<h1>")[1].split("<a href=");
        for(int i =2;i<response.data.toString().split("<body>")[1].split("<h1>")[1].split("<a href=").length;i++){
          String s =response.data.toString().split("<body>")[1].split("<h1>")[1].split("<a href=")[i].split(">")[0].replaceAll('"', "");
          audiosNames.add(s);
        }
        return audiosNames;
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