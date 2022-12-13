import 'dart:convert';

class Sura {
  int? id;
  String? name;
  int? startPage;
  int? endPage;
  int? makkia;

  Sura({this.id, this.name, this.startPage, this.endPage, this.makkia});

  Sura.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    startPage = json['start_page'];
    endPage = json['end_page'];
    makkia = json['makkia'];
  }
  static String encode(List<Sura> suwar) => json.encode(
    suwar.map<Map<String, dynamic>>((music) => music.toJson()).toList(),
  );

  static List<Sura> decode(String musics) =>
      (json.decode(musics) as List<dynamic>)
          .map<Sura>((item) => Sura.fromJson(item))
          .toList();

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['start_page'] = startPage;
    data['end_page'] = endPage;
    data['makkia'] = makkia;
    return data;
  }
}