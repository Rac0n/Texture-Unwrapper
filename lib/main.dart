import 'dart:convert';
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' show AnchorElement;
import 'package:file_picker/file_picker.dart';
import 'package:image_picker_web/image_picker_web.dart';

import 'my_hud.dart';
import 'package:flutter/material.dart';
import 'dart:ui' as my_ui;

import 'package:screenshot/screenshot.dart';

import 'dart:async';
import 'package:flutter/services.dart';

Map<String, dynamic> allAssets={};
bool assetsLoading = true;
Size gameSize = const Size(1.0, 1.0);
int currentFra=0;
bool starting=false;

late StreamController<String> streamController;
late Stream stream;

late Uint8List? fromPicker;
String jsonName="";

late dynamic results;

bool addedImage=false;
bool addedJson=false;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
  
  streamController = StreamController<String>();
  stream = streamController.stream.asBroadcastStream();
  
  assetsLoading = true;
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Texture Unwrapping',
      theme: ThemeData(
        primarySwatch:Colors.teal,
        fontFamily: "Gamlangdee"
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  MyHomePageState createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin,WidgetsBindingObserver {
  late Animation<double> animation;
  late AnimationController controller;
  ScreenshotController screenshotController = ScreenshotController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    stream.listen((event) {
      if (event == "LOADED") {
        assetsLoading = false;
        setState(() {
          
        });
      }
    });

    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 60),
    );

    Tween<double> animationTween = Tween(begin: 0, end: 1.0);

    animation = animationTween.animate(controller)
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          controller.repeat();
        } else if (status == AnimationStatus.dismissed) {
          controller.forward();
        }
      });

    controller.forward();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:Stack(
        children: [
        Container(color: Colors.grey.shade100,
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,),
            Row(
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width-200,
                  child:
        starting==false? Container(margin:const EdgeInsets.all(50),
        color: Colors.white54,)
        : assetsLoading
            ? Center(child: CircularProgressIndicator(color: Colors.grey.shade800,)): Center(
        child: Screenshot(
                  controller: screenshotController,child: SizedBox(
                    width: gameSize.width,
                    height: gameSize.height,
                    child: AnimatedBuilder(
                      animation: animation,
                      builder: (context, child) {
                      return CustomPaint(
                      painter: MyPaintOne(
                          animation.value),
                      size: gameSize
                    );}))))),
                    SizedBox(width: 200,
                    child:Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [ Column(
                      children: [
                        const SizedBox(height: 20,),
                        const Text("Choose the image:"),
                        const SizedBox(height: 10,),
                        addedImage==false? Container(
                              width: 160,
                              height: 35,
                              decoration: BoxDecoration(
                                color: Colors.green.shade300,
                                borderRadius: BorderRadius.circular(10)
                              ),
                              child:MaterialButton(
                            child: const Icon( Icons.image_outlined),
                            onPressed: () async{
                              addedImage=false;
                              fromPicker=null;
                              ImagePickerWeb.getImageAsBytes().then((value) {
                                if(value!=null){
                                fromPicker=value;
                                addedImage=true;
                                setState(() {
                                  
                                });
                                }
                                else {
                                  addedImage=false;
                                  fromPicker=null;
                                }
                              }).catchError((onError){
                                throw Exception("ERROR loading image.");
                              });

                            },
                          )):
                          Container(
                              padding: const EdgeInsets.all(10),
                              child: MaterialButton(
                            child: Image.memory(fromPicker!),
                            onPressed: () async{
                              addedImage=false;
                              fromPicker=null;
                              ImagePickerWeb.getImageAsBytes().then((value) {
                                if(value!=null){
                                fromPicker=value;
                                addedImage=true;
                                setState(() {
                                  
                                });
                                }
                                else {
                                  addedImage=false;
                                  fromPicker=null;
                                }
                              }).catchError((onError){
                                throw Exception("ERROR loading image.");
                              });

                            }),),
                            const SizedBox(height: 20,),
                            const Text("Choose the JSON file:"),
                            const SizedBox(height: 10,),
                            addedJson==false? Container(
                              width: 160,
                              height: 35,
                              decoration: BoxDecoration(
                                color: Colors.green.shade300,
                                borderRadius: BorderRadius.circular(10)
                              ),
                              child:MaterialButton(
                            child:const Icon( Icons.open_in_browser_outlined),
                            onPressed: () async{
                              addedJson=false;
                              results=null;

                              FilePicker.platform.pickFiles().then((FilePickerResult? value) {
                                if(value!=null){
                                  var decoded = utf8.decode(value.files.first.bytes as List<int>);
                                  jsonName=value.files.first.name;
                                  results=json.decode(decoded);

                                  addedJson=true;
                                  setState(() {
                                  
                                  });
                                }
                                else {
                                  results=null;
                                  addedJson=false;
                                }
                              }).catchError((onError){
                                throw Exception("ERROR loading the json file.");
                              });

                            },
                          )): 
                          SizedBox(
                              width: 180,
                              height: 35,
                              child: MaterialButton(
                            child: Row(children: [
                              Text(jsonName),
                              const SizedBox(width: 10,),
                              const Icon(Icons.check, color: Colors.green,)
                            ]),
                            onPressed: () async{
                              addedJson=false;
                              results=null;

                              FilePicker.platform.pickFiles().then((FilePickerResult? value) {
                                if(value!=null){
                                  jsonName=value.files.first.name;
                                  results=json.decode(value.files.first.bytes.toString());
                                  addedJson=true;
                                  setState(() {
                                  
                                  });
                                }
                                else {
                                  results=null;
                                  addedJson=false;
                                }
                              }).catchError((onError){
                                throw Exception("ERROR loading the json file.");
                              });

                            },),),
                            const SizedBox(height: 35,),
                            Container(
                        margin: const EdgeInsets.only(bottom: 20),
                              width: 160,
                              height: 35,
                              decoration: BoxDecoration(
                                color: addedImage && addedJson? Colors.green.shade300: Colors.grey.shade300,
                                borderRadius: BorderRadius.circular(10)
                              ),
                              child:MaterialButton(
                            child:const Text("Start"),
                            onPressed: () async{
                              if(addedImage && addedJson){
                                currentFra=0;
                              starting=true;
                              setState(() {
                                
                              });
                              loadAssets();
                              }
                            })),
                      ]),
                      assetsLoading==false? Container(
                        margin: const EdgeInsets.only(bottom: 20),
                              width: 180,
                              child:
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(results["frames"].keys.elementAt(currentFra)),
                                  const SizedBox(height: 15,),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [ IconButton(
                            icon :const Icon(Icons.arrow_back),
                            onPressed: () async{
            if(currentFra>0){
              currentFra-=1;
            }
            else {
              currentFra=results["frames"].keys.length-1;
            }
            String first=results["frames"].keys.elementAt(currentFra);
            gameSize=Size(results["frames"][first]["sourceSize"]["w"].toDouble(),
            results["frames"][first]["sourceSize"]["h"].toDouble());

            setState(() {
              
            });
                            }),
                            IconButton(
                            icon :const Icon(Icons.download),
                            onPressed: () async{
            String first=results["frames"].keys.elementAt(currentFra);
            
            AnchorElement()
            ..href = '${Uri.dataFromBytes(fromPicker!, mimeType: 'image/png')}'
            ..download = "$first.png"
            ..style.display = 'none'
            ..click();
                            }),
                            IconButton(
                            icon :const Icon(Icons.arrow_forward),
                            onPressed: () async{
            if(currentFra<results["frames"].keys.length-1){
              currentFra+=1;
            }
            else {
              currentFra=0;
            }
            String first=results["frames"].keys.elementAt(currentFra);
            gameSize=Size(results["frames"][first]["sourceSize"]["w"].toDouble(),
            results["frames"][first]["sourceSize"]["h"].toDouble());

            setState(() {
              
            });
                            })])]) ): const SizedBox(),
              ]))
                    ]),
        MyHUD(context.widget.key),
      ])
    );
  }
}

