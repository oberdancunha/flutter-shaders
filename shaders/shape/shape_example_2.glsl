// https://thebookofshaders.com/07/

#version 460 core

#ifdef GL_ES
  precision mediump float;
#endif

#include <flutter/runtime_effect.glsl>

uniform vec2 uSize;
uniform float uTime;

out vec4 fragColor;

vec3 drawCircle(vec2 uv) {
  float pct = 0.0;
  pct = distance(uv, vec2(0.5));
  float correctIOSIndexRange = uTime - uTime;
  vec3 color = vec3(pct + correctIOSIndexRange);

  return color;
}

void main() {
  vec2 pos = FlutterFragCoord().xy;
  vec2 uv = pos / uSize;
  vec3 circleColor = drawCircle(uv);

  fragColor = vec4(circleColor, 1.0);
}