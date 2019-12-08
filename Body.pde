class Body{
  PVector x0;
  PVector x;
  PVector v;
  float   m;
  color   c;
  Body coll;
  
  public Body(PVector x, PVector v, float m, color c){
    this.x0 = x;
    this.x = x;
    this.v = v;
    this.m = m;
    this.c = c;
  }
  
  private float dst(Body other){
    float xdst = this.x.x - other.x.x;
    float ydst = this.x.y - other.x.y;
    if(sqrt( xdst*xdst + ydst*ydst ) < 10 && (coll == null)){
      coll = other;
    }
    return sqrt( xdst*xdst + ydst*ydst ); // sqrt[(x - x_)^2 + (y - y_)^2]
  }
  
  public PVector acc(Body other){
    float d = this.dst(other);
    PVector ret = (PVector.mult(PVector.sub(other.x,this.x), other.m)).div(d*d*d);
    return ret;
  }
  
  public void show(){
    fill(c);
    stroke(c);
    int size = this.m == 0 ? 1 : 10;
    ellipse(x.x, x.y, size, size);
  }
}
