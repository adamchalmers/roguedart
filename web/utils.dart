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
      if (v == a || v == b) {
        merges[k] = smaller;
      }
    });
  }
}