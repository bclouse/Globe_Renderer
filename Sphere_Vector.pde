final int CARTESIAN = 0;
;
final int SPHERICAL = 1;

class SphereVector {
  public float x, y, z, r, theta, phi;    //'radius' is used for cylidrical coordinates. 'r' is used for spherical coordinates.

  SphereVector() {
    init(0, 0, 0, CARTESIAN);
  }

  SphereVector(float a, float b, float c, int coordinateMode) {
    init(a, b, c, coordinateMode);
  }

  void init(float a, float b, float c, int coordinateMode) {
    if (coordinateMode == CARTESIAN) {
      x = a;
      y = b;
      z = c;
    } else if (coordinateMode == SPHERICAL) {
      r = a;
      theta = b;
      phi = c;

      setThetaBounds();
      if (phi > PI/2 || phi < -PI/2) {
        setPhiBounds();
        println("Phi is out of bounds. Was set to "+(phi/PI)+"*PI");
      }
    } else {
      println("ERROR IN 'SphereVector' CONSTRUCTOR. THE 'coordinateMode' ("+coordinateMode+") IS INVALID.\n\tMust be either 0 or 1.");
    }

    updateCoordinates(coordinateMode);
  }

  private void setThetaBounds() {
    while (theta > 2*PI) {
      theta -= 2*PI;
    }
    while (theta < 0) {
      theta += 2*PI;
    }
  }


  private void setPhiBounds() {
    while (theta > PI/2) {
      theta -= PI;
    }
    while (theta < -PI/2) {
      theta += PI;
    }
  }

  void updateCoordinates(int coordinateMode) {
    switch (coordinateMode) {
    case CARTESIAN:
      r = sqrt(x*x + y*y + z*z);
      phi = acos(z/r);
      theta = true_asin(y/(r*sin(phi)), x, y);
      break;
    case SPHERICAL:
      x = r*sin(phi)*cos(theta);
      y = r*sin(phi)*sin(theta);
      z = r*cos(phi);
      break;
    default:
      println("ERROR IN 'updateCoordinates' METHOD. THE 'coordinateMode' ("+coordinateMode+") IS INVALID.\n\tMust be 0 or 1.");
    }
  }

  void rotateX(float alpha) {
    float radius = sqrt(y*y+z*z);
    float angle = true_asin(z/radius, y, z);
    angle += alpha;
    println(angle);
    y = radius*cos(angle);
    z = radius*sin(angle);
    updateCoordinates(CARTESIAN);
  }

  void rotateY(float alpha) {
    float radius = sqrt(x*x+z*z);
    float angle = true_asin(x/radius, z, x);
    angle += alpha;
    println(angle);
    z = radius*cos(angle);
    x = radius*sin(angle);
    updateCoordinates(CARTESIAN);
  }

  void rotateZ(float alpha) {
    theta += alpha;
    setThetaBounds();
    updateCoordinates(SPHERICAL);
  }

  void printCoords() {
    println("Cartesian: [ "+x+", "+y+", "+z+" ]");
    println("Spherical: [ "+r+", "+theta+", "+phi+" ]\n");
  }

  void setCoords(float a, float b, float c, int coord) {
    switch (coord) {
    case CARTESIAN:
      x = a;
      y = b;
      z = c;
      break;
    case SPHERICAL:
      r = a;
      theta = b;
      phi = c;
      break;
    }
    updateCoordinates(coord);
  }
  
  void setMag(float m) {
    r = m;
    updateCoordinates(SPHERICAL);
  }
}



float true_asin(float v, float x, float y) {
  float out = asin(v);

  if (x < 0) out = PI-out;
  else if (y < 0) out += TWO_PI;

  return out;
}
