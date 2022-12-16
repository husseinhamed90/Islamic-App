import 'package:flutter/material.dart';
import 'package:islamiapp/Screens/HomePage.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    startTimer();
  }
  void startTimer() {
    Future.delayed(const Duration(seconds: 5)).then((value){
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage(),));
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body : Center(
        child: SizedBox(
          height: 200,
          width: 200,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10), // Image border
            child: Image.asset("assets/images/logo.png", fit: BoxFit.cover),
          ),
          //color: Colors.black,
        ),
      ),
    );
  }
}
