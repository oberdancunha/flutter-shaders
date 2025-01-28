// https://thebookofshaders.com/11/

#ifdef GL_ES
  precision mediump float;
#endif

#include <flutter/runtime_effect.glsl>

uniform vec2 uSize;
uniform float uTime;

out vec4 fragColor;

vec3 drawUpperTriangle(in vec3 _triangleColor, in vec2 _p) {
  _triangleColor.yz = 1.0 - vec2(_p.x - _p.y, _p.y);
  _triangleColor.x = _p.x;

  return _triangleColor;
}

vec3 drawLowerTriangle(in vec3 _triangleColor, in vec2 _p) {
  _triangleColor.xy = 1.0 - vec2(_p.x, _p.y - _p.x);
  _triangleColor.z = _p.y;

  return _triangleColor;
}

bool isLowerTriangle(in vec2 _p) {
  return _p.x > _p.y;
}

vec2 skew(in vec2 _uv) {
  vec2 r = vec2(0.0);
  r.x = 1.1547 * _uv.x;
  r.y = _uv.y + (0.5 * r.x);

  return r;
}

vec3 simplexGrid(in vec2 _uv) {
  vec3 triangleColor = vec3(0.0);
  vec2 p = fract(skew(_uv));
  if (isLowerTriangle(p)) {
    triangleColor = drawLowerTriangle(triangleColor, p);
  } else {
    triangleColor = drawUpperTriangle(triangleColor, p);
  }

  return fract(triangleColor);
}

vec3 show2DGrid(in vec2 _uv) {
  vec3 color = vec3(0.0);
  color.rg = fract(_uv);

  return color;
}

vec2 scaleSpaceToSeeGrid(in vec2 _uv) {
  _uv *= 10;

  return _uv;
}

vec2 invertVerticalScreen(in vec2 _uv) {
  _uv.y = 1.0 - _uv.y;

  return _uv;
}

vec3 makeColor(in vec2 _uv) {
  _uv = invertVerticalScreen(_uv);
  vec3 color = vec3(0.0);
  _uv = scaleSpaceToSeeGrid(_uv);
  color = show2DGrid(_uv);
  color = simplexGrid(_uv);

  return color;
}

void main() {
  vec2 pos = FlutterFragCoord().xy;
  vec2 uv = pos / uSize;
  vec3 color = makeColor(uv);
  float correctIOSIndexRange = uTime - uTime;
  fragColor = vec4(color, 1.0 + correctIOSIndexRange);
}