import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Models/Sura.dart';
import '../Helpers/constants.dart';

class AppProvider with ChangeNotifier{
  List<Sura>?suwar;
   Future getSuwar() async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if(suwar==null){
      if(prefs.containsKey("suwar")){
        suwar = Sura.decode(prefs.getString("suwar")!);
      }
      else{
        suwar = ListOfSuwar.map((e) => Sura.fromJson(e)).toList();
        final String encodedData = Sura.encode(suwar!);
        await prefs.setString('suwar', encodedData);
      }
    }
  }

  String getAudioUrl(String baseUrl,int id){
    NumberFormat formatter = NumberFormat("000");
     return "$baseUrl${formatter.format(id)}.mp3";
  }
}