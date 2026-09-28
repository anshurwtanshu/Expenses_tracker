import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'home_screen.dart';
import 'login_screen.dart';
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override

  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  void initState(){
    super.initState();
    checklogin();
  }


  void checklogin() async{
    await Future.delayed(const Duration(seconds: 3));

    final prefs = await SharedPreferences.getInstance();
    bool  isLoggedIn = prefs.getBool("isloggedIn")?? true ;
    if(isLoggedIn){
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context)=>HomeScreen(),));
    }else
    {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const LoginScreen(),
        ),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
children: [
  Text("WELCOME TO EXPENSE TRACKER"),
  SizedBox(height: 20,),
  CircularProgressIndicator(),


],
        )

      ),
    );
  }
}
