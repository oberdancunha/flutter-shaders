// https://thebookofshaders.com/12/

#ifdef GL_ES
  precision mediump float;
#endif

#include <flutter/runtime_effect.glsl>

uniform vec2 uSize;
uniform float uTime;

out vec4 fragColor;

vec3 drawGrid(in vec3 _color, in vec2 _f_st) {
  _color.r += step(0.98, _f_st.x) + step(0.98, _f_st.y);

  return _color;
}

vec3 drawCellCenter(in vec3 _color, in float _minimumDistance) {
  _color += 1.0 - step(0.02, _minimumDistance);

  return _color; 
}

vec3 drawMinimumDistance(in vec3 _color, in float _minimumDistance) {
  _color += _minimumDistance;

  return _color; 
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

float checkDistancePointsOnTheTiles(in vec2 _i_st, in vec2 _f_st) {
  float minimumDistance = 1.0;
  for (int y = -1; y <= 1; y++) {
    for (int x = -1; x <= 1; x++) {
      vec2 neighborPlaceInGrid = vec2(float(x), float(y));
      vec2 neighborPoint = random2(_i_st + neighborPlaceInGrid);
      vec2 animateNeighborPoint = 0.5 + 0.5 * sin(uTime + (6.2831 * neighborPoint));
      vec2 pixelPointDiff = neighborPlaceInGrid + animateNeighborPoint - _f_st;
      float distanceToPoint = length(pixelPointDiff);
      minimumDistance = min(minimumDistance, distanceToPoint);
    }
  }

  return minimumDistance;
}

vec2 getEachPixelInsideTile(in vec2 _uv) {
  vec2 f_st = fract(_uv);

  return f_st;
}

vec2 getIntegerTileCoordinate(in vec2 _uv) {
  vec2 i_st = floor(_uv);

  return i_st;
} 

vec2 scaleScreen(in vec2 _uv) {
  _uv *= 3;

  return _uv;
}

vec3 makeColor(in vec2 _uv) {
  vec3 color = vec3(0.0);
  _uv = scaleScreen(_uv);

  // Tile the space
  vec2 i_st = getIntegerTileCoordinate(_uv);
  vec2 f_st = getEachPixelInsideTile(_uv);
  
  float minimumDistance = checkDistancePointsOnTheTiles(i_st, f_st);
  color = drawMinimumDistance(color, minimumDistance);
  color = drawCellCenter(color, minimumDistance);
  color = drawGrid(color, f_st);

  return color;
}

void main() {
  vec2 pos = FlutterFragCoord().xy;
  vec2 uv = pos / uSize;
  vec3 color = makeColor(uv);
  fragColor = vec4(color, 1.0);
}