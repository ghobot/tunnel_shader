// shader code adapted from https://www.shadertoy.com/view/XsfGzH, https://www.shadertoy.com/view/MsX3RH, 
//https://www.shadertoy.com/view/XdfGz8, https://www.shadertoy.com/view/4dXGR4, https://www.shadertoy.com/view/4dfGDM

//uniform vec3      iResolution;           // viewport resolution (in pixels)
//uniform float     iGlobalTime;           // shader playback time (in seconds)
//uniform float     iChannelTime[4];       // channel playback time (in seconds)
//uniform vec3      iChannelResolution[4]; // channel resolution (in pixels)
//uniform vec4      iMouse;                // mouse pixel coords. xy: current (if MLB down), zw: click
//uniform samplerXX iChannel0..3;          // input channel. XX = 2D/Cube
//uniform vec4      iDate;                 // (year, month, day, time in seconds)
import ddf.minim.*;
import processing.video.*;
import processing.opengl.*;

Movie myMovie, tube;
AudioPlayer player;
Minim minim;//audio context
PShader selShader, nursery, starfield, explosion, star, tunnel, jupiter ;
PGraphics pg;
PImage noise, rust, rust2;
float speed1, speed2, duration;
Boolean playMovie, playShader, flashIt, counter, normal, sequence;
int count;
int m;
int c2;
float sec;
ArrayList <PShader> shaders;

void setup() {

  size(800, 600, P3D);
  myMovie = new Movie(this, "one.mpg");
  tube = new Movie(this, "two.mpg");
  minim = new Minim(this);
  player = minim.loadFile("world_to_stop.mp3", 2048); 
  shaders = new ArrayList<PShader>();  // Create an empty ArrayList  
  noise = loadImage("noise2.png");
  rust = loadImage("rust.jpg");
  rust2= loadImage("rust2.jpg"); 
  pg = createGraphics(width, height, OPENGL);
  nursery = loadShader("nursery.glsl");
  tunnel = loadShader("tunnel.glsl");
  explosion = loadShader("explosion.glsl");
  star = loadShader("star.glsl");
  starfield=loadShader("star_field.glsl");
  jupiter=loadShader("warpFrag.glsl");
  nursery.set("iResolution", (float)width, (float)height, 0);
  tunnel.set("iResolution", (float)width, (float)height, 0);
  explosion.set("iResolution", (float)width, (float)height, 0);
  star.set("iResolution", (float)width, (float)height, 0);
  starfield.set("iResolution", (float)width, (float)height, 0);
  jupiter.set("resolution", (float)width, (float)height);

  nursery.set("iChannel0", noise);
  tunnel.set("iChannel0", noise);
  tunnel.set("iChannel1", rust);
  tunnel.set("iChannel2", rust2);
  star.set("iChannel0", rust2);
  star.set("iChannel1", noise);
  jupiter.set("colorScale", 1.0);

  selShader = nursery;
  playShader = false;
  normal= false;
  playMovie = true;
  counter=false;
  sequence=true;
  count=0;
  c2=255; //opacity set to visible
  speed1=1500;
  speed2=1500;
  flashIt= false;
  // theta = 0;
  // c=0;
  // smooth(8);
  //  shaders.add(nursery);
  //  shaders.add(explosion);
  //  //shaders.add(star);
  //  shaders.add(tunnel);
}

void draw() {
  background(0);
  m=millis();
  sec = (float)m/1000;
  nursery.set("iGlobalTime", millis() / speed1);
  tunnel.set("iGlobalTime", millis() / speed2);
  explosion.set("iGlobalTime", millis() / speed2);
  jupiter.set("time", millis() / 500.0);
  star.set("iGlobalTime", millis() / speed2);
  starfield.set("iGlobalTime", millis() / speed2);
  //println("seconds = " + sec);
  //println("position: "+ player.position());
  if (playMovie) {
    myMovie.play();   
    image(myMovie, 0, 0, width, height );
    String world="i want the world to stop";
    textSize(48);
    textAlign(CENTER);
    text(world, width/2, height*.75);
    if (myMovie.time()>20.7) {
      player.play();
    }
  }
  else {
    myMovie.stop();
  }


  if (movieFinished(myMovie)) {
    //println("the movie is finished");
    playMovie=false;
    playShader=true;
    c2=255;
    normal=true;
    selShader=nursery;
  }

  if (playShader && normal) {    
    //    if (flashIt) {
    //      image(flash, 0, 0);
    //    }

    pg.beginDraw();
    pg.background(0, 0);  
    pg.noStroke();
    pg.shader(selShader); 
    pg.rect(0, 0, width, height);
    pg.endDraw();
    int n = constrain(c2, 0, 255);
    tint(255, 255, 255, n);
    image(pg, 0, 0);

    c2+=10;
    //song timepoints
    if (player.position()>18000 && player.position()<28000 && sequence) { //if the song is at 28 seconds, go to starfield
      selShader=starfield;
    }

    if (player.position()>28000 && player.position()<36000 && sequence) { //if the song is at 28 seconds, go to starfield
      selShader=explosion;
    }

    if (player.position()>36000 && player.position()<46000 && sequence) { //if the song is at 28 seconds, go to starfield
      selShader=star;
    }
    if (player.position()>46000 && player.position()<72000 && sequence) { //if the song is at 28 seconds, go to starfield
      selShader=tunnel;
    }   

    if (player.position()>72000 && sequence) { //if the song is at 28 seconds, go to starfield
      selShader=jupiter;
    }

    if (selShader==tunnel) {
      textAlign(LEFT);
      textSize(16);
      fill(255);
      text(_s, padding, height-padding);  // Text wraps within text box
      //status("speed2");
    }

    if (selShader==nursery) {
      textAlign(LEFT);
      textSize(16);
      fill(255);
      text(_s, padding, height-padding);  // Text wraps within text box
      //status("speed1");
    }
  }
}

void keyPressed() {
  c2=0;
  normal=true;
  sequence=false;
  if (key=='s') {

    playShader=!playShader; 
    playMovie= false;
  }
  if (key=='p') {

    playMovie=!playMovie; 
    playShader=false;
    // flashIt=true;
  }
  if (key=='1') {
    playShader=true;
    selShader=nursery;
  }

  if (key=='2') {
    playShader=true;
    selShader=starfield;
  } 

  if (key=='3') {
    playShader=true;
    selShader=explosion;
  }

  if (key=='4') {
    playShader=true;
    selShader=star;
  }

  if (key=='5') {
    playShader=true;
    selShader=tunnel;
  } 
  if (key=='6') {
    playShader=true;
    selShader=jupiter;
  }

//  if (key=='7') {
//    myMovie.stop();
//    playShader=false;
//    playMovie=false;
//    tube.play();
//    image(tube, 0, 0, width, height);
//    
//  }

  if (keyCode==DOWN) {
    speed2+=100;
  }

  if (keyCode==UP) {
    speed2-=100;
  }

  if (key=='q') {
    stop();
    exit();
  }
}

void movieEvent(Movie m) {
  m.read();
}

void stop() {
  player.close();
  minim.stop();
  super.stop();
}

boolean movieFinished(Movie myMovie) {
  if (myMovie.time() >= myMovie.duration()) { //movie must be finished
    return true;
  }
  else {
    return false;
  }
}

