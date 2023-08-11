class GlobeSphere {
  float radius;
  PVector spacing;
  int flatWidth, flatHeight;
  SphereVector[][] vertices;
  PImage face;

  GlobeSphere(float r, int w, int h) {
    radius = r;
    flatWidth = w;
    flatHeight = h;
    spacing = new PVector(2*PI/w, PI/(h-1));
    vertices = new SphereVector[w][h];
    //println(spacing.x+"\t\t"+spacing.y);
    //println(spacing.y*(h-1)+"\t\t"+spacing.y*h+"\t\t"+PI);
    getCoords();
  }

  void getCoords() {
    for (int y = 0; y < flatHeight; y++) {
      for (int x = 0; x < flatWidth; x++) {
        if (y == 0) {
          vertices[x][y] = new SphereVector(0, 0, radius, CARTESIAN);
        } else if (y == flatHeight-1) {
          vertices[x][y] = new SphereVector(0, 0, -radius, CARTESIAN);
        } else {
          vertices[x][y] = new SphereVector(radius, x*spacing.x, y*spacing.y, SPHERICAL);
        }
      }
    }
  }

  void renderShape() {
    /*================================
     North Pole
     ================================*/

    beginShape(TRIANGLE_FAN);
    vertex(vertices[0][0].x, vertices[0][0].y, vertices[0][0].z);
    for (int x = 0; x < flatWidth; x++) {
      vertex(vertices[x][1].x, vertices[x][1].y, vertices[x][1].z);
    }
    vertex(vertices[0][1].x, vertices[0][1].y, vertices[0][1].z);
    endShape();

    /*================================
     Globe Body
     ================================*/

    for (int y = 1; y < flatHeight-2; y++) {
      beginShape(TRIANGLE_STRIP);
      for (int x = 0; x < flatWidth; x++) {
        vertex(vertices[x][y].x, vertices[x][y].y, vertices[x][y].z);
        vertex(vertices[x][y+1].x, vertices[x][y+1].y, vertices[x][y+1].z);
      }
      vertex(vertices[0][y].x, vertices[0][y].y, vertices[0][y].z);
      vertex(vertices[0][y+1].x, vertices[0][y+1].y, vertices[0][y+1].z);
      endShape();
    }


    /*================================
     South Pole
     ================================*/

    beginShape(TRIANGLE_FAN);
    vertex(vertices[0][flatHeight-1].x, vertices[0][flatHeight-1].y, vertices[0][flatHeight-1].z);
    for (int x = 0; x < flatWidth; x++) {
      vertex(vertices[x][flatHeight-2].x, vertices[x][flatHeight-2].y, vertices[x][flatHeight-2].z);
    }
    vertex(vertices[0][flatHeight-2].x, vertices[0][flatHeight-2].y, vertices[0][flatHeight-2].z);
    endShape();
  }

  void loadPicture(String fileName) {
    face = loadImage(fileName);
  }

  void renderImage() {
    int xStep = face.width/flatWidth;
    int yStep = face.height/flatHeight;
    //noStroke();

    /*================================
     North Pole
     ================================*/

    beginShape(TRIANGLE_STRIP);
    texture(face);
    for (int x = 0; x < flatWidth; x++) {
      vertex(vertices[x][0].x, vertices[x][0].y, vertices[x][0].z, face.width-x*xStep-1, 0);
      vertex(vertices[x][1].x, vertices[x][1].y, vertices[x][1].z, face.width-x*xStep-1, yStep);
    }
    vertex(vertices[0][0].x, vertices[0][0].y, vertices[0][0].z, 0, 0);
    vertex(vertices[0][1].x, vertices[0][1].y, vertices[0][1].z, 0, yStep);
    endShape();

    /*================================
     Globe Body
     ================================*/

    for (int y = 1; y < flatHeight-2; y++) {
      beginShape(TRIANGLE_STRIP);
      texture(face);
      for (int x = 0; x < flatWidth; x++) {
        vertex(vertices[x][y].x, vertices[x][y].y, vertices[x][y].z, face.width-x*xStep-1, y*yStep);
        vertex(vertices[x][y+1].x, vertices[x][y+1].y, vertices[x][y+1].z, face.width-x*xStep-1, (y+1)*yStep);
      }
      vertex(vertices[0][y].x, vertices[0][y].y, vertices[0][y].z, 0, y*yStep);
      vertex(vertices[0][y+1].x, vertices[0][y+1].y, vertices[0][y+1].z, 0, (y+1)*yStep);
      endShape();
    }


    /*================================
     South Pole
     ================================*/

    beginShape(TRIANGLE_STRIP);
    texture(face);
    //vertex(vertices[0][flatHeight-1].x, vertices[0][flatHeight-1].y, vertices[0][flatHeight-1].z);
    for (int x = 0; x < flatWidth; x++) {
      vertex(vertices[x][flatHeight-2].x, vertices[x][flatHeight-2].y, vertices[x][flatHeight-2].z, face.width-x*xStep-1, (flatHeight-2)*yStep);
      vertex(vertices[x][flatHeight-1].x, vertices[x][flatHeight-1].y, vertices[x][flatHeight-1].z, face.width-x*xStep-1, face.height-1);
    }
    vertex(vertices[0][flatHeight-2].x, vertices[0][flatHeight-2].y, vertices[0][flatHeight-2].z, 0, (flatHeight-2)*yStep);
    vertex(vertices[0][flatHeight-1].x, vertices[0][flatHeight-1].y, vertices[0][flatHeight-1].z, 0, face.height-1);
    endShape();
  }
}
