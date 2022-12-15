import 'package:flutter/material.dart';
import 'package:islamiapp/Logic/AppProvider.dart';
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
        child: ListView.separated(
          itemCount: context.read<AppProvider>().suwar!.length,
          separatorBuilder: (BuildContext context, int index) =>
              const Divider(),
          itemBuilder: (BuildContext context, int index) {
            return Row(
              children: [
                Text(context.read<AppProvider>().suwar![index].name!,
                    style: const TextStyle(color: Colors.white)),
                const Spacer(),
                IconButton(onPressed: () {
                  if(!(context.read<AppProvider>().currentIndex==-1))
                  {
                    if(context.read<AppProvider>().currentIndex!=index){
                      context.read<AppProvider>().setIsAudioChanged(true);
                    }
                    else{
                      context.read<AppProvider>().setIsAudioChanged(false);
                    }
                  }
                  context.read<AppProvider>().setCurrentIndex(index);
                  String audioUrl = context.read<AppProvider>().getAudioUrl(baseUrl,context.read<AppProvider>().suwar![index].id!);
                  Navigator.push(context, MaterialPageRoute(builder: (context) =>  ScreenAudio(baseUrl:baseUrl ,audioUrl:audioUrl,reciterName:reciterName,suratName: context.read<AppProvider>().suwar![index].name!, id: context.read<AppProvider>().suwar![index].id!,)));
                }, icon:Icon(context.watch<AppProvider>().currentIndex==index?Icons.pause:Icons.play_arrow,color: Colors.white,))
              ],
            );
          },
        ),
      ),
    );
  }
}
