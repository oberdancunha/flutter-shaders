// https://thebookofshaders.com/edit.php#11/iching-03.frag

#ifdef GL_ES
  precision mediump float;
#endif

#include <flutter/runtime_effect.glsl>

#define NUMBER_OF_BLOCKS 6
#define PI 3.14159265359
#define TWO_PI 6.28318530718
#define F3 0.3333333
#define G3 0.1666667

uniform vec2 uSize;
uniform float uTime;

out vec4 fragColor; 

vec3 random3(in vec3 _c) {
  float j = 4096.0 * sin(
    dot(
      _c, 
      vec3(17.0, 59.4, 15.0)
      )
    );
  vec3 rColor = vec3(0.0);
  rColor.z = fract(512.0 * j);
  j *= 0.125;
  rColor.x = fract(512.0 * j);
  j *= 0.125;
  rColor.y = fract(512.0 * j);

  return rColor - 0.5;
}

float snoise(in vec3 _p) {
  vec3 s = floor(_p + dot(_p, vec3(F3)));
  vec3 x = _p - s + dot(s, vec3(G3));
  vec3 e = step(vec3(0.0), x - x.yzx);
  vec3 i1 = e * (1.0 - e.zxy);
  vec3 i2 = 1.0 - e.zxy * (1.0 - e);
  vec3 x1 = x - i1 + G3;
  vec3 x2 = x - i2 + (2.0 * G3);
  vec3 x3 = x - 1.0 + (3.0 * G3);
  vec4 w, d;
  w.x = dot(x, x);
  w.y = dot(x1, x1);
  w.z = dot(x2, x2);
  w.w = dot(x3, x3);
  w = max(0.6 - w, 0.0);
  d.x = dot(random3(s), x);
  d.y = dot(random3(s + i1), x1);
  d.z = dot(random3(s + i2), x2);
  d.w = dot(random3(s + 1.0), x3);
  w *= w;
  w *= w;
  d *= w;

  return dot(d, vec4(52.0));
}

float shape(in vec2 _uv, in int _N) {
  _uv = _uv * 2.0 - 1.0;
  float a = atan(_uv.x, _uv.y) + PI;
  float r = TWO_PI / float(_N);

  return cos((floor(0.5 + (a / r)) * r) - a) * length(_uv); 
}

float box(in vec2 _uv, in vec2 _size) {
  return shape(_uv * _size, 4);
}

float getBoxValue(in bool _v, in vec2 _fpos) {
  return _v ? 
  box(
    _fpos - vec2(0.03, 0.0), 
    vec2(1.0)
  )
  : box(
      _fpos,
      vec2(0.84, 1.0)
    );
}

vec2 getIntegerCoords(in vec2 _uv) {
  return floor(_uv);
}

vec2 getFractionalCoords(in vec2 _uv) {
  return fract(_uv);
}

float hex(in vec2 _uv, in bool _a, in bool _b, in bool _c, in bool _d, in bool _e, in bool _f) {
  _uv = _uv * vec2(2.0, 6.0);
  vec2 fpos = getFractionalCoords(_uv);
  vec2 ipos = getIntegerCoords(_uv);
  if (ipos.x == 1.0) fpos.x = 1.0 - fpos.x;
  if (ipos.y < 1.0) {
    return getBoxValue(_a, fpos);
  }
  if (ipos.y < 2.0) {
    return getBoxValue(_b, fpos);
  }
  if (ipos.y < 3.0) {
    return getBoxValue(_c, fpos);
  }
  if (ipos.y < 4.0) {
    return getBoxValue(_d, fpos);
  }
  if (ipos.y < 5.0) {
    return getBoxValue(_e, fpos);
  }
  if (ipos.y < 6.0){
    return getBoxValue(_f, fpos);
  }

  return 0.0;
}

float hex(in vec2 _uv, in float _N) {
  bool b[NUMBER_OF_BLOCKS];
  float remain = floor(mod(_N, 64.0));
  for(int i = 0; i < NUMBER_OF_BLOCKS; i++) {
    b[i] = mod(remain, 2.0) == 1.0 ? true : false;
    remain = ceil(remain / 2.0);
  }

  return hex(_uv, b[0], b[1], b[2], b[3], b[4], b[5]);
}

vec2 invertVerticalScreen(in vec2 _uv) {
  _uv.y = 1.0 - _uv.y;

  return _uv;
}

vec3 makeColor(in vec2 _uv) {
  vec3 color = vec3(0.0);
  _uv = invertVerticalScreen(_uv);
  float t = uTime * 0.5;
  float df = 1.0;
  df = mix(
    hex(_uv, t),
    hex(_uv, t + 1.0),
    fract(t)
  );
  df += snoise(vec3(_uv * 75.0, t * 0.1)) * 0.03;
  color = mix(
    vec3(0.0),
    vec3(1.0),
    step(0.7, df)
  );

  return color;
}

void main() {
  vec2 pos = FlutterFragCoord().xy;
  vec2 uv = pos / uSize;
  vec3 color = makeColor(uv);
  fragColor = vec4(color, 1.0);
}