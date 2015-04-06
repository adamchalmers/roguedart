import 'dart:html';
import 'level.dart';
import 'utils.dart';
import 'entities.dart';
import '../packages/unittest/unittest.dart';

CanvasRenderingContext2D ctx;
CanvasElement canvas;
const CANVAS_WIDTH = 1800;
const CANVAS_HEIGHT = 1000;

void main() {
  canvas = querySelector("#canvas") as CanvasElement;
  canvas.width = CANVAS_WIDTH;
  canvas.height = CANVAS_HEIGHT;
  ctx = canvas.context2D;
  var data = {
    "stoneImg": new ImageElement(src: "img/cobblestone.png"),
    "clothImg": new ImageElement(src: "img/stone.png"),
    "tileImg": new ImageElement(src: "img/stonebits.png")
  };
  makeLevel(data);
}

void makeLevel(dynamic data) {
  Level level = new Level(57, 31, ctx);
  level.fill();
  level.draw(data);
  Player player = new Player();
  player.x = 0;
  player.y = 0;
  player.draw(ctx);
}