// https://thebookofshaders.com/12/

#ifdef GL_ES
  precision mediump float;
#endif

#include <flutter/runtime_effect.glsl>

uniform vec2 uSize;
uniform float uTime;

out vec4 fragColor;

vec3 getFeaturePoints(in vec3 _color, in vec3 _c) {
  float dd = length(_c.yz);
  _color += vec3(1.0) * (1.0 - smoothstep(0.0, 0.04, dd));

  return _color;
}

vec3 showBorders(in vec3 _color, in vec3 _c) {
  return mix(
    vec3(1.0),
    _color,
    smoothstep(0.01, 0.02, _c.x)
  );
}

vec3 showIsolines(in vec3 _c) {
  return _c.x * (0.5 + 0.5 * sin(64.0 * _c.x)) * vec3(1.0);
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
          vec2(
            269.5,
            183.3
          )
        )
      )
    ) * 43758.5453
  );
}

bool isCloserPoint(in float _distance, in float _minimumDistance) {
  return _distance < _minimumDistance;
}

vec3 voronoi(in vec2 _uv) {
  vec2 integerSpaceTile = floor(_uv);
  vec2 fractionalSpaceTile = fract(_uv);
  vec2 minimalNeighborPlaceInGrid, minimalPixelPointDiff;
  float minimumDistanceToPoint = 8.0;
  for(int j = -1; j <= 1; j++) {
    for(int i = -1; i<= 1; i++) {
      vec2 neighborPlaceInGrid = vec2(float(i), float(j));
      vec2 neighborPoint = random2(integerSpaceTile + neighborPlaceInGrid);
      vec2 animateNeighborPoint = 0.5 + 0.5 * sin(uTime + (6.2831 * neighborPoint));
      vec2 pixelPointDiff = neighborPlaceInGrid + animateNeighborPoint - fractionalSpaceTile;
      float distanceToPoint = dot(pixelPointDiff, pixelPointDiff);
      if (isCloserPoint(distanceToPoint, minimumDistanceToPoint)) {
        minimumDistanceToPoint = distanceToPoint;
        minimalPixelPointDiff = pixelPointDiff;
        minimalNeighborPlaceInGrid = neighborPlaceInGrid;
      }
    }
  }

  minimumDistanceToPoint = 8.0;
  for(int j = -2; j <= 2; j++) {
    for(int i = -2; i <= 2; i++) {
      vec2 neighborPlaceInGrid = minimalNeighborPlaceInGrid + vec2(float(i), float(j));
      vec2 neighborPoint = random2(integerSpaceTile + neighborPlaceInGrid);
      vec2 animateNeighborPoint = 0.5 + 0.5 * sin(uTime + (6.2831 * neighborPoint));
      vec2 pixelPointDiff = neighborPlaceInGrid + animateNeighborPoint - fractionalSpaceTile;
      if (dot(minimalPixelPointDiff - pixelPointDiff, minimalPixelPointDiff - pixelPointDiff) > 0.00001) {
        minimumDistanceToPoint = min(
          minimumDistanceToPoint,
          dot(
            0.5 * (minimalPixelPointDiff + pixelPointDiff),
            normalize(pixelPointDiff - minimalPixelPointDiff)
          )
        );
      }
    }
  }

  return vec3(minimumDistanceToPoint, minimalPixelPointDiff);
}

vec3 makeColor(in vec2 _uv) {
  vec2 uvVerticalInverted = vec2(_uv.x, 1.0 - _uv.y);
  vec2 uvScaled = uvVerticalInverted * 3.0;
  vec3 color = vec3(0.0);
  vec3 c = voronoi(uvScaled);
  color = showIsolines(c);
  color = showBorders(color, c);
  color = getFeaturePoints(color, c);

  return color;
}

void main() {
  vec2 pos = FlutterFragCoord().xy;
  vec2 uv = pos / uSize;
  vec3 color = makeColor(uv);
  fragColor = vec4(color, 1.0);
}