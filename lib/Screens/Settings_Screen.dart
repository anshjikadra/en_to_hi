import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:en_to_hi/Screens/Home_Screen.dart';
import 'package:en_to_hi/main.dart';

class Settings_Screen extends StatefulWidget {
  const Settings_Screen({Key? key}) : super(key: key);

  @override
  State<Settings_Screen> createState() => _Settings_ScreenState();
}

bool isChecked = false;
String gvalue = "20";


class _Settings_ScreenState extends State<Settings_Screen> {


  @override
  Widget build(BuildContext context) {

    @override
    _savebool() async
    {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      await prefs.setBool("colormode", isChecked);
      await prefs.setDouble("sizemode", custFontSize);
      await prefs.setString("valuemode", gvalue);

    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: greencolor,
        elevation: 0,
        leading: IconButton(
            onPressed: () =>
                Navigator.pushReplacement(context, MaterialPageRoute(
                  builder: (context) {
                    return Home_Screen();
                  },
                )),
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.white,
            )),
        title: Row(children: const [
          Icon(Icons.settings, size: 35),
          SizedBox(width: 3),
          Text(
            "Settings",
            style: TextStyle(
                fontSize: 22, color: Colors.white, fontWeight: FontWeight.w500),
          )
        ]),
      ),
      body: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [


              Padding(
                padding: const EdgeInsets.only(left: 20),
                child: ListTile(

                  title: const Text("Keyboard",style: const TextStyle(fontSize: 18,fontWeight: FontWeight.w400)),
                  subtitle: const Text("Show the keyboard at startup",style: TextStyle(fontSize: 16,fontWeight: FontWeight.w400)),

                  trailing: Checkbox(
                    checkColor: Colors.white,
                    // fillColor: MaterialStateProperty.resolveWith(),
                    value: isChecked,
                    onChanged: (bool? value) {
                      setState(() {

                        isChecked = value!;


                        _savebool();
                      });
                    },
                  ),

                ),
              ),

              const SizedBox(height: 8,),

              Padding(
                padding: const EdgeInsets.only(left: 20),
                child: ListTile(

                  onTap: () {


                    Future.delayed(
                        const Duration(seconds: 0),
                            () => showDialog(
                            context: context,
                            builder: (ctx) {
                              return StatefulBuilder(builder: (context, setState) {
                                return SimpleDialog(
                                  contentPadding: const EdgeInsets.only(
                                      left: 15, top: 20, bottom: 10, right: 10),
                                  // alignment: Alignment.center,
                                  title: const Text(
                                    'Text size',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w500, fontSize: 22),
                                  ),
                                  children: [

                                    Row(children: [
                                      Radio(
                                        onChanged: (value) {
                                          setState(() {
                                            gvalue = value.toString();
                                            custFontSize = double.parse(value.toString());

                                          });
                                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Settings_Screen(),));

                                          _savebool();
                                        },
                                        value: "12",
                                        groupValue: gvalue,

                                      ),
                                      const Text("12",style: const TextStyle(fontWeight: FontWeight.w400,fontSize: 21),)
                                    ],),

                                    Row(children: [
                                      Radio(
                                        onChanged: (value) {
                                          // Navigator.pop(context);
                                          setState(() {
                                            gvalue = value.toString();
                                            custFontSize = double.parse(value.toString());


                                          });

                                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Settings_Screen(),));


                                          _savebool();


                                        },
                                        value: "16",
                                        groupValue: gvalue,

                                      ),
                                      const Text("16",style: const TextStyle(fontWeight: FontWeight.w400,fontSize: 21),)
                                    ],),

                                    Row(children: [
                                      Radio(

                                        onChanged: (value) {
                                          // Navigator.pop(context);

                                          setState(() {
                                            gvalue = value.toString();
                                            custFontSize = double.parse(value.toString());


                                          });
                                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Settings_Screen(),));


                                          _savebool();


                                        },
                                        value: "20",
                                        groupValue: gvalue,

                                      ),
                                      const Text("20",style: const TextStyle(fontWeight: FontWeight.w400,fontSize: 21),)
                                    ],),

                                    Row(children: [
                                      Radio(
                                        onChanged: (value) {
                                          // Navigator.pop(context);

                                          setState(() {
                                            gvalue = value.toString();
                                            custFontSize = double.parse(value.toString());

                                          });
                                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Settings_Screen(),));


                                          _savebool();

                                        },
                                        value: "24",
                                        groupValue: gvalue,

                                      ),
                                      const Text("24",style: TextStyle(fontWeight: FontWeight.w400,fontSize: 21),)
                                    ],),

                                    Row(children: [
                                      Radio(
                                        onChanged: (value) {
                                          // Navigator.pop(context);

                                          setState(() {
                                            gvalue = value.toString();
                                            custFontSize = double.parse(value.toString());


                                          });
                                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Settings_Screen(),));


                                          _savebool();

                                        },
                                        value: "28",
                                        groupValue: gvalue,

                                      ),
                                      const Text("28",style: const TextStyle(fontWeight: FontWeight.w400,fontSize: 21),)
                                    ],),

                                    Row(children: [
                                      Radio(
                                        onChanged: (value) {
                                          // Navigator.pop(context);

                                          setState(() {
                                            gvalue = value.toString();
                                            custFontSize = double.parse(value.toString());


                                          });

                                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Settings_Screen(),));


                                          _savebool();


                                        },
                                        value: "32",
                                        groupValue: gvalue,

                                      ),
                                      const Text("32",style: const TextStyle(fontWeight: FontWeight.w400,fontSize: 21),)
                                    ],),


                                    Row(mainAxisAlignment: MainAxisAlignment.end,children: [

                                      TextButton(onPressed: () {
                                      Navigator.pop( context);
                                    }, child: Text("CANCEL",style: TextStyle(fontSize: 18,color: greencolor,fontWeight: FontWeight.w500),)),

                                    ],),
                                  ],
                                );
                              },);
                            }
                        ));

                    Navigator.pop(context);


                    print("CUSTOM FONT SIZE == $custFontSize");
                    // setpref();

                  },

                  title: const Text("Text size",style: const TextStyle(fontSize: 18,fontWeight: FontWeight.w400)),
                  subtitle: Text("${custFontSize.toStringAsFixed(0)}",style: const TextStyle(fontSize: 16,fontWeight: FontWeight.w400)),

                ),
              ),

            ],
          )),
    );
  }

}