Future<void> loadAssets() async {
  if(fromPicker!=null && addedImage && addedJson){
    currentFra=0;
  allAssets["Alls"] = await loadImage1(fromPicker!);
  String first=results["frames"].keys.elementAt(currentFra);

  gameSize=Size(results["frames"][first]["sourceSize"]["w"].toDouble(),
  results["frames"][first]["sourceSize"]["h"].toDouble());

  streamController.add("LOADED");
  }
  return;
}

Future<my_ui.Image> loadImage1(Uint8List imagepath) async {
  var codec = await my_ui.instantiateImageCodec(imagepath);
  var frame = await codec.getNextFrame();
  return frame.image;
}

class MyPaintOne extends CustomPainter {
  bool once=false;
  MyPaintOne(this.minut){
    _paint.color=Colors.white;
    _paint.isAntiAlias=false;
    _paint.filterQuality=FilterQuality.low;
  }

  final double minut;
  final Paint _paint = Paint();

  @override
  void paint(Canvas canvas, Size size) {

    if (assetsLoading == false) {
      String first=results["frames"].keys.elementAt(currentFra);
      
      if(results["frames"][first]["rotated"]==false){
      canvas.drawImageRect (allAssets["Alls"],
      Rect.fromLTWH(results["frames"][first]["frame"]["x"].toDouble(),
      results["frames"][first]["frame"]["y"].toDouble(),
      results["frames"][first]["frame"]["w"].toDouble(),
      results["frames"][first]["frame"]["h"].toDouble()),
      Rect.fromLTWH(results["frames"][first]["spriteSourceSize"]["x"].toDouble(),
      results["frames"][first]["spriteSourceSize"]["y"].toDouble(),
      results["frames"][first]["spriteSourceSize"]["w"].toDouble(),
      results["frames"][first]["spriteSourceSize"]["h"].toDouble()), _paint);
      }
      else {

      canvas.drawImageRect (allAssets["Alls"],
      Rect.fromLTWH(results["frames"][first]["frame"]["x"].toDouble(),
      results["frames"][first]["frame"]["y"].toDouble(),
      results["frames"][first]["frame"]["h"].toDouble(),
      results["frames"][first]["frame"]["w"].toDouble()),
      Rect.fromLTWH(results["frames"][first]["spriteSourceSize"]["x"].toDouble(),
      results["frames"][first]["spriteSourceSize"]["y"].toDouble(),
      results["frames"][first]["spriteSourceSize"]["w"].toDouble(),
      results["frames"][first]["spriteSourceSize"]["h"].toDouble()), _paint);

      canvas.restore();
      }

      stage.checkChildren(canvas, size);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}