import 'dart:html';
import 'class_level.dart';
import 'utils.dart';
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
    "stoneImg": new ImageElement(src: "img/stone.jpg"),
    "clothImg": new ImageElement(src: "img/cloth.jpg"),
    "tileImg": new ImageElement(src: "img/tile.jpg")
  };
  makeLevel(data);
}

void makeLevel(dynamic data) {
  Level level = new Level(57, 31, ctx);
  level.placeRooms(40, 400);
  level.placeCorridors(10, 2000);
  level.merge();
  level.draw(data);
}