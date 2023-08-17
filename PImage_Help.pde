color[][] pixels2D;

void loadPixels2D(PImage img) {
  int index = 0;
  pixels2D = new color[img.width][img.height];
  
  img.loadPixels();
  for (int j = 0; j < img.height; j++) {
    for (int i = 0; i < img.width; i++) {
      pixels2D[i][j] = img.pixels[index];
      index++;
    }
  }
}

//color[] updatePixels2D() {
//  color[] out = new int[pixels2D.length*pixels2D[0].length];
//  int index = 0;
  
//  for (int y = 0; y < pixels2D[0].length; y++) {
//    for (int x = 0; x < pixels2D.length; x++) {
//      out[index] = pixels2D[x][y];
//      index++;
//    }
//  }
  
//  return out;
//}

void updatePixels2D(PImage img) {
  int index = 0;
  
  img.loadPixels();
  
  for (int y = 0; y < pixels2D[0].length; y++) {
    for (int x = 0; x < pixels2D.length; x++) {
      img.pixels[index] = pixels2D[x][y];
      index++;
    }
  }
  
  img.updatePixels();
}

PImage rotateImage(PImage img, int rotationID) {
  color[][] dummy;
  PImage out;
  int index = 0;
  img.loadPixels();

  if (rotationID == 1 || rotationID == 3) {
    dummy = new color[img.height][img.width];
    out = createImage(img.height, img.width, RGB);
  } else if (rotationID == 2) {
    dummy = new color[img.width][img.height];
    out = createImage(img.width, img.height, RGB);
  } else {
    if (rotationID != 0) {
      println("ERROR with 'rotateImage'. The rotationID ("+rotationID+") is invalid");
    }
    return img;
  }

  for (int r = 0; r < img.height; r++) {
    for (int c = 0; c < img.width; c++) {
      switch(rotationID) {
      case 1:
        dummy[img.height-r-1][c] = img.pixels[index];
        break;
      case 2:
        dummy[img.width-c-1][img.height-r-1] = img.pixels[index];
        break;
      case 3:
        dummy[r][img.width-c-1] = img.pixels[index];
        break;
      }
      index++;
    }
  }
  img.updatePixels();
  
  out.loadPixels();
  index = 0;
  for (int r = 0; r < out.height; r++) {
    for (int c = 0; c < out.width; c++) {
      out.pixels[index] = dummy[c][r];
      index++;
    }
  }
  out.updatePixels();

  return out;
}
