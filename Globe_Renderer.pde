PVector angle;
CubeSphere cs;
GlobeSphere gs;
int res = 6;
int axis = 0;
PImage [][][] renderStrips;
int globeWidth = 8;
int globeHeight = 5;

void setup() {
  size(500, 500, P3D);
  cs = new CubeSphere(150, res);
  angle = new PVector(0, 0, 0);
  generateImages();
  gs = new GlobeSphere(150, globeWidth, globeHeight);
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

  gs.renderShape();
  //cs.renderShape(false);
  switch (axis) {
  case 0:
    angle.x += 0.01;
    break;
  case 1:
    angle.y += 0.01;
    break;
  case 2:
    angle.z += 0.01;
    break;
  }
  //exit();
}

void generateImages() {
  renderStrips = new PImage[6][res-1][res-1];
  PImage testImage;
  int index = 0;
  int stepX, stepY;



  for (int s = 0; s < 6; s++) {
    testImage = loadImage("Faces\\face_"+s+".png");
    testImage.loadPixels();
    stepX =  testImage.width/(res-1);
    stepY =  testImage.height/(res-1);
    for (int j = 0; j < res-1; j++) {
      for (int i = 0; i < res-1; i++) {
        renderStrips[s][i][j] = createImage(stepX, stepY, RGB);
        renderStrips[s][i][j].loadPixels();
        index = 0;
        for (int y = 0; y < stepY; y++) {
          for (int x = 0; x < stepX; x++) {
            renderStrips[s][i][j].pixels[index] = testImage.pixels[(j*stepY+y)*testImage.width+(i*stepX+x)];
            index++;
          }
        }
        renderStrips[s][i][j].updatePixels();
        if (s == 0) {
          renderStrips[s][i][j].save("Mini Faces\\face_"+j+"_"+i+".png");
        }
      }
    }
  }
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
    globeHeight++;
    gs = new GlobeSphere(150, globeWidth, globeHeight);
    break;
  case DOWN:
    globeHeight--;
    gs = new GlobeSphere(150, globeWidth, globeHeight);
    break;
  case LEFT:
    globeWidth--;
    gs = new GlobeSphere(150, globeWidth, globeHeight);
    break;
  case RIGHT:
    globeWidth++;
    gs = new GlobeSphere(150, globeWidth, globeHeight);
    break;
  }
}
