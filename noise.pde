void noiseTex() {

  PGraphics pg = createGraphics(256, 256);

  pg.beginDraw();
  for (int x=0; x<256; x+=1) {
    for (int y=0; y<256;y+=1) {
      float r, g, b;
      int a = 0;
      int c = 255;
      r = c*noise(random(a,c));
      g = c*noise(random(a,c));
      b = c*noise(random(a,c));
      pg.noStroke();
      pg.fill(r, g, b);
      pg.rect(x, y, 5, 5);
    }
  }
  pg.endDraw();

   image(pg, 0, 0);
}

