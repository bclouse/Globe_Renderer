PVector angle;
CubeSphere cs;
int res = 10;
int axis = 0;

void setup() {
  size(500, 500, P3D);
  cs = new CubeSphere(150, res);
  angle = new PVector(0,0,0);
  //sv = new SphereVector(5, 5, 5, CARTESIAN);
  //sv.printCoords();

  //for (int i = 0; i < 8; i++) {
  //  sv.rotateY(PI/4);

  //  //println((i+1)*PI/4);
  //  sv.printCoords();
  //}
}

void draw() {
  background(0);
  translate(width/2, height/2);
  rotateX(angle.x);
  rotateY(angle.y);
  rotateZ(angle.z);
  
  fill(0);
  stroke(255);
  
  cs.renderShape();
  switch (axis) {
    case 0: angle.x += 0.01; break;
    case 1: angle.y += 0.01; break;
    case 2: angle.z += 0.01; break;
  }
  //exit();
}

void mouseReleased() {
  res++;
  println(res);
  cs = new CubeSphere(150, res);
}

void keyReleased() {
  if (axis < 2) {
    axis++;
  } else {
    axis = 0;
  }
}
