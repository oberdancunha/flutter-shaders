// https://thebookofshaders.com/08/

#version 460 core

#ifdef GL_ES
  precision mediump float;
#endif

#include <flutter/runtime_effect.glsl>

#define PI 3.14159265359

uniform vec2 uSize;
uniform float uTime;

out vec4 fragColor;

mat2 rotate2d(float _angle) {
  return mat2(
    cos(_angle),
    -sin(_angle),
    sin(_angle), 
    cos(_angle)
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

vec2 moveSpaceFromCenter(vec2 _uv) {
  // move space from the center to the vec2(0,0)
  _uv -= vec2(0.5);
  
  return _uv;
}

vec2 rotateSpace(vec2 _uv) {
  _uv = rotate2d(sin(uTime) * PI) * _uv;

  return _uv;
}

vec2 moveBackToTheOriginalPlace(vec2 _uv) {
  _uv += vec2(0.5);

  return _uv;
}

vec3 makeColor(vec2 _uv) {
  vec3 color = vec3(0.0);
  
  // Show the coordinates of the space on the background;
  color = vec3(_uv.x, 1.0 - _uv.y, 0.0);

  // Add the shape on the foreground
  color += vec3(cross(_uv, 0.4));

  return color;
}

vec3 draw(vec2 _uv) {
  _uv = moveSpaceFromCenter(_uv);
  _uv = rotateSpace(_uv);
  _uv = moveBackToTheOriginalPlace(_uv);
  vec3 color = makeColor(_uv);

  return color;
}

void main() {
  vec2 pos = FlutterFragCoord().xy;
  vec2 uv = pos / uSize;
  vec3 color = draw(uv);
  fragColor = vec4(color, 1.0);
}