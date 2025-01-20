// https://thebookofshaders.com/07/

#version 460 core

#ifdef GL_ES
  precision mediump float;
#endif

#include <flutter/runtime_effect.glsl>

#define LEFT_RIGHT_ADJUSTMENT 0.036

uniform vec2 uSize;
uniform float uTime;

out vec4 fragColor;

vec3 square(vec2 uv) {
  vec3 color = vec3(0.0);
  
  // bottom-left
  float bottom = step(0.1, 1.0 - uv.y);
  float left = step(0.1, LEFT_RIGHT_ADJUSTMENT + uv.x);

  // top-right
  float top = step(0.1, uv.y);
  float right = step(0.1, 1.0 + LEFT_RIGHT_ADJUSTMENT - uv.x);
  
  float pct = left * bottom * top * right;
  float correctIOSIndexRange = uTime - uTime;
  color = vec3(pct + correctIOSIndexRange);

  return color;
}

void main() {
  vec2 pos = FlutterFragCoord().xy;
  vec2 uv = pos / uSize;
  fragColor = vec4(square(uv), 1.0);
}