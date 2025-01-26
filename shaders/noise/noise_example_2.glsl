// https://thebookofshaders.com/11/

#ifdef GL_ES
  precision mediump float;
#endif

#include <flutter/runtime_effect.glsl>

#define PI 3.1415

uniform vec2 uSize;
uniform float uTime;

out vec4 fragColor;

float lines(in vec2 _pos, in float _b) {
  float scale = 10.0;
  _pos *= scale;

  return smoothstep(
    0.0,
    0.5 + (_b * 0.5),
    abs(
      (sin(_pos.x * PI) + _b * 2.0)
    ) * 0.5
  );
}

float drawLines(in vec2 _pos) {
  return lines(_pos, 0.5);
}

float random(in vec2 _uv) {
  return fract(
    sin(
      dot(
        _uv.xy,
        vec2(12.9898, 78.233)
      )
    ) * 43758.5453123
  );
}

float noise(in vec2 _uv) {
  vec2 i = floor(_uv);
  vec2 f = fract(_uv);
  vec2 u = f * f * (3.0 - (2.0 * f));

  return mix(
    mix(
      random(i + vec2(0.0, 0.0)),
      random(i + vec2(1.0, 0.0)),
      u.x
    ),
    mix(
      random(i + vec2(0.0, 1.0)),
      random(i + vec2(1.0, 1.0)),
      u.x
    ),
    u.y
  );
}

mat2 rotate2d(in float _angle) {
  return mat2(
    cos(_angle),
    -sin(_angle),
    sin(_angle),
    cos(_angle)
  );
}

vec2 addNoise(in vec2 _pos) {
  return rotate2d(
    noise(_pos)
  ) * _pos;
}

vec3 makeColor(in vec2 _uv) {
  _uv.y = 1.0 - _uv.y;
  vec3 color = vec3(0.0);
  vec2 pos = _uv.yx * vec2(10.0, 3.0);
  float pattern = pos.x;
  pos = addNoise(pos);
  pattern = drawLines(pos);
  color = vec3(pattern);

  return color;
}

void main() {
  vec2 pos = FlutterFragCoord().xy;
  vec2 uv = pos / uSize;
  vec3 color = makeColor(uv);
  float correctIOSIndexRange = uTime - uTime;
  fragColor = vec4(color, 1.0 + correctIOSIndexRange);
}

