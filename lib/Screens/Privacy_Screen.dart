import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:en_to_hi/Screens/Home_Screen.dart';
import 'package:en_to_hi/main.dart';

class Privacy_Screen extends StatefulWidget {
  const Privacy_Screen({Key? key}) : super(key: key);

  @override
  State<Privacy_Screen> createState() => _Privacy_ScreenState();
}

class _Privacy_ScreenState extends State<Privacy_Screen> {




  @override
  void initState() {

    super.initState();

    privacynote();

  }


  String privacy = "";

  privacynote () async
  {
      privacy = await rootBundle.loadString("assets/privacy.txt");

      print("Privacy :: $privacy");

      setState(() {


      });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
     appBar: AppBar(
      backgroundColor: greencolor,
      elevation: 0,
      centerTitle: true,
      leading: IconButton(
          onPressed: () =>
              Navigator.pushReplacement(context, MaterialPageRoute(
                builder: (context) {
                  return Home_Screen();
                },
              )),
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          )),
      title:  Text(
        "Privacy Policy",
        style: TextStyle(
            fontSize: 22, color: Colors.white, fontWeight: FontWeight.w500),
      )
    ),


    body: Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListView(
        children: [
          Container(child: Text(privacy,style: TextStyle(fontSize: 18,wordSpacing: 0.4),)),
        ],
      ),
    ),
    );
  }

}
