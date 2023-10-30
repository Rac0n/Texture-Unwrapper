// ignore_for_file: prefer_typing_uninitialized_variables

import 'dart:math';
import 'dart:ui' as my_ui;
import 'package:flutter/material.dart';

class Stage {
  double x = 0;
  double y = 0;
  double angle = 0;
  double scaleX = 1;
  double scaleY = 1;
  double globalX = 0;
  double globalY = 0;
  double globalAngle = 0;
  double globalScaleX = 1;
  double globalScaleY = 1;

  int type = 2;

  var children = [];
  var toRemove=[];

  checkChildren(Canvas canvas, Size size) {
    for (var i = 0; i < children.length; i++) {
      if(children[i].toBeRemoved==false){
      if (children[i].type < 2) {
        children[i].preUpdate();

        children[i].centerCanvas(canvas, size);
      } else {
        children[i].checkChildren(canvas, size);
      }
    }
    }

    for(var j=0; j< toRemove.length; j++){
      children.remove(toRemove[j]);
    }
    toRemove=[];
  }

  addChild(cc) {
    children.add(cc);
    cc.parent = this;
  }

  removeChild(cc) {
    cc.toBeRemoved=true;
    toRemove.add(cc);
    cc.destroy();
  }
}

class Group {
  double x = 0;
  double y = 0;
  double angle = 0;
  double scaleX = 1;
  double scaleY = 1;
  double globalX = 0;
  double globalY = 0;
  double globalAngle = 0;
  double globalScaleX = 1;
  double globalScaleY = 1;
  var parent;

  int type = 2;

  var children = [];
  var toRemove=[];
  bool toBeRemoved=false;

  checkChildren(Canvas canvas, Size size) {
    double ang = atan2(y, x);
    double sum = sqrt(x * x + y * y);

    globalX =
        sum * parent.globalScaleX * cos(ang + parent.globalAngle * pi / 180) +
            parent.globalX;
    globalY =
        sum * parent.globalScaleY * sin(ang + parent.globalAngle * pi / 180) +
            parent.globalY;
    globalScaleX = scaleX * parent.globalScaleX;
    globalScaleY = scaleY * parent.globalScaleY;
    globalAngle = angle + parent.globalAngle;

    for (var i = 0; i < children.length; i++) {
    if(toBeRemoved==false){
      if (children[i].type < 2) {
        children[i].preUpdate();

        children[i].centerCanvas(canvas, size);
      } else {
        children[i].checkChildren(canvas, size);
      }
    }
    }

    for(var j=0; j< toRemove.length; j++){
      children.remove(toRemove[j]);
    }
    toRemove=[];
  }

  addChild(cc) {
    children.add(cc);
    cc.parent = this;
  }

  removeChild(cc) {
    cc.toBeRemoved=true;
    toRemove.add(cc);
    cc.destroy();
  }

  destroy(){
    for (var i = 0; i < children.length; i++) {
      children[i].destroy();
    }
  }
}


class Graphic {
  Paint painting = Paint();
  double x = 0;
  double y = 0;
  double angle = 0;
  double scaleX = 1;
  double scaleY = 1;
  double globalX = 0;
  double globalY = 0;
  bool toBeRemoved=false;
  double globalScaleX = 1;
  double globalScaleY = 1;
  double globalAngle = 0;
  var parent;

  int type = 0;

  centerCanvas(Canvas canvas, Size size) {
    if(toBeRemoved==false){
    double ang = atan2(y, x);
    double sum = sqrt(x * x + y * y);

    globalX =
        sum * parent.globalScaleX * cos(ang + parent.globalAngle * pi / 180) +
            parent.globalX;
    globalY =
        sum * parent.globalScaleY * sin(ang + parent.globalAngle * pi / 180) +
            parent.globalY;
    globalScaleX = scaleX * parent.globalScaleX;
    globalScaleY = scaleY * parent.globalScaleY;
    globalAngle = angle + parent.globalAngle;

    canvas.save();
    canvas.translate(globalX, globalY);
    canvas.rotate(globalAngle * pi / 180);
    canvas.scale(globalScaleX, globalScaleY);

    paint(canvas, size);

    canvas.restore();
    }
  }

  preUpdate(){
    if(toBeRemoved==false){
      update();
    }
  }

  paint(Canvas canvas, Size size) {}

  destroy() {}

  update() {}
}

class Sprite {
  Paint painting = Paint();
  double x = 0;
  double y = 0;
  bool toBeRemoved=false;
  double angle = 0;
  double scaleX = 1;
  double scaleY = 1;
  double globalX = 0;
  double globalY = 0;
  double globalScaleX = 1;
  double globalScaleY = 1;
  double globalAngle = 0;
  var parent;

  int type = 1;

  late my_ui.Image currentImage;

  double pivotX = 0;
  double pivotY = 0;

  centerCanvas(Canvas canvas, Size size) {
    if(toBeRemoved==false){
    double ang = atan2(y, x);
    double sum = sqrt(x * x + y * y);

    globalX =
        sum * parent.globalScaleX * cos(ang + parent.globalAngle * pi / 180) +
            parent.globalX;
    globalY =
        sum * parent.globalScaleY * sin(ang + parent.globalAngle * pi / 180) +
            parent.globalY;
    globalScaleX = scaleX * parent.globalScaleX;
    globalScaleY = scaleY * parent.globalScaleY;
    globalAngle = angle + parent.globalAngle;

    canvas.save();
    canvas.translate(globalX, globalY);
    canvas.rotate(globalAngle * pi / 180);
    canvas.scale(globalScaleX, globalScaleY);
    canvas.translate(
        -currentImage.width * pivotX, -currentImage.height * pivotY);
    paint(canvas, size);
    canvas.drawImage(currentImage, const Offset(0.0, 0.0), painting);

    canvas.restore();
    }
  }

  paint(Canvas canvas, Size size) {}

  preUpdate(){
    if(toBeRemoved==false) {
      update();
    }
  }

  destroy() {}

  update() {}
}