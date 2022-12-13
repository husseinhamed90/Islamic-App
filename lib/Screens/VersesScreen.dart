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
                Spacer(),
                IconButton(onPressed: () {
                  String audioUrl = context.read<AppProvider>().getAudioUrl(baseUrl,context.read<AppProvider>().suwar![index].id!);
                  Navigator.push(context, MaterialPageRoute(builder: (context) =>  ScreenAudio(audioUrl:audioUrl,reciterName:reciterName,suratName: context.read<AppProvider>().suwar![index].name!,)));
                }, icon: Icon(Icons.play_arrow,color: Colors.white,))
              ],
            );
          },
        ),
      ),
    );
  }
}
