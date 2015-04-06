import 'dart:html';
import 'class_level.dart';
import 'utils.dart';
import '../packages/unittest/unittest.dart';

CanvasRenderingContext2D ctx;
CanvasElement canvas;
const CANVAS_WIDTH = 1500;
const CANVAS_HEIGHT = 700;

void main() {
  tests();
  canvas = querySelector("#canvas") as CanvasElement;
  canvas.width = CANVAS_WIDTH;
  canvas.height = CANVAS_HEIGHT;
  ctx = canvas.context2D;
  
  Level level = new Level(21, 21, ctx);
  level.placeRooms(20, 400);
  level.placeCorridors();
  level.merge();
  level.draw();
  
  Merges m = new Merges(4);
  print(m.merges);
  m.merge(1,2);
  m.merge(3,4);
  print(m.merges);
  m.merge(1,3);
  print(m.merges);
  
}

void tests() {
  test("PointEquals", () => expect(true, Pt(0,0) == Pt(0,0)));
  test("PointSets", () => () {
    Set s = new Set();
    s.add(Pt(0,0));
    expect(true, s.contains(Pt(0,0)));
  });
}