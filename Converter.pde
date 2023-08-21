class Converter {
  PVector[][][] cube2D;  //The PVector coords map to the location of the pixels
  PVector[][] globe2D;   //The PVector coords map to the location of the pixels
  CubeSphere cs;
  GlobeSphere gs;
  float thetaSpacing;
  float phiSpacing;
  int cRes;

  /*==========================================================
                           Initializers
   ==========================================================*/

  Converter(CubeSphere c, GlobeSphere g) {
    cs = c;
    gs = g;
    thetaSpacing = 2*PI/gs.flatWidth;
    phiSpacing = PI/gs.flatHeight;
    cRes = cs.resolution;
  }

  /*==========================================================
                           Converters
   ==========================================================*/

  void convertGlobe2Cube() {
    getGlobeCoords(false);
    getCubeCoords(true);
    cube2Image();
  }

  void convertCube2Globe() {
    getCubeCoords(false);
    getGlobeCoords(true);
  }

  /*==========================================================
                        Image Saving
   ==========================================================*/

  void cube2Image() {
    for (int s = 0; s < 6; s++) {
      cubeMap[s] = createImage(cRes, cRes, RGB);
      loadPixels2D(cubeMap[s]);
      for (int y = 0; y < cRes; y++) {
        for (int x = 0; x < cRes; x++) {
          pixels2D[x][y] = color(cs.vertices[s][x][y].value);
        }
      }
      updatePixels2D(cubeMap[s]);
      cubeMap[s].save(("Testing\\face_"+s+".png"));
    }
  }

  /*==========================================================
                        Getting Coords
   ==========================================================*/

  void getGlobeCoords(boolean updateValues) {
    globe2D = new PVector[gs.flatWidth][gs.flatHeight];

    for (int i = 0; i < gs.flatWidth; i++) {
      for (int j = 0; j < gs.flatHeight; j++) {
        if (updateValues) {
          //convert from Cube to Globe
        } else {
          globe2D[i][j] = new PVector(i, j, gs.vertices[i][j].value);
        }
      }
    }
  }

  void getCubeCoords(boolean updateValue) {
    cube2D = new PVector[6][cRes][cRes];
    float xCoord, yCoord, newVal;

    for (int s = 0; s < 6; s++) {
      for (int y = 0; y < cRes; y++) {
        for (int x = 0; x < cRes; x++) {
          xCoord = cs.vertices[s][x][y].theta/thetaSpacing;
          yCoord = cs.vertices[s][x][y].phi/phiSpacing;
          if (updateValue) {
            newVal = dualInterpolate(getVectors(xCoord, yCoord), getValues((int)xCoord, (int)yCoord, gs));
            cs.vertices[s][x][y].value = newVal;
            cs.vertices[s][x][y].setMagnitude(sphereRadius+newVal);
          } else {
            newVal = cs.vertices[s][x][y].value;
          }
          cube2D[s][x][y] = new PVector(xCoord, yCoord, newVal);
        }
      }
    }
  }
}

/*===================================================================
            Interpolation for globe to Cube Conversion
===================================================================*/

PVector[] getVectors(float posX, float posY) {  //gets the array of PVectors needed for the "dualInterpolate" function
  int a = (int) posX;                      //gets the x location in the upper left of the map coordinate
  int b = (int) posY;                      //gets the y location in the upper left of the map coordinate
  PVector[] out = new PVector[3];

  out[0] = new PVector(a, b);               //Upper left corner of the square that contains [x,y]
  out[1] = new PVector(a+1, b+1);           //Bottom right corner of the square that contains [x,y]
  out[2] = new PVector(posX, posY);       //Position [x,y]

  return out;
}

float[] getValues(int x, int y, GlobeSphere globe) {
  float [] out = new float[4];
  int x2, y2;

  if (x+1 > globe.flatWidth-1) {
    x2 = 0;
  } else {
    x2 = x+1;
  }

  if (y == 0 || y == globe.flatHeight-1) {
    y2 = y;
  } else {
    y2 = y+1;
  }

  out[0] = globe.vertices[x][y].value;
  out[1] = globe.vertices[x2][y].value;
  out[2] = globe.vertices[x][y2].value;
  out[3] = globe.vertices[x2][y2].value;

  return out;
}

float dualInterpolate(PVector[] positions, float [] v) {  //positions: [0] low, [1] high, [2] pos
  float top, bottom;

  if (v[0] == v[1]) {
    top = v[0];
  } else {
    top = map(positions[2].x, positions[0].x, positions[1].x, v[0], v[1]);
  }

  if (v[2] == v[3]) {
    bottom = v[2];
  } else {
    bottom = map(positions[2].x, positions[0].x, positions[1].x, v[2], v[3]);
  }

  if (top == bottom) {
    return top;
  }
  return map(positions[2].y, positions[0].y, positions[1].y, top, bottom);
}

/*===================================================================
          Triangle Interpolation for Cube to Globe Conversion
===================================================================*/

boolean isInsideTriangle(PVector p1, PVector p2, PVector p3, float x, float y) {
  float a, b, c;
  a = (p2.x-p1.x)*(y-p1.y)-(p2.y-p1.y)*(x-p1.x);
  b = (p3.x-p2.x)*(y-p2.y)-(p3.y-p2.y)*(x-p2.x);
  c = (p1.x-p3.x)*(y-p3.y)-(p1.y-p3.y)*(x-p3.x);
  ;
  if ((a <= 0 && b <= 0 && c <= 0)||(a >= 0 && b >= 0 && c >= 0)) {
    return true;
  }
  return false;
}



float triangleInterp(PVector p1, PVector p2, PVector p3, float x, float y) {
  float a = (p2.y-p1.y)*(p3.z-p1.z)-(p2.z-p1.z)*(p3.y-p1.y);
  float b = (p2.z-p1.z)*(p3.x-p1.x)-(p2.x-p1.x)*(p3.z-p1.z);
  float c = (p2.x-p1.x)*(p3.y-p1.y)-(p2.y-p1.y)*(p3.x-p1.x);
  float v = p1.x*a + p1.y*b + p1.z*c;

  return (v-a*x-b*y)/c;
}
