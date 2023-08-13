class Converter {
  PVector[][][] cubeCoords2D;  //The PVector coords map to the location of the pixels
  PVector[][] globeCoords2D;   //The PVector coords map to the location of the pixels
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
    
    getGlobeCoords();
  }
  
  void getGlobeCoords() {
    globeCoords2D = new PVector[gs.flatWidth][gs.flatHeight];
    
    for (int i = 0; i < gs.flatWidth; i++) {
      for (int j = 0; j < gs.flatHeight; j++) {
        globeCoords2D[i][j] = new PVector(i,j);
      }
    }
  }
  
  void getCubeCoords() {
    cubeCoords2D = new PVector[6][cRes][cRes];
  }
  
}
