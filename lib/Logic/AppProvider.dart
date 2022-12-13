import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Models/Sura.dart';
import '../Helpers/constants.dart';

class AppProvider with ChangeNotifier{
  bool wantRepeat=false;
  static int _nextMediaId = 0;
  ConcatenatingAudioSource? playlist;
  Sura ?currentSura;

  void setCurrentSura(Sura current){
    currentSura= current;
    notifyListeners();
  }
  void setWantRepeat(){
    wantRepeat=!wantRepeat;
    notifyListeners();
  }
  void makePlaylist(String baseUrl){
    playlist = ConcatenatingAudioSource(
      children: suwar!.map((e) =>AudioSource.uri(
        Uri.parse(getAudioUrl(baseUrl, e.id!)),
        tag: MediaItem(
          id: '${_nextMediaId++}',
          album: e.name,
          title: e.name!,
          artUri: Uri.parse(
              "https://www.fekera.com/wp-content/uploads/2019/11/%D8%AA%D9%81%D8%B3%D9%8A%D8%B1-%D8%AD%D9%84%D9%85-%D8%B1%D8%A4%D9%8A%D8%A9-%D8%A7%D9%84%D9%85%D8%B5%D8%AD%D9%81.jpg"),
        ),
      ),).toList(),
    );
  }
  List<Sura>?suwar;
  Map<int,Sura>maps ={};
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