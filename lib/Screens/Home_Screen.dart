import 'dart:io';
import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:fluttertoast/fluttertoast.dart';
// import 'package:google_ml_kit/google_ml_kit.dart';
// import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:language_picker/languages.dart';
import 'package:rate_my_app/rate_my_app.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:sqflite/sqflite.dart';
import 'package:translator/translator.dart';
import 'package:en_to_hi/Screens/DbHelper.dart';
import 'package:en_to_hi/Screens/Favorite_Screen.dart';
import 'package:en_to_hi/Screens/History_Screen.dart';
import 'package:en_to_hi/Screens/ads.dart';
import 'package:en_to_hi/main.dart';
import 'Privacy_Screen.dart';
import 'Settings_Screen.dart';



class Home_Screen extends StatefulWidget {
  // const Home_Screen({Key? key}) : super(key: key);

  Map? m;

  Home_Screen({this.m}); // Home_Screen(String jsCode, {this.m, this.jsCode});

  @override
  State<Home_Screen> createState() => _Home_ScreenState();
}

// Image to TExt --------------//
bool textScanning = false;
XFile? imageFile;
String scannedText = "";

class _Home_ScreenState extends State<Home_Screen> with WidgetsBindingObserver {
  bool isswitch = false;


  int id=0;
  bool isLike=false;


  final Language _selectedLanguage1 = Languages.english;
  final Language _selectedLanguage2 = Languages.lao;

  TextEditingController mycontroller = TextEditingController();
  final translator = GoogleTranslator();
  String translated = "";

  bool isSpeaking = false;
  bool sound = false;

  final _flutterTts = FlutterTts();

  void initializeTts() {
    _flutterTts.setStartHandler(() {
      setState(() {
        isSpeaking = true;
      });
    });
    _flutterTts.setCompletionHandler(() {
      setState(() {
        isSpeaking = false;
      });
    });
    _flutterTts.setErrorHandler((message) {
      setState(() {
        isSpeaking = false;
      });
    });
  }

  void speak(String ss) async {
    if (mycontroller.text.isNotEmpty) {
      await _flutterTts.speak(ss);
    }
  }

  void stop() async {
    await _flutterTts.stop();
    setState(() {
      isSpeaking = false;
    });
  }

  // Mic To text
  SpeechToText _speechToText = SpeechToText();
  bool _speechEnabled = false;

  /// This has to happen only once per app
  void _initSpeech() async {
    _speechEnabled = await _speechToText.initialize();
    setState(() {});
  }

  /// Each time to start a speech recognition session
  void _startListening() async {
    await _speechToText.listen(onResult: _onSpeechResult);
    setState(() {});
  }

  void _stopListening() async {
    await _speechToText.stop();
    setState(() {});
  }

  void _onSpeechResult(SpeechRecognitionResult result) {
    setState(() {
      mycontroller.text = result.recognizedWords;
      onchangestring = mycontroller.text;
    });
  }



  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance!.addObserver(this);

    _initSpeech();
    initializeTts();

    _flutterTts.setIosAudioCategory(
      IosTextToSpeechAudioCategory.playback,
      [IosTextToSpeechAudioCategoryOptions.defaultToSpeaker],
    );

    loaddata();

    setState(() {
      custFontSize;
    });

    DbHelper().createDatabase().then((value) {
      db = value;
    });

    if (widget.m != null) {
      _selectedLanguage1.name = widget.m!['language_1'];
      _selectedLanguage2.name = widget.m!['language_2'];
      mycontroller.text = widget.m!['text_controller'];
      translated = widget.m!['text_translated'];
      isLike = true;


      print(id);
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    var isPaused = state == AppLifecycleState.paused;
    if (isPaused) {
      // adsController.loadAppOpenAd();
    }
  }

  RateMyApp rateMyApp = RateMyApp(
    preferencesPrefix: 'rateMyApp_',
    minDays: 0,
    minLaunches: 2,
    googlePlayIdentifier: 'Translator.English.Tajik',
    appStoreIdentifier: '6447338706',
  );

