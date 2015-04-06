import "level_layout.dart";
import 'actor.dart';
import "dart:html";

class Level {
  LevelLayout _layout;
  List<Actor> _actors;
  Player _player;

  var data = {
    "stoneImg": new ImageElement(src: "img/cobblestone.png"),
    "clothImg": new ImageElement(src: "img/stone.png"),
    "tileImg": new ImageElement(src: "img/stonebits.png")
  };
  
  Level(LevelLayout layout, List<Actor> actors) {
    _layout = layout;
    _layout.fill();
    _actors = actors;
    _player = new Player();
    _player.x = 0;
    _player.y = 0;
  }
  
  void draw(CanvasRenderingContext2D ctx) {
    _layout.draw(data);
    _player.draw(ctx);
    _actors.forEach((actor) => actor.draw(ctx));
  }
}