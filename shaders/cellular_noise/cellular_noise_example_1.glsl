// https://thebookofshaders.com/12/

#ifdef GL_ES
  precision mediump float;
#endif

#include <flutter/runtime_effect.glsl>

#define AMOUNT_POINTS 5

uniform vec2 uSize;
uniform float uTime;
const vec2 uMouseSimulation = vec2(0.0);

out vec4 fragColor;

vec2 point[AMOUNT_POINTS];

vec3 drawMinDistance(in vec3 _color, in float _minimumDistance) {
  _color += _minimumDistance;

  return _color;
}

float keepCloserDistance(in float _minimumDistance, in float _distance) {
  return min(_minimumDistance, _distance);
}

float iterateThroughPointsPositions(in vec2 _uv, in float _minimumDistance) {
  for(int i = 0; i < AMOUNT_POINTS; i++) {
    float dist = distance(_uv, point[i]);
    _minimumDistance = keepCloserDistance(
      _minimumDistance,
      dist
    );
  }

  return _minimumDistance;
}

void getCellPositions() {
  point[0] = vec2(0.83, 0.75);
  point[1] = vec2(0.60, 0.07);
  point[2] = vec2(0.28, 0.64);
  point[3] = vec2(0.31, 0.26);
  point[4] = uMouseSimulation / uSize;
}

vec2 invertVerticalScreen(in vec2 _uv) {
  _uv.y = 1.0 - _uv.y;

  return _uv;
}

vec3 makeColor(in vec2 _uv) {
  _uv = invertVerticalScreen(_uv);
  vec3 color = vec3(0.0);
  getCellPositions();
  float minimumDistance = 1.0;
  minimumDistance =  iterateThroughPointsPositions(
    _uv,
    minimumDistance
  );
  color = drawMinDistance(color, minimumDistance);

  return color;
}

void main() {
  vec2 pos = FlutterFragCoord().xy;
  vec2 uv = pos / uSize;
  vec3 color = makeColor(uv);
  float correctIOSIndexRange = uTime - uTime;
  fragColor = vec4(color, 1.0 + correctIOSIndexRange);
}