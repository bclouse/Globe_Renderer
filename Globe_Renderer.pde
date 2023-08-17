import nervoussystem.obj.*;

PVector angle;
CubeSphere cube;
GlobeSphere globe;
int res = 500;
int axis = -3;
PImage [][][] renderStrips;
int globeWidth = 1800;
int globeHeight = 900;
PImage flatMap;
PImage[] cubeMap;
float angleStep = 0.01;
int sphereRadius = 200;
boolean cubeOrGlobe = false;
boolean renderImages = false;
boolean saveOBJ = false;
float HEIGHT_MAP_RATIO = 10.0/255;
float sampleRadius = 1;
float maxLevel = 25;
float waterLevel = 13;
float offset = 99999;

void setup() {
  size(1000, 1000, P3D);
  angle = new PVector(0, -PI/2, PI/4);
  cube = new CubeSphere(sphereRadius, res);
  cubeMap = new PImage[6];
  cube.loadPictures("Faces\\face_", ".png");
  cubeMap = new PImage[6];

  //if (saveOBJ) {
  //  cube.updateHeightMap();
  //} else {
  //  res = 50;
  //  cube.setResolution(res);
  //}


  globe = new GlobeSphere(sphereRadius, globeWidth, globeHeight);
  globe.loadPicture("Faces\\Flat Map.png");
  globe.rotateGlobe(2, -PI/4);


  //if (saveOBJ) {
  //globe.updateHeightMap();
  //} else {
  //  globeWidth = 90;
  //  globeHeight = 45;
  //  globe.setSize(globeWidth, globeHeight);
  //  globe.rotateGlobe(2, -PI/4);
  //}
  //CubeSphere cubesphere = new CubeSphere(sphereRadius, 10);
  //GlobeSphere globesphere = new GlobeSphere(sphereRadius, 18, 9);

  Converter convert = new Converter(cube, globe);
  noiseSeed(1);
  noiseDetail(13, 0.5);
  updateGlobe();
  convert.convert();
  
}

void draw() {
  //exit();
  background(25);

  //if (!saveOBJ) {
  translate(width/2, height/2);
  rotateX(angle.x);
  rotateY(angle.y);
  if (cubeOrGlobe) {
    rotateZ(-PI/4 + angle.z);
  } else {
    rotateZ(angle.z);
  }

  fill(0);
  noStroke();
  //stroke(100);
  //} else {
  //  beginRecord("nervoussystem.obj.OBJExport", "globe.obj");
  //}
  ////noStroke();

  if (cubeOrGlobe) {
    if (renderImages && !saveOBJ) {
      noStroke();
      cube.renderImages();
    } else {
      cube.renderShape(false);
    }
  } else {
    if (renderImages && !saveOBJ) {
      noStroke();
      globe.renderImage();
    } else {
      globe.renderShape();
    }
  }

  noStroke();
  fill(0, 0, 200);
  sphere(sphereRadius+waterLevel);

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

  //if (saveOBJ) {
  //  endRecord();
  //  saveOBJ = false;
  //  //if (cubeOrGlobe) {
  //  res = 50;
  //  cube.setResolution(res);
  //  //} else {
  //  globeWidth = 90;
  //  globeHeight = 45;
  //  globe.setSize(globeWidth, globeHeight);
  //  globe.rotateGlobe(2, -PI/4);
  //  //}
  //}
  exit();
}

void updateGlobe() {
  float scale = sampleRadius/sphereRadius;
  flatMap = createImage(globeWidth, globeHeight, RGB);
  //int index = 0;

  loadPixels2D(flatMap);
  for (int y = 0; y < globe.flatHeight; y++) {
    for (int x = 0; x < globe.flatWidth; x++) {
      globe.vertices[x][y].value = maxLevel*noise(globe.vertices[x][y].x*scale+offset, globe.vertices[x][y].y*scale+offset, globe.vertices[x][y].z*scale+offset);
      if (globe.vertices[x][y].value >= waterLevel-2) {
        globe.vertices[x][y].setMagnitude(sphereRadius + globe.vertices[x][y].value);
      } else {
        globe.vertices[x][y].value = 0;
        globe.vertices[x][y].setMagnitude(sphereRadius);
      }
      pixels2D[x][y] = color(globe.vertices[x][y].value * 10);
    }
  }
  updatePixels2D(flatMap);
  flatMap.save("Testing\\test.png");
}

void mouseReleased() {
  if (axis < 2 && axis >= 0) {
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
      cube.setResolution(res);
    } else {
      globeHeight++;
      globe = new GlobeSphere(sphereRadius, globeWidth, globeHeight);
      globe.rotateGlobe(2, -PI/4);
    }
    break;
  case DOWN:
    if (cubeOrGlobe) {
      res--;
      cube.setResolution(res);
    } else {
      globeHeight--;
      globe = new GlobeSphere(sphereRadius, globeWidth, globeHeight);
      globe.rotateGlobe(2, -PI/4);
    }
    break;
  case LEFT:
    if (!cubeOrGlobe) {
      globeWidth--;
      globe = new GlobeSphere(sphereRadius, globeWidth, globeHeight);
      globe.rotateGlobe(2, -PI/4);
    }
    break;
  case RIGHT:
    if (!cubeOrGlobe) {
      globeWidth++;
      globe = new GlobeSphere(sphereRadius, globeWidth, globeHeight);
      globe.rotateGlobe(2, -PI/4);
    }
    break;
  }
  switch(key) {
  case ' ':
    cubeOrGlobe = !cubeOrGlobe;
    break;
  case '\n':
    if (axis >= 0) {
      axis -= 3;
    } else {
      axis += 3;
    }
    break;
  case 'w':
    waterLevel++;
    println("Water Level: "+waterLevel);
    break;
  case 's':
    waterLevel--;
    println("Water Level: "+waterLevel);
    break;
  case 'a':
    sampleRadius -= 0.25;
    updateGlobe();
    println("Sample Radius: "+sampleRadius);
    break;
  case 'd':
    sampleRadius += 0.25;
    updateGlobe();
    println("Sample Radius: "+sampleRadius);
    break;
  }
}
