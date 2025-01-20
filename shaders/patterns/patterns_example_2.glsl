// https://thebookofshaders.com/09/

#ifdef GL_ES
  precision mediump float;
#endif

#include <flutter/runtime_effect.glsl>

#define PI 3.14159265358979323846

uniform vec2 uSize;
uniform float uTime;

out vec4 fragColor;

float box(in vec2 _uv, in vec2 _size, in float _smoothEdges) {
  _size = vec2(0.5) - _size * 0.5;
  vec2 aa = vec2(_smoothEdges * 0.5);
  vec2 uv = smoothstep(
    _size, 
    _size + aa, 
    _uv
  );
  uv *= smoothstep(
    _size,
    _size + aa,
    vec2(1.0) - _uv
  );

  return uv.x * uv.y;
}

vec3 drawSquare(in vec2 _uv) {
  vec3 color = vec3(0.0);
  color = vec3(
    box(
      _uv,
      vec2(0.7),
      0.01
    )
  );

  return color;
}

vec2 rotate2D(in vec2 _uv, in float _angle) {
  _uv -= 0.5;
  _uv = mat2(
    cos(_angle),
    -sin(_angle),
    sin(_angle),
    cos(_angle)
  ) * _uv;
  _uv += 0.5;

  return _uv;
}

vec2 rotateSpace45Degrees(in vec2 _uv) {
  _uv = rotate2D(_uv, PI * 0.25);

  return _uv;
}

vec2 tile(in vec2 _uv, in float _zoom) {
  _uv *= _zoom;

  return fract(_uv);
}

vec2 divideSpaceIn4(in vec2 _uv) {
  _uv = tile(_uv, 4.0);
  
  return _uv;
}

vec3 makeColor(in vec2 _uv) {
  _uv = divideSpaceIn4(_uv);
  _uv = rotateSpace45Degrees(_uv);
  vec3 color = drawSquare(_uv);

  return color;
}

void main() {
  vec2 pos = FlutterFragCoord().xy;
  vec2 uv = pos / uSize;
  vec3 color = makeColor(uv);
  float correctIOSIndexRange = uTime - uTime;
  fragColor = vec4(color, 1.0 + correctIOSIndexRange);
}