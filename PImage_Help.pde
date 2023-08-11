int[][] pixels2D;

void loadPixels2D(PImage img) {
  int index = 0;
  pixels2D = new int[img.width][img.height];
  
  img.loadPixels();
  for (int j = 0; j < img.height; j++) {
    for (int i = 0; i < img.width; i++) {
      pixels2D[i][j] = img.pixels[index];
      index++;
    }
  }
}
