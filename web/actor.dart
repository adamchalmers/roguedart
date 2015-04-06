import 'dart:html';
import 'level_layout.dart';

abstract class Actor {
  static const speedToMove = 12;
  int x, y;
  int speed;
                          
  ImageElement pic;
  
  void draw(CanvasRenderingContext2D ctx) {
    ctx.drawImage(pic, x*TILE_LENGTH + TILE_BORDER + pic.width/4, y*TILE_LENGTH + TILE_BORDER + pic.width/4);
  }
}

class Player extends Actor {
  ImageElement pic =  new ImageElement(src: "img/smile.gif");
}

class Enemy extends Actor {
  ImageElement pic = new ImageElement(src: "img/creeper.png");
}