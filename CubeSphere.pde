class CubeSphere {
  float size;
  int resolution;
  SphereVector[][][] vertices;
  PImage[] faces;

  CubeSphere(float s, int r) {
    size = s;
    resolution = r;
    vertices = new SphereVector[6][resolution][resolution];
    getCoords();
    faces = new PImage[6];
  }

  void getCoords() {
    float[] placement = new float[resolution];
    //float tempSize = size+1;

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

        //if (x == 5) {
        //  vertices[0][x][y].printCoords();
        //}

        vertices[0][x][y].setMagnitude(size);
        vertices[1][x][y].setMagnitude(size);
        vertices[2][x][y].setMagnitude(size);
        vertices[3][x][y].setMagnitude(size);
        vertices[4][x][y].setMagnitude(size);
        vertices[5][x][y].setMagnitude(size);

        //if (x == 5) {
        //  vertices[0][x][y].printCoords();
        //}
      }
    }
  }

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
        //if (renderImages) {
        //  texture(renderStrips[s][x][y]);
        //}
        for (int x = 0; x < resolution; x++) {
          vertex(vertices[s][x][y].x, vertices[s][x][y].y, vertices[s][x][y].z);
          vertex(vertices[s][x][y+1].x, vertices[s][x][y+1].y, vertices[s][x][y+1].z);
          //println(cube[0][x][y].x+", "+ cube[0][x][y].y);
          //vertex(cube[0][x][y].x, cube[0][x][y].y, cube[0][x][y].z);
          //vertex(cube[0][x][y+1].x, cube[0][x][y+1].y, cube[0][x][y+1].z);
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
          //println(cube[0][x][y].x+", "+ cube[0][x][y].y);
          //vertex(cube[0][x][y].x, cube[0][x][y].y, cube[0][x][y].z);
          //vertex(cube[0][x][y+1].x, cube[0][x][y+1].y, cube[0][x][y+1].z);
        }
          vertex(vertices[s][resolution-1][y].x, vertices[s][resolution-1][y].y, vertices[s][resolution-1][y].z, faces[s].width-1, y*yStep);
          vertex(vertices[s][resolution-1][y+1].x, vertices[s][resolution-1][y+1].y, vertices[s][resolution-1][y+1].z, faces[s].width-1, (y+1)*yStep);
        endShape();
      }
    }
  }

  void loadPictures(String fileExtension, String fileType) {
    for (int i = 0; i < 6; i++) {
      faces[i] = loadImage(fileExtension+i+fileType);
    }
  }
}
