import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Logic/AppProvider.dart';
import '../Models/Reciter.dart';
import '../Screens/VersesScreen.dart';

class RecitersList extends StatelessWidget {
  final List<Reciter>reciters;
  const RecitersList({
    Key? key,required this.reciters
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 6,
      child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          color:  Colors.black,
          padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 10),
          child: GridView.builder(
            itemCount: reciters.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 1,
                crossAxisSpacing: 14,
                mainAxisSpacing: 14
            ),
            itemBuilder: (BuildContext context, int index){
              return GestureDetector(
                onTap: () {
                  if(!(context.read<AppProvider>().currentReciterIndex==-1))
                  {
                    if(context.read<AppProvider>().currentReciterIndex!=index){
                      context.read<AppProvider>().setCurrentSuraIndex(-1);
                      context.read<AppProvider>().setIsReciterChanged(true);
                    }
                    else{
                      context.read<AppProvider>().setIsReciterChanged(false);
                    }
                  }
                  else{
                    context.read<AppProvider>().setCurrentSuraIndex(-1);
                    context.read<AppProvider>().setIsReciterChanged(true);
                  }
                  context.read<AppProvider>().setCurrentReciterIndex(index);
                  context.read<AppProvider>().makePlaylist(reciters[index].moshaf![0].server!);
                  Navigator.push(context, MaterialPageRoute(builder: (context) =>  VersesScreen(reciterName: reciters[index].name!,baseUrl: reciters[index].moshaf![0].server!,)));
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: SizedBox(
                        width: double.infinity,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10), // Image border
                          child: Image.network("https://images.akhbarelyom.com//images/images/medium/20201031140317535.jpg", fit: BoxFit.cover),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10,),
                    Text(reciters[index].name!,style: const TextStyle(
                      color: Colors.white,fontSize: 18,
                    ),textDirection: TextDirection.rtl,),
                  ],
                ),
              );
            },
          )),
    );
  }
}