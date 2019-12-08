Body[] bodies;
ArrayList Particles;
int n = 2;
int n_particles = 50000;
float h = 0.05;
void setup() {
  size(500, 500);
  bodies = new Body[n];
  Particles = new ArrayList();
  initialize();
  background(0);
}

void draw() {
  //background(0);
  updateParticles();
  if (frameCount % 100 == 0) {
    show();
  }
}

void initialize() {
  /*for (int i = 0; i < n; i++) {
    PVector x = new PVector(random(0, width), random(0, height));
    PVector v = new PVector(0, 0);
    float   m = 1000;
    color   c = color(random(255), 0, random(255));
    bodies[i] = new Body(x, v, m, c);
  }*/
  bodies[0] = new Body(new PVector(width/2 - 50,height/2),new PVector(0,0), 1000, color(random(255), 0, random(255)));
  bodies[1] = new Body(new PVector(width/2 + 50,height/2),new PVector(0,0), 1000, color(random(255), 0, random(255)));
  for (int i = 0; i < n_particles; i++) {
    Particles.add(
      new Body(
        new PVector(random(0, width), random(0, height)), 
        new PVector(0, 0), 
        0, 
        color(255, 255, 255)
      )
    );
  }
}

void show() {
  for (int i = 0; i < Particles.size(); i++) {
    Body p = (Body)Particles.get(i);
    if (p.coll != null) {
      fill(p.coll.c);
      stroke(p.coll.c);
      rect(p.x0.x, p.x0.y, 3, 3);
      Particles.remove(i);
    }
  }
}

void updateParticles() {
  for (int i = 0; i < Particles.size(); i++) {
    Body p = (Body)Particles.get(i);
    PVector x = p.x;
    PVector v = p.v;

    // calculate k1 - k4 for x and v
    PVector k1v = getAcc(p);
    PVector k1r = v;

    PVector k2v = getAcc(new Body(PVector.add(x, PVector.mult(k1r, h/2)), v, 0, 0));
    PVector k2r = PVector.add(v, PVector.mult(k1v, h/2));

    PVector k3v = getAcc(new Body(PVector.add(x, PVector.mult(k2r, h/2)), v, 0, 0));
    PVector k3r = PVector.add(v, PVector.mult(k2v, h/2));

    PVector k4v = getAcc(new Body(PVector.add(x, PVector.mult(k3r, h/2)), v, 0, 0));
    PVector k4r = PVector.add(v, PVector.mult(k3v, h));

    // calculate new x and v
    // v = v + (k1v + 2*k2v + 2*k3v + k4v) * h/6
    // x = x + (k1r + 2*k2r + 2*k3r + k4r) * h/6
    PVector vNew = PVector.add(v, PVector.mult(PVector.add(PVector.add(PVector.add(k1v, PVector.mult(k2v, 2)), PVector.mult(k3v, 2)), k4v), h/6));
    PVector xNew = PVector.add(x, PVector.mult(PVector.add(PVector.add(PVector.add(k1r, PVector.mult(k2r, 2)), PVector.mult(k3r, 2)), k4r), h/6));
    p.v = vNew;
    p.x = xNew;
  }
}

// calculates accumulative acceleration on particle based on n-Bodies
PVector getAcc(Body p) {
  PVector acc = new PVector(0, 0);
  for (int i = 0; i < n; i++) {
    acc.add(p.acc(bodies[i]));
  }
  return acc;
}

void updateParticles_Euler(){
  for (int i = 0; i < Particles.size(); i++) {
    Body p = (Body)Particles.get(i);
    PVector x = p.x;
    PVector v = p.v;
    PVector a = getAcc(p);
    PVector vNew = PVector.add(v, PVector.mult(a,h));
    PVector xNew = PVector.add(x, PVector.mult(vNew,h));
    p.v = vNew;
    p.x = xNew;
    
  }
}
