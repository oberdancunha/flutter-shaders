// https://thebookofshaders.com/08/

#version 460 core

#ifdef GL_ES
  precision mediump float;
#endif

#include <flutter/runtime_effect.glsl>

uniform vec2 uSize;
uniform float uTime;

out vec4 fragColor;

mat2 scale(vec2 _scale) {
  return mat2(
    _scale.x,
    0.0,
    0.0,
    _scale.y
  );
}

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
    _uv,
    vec2(_size / 4.0, _size)
  );
}

vec3 showCoordinatesSpaceOnTheBackground(in vec2 _uv) {
  return vec3(_uv.x, 1.0 - _uv.y, 0.0);
}

vec3 addShapeOnForeground(in vec2 _uv, in vec3 _color) {
  _color += vec3(cross(_uv, 0.2));

  return _color;
}

vec3 makeColor(in vec2 _uv) {
  vec3 color = vec3(0.0);
  color = showCoordinatesSpaceOnTheBackground(_uv);
  color = addShapeOnForeground(_uv, color);

  return color;
}

vec3 draw(vec2 _uv) {
  _uv -= vec2(0.5);
  _uv = scale(vec2(sin(uTime) + 1.0)) * _uv;
  _uv += vec2(0.5);
  vec3 color = makeColor(_uv);

  return color;
}

void main() {
  vec2 pos = FlutterFragCoord().xy;
  vec2 uv = pos / uSize;
  vec3 color = draw(uv);
  fragColor = vec4(color, 1.0);
}