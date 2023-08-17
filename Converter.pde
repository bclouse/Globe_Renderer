class Converter {
  PVector[][][] cube2D;  //The PVector coords map to the location of the pixels
  PVector[][] globe2D;   //The PVector coords map to the location of the pixels
  CubeSphere cs;
  GlobeSphere gs;
  float thetaSpacing;
  float phiSpacing;
  int cRes;

  Converter(CubeSphere c, GlobeSphere g) {
    cs = c;
    gs = g;
    thetaSpacing = 2*PI/gs.flatWidth;
    phiSpacing = PI/gs.flatHeight;
    cRes = cs.resolution;
  }

  void convert() {
    getGlobeCoords();
    getCubeCoords();
    cube2Image();
  }

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

  void getGlobeCoords() {
    globe2D = new PVector[gs.flatWidth][gs.flatHeight];

    for (int i = 0; i < gs.flatWidth; i++) {
      for (int j = 0; j < gs.flatHeight; j++) {
        globe2D[i][j] = new PVector(i, j);
      }
    }
  }

  void getCubeCoords() {
    cube2D = new PVector[6][cRes][cRes];
    float xCoord, yCoord, newVal;

    for (int s = 0; s < 6; s++) {
      for (int y = 0; y < cRes; y++) {
        for (int x = 0; x < cRes; x++) {
          //if (x == 5 && y == 5) {
          //  println("\n\nSide: "+s+"\t\t[ "+x+", "+y+" ]");
          //  cs.vertices[s][x][y].printCoords();
          //}
          xCoord = cs.vertices[s][x][y].theta/thetaSpacing;
          yCoord = cs.vertices[s][x][y].phi/phiSpacing;
          newVal = dualInterpolate(getVectors(xCoord, yCoord), getValues((int)xCoord, (int)yCoord, gs));
          cube2D[s][x][y] = new PVector(xCoord, yCoord, newVal);
          cs.vertices[s][x][y].value = newVal;
          cs.vertices[s][x][y].setMagnitude(sphereRadius+newVal);
          //if (x == 5 && y == 5) {
          //  println("xCoord: "+xCoord+"\tyCoord: "+yCoord+"\tnewVal: "+newVal);
          //  cs.vertices[s][x][y].printCoords();
          //}
        }
      }
    }
  }
}

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

//float dualInterpolate(float x1, float x2, float y1, float y2, float posX, float posY, float v1, float v2, float v3, float v4) {
//  float top, bottom;

//  top = map(posX, x1, x2, v1, v2);
//  bottom = map(posX, x1, x2, v3, v4);

//  return map(posY, y1, y2, top, bottom);
//}
