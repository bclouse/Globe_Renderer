PVector angle;
CubeSphere cs;
GlobeSphere gs;
int res = 5;
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
  //generateImages();
  cs = new CubeSphere(sphereRadius, res);
  cubeMap = new PImage[6];
  cs.loadPictures("Testing\\face_", ".png");


  gs = new GlobeSphere(sphereRadius, globeWidth, globeHeight);
  gs.loadPicture("Faces\\Flat Map.png");
  //sv = new SphereVector(5, 5, 5, CARTESIAN);
  //sv.printCoords();

  //for (int i = 0; i < 8; i++) {
  //  sv.rotateY(PI/4);

  //  //println((i+1)*PI/4);
  //  sv.printCoords();
  //}
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

//void generateImages() {
//  renderStrips = new PImage[6][res-1][res-1];
//  PImage testImage;
//  int index = 0;
//  int stepX, stepY;



//  for (int s = 0; s < 6; s++) {
//    testImage = loadImage("Faces\\face_"+s+".png");
//    testImage.loadPixels();
//    stepX =  testImage.width/(res-1);
//    stepY =  testImage.height/(res-1);
//    for (int j = 0; j < res-1; j++) {
//      for (int i = 0; i < res-1; i++) {
//        renderStrips[s][i][j] = createImage(stepX, stepY, RGB);
//        renderStrips[s][i][j].loadPixels();
//        index = 0;
//        for (int y = 0; y < stepY; y++) {
//          for (int x = 0; x < stepX; x++) {
//            renderStrips[s][i][j].pixels[index] = testImage.pixels[(j*stepY+y)*testImage.width+(i*stepX+x)];
//            index++;
//          }
//        }
//        renderStrips[s][i][j].updatePixels();
//        if (s == 0) {
//          renderStrips[s][i][j].save("Mini Faces\\face_"+j+"_"+i+".png");
//        }
//      }
//    }
//  }
//}

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
    axis = -1;
    break;
  }
}
