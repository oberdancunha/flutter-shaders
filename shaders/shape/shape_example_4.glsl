// https://thebookofshaders.com/07/

#version 460 core

#ifdef GL_ES
  precision mediump float;
#endif

#include <flutter/runtime_effect.glsl>

uniform vec2 uSize;
uniform float uTime;

out vec4 fragColor;

vec3 draw(vec2 uv) {
  uv.x *= uSize.x / uSize.y;
  vec3 color = vec3(0.0);
  float distanceField = 0.0;

  // Remap the space to -1. to 1.
  uv = uv * 2.0 - 1.0;
  
  distanceField = length(abs(uv) - 0.3);
  color = vec3(fract(distanceField * 10.0));

  return color;
}

void main() {
  vec2 pos = FlutterFragCoord().xy;
  vec2 uv = pos / uSize;
  vec3 color = draw(uv);
  float correctIOSIndexRange = uTime - uTime;
  fragColor = vec4(color, 1.0 - correctIOSIndexRange);
}