library level;

import 'dart:core';
import 'dart:html';
import 'dart:math';
import 'utils.dart';


const TILE_LENGTH = 30;
const TILE_BORDER = 1;

class Level {
  int w, h, currRegions;
  List<List<Room>> grid;
  List region;
  CanvasRenderingContext2D ctx;
  Map<Point, Set<int>> connectors;
  
  Level(int _w, int _h, _ctx) {
    ctx = _ctx;
    this.w = _w;
    this.h = _h;
    grid = new List<List<Room>>();
    region = new List<List<int>>();
    for (int i = 0; i < max(w,h); i++) {
      grid.add(new List<Room>());
      region.add(new List<int>());
      for (int j = 0; j < max(w,h); j++) {
        grid[i].add(Room.EMPTY);
        region[i].add(0);
      }
    }
  }
  
  void fill() {
    placeRooms(40, 400);
    placeCorridors(10, 2000);
    merge();
  }
  
  draw(dynamic data) {
    ctx.fillStyle = "#000";
    ctx.fillRect(0, 0, w*TILE_LENGTH + TILE_BORDER, h*TILE_LENGTH + TILE_BORDER);
    for (int i = 0; i < w; i++) {
      for (int j = 0; j < h; j++) {
        ctx.fillStyle = grid[i][j].color;
        if (grid[i][j] == Room.CORRIDOR) {
          ctx.drawImage(data["stoneImg"], i*TILE_LENGTH + TILE_BORDER, j*TILE_LENGTH + TILE_BORDER);
        } else if (grid[i][j] == Room.ROOM) {
          ctx.drawImage(data["tileImg"], i*TILE_LENGTH + TILE_BORDER, j*TILE_LENGTH + TILE_BORDER);
        } else if (grid[i][j] == Room.DOOR) {
          ctx.drawImage(data["clothImg"], i*TILE_LENGTH + TILE_BORDER, j*TILE_LENGTH + TILE_BORDER);
        } else {
          ctx.fillRect(
              i*TILE_LENGTH + TILE_BORDER, 
              j*TILE_LENGTH + TILE_BORDER, 
              TILE_LENGTH - TILE_BORDER, 
              TILE_LENGTH - TILE_BORDER);
        }
        
        
//        // Print a room's region
//        if (region[i][j] > 0) {
//          ctx.fillStyle = "blue";
//          ctx.font = "bold 16px Arial";
//          ctx.fillText(
//              region[i][j].toString(), 
//              i*TILE_LENGTH, 
//              (j+1)*TILE_LENGTH);
//        } else if (connectors.containsKey(Pt(i,j))){
//          // Print the empty cell neighbours
//          ctx.fillStyle = "white";
//          ctx.font = "14px Arial";
//          ctx.fillText(
//              connectors[Pt(i,j)].toString().substring(1, connectors[Pt(i,j)].toString().length-1).replaceAll(" ", ""), 
//              i*TILE_LENGTH, 
//              (j+1)*TILE_LENGTH);
//        }
      }
    }
  }
  
  List<Point> neighbours(Point p) {
    List<Point> out = new List<Point>();
    if (p.x - 1 >= 0) out.add(Pt(p.x-1, p.y));
    if (p.x + 1 < w) out.add(Pt(p.x+1, p.y));
    if (p.y - 1 >= 0) out.add(Pt(p.x, p.y-1));
    if (p.y + 1 < h) out.add(Pt(p.x, p.y+1));
    return out;
  }
  
  placeCorridors(int corridors, int maxTries) {
    for (int i = 0; i < corridors; i++) {
      placeCorridor(maxTries);
      currRegions ++;
    }
  }
  
  placeCorridor(int maxTries) {
    
    // Initialize data structures
    var random = new Random();
    List q = new List<Point>();
    Set<Point> seen = new Set<Point>();
    Map<Point, Point> parents = new Map<Point, Point>();
    
    // Start the DFS on an empty, odd-aligned space.
    Point start = Pt(0,0);
    int tries = 0;
    while (grid[start.x][start.y] != Room.EMPTY || start.x % 2 == 0 || start.y %2 == 0) {
      start = Pt(random.nextInt(w), random.nextInt(w));
      if (tries++ > maxTries) return;
    }
    parents[start] = start;
    q.add(start);
    
    // DFS loop
    while (q.isNotEmpty) {
      Point curr = q.removeAt(q.length-1);
      if (seen.contains(curr)) {
        continue;
      }
      seen.add(curr);
      List<Point> toAdd = new List<Point>();
      
      // Check each cardinal direction for valid neighbours.
      if (curr.x - 2 >= 0) {
        toAdd.add(Pt(curr.x-2, curr.y));
        parents[Pt(curr.x-2, curr.y)] = Pt(curr.x-1, curr.y);
      }
      if (curr.x + 2 < w) {
        toAdd.add(Pt(curr.x+2, curr.y));
        parents[Pt(curr.x+2, curr.y)] = Pt(curr.x+1, curr.y);
      }
      if (curr.y - 2 >= 0) {
        toAdd.add(Pt(curr.x, curr.y-2));
        parents[Pt(curr.x, curr.y-2)] = Pt(curr.x, curr.y-1);
      }
      if (curr.y + 2 < h) {
        toAdd.add(Pt(curr.x, curr.y+2));
        parents[Pt(curr.x, curr.y+2)] = Pt(curr.x, curr.y+1);
      }
      
      // Eliminate rooms that aren't empty
      List<Point> emptyRooms = [];
      for (var i = 0; i < toAdd.length; i++) {
        if (grid[toAdd[i].x][toAdd[i].y] == Room.EMPTY) {
          emptyRooms.add(toAdd[i]);
        }
      }
      
      // Set this grid space to be a room.
      grid[curr.x][curr.y] = Room.CORRIDOR;
      grid[parents[curr].x][parents[curr].y] = Room.CORRIDOR;
      region[curr.x][curr.y] = currRegions;
      region[parents[curr].x][parents[curr].y] = currRegions;
      q.addAll(shuffle(emptyRooms));
    }
  }
  
