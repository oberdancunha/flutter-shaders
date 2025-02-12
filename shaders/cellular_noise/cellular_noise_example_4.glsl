// https://thebookofshaders.com/12/

#ifdef GL_ES
  precision mediump float;
#endif

#include <flutter/runtime_effect.glsl>

uniform vec2 uSize;
uniform vec2 uTime;

out vec4 fragColor;

vec3 drawGrid(in vec3 _color, in vec2 _f_st) {
  _color.r += step(0.98, _f_st.x) + step(0.98, _f_st.y);

  return _color;
}

vec3 drawCellCenter(in vec3 _color, in float _minimumDistance) {
  _color += 1.0 - step(0.05, _minimumDistance);

  return _color;
}

vec3 showIsolines(in vec3 _color, in float _minimumDistance) {
  _color -= abs(
    sin(40.0 * _minimumDistance)
  ) * 0.07;

  return _color;
}

vec3 getClosestPointPosition(in vec3 _color, in vec2 _minimumPoint) {
  _color += dot(
    _minimumPoint, 
    vec2(0.3, 0.6)
  );

  return _color;
}

bool isCloserPoint(in float _dist, in float _minimumDistance) {
  return _dist < _minimumDistance;
}

vec2 random2(in vec2 _p) {
  return fract(
    sin(
      vec2(
        dot(
          _p,
          vec2(127.1, 311.7)
        ),
        dot(
          _p,
          vec2(269.5, 183.3)
        )
      )
    )
  ) * 43758.5453;
}

vec3 iterateThroughPointsPositions(in vec3 _color, in vec2 _i_st, in vec2 _f_st) {
  float minimumDistanceToPoint = 10.0;
  vec2 minimumAnimateNeighborPoint;
  for(int j = -1; j <= 1; j++) {
    for(int i = -1; i <= 1; i++) {
      vec2 neighborPlaceInGrid = vec2(float(i), float(j));
      vec2 neighborPoint = random2(_i_st + neighborPlaceInGrid);
      vec2 animateNeighborPoint = 0.5 + 0.5 * sin(uTime + (6.2831 * neighborPoint));
      vec2 pixelPointDiff = neighborPlaceInGrid + animateNeighborPoint - _f_st;
      float distanceToPoint = length(pixelPointDiff);
      if (isCloserPoint(distanceToPoint, minimumDistanceToPoint)) {
        minimumDistanceToPoint = distanceToPoint;
        minimumAnimateNeighborPoint = animateNeighborPoint;
      }
    }
  }
  _color = getClosestPointPosition(_color, minimumAnimateNeighborPoint);
  _color = showIsolines(_color, minimumDistanceToPoint);
  _color = drawCellCenter(_color, minimumDistanceToPoint);

  return _color;
}

vec2 getFractionalSpaceTile(in vec2 _uv) {
  return fract(_uv);
}

vec2 getIntegerSpaceTile(in vec2 _uv) {
  return floor(_uv);
}

vec2 makeScreenScale(in vec2 _uv) {
  _uv *= 5;

  return _uv;
}

vec2 invertVerticalScreen(in vec2 _uv) {
  _uv.y = 1.0 - _uv.y;

  return _uv;
}

vec3 makeColor(in vec2 _uv) {
  _uv = invertVerticalScreen(_uv);
  vec3 color = vec3(0.0);
  _uv = makeScreenScale(_uv);
  vec2 i_st = getIntegerSpaceTile(_uv);
  vec2 f_st = getFractionalSpaceTile(_uv);
  color = iterateThroughPointsPositions(color, i_st, f_st);
  color = drawGrid(color, f_st);

  return color;
}

void main() {
  vec2 pos = FlutterFragCoord().xy;
  vec2 uv = pos / uSize;
  vec3 color = makeColor(uv);
  fragColor = vec4(color, 1.0);
}