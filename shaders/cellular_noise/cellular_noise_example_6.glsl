// https://thebookofshaders.com/12/

#ifdef GL_ES
precision mediump float;
#endif

#include <flutter/runtime_effect.glsl>

#define NUMBER_OF_CELLS 100.0
#define PI 3.1415926535897932384626433832795

uniform vec2 uSize;
uniform float uTime;

out vec4 fragColor;

float hash(in float _n) {
  return fract(sin(_n) * 43758.5453123);
}

vec3 makeCellColor(in vec2 _uv, in vec3 _rotatingLight) {
  vec3 cellColor = vec3(0.0);
  float maximumSurfaceDistanceToCenter = 4.0;
  for(float i = 0.0; i < NUMBER_OF_CELLS; i += 1.0) {
    float angleAroundTheCenter = sin(uTime * PI * 0.00001) - hash(i) * PI * 2.0;
    float spaceBetweenCellsInRadians = sqrt(hash(angleAroundTheCenter)) * 0.5;
    vec2 p = vec2(
      _rotatingLight.x + cos(angleAroundTheCenter) * spaceBetweenCellsInRadians, 
      _rotatingLight.z + sin(angleAroundTheCenter) * spaceBetweenCellsInRadians
    );
    float cellDistanceToFragmentCoordinates = distance(_uv, p);
    maximumSurfaceDistanceToCenter = min(maximumSurfaceDistanceToCenter, cellDistanceToFragmentCoordinates);
    bool isCellClosest = maximumSurfaceDistanceToCenter == cellDistanceToFragmentCoordinates;
    if (isCellClosest) {
      cellColor.xy = p;
      cellColor.z = i / NUMBER_OF_CELLS * _uv.x * _uv.y;
    }
  }

  return cellColor;
}

vec3 makeColor(in vec2 _uv) {
  vec2 uvVerticalInverted = vec2(_uv.x, -_uv.y);
  vec3 color = vec3(0.0);
  vec3 rotatingLight = vec3(
    sin(uTime),
    1.0,
    cos(uTime * 0.5)
  );
  vec3 cellColor = makeCellColor(uvVerticalInverted, rotatingLight);
  vec3 shadeColor = vec3(1.0) * (1.0 - max(0.0, dot(cellColor, rotatingLight)));
  color = cellColor + shadeColor;
  
  return color;
}

void main() {
  vec2 pos = FlutterFragCoord().xy;
  vec2 uv = (2.0 * pos - uSize.xy) / uSize.y;
  vec3 color = makeColor(uv);
  fragColor = vec4(color, 1.0);
}