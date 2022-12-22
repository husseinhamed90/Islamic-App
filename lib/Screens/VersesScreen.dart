import 'package:flutter/material.dart';
import 'package:islamiapp/Logic/AppProvider.dart';
import 'package:islamiapp/Models/Sura.dart';
import 'package:provider/provider.dart';
import 'ScreenAudio.dart';

class VersesScreen extends StatelessWidget {

  final String reciterName,baseUrl;
  const VersesScreen({Key? key, required this.reciterName,required this.baseUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        centerTitle: true,
        title: Text(reciterName,
            style: const TextStyle(color: Colors.white, fontSize: 25),
            textDirection: TextDirection.rtl),
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: StreamBuilder(
          stream: context.read<AppProvider>().getCurrentPosition() ,
          builder: (context, snapshot) {
            return FutureBuilder<List<Sura>>(
              future: context.read<AppProvider>().getSuwar(baseUrl),
              builder: (context, AsyncSnapshot<List<Sura>>snapshot) {
                if(snapshot.hasData){
                  return ListView.separated(
                    itemCount: snapshot.data!.length,
                    separatorBuilder: (BuildContext context, int index) => const Divider(),
                    itemBuilder: (BuildContext context, int index) => Row(
                        children: [
                          Text(snapshot.data![index].name!, style: const TextStyle(color: Colors.white)),
                          const Spacer(),
                          IconButton(onPressed: () {
                            if(context.read<AppProvider>().currentSuraIndex==index){
                              context.read<AppProvider>().sameAudio();
                            }
                            else{
                              context.read<AppProvider>().audioChanged(index);
                              String audioUrl = context.read<AppProvider>().getAudioUrl(baseUrl,snapshot.data![index].id!);
                              Navigator.push(context, MaterialPageRoute(builder: (context) =>  ScreenAudio(baseUrl:baseUrl ,audioUrl:audioUrl,reciterName:reciterName,
                                suratName: snapshot.data![index].name!, id: snapshot.data![index].id!,reciterSwar: snapshot.data!,)));
                            }
                          }, icon:Icon(context.watch<AppProvider>().currentSuraIndex==index?Icons.pause:Icons.play_arrow,color: Colors.white,))
                        ],
                      ),
                  );
                }
                else{
                  return const Center(child: CircularProgressIndicator(color: Colors.white),);
                }
              },
            );
          },
        ),
      ),
    );
  }




}
