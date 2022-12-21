import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:islamiapp/Logic/AppProvider.dart';
import 'package:islamiapp/di.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:provider/provider.dart';
import 'DataLayer/ApiService.dart';
import 'Screens/SplashScreen.dart';

void main()async{
  setup();
  await JustAudioBackground.init(
    androidNotificationChannelId: 'com.ryanheise.bg_demo.channel.audio',
    androidNotificationChannelName: 'Audio playback',
    androidNotificationOngoing: true,
  );
  ApiServices.init();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: GoogleFonts.tajawal().fontFamily
      ),
      home: FutureBuilder(
        future: context.read<AppProvider>().getAllSawr(),
        builder: (context, snapshot) {
          if(context.read<AppProvider>().suwar!=null){
            return const SplashScreen();
          }
          else{
            return const Center(child: CircularProgressIndicator(),);
          }
        },
      ),
    );
  }
}

