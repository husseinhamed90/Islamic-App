import 'package:flutter/material.dart';
import 'package:islamiapp/DataLayer/ApiService.dart';
import 'VersesScreen.dart';

class HomePage extends StatelessWidget {

  HomePage({
    Key? key,
  }) : super(key: key);

  List<String> images = [
    "https://quran.com.kw/wp-content/uploads/%D8%A7%D9%84%D8%B4%D9%8A%D8%AE-%D9%85%D8%B4%D8%A7%D8%B1%D9%8A-%D8%B1%D8%A7%D8%B4%D8%AF-%D8%A7%D9%84%D8%B9%D9%81%D8%A7%D8%B3%D9%8A.jpg",
    "https://pbs.twimg.com/profile_images/1594678248885157888/JKjFw-mH_400x400.jpg",
    "https://upload.wikimedia.org/wikipedia/commons/thumb/9/90/Maher_Al_Mueaqly.png/270px-Maher_Al_Mueaqly.png",
    "https://upload.wikimedia.org/wikipedia/commons/thumb/1/18/Abdul-Rahman_Al-Sudais_%28Cropped%2C_2011%29.jpg/247px-Abdul-Rahman_Al-Sudais_%28Cropped%2C_2011%29.jpg",
    "https://upload.wikimedia.org/wikipedia/commons/thumb/7/74/%D9%8A%D8%A7%D8%B3%D8%B1_%D8%A7%D9%84%D8%AF%D9%88%D8%B3%D8%B1%D9%8A_%D8%A5%D9%85%D8%A7%D9%85_%D9%88%D8%AE%D8%B7%D9%8A%D8%A8_%D9%88%D9%82%D8%A7%D8%B1%D8%A6_%D9%82%D8%B1%D8%A2%D9%86_%D8%B3%D8%B9%D9%88%D8%AF%D9%8A.jpg/220px-%D9%8A%D8%A7%D8%B3%D8%B1_%D8%A7%D9%84%D8%AF%D9%88%D8%B3%D8%B1%D9%8A_%D8%A5%D9%85%D8%A7%D9%85_%D9%88%D8%AE%D8%B7%D9%8A%D8%A8_%D9%88%D9%82%D8%A7%D8%B1%D8%A6_%D9%82%D8%B1%D8%A2%D9%86_%D8%B3%D8%B9%D9%88%D8%AF%D9%8A.jpg",
    "https://upload.wikimedia.org/wikipedia/commons/e/ef/%D8%B5%D9%84%D8%A7%D8%AD_%D8%A8%D8%A7%D8%B9%D8%AB%D9%85%D8%A7%D9%86.jpg"
  ];
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
                                child: Image.network("https://www.fekera.com/wp-content/uploads/2019/11/%D8%AA%D9%81%D8%B3%D9%8A%D8%B1-%D8%AD%D9%84%D9%85-%D8%B1%D8%A4%D9%8A%D8%A9-%D8%A7%D9%84%D9%85%D8%B5%D8%AD%D9%81.jpg", fit: BoxFit.cover),
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
            return const Center(child: CircularProgressIndicator(),);
          }

        },
      ),
    );
  }
}