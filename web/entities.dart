import 'dart:html';
import 'level.dart';

abstract class Entity {
  int x, y;
  ImageElement pic;
  
  void draw(CanvasRenderingContext2D ctx, int x, int y);
}

class Player extends Entity {
  ImageElement pic =  new ImageElement(src: "img/creeper.png");
  
  void draw(CanvasRenderingContext2D ctx) {
    print("Done.");
    ctx.drawImage(pic, x*TILE_LENGTH + TILE_BORDER + pic.width/4, y*TILE_LENGTH + TILE_BORDER + pic.width/4);
  }
}