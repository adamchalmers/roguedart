import 'dart:html';
import 'level_layout.dart';
import 'level.dart';
import 'utils.dart';
import 'actor.dart';
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
  makeLevel();
}

void makeLevel() {
  Level level = new Level(new LevelLayout(57, 31, ctx), [new Enemy()..x=4..y=4]);
  level.draw(ctx);
  loop(level);
}

void loop(Level level) {
  
}