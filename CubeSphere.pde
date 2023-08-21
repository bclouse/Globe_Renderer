class CubeSphere {
  float size;
  int resolution;
  public SphereVector[][][] vertices;
  PImage[] faces;

  /*==========================================================
                           Initializers
   ==========================================================*/

  CubeSphere(float s, int r) {
    init(s, r);
    faces = new PImage[6];
  }

  void init(float s, int r) {
    size = s;
    resolution = r;
    vertices = new SphereVector[6][resolution][resolution];
    getCoords();
  }

  void setResolution(int r) {
    init(size, r);
  }

  void getCoords() {
    float[] placement = new float[resolution];

    for (int i = 0; i < resolution; i++) {
      placement[i] = tan(PI/4 - PI*i/(2*(resolution-1)))*(size+1);
    }

    for (int y = 0; y < resolution; y++) {
      for (int x = 0; x < resolution; x++) {
        vertices[0][x][y] = new SphereVector(placement[resolution-1-x], placement[resolution-1-y], size+1, CARTESIAN);
        vertices[1][x][y] = new SphereVector(placement[resolution-1-x], size+1, placement[y], CARTESIAN);
        vertices[2][x][y] = new SphereVector(size+1, placement[x], placement[y], CARTESIAN);
        vertices[3][x][y] = new SphereVector(placement[resolution-1-x], placement[y], -size-1, CARTESIAN);
        vertices[4][x][y] = new SphereVector(placement[x], -size-1, placement[y], CARTESIAN);
        vertices[5][x][y] = new SphereVector(-size-1, placement[resolution-1-x], placement[y], CARTESIAN);

        vertices[0][x][y].setMagnitude(size);
        vertices[1][x][y].setMagnitude(size);
        vertices[2][x][y].setMagnitude(size);
        vertices[3][x][y].setMagnitude(size);
        vertices[4][x][y].setMagnitude(size);
        vertices[5][x][y].setMagnitude(size);
      }
    }
  }

  /*==========================================================
                           Renderers
   ==========================================================*/

  void renderShape(boolean renderColors) {

    for (int s = 0; s < 6; s++) {
      if (renderColors) {
        switch(s) {
        case 0:
          fill(255, 0, 0);
          break;
        case 1:
          fill(0, 255, 0);
          break;
        case 2:
          fill(0, 0, 255);
          break;
        case 3:
          fill(255, 255, 0);
          break;
        case 4:
          fill(255, 0, 255);
          break;
        case 5:
          fill(0, 255, 255);
          break;
        }
      }
      for (int y = 0; y < resolution-1; y++) {
        beginShape(TRIANGLE_STRIP);
        for (int x = 0; x < resolution; x++) {
          vertex(vertices[s][x][y].x, vertices[s][x][y].y, vertices[s][x][y].z);
          vertex(vertices[s][x][y+1].x, vertices[s][x][y+1].y, vertices[s][x][y+1].z);
        }
        endShape();
      }
    }
  }

  void renderImages() {
    int xStep, yStep;
    //noStroke();

    for (int s = 0; s < 6; s++) {
      xStep = faces[s].width/(resolution-1);
      yStep = faces[s].height/(resolution-1);
      for (int y = 0; y < resolution-1; y++) {
        beginShape(TRIANGLE_STRIP);
        texture(faces[s]);
        for (int x = 0; x < resolution-1; x++) {
          vertex(vertices[s][x][y].x, vertices[s][x][y].y, vertices[s][x][y].z, x*xStep, y*yStep);
          vertex(vertices[s][x][y+1].x, vertices[s][x][y+1].y, vertices[s][x][y+1].z, x*xStep, (y+1)*yStep);
        }
        vertex(vertices[s][resolution-1][y].x, vertices[s][resolution-1][y].y, vertices[s][resolution-1][y].z, faces[s].width-1, y*yStep);
        vertex(vertices[s][resolution-1][y+1].x, vertices[s][resolution-1][y+1].y, vertices[s][resolution-1][y+1].z, faces[s].width-1, (y+1)*yStep);
        endShape();
      }
    }
  }

  /*==========================================================
   Loaders/Updaters
   ==========================================================*/

  void loadPictures(String fileExtension, String fileType) {
    for (int i = 0; i < 6; i++) {
      faces[i] = loadImage(fileExtension+i+fileType);

      loadPixels2D(faces[i]);

      for (int y = 0; y < faces[i].height; y++) {
        for (int x = 0; x < faces[i].width; x++) {
          vertices[i][faces[i].width-x-1][y].value = red(pixels2D[x][y]);
        }
      }
    }
  }

  void updateHeightMap() {
    int[] indexStep = new int[resolution];
    for (int i = 0; i < resolution; i++) {
      indexStep[i] = (int)map(i, 0, resolution, 0, faces[0].width);
    }

    for (int s = 0; s < 6; s++) {
      faces[s].loadPixels();
      for (int y = 0; y < resolution; y++) {
        for (int x = 0; x < resolution; x++) {
          //println(x+"\t"+y+"\t"+indexStep[x]+"\t"+face);
          vertices[s][x][y].value = red(faces[s].pixels[indexStep[x]+indexStep[y]*faces[s].width])*10/255;
          if (vertices[s][x][y].value < 0.1) {
            vertices[s][x][y].setMagnitude(-(vertices[s][x][y].r-10));
          } else {
            vertices[s][x][y].setMagnitude(-(vertices[s][x][y].value+vertices[s][x][y].r));
          }
        }
      }
    }
  }
}
