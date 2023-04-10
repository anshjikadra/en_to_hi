import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:en_to_hi/Screens/DbHelper.dart';
import 'package:en_to_hi/Screens/Home_Screen.dart';
import 'package:en_to_hi/main.dart';


List<Map<String, Object?>> l = [];
class Favorite_Screen extends StatefulWidget {
  const Favorite_Screen({Key? key}) : super(key: key);

  @override
  State<Favorite_Screen> createState() => _Favorite_ScreenState();
}

class _Favorite_ScreenState extends State<Favorite_Screen> {
  Database? db;
  List<Map<String, Object?>> ReveList = [];

  bool issearch = false;
  TextEditingController search_text = TextEditingController();
  String query = '';

  bool islongpress = false;





  @override
  void initState() {
    super.initState();

    getAllData();
  }

  Future<List<Map<String, Object?>>> getAllData() async {
    db = await DbHelper().createDatabase();

    String qry = "select * from TestFav";

    List<Map<String, Object?>> l1 = await db!.rawQuery(qry);

    print(qry);
    return l1;
  }

  @override
  Widget build(BuildContext context) {
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
            icon: Icon(
              Icons.arrow_back,
              color: Colors.white,
            )),
        title: Text(
          "Favorites",
          style: TextStyle(
              fontSize: 22, color: Colors.white, fontWeight: FontWeight.w500),
        ),
        actions: [

          IconButton(onPressed: () async {

            _showDialogClearData();

          }, icon: Icon(Icons.delete)),

        ],
      ),
      body: FutureBuilder(
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              l = snapshot.data as List<Map<String, Object?>>;

              ReveList = List.from(l.reversed); // Set Reverse List

              l = ReveList; // Set Reverse List


              print("LIST LLLL === ${l}");

              return (l.length > 0
                  ? ListView.separated(

                itemBuilder: (BuildContext context, int index) {
                  Map m = l[index];
                  print("--------** ${l[index]}");
                  print(l[index]['isFav']);


                  List<MapEntry> myList = m.entries.toList();

                  print(myList);

                  return InkWell(
                    onTap: () {

                      Navigator.pushReplacement(context,
                          MaterialPageRoute(
                            builder: (context) {
                              return Home_Screen(m : m);
                            },
                          ));


                      print( "---------------------------language_1 : ${m['language_1']}");
                      print("---------------------------language_2 :  ${m['language_2']}");
                      print("---------------------------language_1 Iso Code :  ${m['language1IsoCode1']}");
                      print("---------------------------language_2 Iso Code :  ${m['language2IsoCode2']}");


                    },
                    onLongPress: () {
                      setState(() {
                        islongpress = true;
                      });
                    },
                    child: Container(
                      // color: Colors.amber.shade200,
                      height: 80,
                      width: double.infinity,
                      margin: const EdgeInsets.only(top: 8),
                      child: Column(children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 4),
                          // color: Colors.purple.shade100,
                          child: Column(children: [
                            Container(
                              width: double.infinity,
                              // color: Colors.green,
                              child: Text(
                                "${m['text_controller']}",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                softWrap: false,
                                style: const TextStyle(
                                  fontSize: 20,
                                  color: Color(0xFF666666),
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Container(
                              width: double.infinity,
                              // color: Colors.lightBlueAccent,
                              child: Text(
                                "${m['text_translated']}",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                softWrap: false,
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w400,
                                    color: greencolor,
                                    overflow: TextOverflow.ellipsis),
                              ),
                              // const SizedBox(height: 5),
                            ),
                          ]),
                        ),
                        Spacer(),
                      ]),
                    ),
                  );
                },
                separatorBuilder: (context, index) => const Divider(
                    height: 1, thickness: 0.6, color: Colors.black26),
                itemCount: l.length,
              )
                  : const Center(child: const Text("NO FAVORITE WORD FOUND",style: TextStyle(fontSize: 18),)));
            } else {
              const Center(child: const Text("No Data Here"));
            }
          }
          return Center(
              child: CircularProgressIndicator(
                color: greencolor,
              ));
        },
        future: getAllData(),
      ),
    );
  }

  _showDialogClearData() {
    return showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child :
          Padding(
            padding: const EdgeInsets.all(16),
            child: Container(
              height: MediaQuery.of(context).size.width * 0.27,
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  const Align(
                    alignment: Alignment.center,
                    child: Text(
                      "Clear all data?",
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          wordSpacing: 0.4,
                          fontSize: 22),
                    ),
                  ),
                  const SizedBox(height: 20),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [

                      TextButton(onPressed: () {
                        Navigator.pop(context);
                      }, child: Text(
                        'No',
                        style: TextStyle(
                          fontSize: 20,
                          letterSpacing: 0.7,
                          color: greencolor,
                        ),
                      ),),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: greencolor,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          minimumSize: const Size(100, 45), //////// HERE
                        ),
                        onPressed: () async {

                          String qry = "DELETE FROM TestFav";

                          await db!.rawDelete(qry);

                          setState(() {

                          });


                          Navigator.pop(context);
                        },
                        child: const Text(
                          'Yes',
                          style: TextStyle(
                              fontSize: 18,
                              letterSpacing: 0.7,
                              color: Colors.white,
                              fontWeight: FontWeight.w500
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

}
