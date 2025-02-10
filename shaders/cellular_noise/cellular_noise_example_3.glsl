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

vec3 drawPointCenter(in vec3 _color, in float _minimumDistance) {
  _color += 1.0 - step(0.02, _minimumDistance);

  return _color;
}

vec3 showIsolines(in vec3 _color, in float _minimumDistance) {
  _color -= abs(
    sin(
      80.0 * _minimumDistance
    )
  ) * 0.07;

  return _color;
}

vec3 tintAccordingTheClosestPointPosition(in vec3 _color, in vec2 _minimumPoint) {
  _color.rg = _minimumPoint;

  return _color;
}

vec3 addDistanceFieldToClosestPointCenter(in vec3 _color, in float minimumDistance) {
  _color += minimumDistance * 2.0;

  return _color;
}

bool isCloserPoint(in float _dist, in float _minimumDistance) {
  return _dist < _minimumDistance;
}

vec3 iterateThroughPointsPositions(in vec2 _uv, in vec3 _color) {
  float minimumDistance = 1.0;
  vec2 minimumPoint;
  for(int i = 0; i < AMOUNT_POINTS; i++) {
    float dist = distance(_uv, point[i]);
    if (isCloserPoint(dist, minimumDistance)) {
      // Keep the closer distance
      minimumDistance = dist;
      
      // Keep the position of the closer point
      minimumPoint = point[i];
    }
  }
  _color = addDistanceFieldToClosestPointCenter(_color, minimumDistance);
  _color = tintAccordingTheClosestPointPosition(_color, minimumPoint);
  _color = showIsolines(_color, minimumDistance);
  _color = drawPointCenter(_color, minimumDistance);

  return _color;
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
  color = iterateThroughPointsPositions(_uv, color);
  
  return color;
}

void main() {
  vec2 pos = FlutterFragCoord().xy;
  vec2 uv = pos / uSize;
  vec3 color = makeColor(uv);
  float correctIOSIndexRange = uTime - uTime;
  fragColor = vec4(color, 1.0 - correctIOSIndexRange);
}