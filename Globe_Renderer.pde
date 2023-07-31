SphereVector sv;

void setup() {
  sv = new SphereVector(5, 5, 5, CARTESIAN);
  sv.printCoords();
  
  for (int i = 0; i < 8; i++) {
    sv.rotateY(PI/4);
    
    //println((i+1)*PI/4);
    sv.printCoords();
  }
}

void draw() {
  exit();
}
