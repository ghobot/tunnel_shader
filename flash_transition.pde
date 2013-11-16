float theta, c;
PGraphics flash;
void flashTransition() {
  createGraphics(width, height, OPENGL);
  pushMatrix();  
  flash.beginDraw();
  c = map(sin(radians(theta)), 0, TWO_PI, 0, 255);
  theta += 2;
  if (c<0) { 
    flashIt=false;
  }
  flash.fill(255, 8*c);
  flash.blend(0, 0, width, height, 0, 0, width, height, ADD);
  flash.rect(0, 0, width, height);
  flash.endDraw();
  popMatrix();
}

