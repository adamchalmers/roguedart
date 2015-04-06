import "actor.dart";

abstract class Action {
  void execute(Actor a);
}

class Left extends Action {
  void execute(Actor a) {
    a.x--;
  }
}