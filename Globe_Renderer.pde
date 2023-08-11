PVector angle;
CubeSphere cs;
GlobeSphere gs;
int res = 50;
int axis = 0;
PImage [][][] renderStrips;
int globeWidth = 180;
int globeHeight = 90;
boolean cubeOrGlobe = true;
PImage flatMap;
PImage[] cubeMap;
float angleStep = 0.01;
int sphereRadius = 200;

void setup() {
  size(1000, 1000, P3D);
  angle = new PVector(0, 0, 0);
  cs = new CubeSphere(sphereRadius, res);
  cubeMap = new PImage[6];
  cs.loadPictures("Faces\\face_", ".png");


  gs = new GlobeSphere(sphereRadius, globeWidth, globeHeight);
  gs.loadPicture("Faces\\Flat Map.png");
  
}

void draw() {
  background(25);
  translate(width/2, height/2);
  rotateX(angle.x);
  rotateY(angle.y);
  rotateZ(angle.z);

  fill(25);
  stroke(100);
  //noStroke();

  if (cubeOrGlobe) {
    //cs.renderShape(false);
    noStroke();
    cs.renderImages();
  } else {
    noStroke();
    gs.renderImage();
  }
  switch (axis) {
  case 0:
    angle.x += angleStep;
    break;
  case 1:
    angle.y += angleStep;
    break;
  case 2:
    angle.z += angleStep;
    break;
  }
  //exit();
}

void mouseReleased() {
  if (axis < 2) {
    axis++;
  } else {
    axis = 0;
  }
}

void keyReleased() {
  switch (keyCode) {
  case UP:
    if (cubeOrGlobe) {
      res++;
      cs = new CubeSphere(sphereRadius, res);
    } else {
      globeHeight++;
      gs = new GlobeSphere(sphereRadius, globeWidth, globeHeight);
    }
    break;
  case DOWN:
    if (cubeOrGlobe) {
      res--;
      cs = new CubeSphere(sphereRadius, res);
    } else {
      globeHeight--;
      gs = new GlobeSphere(sphereRadius, globeWidth, globeHeight);
    }
    break;
  case LEFT:
    if (!cubeOrGlobe) {
      globeWidth--;
      gs = new GlobeSphere(sphereRadius, globeWidth, globeHeight);
    }
    break;
  case RIGHT:
    if (!cubeOrGlobe) {
      globeWidth++;
      gs = new GlobeSphere(sphereRadius, globeWidth, globeHeight);
    }
    break;
  }
  switch(key) {
  case ' ':
    cubeOrGlobe = !cubeOrGlobe;
    break;
  case '\n':
    axis = -axis;
    break;
  }
}
