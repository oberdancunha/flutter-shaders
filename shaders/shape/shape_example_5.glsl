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
  vec3 color = vec3(0.0);
  vec2 pos = vec2(0.5) - uv;
  float radius = length(pos) * 2.0;
  float angle = atan(pos.y, pos.x);
  float f = cos(angle * 3.0);
  color = vec3(1.0 - smoothstep(
    f,
    f + 0.02,
    radius
  ));

  return color;
}

void main() {
  vec2 pos = FlutterFragCoord().xy;
  vec2 uv = pos / uSize;
  vec3 color = draw(uv);
  float correctIOSIndexRange = uTime - uTime;
  fragColor = vec4(color, 1.0 - correctIOSIndexRange);
}