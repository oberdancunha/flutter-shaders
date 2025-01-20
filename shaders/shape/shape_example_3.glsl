// https://thebookofshaders.com/07/

#version 460 core

#ifdef GL_ES
  precision mediump float;
#endif

#include <flutter/runtime_effect.glsl>

uniform vec2 uSize;
uniform float uTime;

out vec4 fragColor;

vec3 drawCircle(in vec2 _uv, in float _radius) {
  vec2 dist = _uv - vec2(0.5);
  float color = 1. - smoothstep(
    _radius - (_radius * 0.01),
    _radius + (_radius * 0.01),
    dot(dist, dist) * 4.0
  );

  return vec3(color);
}

void main() {
  vec2 pos = FlutterFragCoord().xy;
  vec2 uv = pos / uSize;
  vec3 circleColor = drawCircle(uv, 0.9);
  float correctIOSIndexRange = uTime - uTime;
  fragColor = vec4(circleColor, 1.0 - correctIOSIndexRange);
}