/*
Iterated Fractional Brownian Motion
Based on:
  http://www.iquilezles.org/www/articles/warp/warp.htm
*/

#ifdef GL_ES
precision mediump float;
precision mediump int;
#endif

uniform float time;
uniform vec2 resolution;
uniform float colorScale;

// makes a pseudorandom number between 0 and 1
float hash(float n) {
  return fract(sin(n)*93942.234);
}

// smoothsteps a grid of random numbers at the integers
float noise(vec2 p) {
  vec2 w = floor(p);
  vec2 k = fract(p);
  k = k*k*(3.-2.*k); // smooth it
  
  float n = w.x + w.y*57.;
  
  float a = hash(n);
  float b = hash(n+1.);
  float c = hash(n+57.);
  float d = hash(n+58.);
  
  return mix(
    mix(a, b, k.x),
    mix(c, d, k.x),
    k.y);
}

// rotation matrix
mat2 m = mat2(0.6,0.8,-0.8,0.6);

// fractional brownian motion (i.e. photoshop clouds)
float fbm(vec2 p) {
  float f = 0.;
  f += 0.5000*noise(p); p *= 1.52*m;
  f += 0.2500*noise(p); p *= 1.51*m;
  f += 0.1250*noise(p); p *= 1.53*m;
  f += 0.0625*noise(p);
  f /= 0.9375;
  return f;
}

void main() {
  // relative coordinates
  //vec2 p = vec2(position*6.)*vec2(resolution.x/resolution.y, 1.);
  vec2 p = 8.0*(gl_FragCoord.xy / resolution.xy);
  float t = time * .009;
  
  // calling fbm on itself
  vec2 a = vec2(fbm(p+t*3.), fbm(p-t*3.+8.1));
  vec2 b = vec2(fbm(p+t*4. + a*7. + 3.1), fbm(p-t*4. + a*7. + 91.1));
  float c = fbm(b*9. + t*20.);
  
  // increase contrast
  c = smoothstep(0.15,0.98,c);
  
  // mix in some color
  vec3 col = vec3(c);
  col += vec3(colorScale, b*0.18);
  
  gl_FragColor = vec4(col, 1.);
}