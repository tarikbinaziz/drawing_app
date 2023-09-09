import 'dart:ui';

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var selectedColor = Colors.black;
  var strockWidth = 5;
  List<DrawingPoint?> drawingPoint = [];
  List<Color> myColor = [
    Colors.pink,
    Colors.blueAccent,
    Colors.black,
    Colors.red,
    Colors.yellow,
    Colors.green,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomAppBar(
        child: Container(
            color: Colors.grey,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: List.generate(
                    myColor.length, (index) => pickColor(myColor[index])),
              ),
            )),
      ),

      body: Stack(
        children: [
          GestureDetector(
            onPanStart: (details) {
              setState(() {
                drawingPoint.add(
                  DrawingPoint(
                    details.localPosition,
                    Paint()
                      ..color = selectedColor
                      ..isAntiAlias = true
                      ..strokeWidth = strockWidth.toDouble()
                      ..strokeCap = StrokeCap.round,
                  ),
                );
              });
            },
            onPanUpdate: (details) {
              setState(() {
                drawingPoint.add(
                  DrawingPoint(
                    details.localPosition,
                    Paint()
                      ..color = selectedColor
                      ..isAntiAlias = true
                      ..strokeWidth = strockWidth.toDouble()
                      ..strokeCap = StrokeCap.round,
                  ),
                );
              });
            },
            onPanEnd: (details){
              setState(() {
                drawingPoint.add(null);
              });
            },
            child: Container(
              color: Colors.white70,
              height: MediaQuery.sizeOf(context).height,
              width: MediaQuery.sizeOf(context).width,
              child: CustomPaint(
                painter: LinearPainter(drawingPoint),
              ),
            ),
          ),
          Positioned(
            top: 40,
            right: 30,
            child: Row(
              children: [
                Slider(
                    value: strockWidth.toDouble(), onChanged: (val){
                  setState(() {
                    strockWidth=val.toInt();
                  });
                },

                max: 40,
                  min: 0,
                ),
                ElevatedButton.icon(onPressed: (){
                  setState(() {
                    drawingPoint=[];
                  });
                }, icon: Icon(Icons.clear),
                label: Text("clear board"),
        ),
              ],
            ),
          )
        ],
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  GestureDetector pickColor(color) {
    bool isSelected = selectedColor == color;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedColor = color;
        });
      },
      child: Container(
        height: isSelected ? 50 : 40,
        width: isSelected ? 50 : 40,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color,
          border: isSelected ? Border.all(color: Colors.white, width: 3) : null,
        ),
      ),
    );
  }
}

class LinearPainter extends CustomPainter {
  final List<DrawingPoint?> drawingPoint;
   LinearPainter(this.drawingPoint);
   List<Offset>offsetList=[];
  @override
  void paint(Canvas canvas, Size size) {

    for(int i=0;i<drawingPoint.length-1;i++){
      if(drawingPoint[i]!= null&& drawingPoint[i+1]!= null ){
        canvas.drawLine(drawingPoint[i]!.offset,drawingPoint[i+1]!.offset,drawingPoint[i]!.paint);
      } else if(drawingPoint[i]!= null&& drawingPoint[i+1]!= null){
       offsetList.clear();
       offsetList.add(drawingPoint[i]!.offset);
       canvas.drawPoints(PointMode.points, offsetList, drawingPoint[i]!.paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class DrawingPoint {
  Offset offset;
  Paint paint;

  DrawingPoint(this.offset, this.paint);
}
