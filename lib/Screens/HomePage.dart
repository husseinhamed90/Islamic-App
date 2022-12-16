import 'package:flutter/material.dart';
import 'package:islamiapp/DataLayer/ApiService.dart';
import 'package:islamiapp/Logic/AppProvider.dart';
import 'package:provider/provider.dart';
import '../Models/Reciter.dart';
import '../Widgets/RecitersList.dart';
import 'VersesScreen.dart';

class HomePage extends StatelessWidget {

  const HomePage({
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
        future: context.read<AppProvider>().getReciters(),
        builder: (context, snapshot) {
          if(context.watch<AppProvider>().reciters!=null){
            return Column(
              children: [
                Container(
                  color: Colors.black,
                  padding: const EdgeInsets.all(12.0),
                    child: TextField(
                      controller: context.watch<AppProvider>().controller,
                      onChanged: (value) {
                        context.read<AppProvider>().fillFilteredReciter(value);
                      },
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),

                          filled: true,
                          contentPadding: EdgeInsets.zero,
                          prefixIcon: GestureDetector(
                              onTap: () {
                                context.read<AppProvider>().resetFilteredReciter();
                              },
                              child: const Icon(Icons.close)),
                          suffixIcon: const Icon(Icons.search_outlined),
                          hintStyle: TextStyle(color: Colors.black.withOpacity(0.6),height: 2,fontWeight: FontWeight.w600),
                          hintText: "اسم الشيخ",
                          fillColor: Colors.white),textAlign: TextAlign.right,
                    )
                ),
                context.watch<AppProvider>().filteredReciter!=null
                    ? RecitersList(reciters: context.read<AppProvider>().filteredReciter!,)
                    : RecitersList(reciters: context.read<AppProvider>().reciters!,),
              ],
            );
          }
          else{
            return Container(
                color:  Colors.black,
                child: const Center(child: CircularProgressIndicator(
                  color: Colors.white,
                ),)
            );
          }
        },
      ),
    );
  }
}