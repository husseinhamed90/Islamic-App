import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:islamiapp/DataLayer/ApiService.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Helpers/HelperClasses/PositionData.dart';
import '../Models/Reciter.dart';
import '../Models/Sura.dart';
import '../Helpers/constants.dart';

class AppProvider with ChangeNotifier{
  bool wantRepeat=false;
  bool wantShuffle=false;
  int currentSuraIndex=-1;
  int currentReciterIndex=-1;
  bool isAudioChanged=false;
  bool isReciterChanged=false;
  int prevIndex=-1;
  List<Reciter>?filteredReciter;
  static int _nextMediaId = 0;
  ConcatenatingAudioSource? playlist;
  Sura ?currentSura;
  AudioPlayer audioPlayer = AudioPlayer();
  TextEditingController controller =TextEditingController();
  void resetFilteredReciter(){
    filteredReciter=null;
    controller.clear();
    notifyListeners();
  }
  Stream<int?>getCurrentPosition(){
    return audioPlayer.currentIndexStream;
  }
  void fillFilteredReciter(String name){
    filteredReciter = reciters!.where((element) => element.name!.contains(name)).toList();
    notifyListeners();
  }
  void setIsAudioChanged(bool current){
    isAudioChanged = current;
    notifyListeners();
  }

  void setIsReciterChanged(bool current){
    isReciterChanged = current;
    notifyListeners();
  }

  void setCurrentSura(Sura current){
    currentSura= current;
    notifyListeners();
  }
  void setPrevIndex(int current){
    prevIndex= current;
    notifyListeners();
  }


  Duration  currentAudioSeek=const Duration();
  void setCurrentAudioSeek(Duration duration){
    currentAudioSeek=duration;
    notifyListeners();
  }
  void setCurrentSuraIndex(int current){
    currentSuraIndex= current;
    //notifyListeners();
  }
  void setCurrentReciterIndex(int current){
    currentReciterIndex= current;
    notifyListeners();
  }

  List<Reciter>?reciters;
  void resetSeek(){
    currentAudioSeek=const Duration();
    //notifyListeners();
  }
  Future getReciters()async{
    reciters=[];
    reciters = await ApiServices.getReciter();
    notifyListeners();
  }
  void setWantShuffle(){
    wantShuffle=!wantShuffle;
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
  Map<int,Map<String,dynamic>>map={};
   Future<List<Sura>> getSuwar(String baseUrl) async{
     List<Sura>reciterSwar=[];
     if(map.isEmpty){
       ListOfSuwar.forEach((element) {
         map[element["id"]]=element;
       });
     }
     List<String>audiosNames =await ApiServices.getSawrFromApi(baseUrl);
     for(int i=0;i<audiosNames.length;i++){
       int num = int.parse(audiosNames[i].replaceAll(".mp3", "").replaceAll(RegExp(r'^0+(?=.)'), ''));
       reciterSwar.add(Sura.fromJson(map[num]!));
     }
     return reciterSwar;
  }

  String getAudioUrl(String baseUrl,int id){
    NumberFormat formatter = NumberFormat("000");
     return "$baseUrl${formatter.format(id)}.mp3";
  }

  Future getAllSawr() async{
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
}