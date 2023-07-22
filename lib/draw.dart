// ignore_for_file: constant_identifier_names

import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:hexcolor/hexcolor.dart';

class Draw extends StatefulWidget {
  @override
  State<Draw> createState() => _DrawState();
}

class _DrawState extends State<Draw> {
  Color selectedColor = Colors.white;
  Color pickerColor = Colors.white;
  double strokeWidth = 3.0;
  double opacity = 1.0;
  bool showBottomList = false;
  StrokeCap strokeCap = (Platform.isAndroid) ? StrokeCap.butt : StrokeCap.round;
  SelectedMode selectedMode = SelectedMode.StrokeWidth;
  List<DrawingPoints?> points = [];
  List<Color> colors = [
    Colors.tealAccent,
    Colors.white,
    Colors.red,
    Colors.green,
    Colors.blue,
  ];

  bool brush = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   actions: [
      //     Padding(
      //       padding: const EdgeInsets.all(10.0),
      //       child: IconButton(
      //           onPressed: () {
      //             brush = !brush;
      //           },
      //           icon: const Icon(Icons.brush_outlined,size: 40,color: Colors.white,)),
      //     ),
      //   ],
      // ),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8),
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50), color: Colors.amber),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                        icon: const Icon(Icons.notes),
                        onPressed: () {
                          setState(() {
                            if (selectedMode == SelectedMode.StrokeWidth) {
                              showBottomList = !showBottomList;
                            }
                            selectedMode = SelectedMode.StrokeWidth;
                          });
                        }),
                    IconButton(
                        icon: const Icon(Icons.opacity),
                        onPressed: () {
                          setState(() {
                            if (selectedMode == SelectedMode.Opacity) {
                              showBottomList = !showBottomList;
                            }
                            selectedMode = SelectedMode.Opacity;
                          });
                        }),
                    IconButton(
                        icon: const Icon(Icons.color_lens),
                        onPressed: () {
                          setState(() {
                            if (selectedMode == SelectedMode.Color) {
                              showBottomList = !showBottomList;
                            }
                            selectedMode = SelectedMode.Color;
                          });
                        }),
                    IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          setState(() {
                            showBottomList = false;
                            points.clear();
                          });
                        }),
                  ],
                ),
                Visibility(
                  visible: showBottomList,
                  child: selectedMode == SelectedMode.Color
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: getCircleColors(),
                        )
                      : Slider(
                          activeColor: Colors.black,
                          inactiveColor: Colors.grey,
                          value: selectedMode == SelectedMode.StrokeWidth
                              ? strokeWidth
                              : opacity,
                          max: selectedMode == SelectedMode.StrokeWidth
                              ? 50.0
                              : 1.0,
                          min: 0.0,
                          onChanged: (val) {
                            setState(() {
                              if (selectedMode == SelectedMode.StrokeWidth) {
                                strokeWidth = val;
                              } else {
                                opacity = val;
                              }
                            });
                          }),
                ),
              ],
            ),
          ),
        ),
      ),
      body: GestureDetector(
        onPanUpdate: (details) {
          setState(
            () {
              RenderBox? renderBox = context.findRenderObject() as RenderBox?;
              if (brush) {
                points.add(
                  DrawingPoints(
                      points: renderBox!.globalToLocal(details.globalPosition),
                      paint: Paint()
                        ..strokeCap = strokeCap
                        ..isAntiAlias = true
                        ..color =  HexColor('00028')
                        ..strokeWidth = strokeWidth),
                );
              } else {
                points.add(
                  DrawingPoints(
                      points: renderBox!.globalToLocal(details.globalPosition),
                      paint: Paint()
                        ..strokeCap = strokeCap
                        ..isAntiAlias = true
                        ..color = selectedColor.withOpacity(opacity)
                        ..strokeWidth = strokeWidth),
                );
              }
            },
          );
        },
        onPanStart: (details) {
          setState(() {
            RenderBox renderBox = context.findRenderObject() as RenderBox;
            points.add(DrawingPoints(
                points: renderBox.globalToLocal(details.globalPosition),
                paint: Paint()
                  ..strokeCap = strokeCap
                  ..isAntiAlias = true
                  ..color = selectedColor.withOpacity(opacity)
                  ..strokeWidth = strokeWidth));
          });
        },
        onPanEnd: (details) {
          setState(() {
            points.add(null);
          });
        },
        child: CustomPaint(
          size: Size.infinite,
          painter: DrawingPainter(
            drawPointsList: points,
          ),
        ),
      ),
    );
  }

  List<Widget> getCircleColors() {
    List<Widget> colorsFinished = [];
    colorsFinished = colors.map((color) {
      return GestureDetector(
        onTap: () {
          setState(() {
            selectedColor = color;
          });
        },
        child: CircleAvatar(
          radius: 20,
          backgroundColor: color,
        ),
      );
    }).toList();
    colorsFinished.add(GestureDetector(
      onTap: () {
        showDialog(
          builder: (context) => AlertDialog(
            title: const Text('Pick a color!'),
            content: SingleChildScrollView(
              child: ColorPicker(
                pickerColor: pickerColor,
                onColorChanged: (color) {
                  pickerColor = color;
                },
                showLabel: true,
                pickerAreaHeightPercent: 0.8,
              ),
            ),
            actions: [
              TextButton(
                child: const Text('Got it'),
                onPressed: () {
                  setState(() => selectedColor = pickerColor);
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
          context: context,
        );
      },
      child: CircleAvatar(
        radius: 20,
        child: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: const LinearGradient(
              colors: [Colors.white, Colors.black, Colors.red],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
    ));
    return colorsFinished;
  }
}

//painter logic
class DrawingPainter extends CustomPainter {
  List<dynamic> drawPointsList = [];
  List<Offset> offsetPoints = [];

  DrawingPainter({required this.drawPointsList});

  @override
  void paint(Canvas canvas, Size size) {
    for (int i = 0; i < drawPointsList.length - 1; i++) {
      //to draw line found two point
      if (drawPointsList[i] != null && drawPointsList[i + 1] != null) {
        canvas.drawLine(drawPointsList[i].points, drawPointsList[i + 1].points,
            drawPointsList[i].paint);
      }
      //to draw point not found another points
      else if (drawPointsList[i] != null && drawPointsList[i + 1] == null) {
        offsetPoints.clear();
        offsetPoints.add(drawPointsList[i].points);
        offsetPoints.add(Offset(drawPointsList[i].points.dx + 0.1,
            drawPointsList[i].points.dy + 0.1));
        canvas.drawPoints(
            PointMode.points, offsetPoints, drawPointsList[i].paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

//each point has offset w painter for draw it
class DrawingPoints {
  Paint paint;
  Offset points;

  DrawingPoints({required this.paint, required this.points});
}

//to swap properties of drawer
enum SelectedMode { StrokeWidth, Opacity, Color }
