import nervoussystem.obj.*;

PVector angle;
CubeSphere cube;
GlobeSphere globe;
int res = 50;
int axis = 0;
PImage [][][] renderStrips;
int globeWidth = 1800;
int globeHeight = 900;
PImage flatMap;
PImage[] cubeMap;
float angleStep = 0.01;
int sphereRadius = 200;
boolean cubeOrGlobe = false;
boolean renderImages = true;
boolean saveOBJ = true;
float HEIGHT_MAP_RATIO = 10.0/255;

void setup() {
  size(1000, 1000, P3D);
  angle = new PVector(0, 0, 0);
  cube = new CubeSphere(sphereRadius, res);
  cubeMap = new PImage[6];
  cube.loadPictures("Faces\\face_", ".png");

  if (saveOBJ) {
    cube.updateHeightMap();
  } else {
    res = 50;
    cube.setResolution(res);
  }


  globe = new GlobeSphere(sphereRadius, globeWidth, globeHeight);
  globe.loadPicture("Faces\\Flat Map.png");
  globe.rotateGlobe(2, -PI/4);


  if (saveOBJ) {
    globe.updateHeightMap();
  } else {
    globeWidth = 90;
    globeHeight = 45;
    globe.setSize(globeWidth, globeHeight);
    globe.rotateGlobe(2, -PI/4);
  }
}

void draw() {
  background(25);

  if (!saveOBJ) {
    translate(width/2, height/2);
    rotateX(angle.x);
    rotateY(angle.y);
    rotateZ(angle.z);

    fill(0);
    stroke(100);
  } else {
    beginRecord("nervoussystem.obj.OBJExport", "globe.obj");
  }
  //noStroke();

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

  if (saveOBJ) {
    endRecord();
    saveOBJ = false;
    //if (cubeOrGlobe) {
    res = 50;
    cube.setResolution(res);
    //} else {
    globeWidth = 90;
    globeHeight = 45;
    globe.setSize(globeWidth, globeHeight);
    globe.rotateGlobe(2, -PI/4);
    //}
  }
  //exit();
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
  }
}