  void placeRooms(int maxRooms, int maxTries) {
    var random = new Random();
    var maxSize = 8;
    int rooms = 0;
    int tries = 0;
    while (rooms < maxRooms && tries < maxTries) {
      
      // Choose an odd square for the room's top-left corner.
      int x = -1, y = -1;
      while (x < 0) x = 2*random.nextInt(this.w~/2) - 1;
      while (y < 0) y = 2*random.nextInt(this.h~/2) - 1;
      // Choose an even width and height.
      var mx = 2*(min(x+random.nextInt(maxSize-2)+2, this.w)~/2);
      var my = 2*(min(y+random.nextInt(maxSize-2)+2, this.h)~/2);
      if (mx-x <2 || my-y<2) continue;
      
      // Loop over each cell in the potential room
      bool validRoom = true;
      for (int i = x; i < mx; i++) {
        for (int j = y; j < my; j++) {
          // If the square is empty, fill it in.
          if (grid[i][j] == Room.ROOM) {
            validRoom = false;
          } 
        }
      }
      
      // If it's invalid, increment tries and try again.
      if (!validRoom) {
        tries ++;
      } else {
        rooms ++;
        // If it's valid, make the room.
        for (int i = x; i < mx; i++) {
          for (int j = y; j < my; j++) {
            grid[i][j] = Room.ROOM;
            region[i][j] = rooms;
          }
        }
      }//end if

    }//wend
    currRegions = rooms;
  }
  
  void merge() {
    // Maps a region to the lowest-number region it's merged with
    Merges regions = new Merges(currRegions);
    // Maps connector cells to the set of their neighbouring regions.
    connectors = new Map<Point, Set<int>>();
    
    // Find every connector and which regions it connects.
    for (int i = 0; i < w; i++) {
      for (int j = 0; j < h; j++) {
        // Add if it's empty and has two nonempty neighbours
        if (grid[i][j] == Room.EMPTY) {
          Set neighbourRegions = new Set();
          if (i+1 < w && grid[i+1][j] != Room.EMPTY) {
            neighbourRegions.add(region[i+1][j]);
          }
          if (i-1 > 0 && grid[i-1][j] != Room.EMPTY) {
            neighbourRegions.add(region[i-1][j]);
          }
          if (j+1 < h && grid[i][j+1] != Room.EMPTY) {
            neighbourRegions.add(region[i][j+1]);
          }
          if (j-1 > 0 && grid[i][j-1] != Room.EMPTY) {
            neighbourRegions.add(region[i][j-1]);
          }
          if (neighbourRegions.length >= 2) {
            connectors[Pt(i,j)] = neighbourRegions;
          }
        }
      }
    }
    
    // Choose a random connector
    Random rnd = new Random();
    while (connectors.isNotEmpty) {
      Point cell = connectors.keys.elementAt(rnd.nextInt(connectors.length));
      int r1 = connectors[cell].elementAt(0);
      int r2 = connectors[cell].elementAt(1);
      // Make it a corridor
      regions.merge(r1, r2);
      grid[cell.x][cell.y] = Room.DOOR;
      region[cell.x][cell.y] = regions.merges[r1];
      // Remove all connectors that would have joined those two regions.
      Map newConnectors = new Map<Point, Set<int>>();
      connectors.forEach((pt, regions) {
        if (!regions.contains(r1) || !regions.contains(r2)) {
          newConnectors[pt] = regions;
        }
      });
      connectors = newConnectors;
    }
  }
}

class Room {
  
  static final Room ROOM = new Room("#ffa", "ROOM");
  static final Room EMPTY = new Room("#444", "EMPTY");
  static final Room CORRIDOR = new Room("#79f", "CORRIDOR");
  static final Room DOOR = new Room("#f7c", "DOOR");
  
  String color;
  String name;
  Room(String c, String n) {
    color = c;
    name = n;
  }
  String toString() => name;
}
