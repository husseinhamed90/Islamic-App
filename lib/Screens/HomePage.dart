import 'package:flutter/material.dart';
import 'package:islamiapp/DataLayer/ApiService.dart';
import 'package:islamiapp/Logic/AppProvider.dart';
import 'package:provider/provider.dart';
import 'VersesScreen.dart';

class HomePage extends StatelessWidget {

  HomePage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("تلاوات",style: TextStyle(fontSize: 25)),
        backgroundColor: Colors.black,
      ),
      body: FutureBuilder(
        future: ApiServices.getReciter(),
        builder: (context, snapshot) {
          if(snapshot.hasData){
            return Container(
                color:  Colors.black,
                padding: const EdgeInsets.all(12.0),
                child: GridView.builder(
                  itemCount: snapshot.data!.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 1,
                      crossAxisSpacing: 14,
                      mainAxisSpacing: 14
                  ),
                  itemBuilder: (BuildContext context, int index){
                    return GestureDetector(
                      onTap: () {
                        context.read<AppProvider>().setCurrentIndex(index+1);
                        context.read<AppProvider>().makePlaylist(snapshot.data![index].moshaf![0].server!);
                        Navigator.push(context, MaterialPageRoute(builder: (context) =>  VersesScreen(reciterName: snapshot.data![index].name!,baseUrl: snapshot.data![index].moshaf![0].server!,)));

                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: SizedBox(
                              width: double.infinity,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10), // Image border
                                child: Image.network("https://quran.com.kw/wp-content/uploads/%D8%A7%D9%84%D8%B4%D9%8A%D8%AE-%D8%B3%D8%B9%D8%AF-%D8%A7%D9%84%D8%BA%D8%A7%D9%85%D8%AF%D9%8A.jpg", fit: BoxFit.cover),
                              ),
                            ),
                          ),
                          const SizedBox(height: 10,),
                          Text(snapshot.data![index].name!,style: const TextStyle(
                            color: Colors.white,fontSize: 18,
                          ),textDirection: TextDirection.rtl,),
                        ],
                      ),
                    );
                  },
                ));
          }
          else{
            return Container(
                color:  Colors.black,
                child: const Center(child: CircularProgressIndicator(
                  color: Colors.white,
                ),));
          }

        },
      ),
    );
  }
}