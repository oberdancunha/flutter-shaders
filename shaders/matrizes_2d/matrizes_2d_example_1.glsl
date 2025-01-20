// https://thebookofshaders.com/08/

#version 460 core

#ifdef GL_ES
  precision mediump float;
#endif

#include <flutter/runtime_effect.glsl>

uniform vec2 uSize;
uniform float uTime;

out vec4 fragColor;

float box(in vec2 _uv, in vec2 _size) {
  _size = vec2(0.5) - _size * 0.5;
  vec2 uv = smoothstep(
    _size,
    _size + vec2(0.001),
    _uv
  );
  uv *= smoothstep(
    _size,
    _size + vec2(0.001),
    vec2(1.0) - _uv
  );

  return uv.x * uv.y;
}

float cross(in vec2 _uv, float _size) {
  return box(
    _uv,
    vec2(_size, _size / 4.0)
  ) + box(
    _uv, vec2(_size / 4.0, _size)
  );
}

vec3 draw(vec2 uv) {
  vec3 color = vec3(0.0);

  // To move the cross we move the space
  vec2 translate = vec2(cos(uTime), -sin(uTime));
  uv += translate * 0.35;

  // Show the coordinates of the space on the background
  color = vec3(uv.x, 1.0 -uv.y, 0.0);

  // Add the shape on the foreground
  color += vec3(cross(uv, 0.25));

  return color;
}

void main() {
  vec2 pos = FlutterFragCoord().xy;
  vec2 uv = pos / uSize;
  vec3 color = draw(uv);
  fragColor = vec4(color, 1.0);
}