  loaddata() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    isChecked = prefs.getBool("colormode")!;
    custFontSize = prefs.getDouble("sizemode")!;
    gvalue = prefs.getString("valuemode")!;

    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
    _flutterTts.stop();
    WidgetsBinding.instance!.removeObserver(this);
  }

  String pasteValue = '';

  TextStyle mystyle = const TextStyle(fontSize: 17, color: Color(0xFF666666));
  Database? db;
  String onchangestring = "";



  // -------------------- Image To Text --------------------
  // void getImage(ImageSource source) async {
  //   try {
  //     final pickedImage = await ImagePicker().pickImage(source: source);
  //     if (pickedImage != null) {
  //       textScanning = true;
  //
  //       imageFile = pickedImage;
  //
  //       _fetchData(context); // loading Dialog
  //       print("click");
  //
  //       setState(() {});
  //       getRecognisedText(pickedImage);
  //     }
  //   } catch (e) {
  //     textScanning = false;
  //     imageFile = null;
  //     scannedText = "Error occured while scanning";
  //     setState(() {});
  //   }
  // }
  //
  // void getRecognisedText(XFile image) async {
  //   final inputImage = InputImage.fromFilePath(image.path);
  //   final textDetector = GoogleMlKit.vision.textRecognizer();
  //   RecognizedText recognisedText = await textDetector.processImage(inputImage);
  //
  //   await textDetector.close();
  //   scannedText = "";
  //
  //   for (TextBlock block in recognisedText.blocks) {
  //     for (TextLine line in block.lines) {
  //       scannedText = scannedText + line.text + "\n";
  //
  //       mycontroller.text = scannedText;
  //       onchangestring = scannedText;
  //     }
  //   }
  //   textScanning = false;
  //   setState(() {});
  //
  //   if (!mounted) return; // loading Dialog
  //   Navigator.of(context).pop();
  // }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => FocusScope.of(context).unfocus(),
      child: WillPopScope(
          onWillPop: goBack,
          child: Scaffold(
            backgroundColor:Colors.deepPurple[100],
            resizeToAvoidBottomInset: false,

            // bottomNavigationBar: const BannerAdWidget(),

            appBar: AppBar(
              backgroundColor: greencolor,
              toolbarHeight: 70,
              elevation: 0,
              centerTitle: true,
              leading: Builder(
                builder: (BuildContext context) {
                  return IconButton(
                    icon: const Icon(
                      Icons.menu,
                      color: Colors.white,
                      size: 30, // Changing Drawer Icon Size
                    ),
                    onPressed: () {
                      Scaffold.of(context).openDrawer();
                    },
                    tooltip:
                        MaterialLocalizations.of(context).openAppDrawerTooltip,
                  );
                },
              ),
              title: Container(
                // height: 60,
                // width: double.infinity,
                alignment: Alignment.center,
                // color: Colors.amber,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(width: 7),
                    Expanded(
                      child: InkWell(
                        // onTap: () => _openLanguagePickerDialog(),
                        child: Container(
                          height: 40,
                          // width: double.infinity,
                          // color: Colors.amber.shade100,
                          alignment: Alignment.center,
                          padding: const EdgeInsets.only(right: 20),
                          child: Text(
                            _selectedLanguage1.name.toString(),
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w500,
                                color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                    IconButton(
                        onPressed: () {
                          mycontroller.clear();
                          setState(() {
                            translated = "";
                            sound = false;
                            onchangestring = "";

                            isswitch = !isswitch;

                            var val1 = _selectedLanguage1.name;
                            var val2 = _selectedLanguage2.name;
                            //
                            _selectedLanguage1.name = val2.toString();
                            _selectedLanguage2.name = val1;

                            var valIso1 = _selectedLanguage1.isoCode;
                            var valIso2 = _selectedLanguage2.isoCode;
                            //
                            _selectedLanguage1.isoCode = valIso2;
                            _selectedLanguage2.isoCode = valIso1;

                            print(
                                "_selectedDialogLanguage = ${_selectedLanguage1.name}");
                            print(
                                "_selectedDialogLanguage2 = ${_selectedLanguage2.name}");

                            print(
                                "_selectedDialogLanguageIso = ${_selectedLanguage1.isoCode}");
                            print(
                                "_selectedDialogLanguage2Iso = ${_selectedLanguage2.isoCode}");
                          });

                          mycontroller.clear();
                          translated = "";
                        },
                        icon: const Icon(
                          Icons.repeat,
                          size: 30,
                        )),
                    Expanded(
                      child: InkWell(
                        // onTap: () => _openLanguagePickerDialog2(),
                        child: Container(
                          height: 40,
                          alignment: Alignment.center,
                          child: Text(
                            _selectedLanguage2.name.toString(),
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w500,
                                color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            drawer: Drawer(
              child: Column(children: [
                Container(
                  height: 160,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: greencolor,
                      gradient: LinearGradient(
                        begin: Alignment.topRight,
                        end: Alignment.bottomLeft,
                        colors: [
                          const Color(0xFF18A092),
                          greencolor,
                        ],
                      )),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 25,
                          ),
                          Image.asset("assets/appicon.png", height: 60),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            "$APPNAME",
                            style: const TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 20,
                                color: Colors.white),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                        ]),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(8, 8, 8, 4),
                  child: Column(
                    children: [
                      ListTile(
                        onTap: () {
                          Navigator.pop(context);

                          Navigator.push(context, MaterialPageRoute(
                            builder: (context) {
                              return const Favorite_Screen();
                            },
                          ));
                        },
                        leading: const Icon(Icons.favorite, size: 27),
                        title: Text("Favorites", style: mystyle),
                      ),
                      ListTile(
                        onTap: () {
                          Navigator.pop(context);

                          Navigator.push(context, MaterialPageRoute(
                            builder: (context) {
                              return const History_Screen();
                            },
                          ));
                        },
                        leading: const Icon(Icons.history_sharp, size: 27),
                        title: Text("History", style: mystyle),
                      ),
                      ListTile(
                        onTap: () {
                          Navigator.pop(context);

                          Future.delayed(
                              const Duration(seconds: 0),
                              () => showDialog(
                                    context: context,
                                    builder: (ctx) => SimpleDialog(
                                      contentPadding: const EdgeInsets.only(
                                          left: 15,
                                          top: 20,
                                          bottom: 10,
                                          right: 10),
                                      // alignment: Alignment.center,
                                      title: const Text(
                                        'Select Action',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 22),
                                      ),
                                      children: [
                                        InkWell(
                                            onTap: () {
                                              // pickImageFromGallery();
                                              //  getImage(ImageSource.gallery);
                                              // Navigator.pop(context);
                                            },
                                            child: Container(
                                                height: 50,
                                                width: double.infinity,
                                                // color: Colors.green.shade100,
                                                alignment: Alignment.centerLeft,
                                                child: Row(
                                                  children: const [
                                                    Icon(Icons.photo,
                                                        color: Colors.black,
                                                        size: 30),
                                                    SizedBox(width: 10),
                                                    FittedBox(
                                                        child: Text(
                                                      "Select photo from gallery",
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.normal,
                                                          fontSize: 16.5),
                                                    )),
                                                  ],
                                                ))),
                                        const SizedBox(
                                          height: 2,
                                        ),
                                        InkWell(
                                            onTap: () {
                                              // pickImageFromCamera();
                                              // getImage(ImageSource.camera);
                                              // Navigator.pop(context);
                                            },
                                            child: Container(
                                                height: 60,
                                                width: double.infinity,
                                                alignment: Alignment.centerLeft,
                                                child: Row(
                                                  children: [
                                                    const Icon(Icons.camera_alt,
                                                        color: Colors.black,
                                                        size: 30),
                                                    const SizedBox(width: 10),
                                                    FittedBox(
                                                        child: Container(
                                                      child: const Text(
                                                        "Capture photo from Camera",
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .normal,
                                                            fontSize: 16.5),
                                                      ),
                                                    )),
                                                  ],
                                                ))),
                                        const SizedBox(
                                          height: 20,
                                        ),
                                      ],
                                    ),
                                  ));
                        },
                        leading: const Icon(Icons.camera_alt, size: 27),
                        title: Text("Camera", style: mystyle),
                      ),
                      ListTile(
                        onTap: () {
                          Navigator.pop(context);

                          Navigator.push(context, MaterialPageRoute(
                            builder: (context) {
                              return const Settings_Screen();
                            },
                          ));
                        },
                        leading: const Icon(Icons.settings, size: 27),
                        title: Text("Settings", style: mystyle),
                      ),
                    ],
                  ),
                ),
                const Divider(color: Color(0xFF666666), thickness: 0.5),
                Padding(
                  padding: const EdgeInsets.fromLTRB(8, 4, 8, 8),
                  child: Column(
                    children: [
                      ListTile(
                        onTap: () {
                          Share.share(
                              'https://apps.apple.com/us/app/english-tajik-translator/id6447338706');
                        },
                        leading: const Icon(Icons.share, size: 27),
                        title: Text("Share this app", style: mystyle),
                      ),
                      ListTile(
                        onTap: () {
                          Navigator.pop(context);

                          rating();
                          setState(() {});
                        },
                        leading: const Icon(Icons.rate_review, size: 27),
                        title: Text("Rate this app", style: mystyle),
                      ),
                      ListTile(
                        onTap: () {
                          Navigator.pop(context);

                          Navigator.push(context, MaterialPageRoute(
                            builder: (context) {
                              return const Privacy_Screen();
                            },
                          ));
                        },
                        leading: const Icon(Icons.security, size: 27),
                        title: Text("Privacy policy", style: mystyle),
                      ),
                    ],
                  ),
                ),
              ]),
            ),

            // bottomNavigationBar: Container(),

            body: Padding(
              padding: const EdgeInsets.all(12),
              child: Stack(
                children: [
                  Column(children: [
                    Expanded(
                        child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Column(
                        children: [
                          Expanded(
                              child: Stack(
                            children: [
                              Container(
                                // color: Colors.lightBlue.shade50,

                                child: TextField(
                                  controller: mycontroller,
                                  // focusNode: FocusNode(canRequestFocus: false),
                                  autofocus: isChecked ? true : false,
                                  clipBehavior: Clip.antiAliasWithSaveLayer,
                                  keyboardType: TextInputType.text,
                                  maxLines: 9999,
                                  cursorHeight: 25,
                                  cursorColor: greencolor,
                                  onChanged: (String) {
                                    setState(() {
                                      onchangestring = mycontroller.text;
                                    });
                                  },
                                  decoration: InputDecoration(
                                      hintText: "Type here...",
                                      hintStyle:
                                          TextStyle(fontSize: custFontSize),
                                      border: InputBorder.none),
                                  style: TextStyle(
                                    fontSize: custFontSize,
                                    decoration: TextDecoration.none,
                                    // Input Text Remove UnderLine
                                    decorationThickness: 0,
                                  ),
                                ),
                              ),
                              Align(
                                alignment: Alignment.bottomCenter,
                                child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      widget.m != null &&
                                              mycontroller.text.isEmpty
                                          ? InkWell(
                                              onTap: () {
                                                FlutterClipboard.paste()
                                                    .then((value) {
                                                  setState(() {
                                                    onchangestring = value;
                                                    mycontroller.text = value;
                                                  });
                                                });
                                              },
                                              child: CircleAvatar(
                                                backgroundColor: greencolor,
                                                radius: 23,
                                                child: FloatingActionButton(
                                                  backgroundColor: greencolor,
                                                  onPressed: () {
                                                    FlutterClipboard.paste()
                                                        .then((value) {
                                                      setState(() {
                                                        onchangestring = value;
                                                        mycontroller.text =
                                                            value;
                                                      });
                                                    });
                                                  },
                                                  tooltip: 'Listen',
                                                  child: const Icon(
                                                    Icons.paste,
                                                    size: 25,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                            )
                                          : widget.m != null
                                              ? CircleAvatar(
                                                  backgroundColor: greencolor,
                                                  radius: 23,
                                                  child: FloatingActionButton(
                                                    backgroundColor: greencolor,
                                                    onPressed: () {
                                                      print("Text Clear");
                                                      mycontroller.clear();
                                                      setState(() {
                                                        translated = "";
                                                        sound = false;
                                                        onchangestring = "";
                                                      });
                                                    },
                                                    tooltip: 'Listen',
                                                    child: const Icon(
                                                      Icons.close,
                                                      size: 25,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                )
                                              : onchangestring == ""
                                                  ? CircleAvatar(
                                                      backgroundColor:
                                                          greencolor,
                                                      radius: 23,
                                                      child:
                                                          FloatingActionButton(
                                                        backgroundColor:
                                                            greencolor,
                                                        onPressed: () {
                                                          FlutterClipboard
                                                                  .paste()
                                                              .then((value) {
                                                            setState(() {
                                                              onchangestring =
                                                                  value;
                                                              mycontroller
                                                                  .text = value;
                                                            });
                                                          });
                                                        },
                                                        tooltip: 'Listen',
                                                        child: const Icon(
                                                          Icons.paste,
                                                          size: 25,
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                    )
                                                  : InkWell(
                                                      onTap: () {
                                                        print("Text Clear");
                                                        mycontroller.clear();
                                                        setState(() {
                                                          translated = "";
                                                          sound = false;
                                                          onchangestring = "";
                                                        });
                                                      },
                                                      child: CircleAvatar(
                                                        backgroundColor:
                                                            greencolor,
                                                        radius: 23,
                                                        child:
                                                            FloatingActionButton(
                                                          backgroundColor:
                                                              greencolor,
                                                          onPressed: () {


                                                            print("Text Clear");
                                                            mycontroller
                                                                .clear();
                                                            setState(() {

                                                              translated = "";
                                                              sound = false;
                                                              onchangestring =
                                                                  "";
                                                            });
                                                          },
                                                          tooltip: 'Listen',
                                                          child: const Icon(
                                                            Icons.close,
                                                            size: 25,
                                                            color: Colors.white,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                      const SizedBox(width: 15),
                                      CircleAvatar(
                                        backgroundColor: greencolor,
                                        radius: 23,
                                        child: FloatingActionButton(
                                          backgroundColor: greencolor,
                                          onPressed:
                                              _speechToText.isNotListening
                                                  ? _startListening
                                                  : _stopListening,
                                          tooltip: 'Listen',
                                          child: Icon(
                                              _speechToText.isNotListening
                                                  ? Icons.mic_off
                                                  : Icons.mic),
                                        ),
                                      ),
                                      const SizedBox(width: 15),
                                      sound == true ||
                                              mycontroller.text.isNotEmpty
                                          ? InkWell(
                                              onTap: () {
                                                isSpeaking
                                                    ? stop()
                                                    : speak(mycontroller.text);
                                              },
                                              child: CircleAvatar(
                                                backgroundColor: greencolor,
                                                radius: 23,
                                                child: const Icon(
                                                  Icons.volume_up,
                                                  size: 25,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            )
                                          : const SizedBox(),
                                    ]),
                              ),
                            ],
                          )),
                        ],
                      ),
                    )),
                    const SizedBox(
                      height: 15,
                    ),
                    Expanded(
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: greencolor,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Column(children: [
                          Expanded(
                              child: Stack(
                            // alignment: AlignmentDirectional.centerEnd,
                            clipBehavior: Clip.none,
                            children: [
                              Container(
                                height: double.infinity, width: double.infinity,
                                // color: Colors.blue,
                                child: SingleChildScrollView(
                                   child: Container(
                                    padding: const EdgeInsets.only(top: 15),
                                    child: Text(translated.toString(),
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: custFontSize,
                                            fontWeight: FontWeight.w500)),
                                  ),
                                ),
                              ),
                              translated.toString().isEmpty
                                  ? const SizedBox()
                                  : Align(
                                      alignment: Alignment.bottomCenter,
                                      child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            InkWell(
                                              onTap: () {
                                                print("Click copy");

                                                FlutterClipboard.copy(
                                                        translated.toString())
                                                    .then(
                                                  (value) =>
                                                      Fluttertoast.showToast(
                                                          msg: "Copied",
                                                          toastLength: Toast
                                                              .LENGTH_SHORT,
                                                          gravity: ToastGravity
                                                              .CENTER,
                                                          timeInSecForIosWeb: 1,
                                                          backgroundColor:
                                                              Colors.black,
                                                          textColor:
                                                              Colors.white,
                                                          fontSize: 16.0),
                                                );
                                              },
                                              child: CircleAvatar(
                                                backgroundColor: Colors.white,
                                                radius: 23,
                                                child: Icon(Icons.copy,
                                                    size: 25,
                                                    color: greencolor),
                                              ),
                                            ),
                                            const SizedBox(width: 15),
                                            InkWell(
                                              onTap: () {
                                                Share.share(
                                                    translated.toString());
                                              },
                                              child: CircleAvatar(
                                                backgroundColor: Colors.white,
                                                radius: 23,
                                                child: Icon(Icons.share,
                                                    size: 25,
                                                    color: greencolor),
                                              ),
                                            ),
                                            const SizedBox(width: 15),
                                            InkWell(
                                              onTap: () async {






                                                Fluttertoast.showToast(
                                                    msg: "Added",
                                                    toastLength:
                                                        Toast.LENGTH_SHORT,
                                                    gravity:
                                                        ToastGravity.CENTER,
                                                    timeInSecForIosWeb: 1,
                                                    backgroundColor:
                                                        Colors.black,
                                                    textColor: Colors.white,
                                                    fontSize: 16.0);


                                                String language1 = _selectedLanguage1.name;
                                                String language2 = _selectedLanguage2.name;

                                                isLike=!isLike;
                                                setState(() {

                                                });

                                                if(isLike==true)
                                                  {

                                                    String qry = """insert into TestFav (language_1,text_controller,language_2,text_translated,isFav) values("${language1.toString()}","${mycontroller.text.toString()}","${language2.toString()}","${translated.toString()}","1")""";
                                                    int a = await db!.rawInsert(qry);
                                                    print(a);
                                                    setState((){
                                                      id=a;
                                                    });

                                                  }
                                                else
                                                  {

                                                    String qry="DELETE FROM TestFav WHERE id=${id}";
                                                    await db!.rawDelete(qry);
                                                    print(qry);
                                                    setState(() {});


                                                  }






                                              },
                                              child: CircleAvatar(
                                                backgroundColor: Colors.white,
                                                radius: 23,
                                                child: Icon(Icons.favorite,
                                                    size: 25,
                                                    color:isLike?Colors.deepOrange: greencolor),
                                              ),
                                            ),
                                            const SizedBox(width: 15),
                                            InkWell(
                                              onTap: () {


                                                isSpeaking
                                                    ? stop()
                                                    : speak(translated);
                                                setState(() {

                                                });
                                              },
                                              child: CircleAvatar(
                                                backgroundColor: Colors.white,
                                                radius: 23,
                                                child: Icon(Icons.volume_up,
                                                    size: 25,
                                                    color: greencolor),
                                              ),
                                            ),
                                          ]),
                                    ),
                            ],
                          ))
                        ]),
                      ),
                    ),
                  ]),
                  Padding(
                    padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).size.height * 0.01,
                    ),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: InkWell(
                        onTap: () async {
                          print("on Tap Sucess");

                          if (mycontroller.text.isNotEmpty) {
                            // adsController.showInterstititalAd(context);

                            setState(() {
                              sound = true;
                            });

                            FocusScope.of(context).requestFocus(
                                FocusNode()); // When TextField closed Keyboard Close..

                            _fetchData(context); // loading Dialog
                            print("click");

                            final translation =
                                await mycontroller.text.translate(
                              from: "auto",
                              to: _selectedLanguage2.isoCode,
                            );

                            translated = translation.text;

                            setState(() {});
                            print(
                                "Mycontroller : ${mycontroller.text.toString()}");
                            print("Translated : $translated");

                            print(
                                "_selectedDialogLanguage = ${_selectedLanguage1.name}");
                            print(
                                "_selectedDialogLanguage2 = ${_selectedLanguage2.name}");

                            print(
                                "_selectedDialogLanguageIso = ${_selectedLanguage1.isoCode}");
                            print(
                                "_selectedDialogLanguage2Iso = ${_selectedLanguage2.isoCode}");

                            if (!mounted) return; // loading Dialog
                            Navigator.of(context).pop();

                            //DataBase

                            String language1 = _selectedLanguage1.name;
                            String language2 = _selectedLanguage2.name;
                            if (widget.m == null) {
                              String qry = """insert into Test (language_1,text_controller,language_2,text_translated,isFav) values("${language1.toString()}","${mycontroller.text.toString()}","${language2.toString()}","${translated.toString()}","1")""";

                              int a = await db!.rawInsert(qry);

                              print(a);
                            }
                            else {
                              int id = widget.m!['id'];

                              String qry = "update Test set language_1='${language1.toString()}',text_controller='${mycontroller.text.toString()}',language_2='${language2.toString()}',text_translated='${translated.toString()}',isFav='1' where id = '$id'";

                              int a = await db!.rawUpdate(qry);

                              print(a);
                            }
                          }
                          else {
                            print("Text Is Empty");

                            Fluttertoast.showToast(
                                msg: "Please enter text!!",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.CENTER,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Colors.black,
                                textColor: Colors.white,
                                fontSize: 16.0);
                          }
// loading Dialog
                        },
                        child:  Padding(
                          padding: EdgeInsets.only(right: 16),
                          child: SizedBox(
                              height: 70,
                              width: 60,
                              child: CircleAvatar(
                                  backgroundColor: Colors.deepPurple[400],
                                  child: Icon(Icons.send,
                                      size: 30, color: Colors.white))
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )),
    );
  }

  void _fetchData(BuildContext context, [bool mounted = true]) async {
    // show the loading dialog
    showDialog(
        // The user CANNOT close this dialog  by pressing outsite it
        barrierDismissible: false,
        context: context,
        builder: (_) {
          return Dialog(
            // The background color
            backgroundColor: Colors.white,
            child: Padding(
              padding: const EdgeInsets.only(top: 20, bottom: 20, right: 05),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // The loading indicator
                  const SizedBox(
                    width: 20,
                  ),
                  CircularProgressIndicator(color: greencolor),
                  const SizedBox(
                    width: 20,
                  ),
                  // Some text
                  const Flexible(
                      child: Text(
                    'Please wait...',
                    style: TextStyle(fontSize: 16.5),
                  ))
                ],
              ),
            ),
          );
        });
  }

  Future<bool> goBack() {
    exit(0);
  }

  rating() {
    rateMyApp.showStarRateDialog(
      context,
      title: 'Rate this app',
      // The dialog title.
      message:
          "You like this app ? Then take a little bit of your time to leave a rating :",
      actionsBuilder: (context, stars) {
        return [
          TextButton(
            child: const Text(
              'OK',
              style: TextStyle(fontFamily: "Myfontlight", color: Colors.black),
            ),
            onPressed: () async {
              print('Thanks for the ' +
                  (stars == null ? '0' : stars.round().toString()) +
                  ' star(s) !');

              await rateMyApp.callEvent(RateMyAppEventType.rateButtonPressed);
              Navigator.pop<RateMyAppDialogButton>(
                  context, RateMyAppDialogButton.rate);
            },
          ),
        ];
      },
      ignoreNativeDialog: Platform.isAndroid,
      dialogStyle: const DialogStyle(
        titleAlign: TextAlign.center,
        messageAlign: TextAlign.center,
        messagePadding: EdgeInsets.only(bottom: 20),
      ),
      starRatingOptions: const StarRatingOptions(),
      onDismissed: () => rateMyApp.callEvent(RateMyAppEventType
          .laterButtonPressed), // Called when the user dismissed the dialog (either by taping outside or by pressing the "back" button).
    );
  }

}
