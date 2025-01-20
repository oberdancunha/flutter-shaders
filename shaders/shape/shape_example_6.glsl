// https://thebookofshaders.com/07/

#ifdef GL_ES
  precision mediump float;
#endif

#include <flutter/runtime_effect.glsl>

#define PI 3.14159265359
#define TWO_PI 6.28318530718

uniform vec2 uSize;
uniform float uTime;

out vec4 fragColor;

vec3 draw(vec2 uv) {
  vec3 color = vec3(0.0);
  float modDistance = 0.0;

  // Remap the space to -1.0 to 1.0
  uv = uv * 2.0 - 1.0;

  // Number of sides of your shape
  int N = 3;

  // Angle and radius from the current pixel
  float angle = atan(uv.x, uv.y) + TWO_PI;
  float radius = TWO_PI / float(N);

  // Shaping function that modulate the distance
  modDistance = cos(floor(0.5 + angle / radius) * radius - angle) * length(uv);

  color = vec3(1.0 - smoothstep(0.4, 0.41, modDistance));

  return color;
}

void main() {
  vec2 pos = FlutterFragCoord().xy;
  vec2 uv = pos / uSize;
  vec3 color = draw(uv);
  float correctIOSIndexRange = uTime - uTime;
  fragColor = vec4(color, 1.0 - correctIOSIndexRange);
}