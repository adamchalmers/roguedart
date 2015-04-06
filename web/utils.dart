import 'dart:math';

List shuffle(List items) {
  var random = new Random();

  // Go through all elements.
  for (var i = items.length - 1; i > 0; i--) {

    // Pick a pseudorandom number according to the list length
    var n = random.nextInt(i + 1);

    var temp = items[i];
    items[i] = items[n];
    items[n] = temp;
  }

  return items;
}

class Merges {
  Map<int, int> merges = new Map<int, int>();
  
  Merges(int n) {
    for (int i = 1; i <= n; i++) {
      merges[i] = i;
    }
  }
  
  // Merge regions number a and b.
  merge(int a, int b) {
    // Any region that used to point to a or b will now point to smaller
    int smaller = min(a,b);
    merges.forEach((k, v) {
      if (v == merges[a] || v == merges[b]) {
        merges[k] = smaller;
      }
    });
  }
}

class Point {
  int x, y;
  Point(_x, _y) { x = _x; y = _y;}
  bool operator ==(other) {
    if (other is! Point) return false;
    Point point = other;
    return (point.x == x && point.y == y);
  }
  int get hashCode {
    int result = 17;
    result = 37*result + x.hashCode;
    result = 37*result + y.hashCode;
    return result;
  }
  String toString() => "($x,$y)";
}
Pt(int x, int y) { return new Point(x,y);}